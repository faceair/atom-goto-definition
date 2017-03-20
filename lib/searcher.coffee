module.exports = class Searcher

  @atomScan: (scan_paths, file_types, regex, iterator, callback) ->
    atom.workspace.scan(regex, {paths: file_types}, (result, error) ->
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

  @siftScan: (scan_paths, file_types, regex, iterator, callback) ->
