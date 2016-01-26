DefinitionsView = require './definitions-view.coffee'

module.exports =
  activate: (state) ->
    atom.commands.add 'atom-text-editor', 'goto-definition:go', =>
      @go()

  deactivate: ->

  go: (editor) ->
    if not editor
      editor = atom.workspace.getActiveTextEditor()
    if @definitionsView
      @definitionsView.destroy()
    @definitionsView = new DefinitionsView()

    word = editor.getWordUnderCursor()
    grammar = editor.getGrammar()

    file_path = editor.getPath()
    for path in atom.project.getPaths()
      if file_path.indexOf(path) is 0
        matches = /\/([^\/]+)$/.exec path
        project_path = matches[1]
        break

    switch grammar.name
      when "CoffeeScript"
        regex = new RegExp("class\\s+#{word}\\s+(extends)?|#{word}\\s*[:=]\\s*(\\(.*\\))?\\s*[=-]>", 'i')
        paths = ['*.coffee', project_path]
      when "Python"
        regex = new RegExp("class\\s+#{word}\\s*\\(|def\\s+#{word}\\s*\\(", 'i')
        paths = ['*.py', project_path]
      else
        regex = new RegExp(word, 'i')
        paths = ['*', project_path]

    atom.workspace.scan regex, {paths: paths}, (result, error) =>
      items = @definitionsView.items ? []
      for match in result.matches
        items.push
          text: match.lineText
          fileName: result.filePath
          line: match.range[0][0]
          column: match.range[0][1]
      @definitionsView.setItems(items)
    .then =>
      items = @definitionsView.items ? []
      switch items.length
        when 0
          @definitionsView.setItems(items)
        when 1
          @definitionsView.confirmed(items[0])
