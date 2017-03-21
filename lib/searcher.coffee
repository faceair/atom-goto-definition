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
    run_ripgrep = child_process.spawn('rg', args)

    run_ripgrep.stdout.setEncoding('utf8')
    run_ripgrep.stderr.setEncoding('utf8')

    run_ripgrep.stdout.on 'data', (result) ->
      data = result.split(":")
      iterator([{
        text: result.substring([data[0], data[1], data[2]].join(":").length),
        fileName: data[0],
        line: Number(data[1] - 1),
        column: Number(data[2])
      }])

    run_ripgrep.stderr.on 'data', (data) ->
      console.error(data)

    run_ripgrep.on 'close', callback
    run_ripgrep.on 'error', callback

    setTimeout(run_ripgrep.kill.bind(run_ripgrep), 10 * 1000)
