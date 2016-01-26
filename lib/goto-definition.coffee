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

    [project_path] = atom.project.relativizePath(editor.getPath())
    [_, project_name] = /\/([^\/]+)$/.exec project_path

    switch grammar.name
      when "CoffeeScript"
        regex = new RegExp("class\\s+#{word}\\s+(extends)?|#{word}\\s*[:=]\\s*(\\(.*\\))?\\s*[=-]>", 'i')
        paths = [project_name, '*.coffee']
      when "Python"
        regex = new RegExp("class\\s+#{word}\\s*\\(|def\\s+#{word}\\s*\\(", 'i')
        paths = [project_name, '*.py']
      else
        regex = new RegExp(word, 'i')
        paths = [project_name, '*']

    atom.workspace.scan regex, {paths: paths}, (result, error) =>
      items = result.matches.map (match) ->
        return {
          text: match.lineText
          fileName: result.filePath
          line: match.range[0][0]
          column: match.range[0][1]
        }

      if (@definitionsView.items ? []).length is 0
        @definitionsView.setItems(items)
      else
        @definitionsView.addItems(items)
    .then =>
      items = @definitionsView.items ? []
      switch items.length
        when 0
          @definitionsView.setItems(items)
        when 1
          @definitionsView.confirmed(items[0])
