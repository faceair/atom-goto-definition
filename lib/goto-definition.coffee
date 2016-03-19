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

    word = (editor.getSelectedText() or editor.getWordUnderCursor()).replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
    grammar_name = editor.getGrammar().name

    if config[grammar_name]
      scan_options = JSON.parse(JSON.stringify(config[grammar_name]))
      regex = scan_options.regex.join('|').replace(/{word}/g, word)
      paths = scan_options.type.concat project_name

      return {
        regex: new RegExp(regex, 'i')
        paths: paths
      }
    else
      return {}

  go: ->
    {regex, paths} = @getScanOptions()
    unless regex
      return atom.notifications.addWarning('This language is not supported.')

    if @definitionsView
      @definitionsView.destroy()
    @definitionsView = new DefinitionsView()

    atom.workspace.scan regex, {paths}, (result, error) =>
      items = result.matches.map (match) ->
        if Array.isArray(match.range)
          return {
            text: match.lineText
            fileName: result.filePath
            line: match.range[0][0]
            column: match.range[0][1]
          }
        else
          if /\s/.test(match.match.input.charAt(match.match.index))
            start_position = match.match.index + 1
          else
            start_position = match.match.index

          all_lines = match.match.input.split(/\r\n|\r|\n/)
          lines = match.match.input.substring(0, start_position).split(/\r\n|\r|\n/)
          line_number = lines.length - 1

          return {
            text: all_lines[line_number]
            fileName: result.filePath
            line: line_number
            column: lines.pop().length
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
