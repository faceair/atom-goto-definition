helpers = require '../spec-helpers'

describe 'CoffeeScript Goto Definition', ->
  [editor, mainModule] = []

  beforeEach ->
    waitsForPromise -> helpers.openFile('test.coffee')
    runs -> { editor, mainModule } = helpers.getPackage()

  it 'no definition', ->
    editor.setText 'hello_world'
    editor.setCursorBufferPosition([0, 1])

    expect(helpers.getSelectedWord()).toEqual 'hello_world'
    expect(helpers.getFileTypes()).toContain '*.coffee'
    expect(helpers.sendComand()).toBe true

    waitsForPromise -> helpers.waitsComplete()

    expect(mainModule.definitionsView.items.length).toEqual 0

  it 'find definition', ->
    editor.setText """
      hello_world = (word) ->
        return true
      hello_world
    """
    editor.setCursorBufferPosition([3, 1])

    expect(helpers.getSelectedWord()).toEqual 'hello_world'
    expect(helpers.getFileTypes()).toContain '*.coffee'
    expect(helpers.sendComand()).toBe true

    waitsForPromise -> helpers.waitsComplete()

    expect(mainModule.definitionsView.items.length).toEqual 1
    expect(mainModule.definitionsView.items[0].line).toEqual 0
    expect(mainModule.definitionsView.items[0].text).toContain 'hello_world = (word) ->'
