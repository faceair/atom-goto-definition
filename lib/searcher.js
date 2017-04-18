/** @babel */

import ChildProcess from 'child_process';

export default class Searcher {

  static transformUnsavedMatch(match) {
    const allLines = match.match.input.split(/\r\n|\r|\n/);
    const lines = match.match.input.substring(0, match.match.index + 1).split(/\r\n|\r|\n/);
    const lineNumber = lines.length - 1;

    return {
      text: allLines[lineNumber],
      line: lineNumber,
      column: lines.pop().length,
    };
  }

  static filterMatch(match) {
    return (match !== null && match.text.trim().length < 350);
  }

  static fixColumn(match) {
    if ((match.column === 1) && (/^\s/.test(match.text) === false)) { // ripgrep's bug
      match.column = 0;
    }

    let emptyChars = '';

    const matches = /^[\s.]/.exec(match.text.substring(match.column));
    if (matches) emptyChars = matches[0];

    return {
      text: match.text,
      fileName: match.fileName,
      line: match.line,
      column: match.column + emptyChars.length,
    };
  }

  static atomBufferScan(activeEditor, fileTypes, regex, iterator, callback) {
    // atomBufferScan just search opened files
    const editors = atom.workspace.getTextEditors().filter(x => !Object.is(activeEditor, x));
    editors.unshift(activeEditor);
    callback(editors.map((editor) => {
      const filePath = editor.getPath();
      if (filePath) {
        const fileExtension = `*.${filePath.split('.').pop()}`;
        if (fileTypes.includes(fileExtension)) {
          editor.scan(new RegExp(regex, 'ig'), (match) => {
            const item = Searcher.transformUnsavedMatch(match);
            item.fileName = filePath;
            iterator([Searcher.fixColumn(item)].filter(Searcher.filterMatch));
          });
        }
        return filePath;
      }
      return null;
    }).filter(x => x !== null));
  }

  static atomWorkspaceScan(activeEditor, scanPaths, fileTypes, regex, iterator, callback) {
    this.atomBufferScan(activeEditor, fileTypes, regex, iterator, (openedFiles) => {
      atom.workspace.scan(new RegExp(regex, 'ig'), { paths: fileTypes }, (result) => {
        if (openedFiles.includes(result.filePath)) {
          return null; // atom.workspace.scan can't set exclusions
        }
        iterator(result.matches.map(match => ({
          text: match.lineText,
          fileName: result.filePath,
          line: match.range[0][0],
          column: match.range[0][1],
        })).filter(Searcher.filterMatch).map(Searcher.fixColumn));
        return null;
      }).then(callback);
    });
  }


  static ripgrepScan(activeEditor, scanPaths, fileTypes, regex, iterator, callback) {
    this.atomBufferScan(activeEditor, fileTypes, regex, iterator, (openedFiles) => {
      const args = fileTypes.map(x => `--glob=${x}`);
      args.push(...openedFiles.map(x => `--glob=!${x}`));
      args.push(...[
        '--line-number', '--column', '--no-ignore-vcs', '--ignore-case', regex,
      ]);
      args.push(...scanPaths);

      const runRipgrep = ChildProcess.spawn('rg', args);

      runRipgrep.stdout.setEncoding('utf8');
      runRipgrep.stderr.setEncoding('utf8');

      runRipgrep.stdout.on('data', (results) => {
        iterator(results.split('\n').map((result) => {
          if (result.trim().length) {
            const data = result.split(':');
            // Windows filepath will become ['C','Windows/blah'], so this fixes it.
            if (data[0].length === 1) {
              const driveLetter = data.shift();
              const path = data.shift();
              data.unshift(`${driveLetter}:${path}`);
            }
            return {
              text: result.substring([data[0], data[1], data[2]].join(':').length + 1),
              fileName: data[0],
              line: Number(data[1] - 1),
              column: Number(data[2]),
            };
          }
          return null;
        }).filter(Searcher.filterMatch).map(Searcher.fixColumn));
      });

      runRipgrep.stderr.on('data', (message) => {
        if (message.includes('No files were searched')) {
          return null;
        }
        throw message;
      });

      runRipgrep.on('close', callback);

      runRipgrep.on('error', (error) => {
        if (error.code === 'ENOENT') {
          atom.notifications.addWarning('Plase install `ripgrep` first.');
        } else {
          throw error;
        }
      });

      setTimeout(runRipgrep.kill.bind(runRipgrep), 10 * 1000);
    });
  }

}
