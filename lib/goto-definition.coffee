{ CompositeDisposable } = require 'atom'

DefinitionsView = require './definitions-view.coffee'
Searcher = require './searcher'
Config = require './config.coffee'

module.exports =
  config:
    contextMenuDisplayAtFirst:
      type: 'boolean'
      default: true

    performanceMode:
      type: 'boolean'
      default: false

  firstContextMenu:
    'atom-text-editor': [
      { label: 'Goto Definition', command: 'goto-definition:go' }, { type: 'separator' }
    ]

  normalContextMenu:
    'atom-text-editor': [
      { label: 'Goto Definition', command: 'goto-definition:go' }
    ]

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-text-editor', 'goto-definition:go', @go.bind(this)

    if atom.config.get('goto-definition.contextMenuDisplayAtFirst')
      @subscriptions.add atom.contextMenu.add @firstContextMenu
      atom.contextMenu.itemSets.unshift(atom.contextMenu.itemSets.pop())
    else
      @subscriptions.add atom.contextMenu.add @normalContextMenu

  deactivate: ->
    @subscriptions.dispose()

  getSelectedWord: (editor, wordRegex) ->
    return (editor.getSelectedText() or editor.getWordUnderCursor({
      wordRegex, includeNonWordCharacters: true
    })).replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

  getScanOptions: ->
    editor = atom.workspace.getActiveTextEditor()

    file_path = editor.getPath()
    unless file_path
      return {
        message: 'This file must be saved to disk .'
      }
    file_extension = '*.' + file_path.split('.').pop()

    scan_regex = []
    scan_types = []
    word_regex = []
    for grammar_name, grammar_option of Config
      if grammar_option.type.indexOf(file_extension) isnt -1
        scan_regex.push.apply(scan_regex, grammar_option.regex.map((x) -> x.source))
        scan_types.push.apply(scan_types, grammar_option.type)
        word_regex.push(grammar_option.word.source)

    if scan_regex.length is 0
      return {
        message: 'This language is not supported . Pull Request Welcome 👏.'
      }

    word = @getSelectedWord(editor, new RegExp(word_regex.join('|'), 'i'))
    unless word.trim().length
      return {
        message: 'Unknown keyword .'
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
      wordRegExp: /[$0-9a-zA-Z_-]+/g,
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
    @definitionsView.items = []
    scan_paths = atom.project.getDirectories().map((x) -> x.path)

    iterator = (items) =>
      if @definitionsView.items.length is 0
        @definitionsView.setItems(items)
      else
        @definitionsView.addItems(items)

    callback = () =>
      items = @definitionsView.items
      switch items.length
        when 0
          @definitionsView.setItems(items)
        when 1
          @definitionsView.confirmed(items[0])

    if atom.config.get('goto-definition.performanceMode')
      Searcher.ripgrepScan(scan_paths, file_types, regex, iterator, callback)
    else
      Searcher.atomWorkspaceScan(scan_paths, file_types, regex, iterator, callback)
