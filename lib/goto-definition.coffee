DefinitionsView = require './definitions-view.coffee'
config = require './config.coffee'

module.exports =
  config:
    rightMenuDisplayAtFirst:
      type: 'boolean'
      default: true

  firstMenu:
    'atom-workspace atom-text-editor:not(.mini)': [
      {
        label: 'Goto Definition',
        command: 'goto-definition:go'
      },
      {
        type: 'separator'
      }
    ]

  normalMenu:
    'atom-workspace atom-text-editor:not(.mini)': [
      {
        label: 'Goto Definition',
        command: 'goto-definition:go'
      }
    ]

  activate: ->
    atom.commands.add 'atom-workspace atom-text-editor:not(.mini)', 'goto-definition:go', =>
      @go()

    if atom.config.get('goto-definition.rightMenuDisplayAtFirst')
      atom.contextMenu.add @firstMenu
      atom.contextMenu.itemSets.unshift(atom.contextMenu.itemSets.pop())
    else
      atom.contextMenu.add @normalMenu

  deactivate: ->

  getScanOptions: ->
    editor = atom.workspace.getActiveTextEditor()

    [project_path] = atom.project.relativizePath(editor.getPath())
    name_matches = /[\/\\]([^\/^\\]+)$/.exec project_path
    project_name = if name_matches then name_matches[1] else '*'

    word = editor.getWordUnderCursor().replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
    grammar_name = editor.getGrammar().name

    scan_options = JSON.parse(JSON.stringify(config[grammar_name] ? config['General']))
    regex = scan_options.regex.join('|').replace(/{word}/g, word)
    paths = scan_options.type.concat project_name

    return {
      regex: new RegExp(regex, 'i')
      paths: paths
    }

  go: ->
    if @definitionsView
      @definitionsView.destroy()
    @definitionsView = new DefinitionsView()

    {regex, paths} = @getScanOptions()

    atom.workspace.scan regex, {paths}, (result, error) =>
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
