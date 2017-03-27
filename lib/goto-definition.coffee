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

  getScanOptions: (editor) ->
    file_path = editor.getPath()
    unless file_path
      return {
        message: 'This file must be saved to disk .'
      }
    file_extension = '*.' + file_path.split('.').pop()

    scan_grammars = []
    scan_regexes = []
    word_regexes = []
    scan_files = []
    for grammar_name, grammar_option of Config
      if grammar_option.files.includes file_extension
        (grammar_option.dependencies ? []).map((x) -> scan_grammars.push(x))
        scan_grammars.push grammar_name

    for grammar_name in scan_grammars
      scan_regexes.push.apply(scan_regexes, Config[grammar_name].regexes.map((x) -> x.source))
      scan_files.push.apply(scan_files, Config[grammar_name].files)
      word_regexes.push(grammar_option.word.source)

    if scan_regexes.length is 0
      return {
        message: 'This language is not supported . Pull Request Welcome 👏.'
      }

    word_regexes = word_regexes.filter (item, index, arr) -> arr.lastIndexOf(item) is index
    word = @getSelectedWord(editor, new RegExp(word_regexes.join('|'), 'i'))
    unless word.trim().length
      return {
        message: 'Unknown keyword .'
      }

    scan_regexes = scan_regexes.filter (item, index, arr) -> arr.lastIndexOf(item) is index
    scan_files = scan_files.filter (item, index, arr) -> arr.lastIndexOf(item) is index

    regex = scan_regexes.join('|').replace(/{word}/g, word)

    return {
      regex, file_types: scan_files
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
    editor = atom.workspace.getActiveTextEditor()

    {regex, file_types, message} = @getScanOptions(editor)
    unless regex
      return atom.notifications.addWarning(message)

    @definitionsView.cancel() if @definitionsView
    @definitionsView = new DefinitionsView()
    @state = 'started'

    iterator = (items) =>
      @state = 'searching'
      @definitionsView.addItems(items)

    callback = () =>
      @state = 'completed'
      switch  @definitionsView.items.length
        when 0
          @definitionsView.showEmpty()
        when 1
          @definitionsView.confirmedFirst()

    scan_paths = atom.project.getDirectories().map((x) -> x.path)
    if atom.config.get('goto-definition.performanceMode')
      Searcher.ripgrepScan(scan_paths, file_types, regex, iterator, callback)
    else
      Searcher.atomWorkspaceScan(scan_paths, file_types, regex, iterator, callback)
