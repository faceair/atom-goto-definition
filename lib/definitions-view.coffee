# fork from https://github.com/sadovnychyi/autocomplete-python/blob/master/lib/definitions-view.coffee

{$, $$, SelectListView} = require 'atom-space-pen-views'

module.exports = class DefinitionsView extends SelectListView
  initialize: ->
    super
    @storeFocusedElement()
    @addClass('symbols-view')
    @setState('ready')
    @setLoading('Looking for definitions')

    @panel = atom.workspace.addModalPanel({item: this, visible: false})
    @items = []

    @list.unbind('mouseup')
    @list.on 'click', 'li', (e) =>
      @confirmSelection() if $(e.target).closest('li').hasClass('selected')
      e.preventDefault()
      return false

    setTimeout(@show.bind(this), 300)

  setState: (state) ->
    return @state = 'ready' if state is 'ready' and not @state
    return @state = 'loding' if state is 'loding' and @state in ['ready', 'loding']
    return @state = 'cancelled' if state is 'cancelled' and @state in ['ready', 'loding']
    throw new Error('state switch error')

  viewForItem: ({text, fileName, line, column}) ->
    [_, relativePath] = atom.project.relativizePath(fileName)
    return $$ ->
      @li class: 'two-lines', =>
        @div "#{text}", class: 'primary-line'
        @div "#{relativePath}, line #{line + 1}", class: 'secondary-line'

  addItems: (items) ->
    return unless @state in ['ready', 'loding']

    @setState('loding')
    if @items.length is 0
      @setItems(items)
    else
      @show()
      for item in items
        @items.push item
        itemView = $(@viewForItem(item))
        itemView.data('select-list-item', item)
        @list.append(itemView)

  getFilterKey: -> 'fileName'

  showEmpty: ->
    @show()
    @setError('No definition found')
    @setLoading()

  confirmedFirst: ->
    @confirmed(@items[0]) if @items.length > 0

  confirmed: ({fileName, line, column}) ->
    return unless @state is 'loding'
    @cancelPosition = null
    @cancelled()
    promise = atom.workspace.open(fileName)
    promise.then (editor) ->
      editor.setCursorBufferPosition([line, column])
      editor.scrollToCursorPosition()

  show: ->
    if @state in ['ready', 'loding'] and not @panel.visible
      @panel.show()
      @focusFilterEditor()

  cancelled: ->
    if @state in ['ready', 'loding']
      @setState('cancelled')
      @panel.destroy()
