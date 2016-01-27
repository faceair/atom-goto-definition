DefinitionsView = require './definitions-view.coffee'
ConfigWrap = require './config-wrap.coffee'
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

    config = new ConfigWrap(editor)
    {regex, paths} = config.getScanningParams()

    atom.workspace.scan regex, paths, (result, error) =>
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
