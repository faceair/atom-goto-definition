child_process = require 'child_process'
path = require 'path'

module.exports = class Searcher

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
          all_lines = match.match.input.split(/\r\n|\r|\n/)
          lines = match.match.input.substring(0, match.match.index).split(/\r\n|\r|\n/)
          line_number = lines.length - 1

          return {
            text: all_lines[line_number],
            fileName: result.filePath,
            line: line_number,
            column: lines.pop().length
          }
        ).map((match) ->
          head_empty_chars = /^[\s\.@]/.exec(match.text.substring(match.column))?[0] ? ''
          return {
            text: match.text,
            fileName: match.fileName,
            line: match.line,
            column: match.column + head_empty_chars.length
          }
        )
      iterator(items)
    ).then(callback)

  @ripgrepScan: (scan_paths, file_types, regex, iterator, callback) ->
    args = [] # file_types.map((x) -> "--glob='" + x + "'")
    args.push.apply(args, ['--line-number', '--column', "'" + regex + "'", scan_paths.join(',')])
    run_sift = child_process.spawn(path.resolve(__dirname, '../bin/ripgrep'), args)

    run_sift.stdout.on 'data', (data) ->
      console.log(data.toString())

    run_sift.stderr.on 'data', (data) ->
      console.log(data.toString())

    run_sift.on 'close', (code) ->
      console.log(code)

    run_sift.on 'error', (err) ->
      console.log(err)
