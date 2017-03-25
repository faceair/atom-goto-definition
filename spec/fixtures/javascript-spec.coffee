helpers = require '../spec-helpers'

describe 'JavaScript Goto Definition', ->
  [editor, mainModule] = []

  beforeEach ->
    waitsForPromise -> helpers.openFile('test.js')
    runs -> { editor, mainModule } = helpers.getPackage()

  it 'no definition', ->
    editor.setText 'hello_world'
    editor.setCursorBufferPosition([0, 1])

    expect(helpers.getSelectedWord()).toEqual 'hello_world'
    expect(helpers.getFileTypes()).toContain '*.js'
    expect(helpers.sendComand()).toBe true

    waitsForPromise -> helpers.waitsComplete()

    expect(mainModule.definitionsView.items.length).toEqual 0

  it 'find definition', ->
    editor.setText """
      function hello_world() {
        return true;
      }
      hello_world
    """
    editor.setCursorBufferPosition([3, 1])

    expect(helpers.getSelectedWord()).toEqual 'hello_world'
    expect(helpers.getFileTypes()).toContain '*.js'
    expect(helpers.sendComand()).toBe true

    waitsForPromise -> helpers.waitsComplete()

    expect(mainModule.definitionsView.items.length).toEqual 1
    expect(mainModule.definitionsView.items[0].line).toEqual 0
    expect(mainModule.definitionsView.items[0].text).toContain 'function hello_world() {'
