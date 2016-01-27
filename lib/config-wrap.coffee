module.exports =
  class ConfigWrap
    constructor:  (@editor) ->
      @config = require './config.coffee'

    getScanningParams: ->
      [project_path] = atom.project.relativizePath(@editor.getPath())
      [_, project_name] = /\/([^\/]+)$/.exec project_path
      word = @editor.getWordUnderCursor().replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
      grammar = @editor.getGrammar()
      regex = @config[grammar.name]['regex'].join('|').replace(/{word}/g, word)
      paths = [project_name, {paths: @config[grammar.name]['type']}]
      return {regex: new RegExp(regex ?= ['*'], 'i') , paths: paths}
