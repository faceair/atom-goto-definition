{CompositeDisposable} = require 'atom'

DefinitionsView = require './definitions-view.coffee'

module.exports =
  activate: (state) ->
    atom.commands.add 'atom-text-editor', 'goto-definition:go', =>
      @goToDefinition()

  deactivate: ->

  goToDefinition: (editor) ->
    if not editor
      editor = atom.workspace.getActiveTextEditor()
    if @definitionsView
      @definitionsView.destroy()
    @definitionsView = new DefinitionsView()

    word = editor.getWordUnderCursor()
    atom.workspace.scan new RegExp(word), {paths: ['*']}, (result, error) =>
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
      if items.length is 1
        @definitionsView.confirmed(items[0])
