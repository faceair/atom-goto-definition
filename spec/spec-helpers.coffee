fs = require 'fs'

exports.openFile = (filename) ->
  atom.workspace.open(filename).then ->
    atom.packages.activatePackage('goto-definition')

exports.editorSave = ->
  { editor } = exports.getPackage()
  return editor.save()

exports.editorDelete = ->
  { editor } = exports.getPackage()
  try
    fs.unlinkSync editor.getPath()
  catch e

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
      if mainModule.state is 'completed'
        resolve()
        clearInterval(timer)
    , 1

exports.nomalMode = ->
  return atom.config.set('goto-definition.performanceMode', false)

exports.performanceMode = ->
  return atom.config.set('goto-definition.performanceMode', true)
