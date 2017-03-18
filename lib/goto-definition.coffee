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

  getSelectedWord: (editor) ->
    return (editor.getSelectedText() or editor.getWordUnderCursor()).replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')

  getScanOptions: ->
    editor = atom.workspace.getActiveTextEditor()
    word = @getSelectedWord(editor)
    file_path = editor.getPath()
    if not file_path
      return {
        message: 'This file must be saved to disk .'
      }
    file_extension = "*." + file_path.split('.').pop()

    scan_regex = []
    scan_paths = []
    for grammar_name, grammar_option of config
      if grammar_option.type.indexOf(file_extension) isnt -1
        scan_regex.push.apply(scan_regex, grammar_option.regex)
        scan_paths.push.apply(scan_paths, grammar_option.type)

    if scan_regex.length == 0
      return {
        message: 'This language is not supported . Pull Request Welcome 👏.'
      }

    scan_regex = scan_regex.filter (e, i, arr) -> arr.lastIndexOf(e) is i
    scan_paths = scan_paths.filter (e, i, arr) -> arr.lastIndexOf(e) is i

    # Word recognition doesn't always work perfectly (e.g. clojure deref with
    # @word, and perl6 sub-as-value reference with &subName)
    # This fn let's us strip a head character from the word when searching for
    # a definition (by looking for def {@word} and sub {&word} respectively,
    # where {@word} really means {word except that we don't care about the first char which is an @ })
    replaceHeadwords = (s) ->
      s.match(/{.word}/g).reduce (x, y) ->
        x.replace(///#{y}///g, word.replace(y[1], ''))
      , s

    regex = replaceHeadwords(scan_regex.join('|').replace(/{word}/g, word))

    return {
      regex: new RegExp(regex, 'i')
      paths: scan_paths
    }

  getProvider: ->
    return {
      providerName:'goto-definition-hyperclick',
      wordRegExp: /[$0-9\w]+/g,
      getSuggestionForWord: (textEditor, text, range) =>
        return {
          range,
          callback: => @go()
        }
    }

  go: ->
    {regex, paths, message} = @getScanOptions()
    unless regex
      return atom.notifications.addWarning(message)

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
