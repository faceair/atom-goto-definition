packagesToTest =
  Python:
    name: 'language-python'
    file: 'test.py'

describe 'Python goto definition', ->
  [editor, mainModule] = []

  waitsComplete = (module) ->
    new Promise (resolve) ->
      timer = setInterval ->
        if module.status is 'complete'
          resolve()
          clearInterval(timer)
      , 1

  beforeEach ->
    waitsForPromise -> atom.packages.activatePackage('language-python')
    waitsForPromise -> atom.workspace.open('test.py')
    runs ->
      editor = atom.workspace.getActiveTextEditor()
      editor.setGrammar(atom.grammars.grammarsByScopeName['source.python'])
    waitsForPromise -> atom.packages.activatePackage('goto-definition')
    runs ->
      mainModule = atom.packages.getActivePackage('goto-definition').mainModule

  it 'no definition', ->
    editor.setText 'hello_world'
    editor.setCursorBufferPosition([0, 1])
    expect(mainModule.getSelectedWord(editor, /[$0-9a-zA-Z_]+/)).toEqual 'hello_world'
    expect(atom.commands.dispatch(atom.views.getView(editor), 'goto-definition:go')).toBe true
    waitsForPromise -> waitsComplete(mainModule)
    expect(mainModule.definitionsView.items.length).toEqual 0

  it 'find definition', ->
    editor.setText """
      def hello_world():
        return True
      hello_world
    """
    editor.setCursorBufferPosition([3, 1])
    expect(mainModule.getSelectedWord(editor, /[$0-9a-zA-Z_]+/)).toEqual 'hello_world'
    expect(mainModule.getScanOptions(editor).file_types).toContain '*.py'
    expect(atom.commands.dispatch(atom.views.getView(editor), 'goto-definition:go')).toBe true
    waitsForPromise -> waitsComplete(mainModule)
    expect(mainModule.definitionsView.items.length).toEqual 1
    expect(mainModule.definitionsView.items[0].line).toEqual 0
