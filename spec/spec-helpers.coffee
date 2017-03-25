exports.openFile = (filename) ->
  atom.workspace.open(filename).then ->
    atom.packages.activatePackage('goto-definition')

exports.getPackage = ->
  editor = atom.workspace.getActiveTextEditor()
  mainModule = atom.packages.getActivePackage('goto-definition').mainModule
  return { editor, mainModule }

exports.getSelectedWord = ->
  { editor, mainModule } = exports.getPackage()
  return mainModule.getSelectedWord(editor, /[$0-9a-zA-Z_]+/)

exports.getFileTypes = ->
  { editor, mainModule } = exports.getPackage()
  return mainModule.getScanOptions(editor).file_types

exports.sendComand = ->
  { editor } = exports.getPackage()
  return atom.commands.dispatch(atom.views.getView(editor), 'goto-definition:go')

exports.waitsComplete = ->
  { mainModule } = exports.getPackage()
  return new Promise (resolve) ->
    timer = setInterval ->
      if mainModule.status is 'complete'
        resolve()
        clearInterval(timer)
    , 1
