child_process = require 'child_process'
path = require 'path'

module.exports = class Searcher

  @transformUnsavedMatch: (match) ->
    all_lines = match.match.input.split(/\r\n|\r|\n/)
    lines = match.match.input.substring(0, match.match.index + 1).split(/\r\n|\r|\n/)
    line_number = lines.length - 1

    return {
      text: all_lines[line_number],
      line: line_number,
      column: lines.pop().length
    }

  @fixColumn: (match) ->
    head_empty_chars = /^[\s\.@]/.exec(match.text.substring(match.column))?[0] ? ''
    return {
      text: match.text,
      fileName: match.fileName,
      line: match.line,
      column: match.column + head_empty_chars.length
    }

  @atomWorkspaceScan: (scan_paths, file_types, regex, iterator, callback) ->
    atom.workspace.scan(new RegExp(regex, 'i'), {paths: file_types}, (result, error) ->
      items = result.matches.map((match) ->
        if Array.isArray(match.range)
          return {
            text: match.lineText,
            fileName: result.filePath,
            line: match.range[0][0],
            column: match.range[0][1]
          }
        else
          item = Searcher.transformUnsavedMatch(match)
          item.fileName = result.filePath
          return item
        ).map(Searcher.fixColumn)
      iterator(items)
    ).then(callback)

  @atomBufferScan: (file_types, regex, iterator, callback) ->
    panels = atom.workspace.getPaneItems()
    callback(panels.map((editor) ->
      if editor.constructor.name is 'TextEditor'
        file_path = editor.getPath()
        if file_path
          file_extension = "*." + file_path.split('.').pop()
          if file_extension in file_types
            editor.scan new RegExp(regex, 'ig'), (match) ->
              item = Searcher.transformUnsavedMatch(match)
              item.fileName = file_path
              iterator([Searcher.fixColumn(item)])
          return file_path
      return null
    ).filter((x) -> x isnt null))

  @ripgrepScan: (scan_paths, file_types, regex, iterator, callback) ->
    @atomBufferScan file_types, regex, iterator, (opened_files) ->
      args = file_types.map((x) -> "--glob=" + x)
      args.push.apply(args, opened_files.map((x) -> "--glob=!" + x))
      args.push.apply(args, [
        '--line-number', '--column', '--no-ignore-vcs', '--ignore-case',
        regex, scan_paths.join(',')
      ])

      run_ripgrep = child_process.spawn('rg', args)

      run_ripgrep.stdout.setEncoding('utf8')
      run_ripgrep.stderr.setEncoding('utf8')

      run_ripgrep.stdout.on 'data', (results) ->
        iterator(results.split("\n").map((result) ->
          if result.trim().length
            data = result.split(":")
            text = result.substring([data[0], data[1], data[2]].join(":").length + 1)
            column = Number(data[2])
            if (column is 1) and (/^\s/.test(text) is false) # ripgrep's bug
              column = 0
            return {
              text, column,
              fileName: data[0],
              line: Number(data[1] - 1)
            }
          else
            return null
        ).filter((x) -> x isnt null))

      run_ripgrep.stderr.on 'data', (error) ->
        throw error

      run_ripgrep.on 'close', callback

      run_ripgrep.on 'error', (error) ->
        if error.code is 'ENOENT'
          atom.notifications.addWarning('Plase install `ripgrep` first.')
        else
          throw error

      setTimeout(run_ripgrep.kill.bind(run_ripgrep), 10 * 1000)
