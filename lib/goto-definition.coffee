DefinitionsView = require './definitions-view.coffee'
Searcher = require './searcher'

config = require './config.coffee'

module.exports =
  config:
    rightMenuDisplayAtFirst:
      type: 'boolean'
      default: true

    performanceMode:
      type: 'boolean'
      default: false

  firstMenu:
    'atom-workspace atom-text-editor:not(.mini)': [
      { label: 'Goto Definition', command: 'goto-definition:go' }, { type: 'separator' }
    ]

  normalMenu:
    'atom-workspace atom-text-editor:not(.mini)': [
      { label: 'Goto Definition', command: 'goto-definition:go' }
    ]

  activate: ->
    atom.commands.add 'atom-workspace atom-text-editor:not(.mini)', 'goto-definition:go', @go.bind(this)

    if atom.config.get('goto-definition.rightMenuDisplayAtFirst')
      atom.contextMenu.add @firstMenu
      atom.contextMenu.itemSets.unshift(atom.contextMenu.itemSets.pop())
    else
      atom.contextMenu.add @normalMenu

  deactivate: ->
    for item, i in atom.contextMenu.itemSets
      if item and item.items[0].command is 'goto-definition:go'
        atom.contextMenu.itemSets.splice(i, 1)

  getSelectedWord: (editor) ->
    return (editor.getSelectedText() or editor.getWordUnderCursor({
      wordRegex: /[$0-9\w-]+/,
      includeNonWordCharacters: true
    })).replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

  getScanOptions: ->
    editor = atom.workspace.getActiveTextEditor()
    word = @getSelectedWord(editor)
    if not word.trim().length
      return {
        message: 'Unknown keyword .'
      }
    file_path = editor.getPath()
    if not file_path
      return {
        message: 'This file must be saved to disk .'
      }
    file_extension = "*." + file_path.split('.').pop()

    scan_regex = []
    scan_types = []
    for grammar_name, grammar_option of config
      if grammar_option.type.indexOf(file_extension) isnt -1
        scan_regex.push.apply(scan_regex, grammar_option.regex)
        scan_types.push.apply(scan_types, grammar_option.type)

    if scan_regex.length == 0
      return {
        message: 'This language is not supported . Pull Request Welcome 👏.'
      }

    scan_regex = scan_regex.filter (item, index, arr) -> arr.lastIndexOf(item) is index
    scan_types = scan_types.filter (item, index, arr) -> arr.lastIndexOf(item) is index

    regex = scan_regex.join('|').replace(/{word}/g, word)

    return {
      regex, file_types: scan_types
    }

  getProvider: ->
    return {
      providerName:'goto-definition-hyperclick',
      wordRegExp: /[$0-9\w-]+/g,
      getSuggestionForWord: (textEditor, text, range) => {
        range, callback: () => @go() if text
      }
    }

  go: ->
    {regex, file_types, message} = @getScanOptions()
    unless regex
      return atom.notifications.addWarning(message)

    if @definitionsView
      @definitionsView.destroy()
    @definitionsView = new DefinitionsView()
    scan_paths = atom.project.getDirectories().map((x) -> x.path)

    iterator = (items) =>
      if (@definitionsView.items ? []).length is 0
        @definitionsView.setItems(items)
      else
        @definitionsView.addItems(items)

    callback = () =>
      items = @definitionsView.items ? []
      switch items.length
        when 0
          @definitionsView.setItems(items)
        when 1
          @definitionsView.confirmed(items[0])

    if atom.config.get('goto-definition.performanceMode')
      Searcher.ripgrepScan(scan_paths, file_types, regex, iterator, callback)
    else
      Searcher.atomWorkspaceScan(scan_paths, file_types, regex, iterator, callback)
