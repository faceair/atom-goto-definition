# fork from https://github.com/sadovnychyi/autocomplete-python/blob/master/lib/definitions-view.coffee

{$, $$, SelectListView} = require 'atom-space-pen-views'
path = require 'path'

module.exports =
class DefinitionsView extends SelectListView
  initialize: (matches) ->
    super
    @storeFocusedElement()
    @addClass('symbols-view')
    @panel ?= atom.workspace.addModalPanel(item: this)
    @panel.show()
    @setLoading('Looking for definitions')
    @focusFilterEditor()

  destroy: ->
    @cancel()
    @panel.destroy()

  viewForItem: ({text, fileName, line, column}) ->
    [_, relativePath] = atom.project.relativizePath(fileName)
    return $$ ->
      @li class: 'two-lines', =>
        @div "#{text}", class: 'primary-line'
        @div "#{relativePath}, line #{line + 1}", class: 'secondary-line'

  addItems: (items) ->
    for item in items
      @items.push item
      itemView = $(@viewForItem(item))
      itemView.data('select-list-item', item)
      @list.append(itemView)

  getFilterKey: -> 'fileName'

  getEmptyMessage: (itemCount) ->
    if itemCount is 0
      'No definition found'
    else
      super

  confirmed: ({fileName, line, column}) ->
    return unless @panel?.visible
    @cancelPosition = null
    @cancel()
    promise = atom.workspace.open(fileName)
    promise.then (editor) ->
      editor.setCursorBufferPosition([line, column])
      editor.scrollToCursorPosition()

  cancelled: ->
    @panel?.hide()
