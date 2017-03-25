module.exports =
  'JavaScript (JSX)':
    word: /[$0-9a-zA-Z_]+/
    regex: [
      /(^|\s|\.){word}\s*[:=]\s*function\s*\(/,
      /(^|\s)function\s+{word}\s*\(/
      /(^|\s)function\s+{word}\s*\(/
      /(^|\s){word}\([^\(]*?\)\s*\{/  # ES6
      /(^|\s)class\s+{word}(\s|$)/
    ]
    type: ['*.jsx', '*.js', '*.html']

  CoffeeScript:
    word: /[$0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}(\s|$)/,
      /(^|\s|\.|@){word}\s*[:=]\s*(\([^\(]*?\))?\s*[=-]>/
      /(^|\s|\.){word}\s*[:=]\s*function\s*\(/ # JavaScript Function
      /(^|\s)function\s+{word}\s*\(/
      /(^|\s){word}\([^\(]*?\)\s*\{/  # ES6
    ]
    type: ['*.coffee', '*.js', '*.html']

  TypeScript:
    word: /[$0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}(\s|$)/
      /(^|\s|\.){word}\s*[:=]\s*(\([^\(]*?\))?\s*[=-]>/
      /(^|\s|\.){word}\s*[:=]\s*function\s*\(/ # JavaScript Function
      /(^|\s)function\s+{word}\s*\(/
      /(^|\s){word}\([^\(]*?\)\s*\{/  # ES6
    ]
    type: ['*.ts', '*.html']

  Python:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}\s*\(/
      /(^|\s)def\s+{word}\s*\(/
    ]
    type: ['*.py']

  PHP:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}(\s|\{|$)/
      /(^|\s)interface\s+{word}(\s|\{|$)/
      /(^|\s)trait\s+{word}(\s|\{|$)/
      /(^|\s)(static\s+)?((public|private|protected)\s+)?(static\s+)?function\s+{word}\s*\(/
      /(^|\s)const\s+{word}(\s|=|;|$)/
    ]
    type: ['*.php', '*.php3', '*.phtml']

  ASP:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)(function|sub)\s+{word}\s*\(/
    ]
    type: ['*.asp']

  Hack:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}(\s|\{|$)/
      /(^|\s)interface\s+{word}(\s|\{|$)/
      /(^|\s)(static\s+)?((public|private|protected)\s+)?(static\s+)?function\s+{word}\s*\(/
    ]
    type: ['*.hh']

  Ruby:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}(\s|$)/
      /(^|\s)module\s+{word}(\s|$)/
      /(^|\s)def\s+(?:self\.)?{word}\s*\(?/
      /(^|\s)scope\s+:{word}\s*\(?/
      /(^|\s)attr_accessor\s+:{word}(\s|$)/
      /(^|\s)attr_reader\s+:{word}(\s|$)/
      /(^|\s)attr_writer\s+:{word}(\s|$)/
      /(^|\s)define_method\s+:?{word}\s*\(?/
    ]
    type: ['*.rb', '*.ru', '*.haml', '*.erb', '*.rake']

  Puppet:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}(\s|$)/
    ]
    type: ['*.pp']

  KRL:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)DEF\s+{word}\s*\(/
      /(^|\s)DECL\s+\w*?{word}\s*\=?/
      /(^|\s)(SIGNAL|INT|BOOL|REAL|STRUC|CHAR|ENUM|EXT|\s)\s*\w*{word}.*/
    ]
    type: ['*.src', '*.dat']

  Perl:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)sub\s+{word}\s*\{/
      /(^|\s)package\s+(\w+::)*{word}\s*\;/
    ]
    type: ['*.pm', '*.pl']

  'C/C++':
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s)class\s+{word}(\s|:)/
      /(^|\s)struct\s+{word}(\s|\{|$)/
      /(^|\s)enum\s+{word}(\s|\{|$)/
      /(^|\s)#define\s+{word}(\s|\(|$)/
      /(^|\s)typedef\s.*(\s|\*|\(){word}(\s|;|\)|$)/
      /(^|\s|\*|:|&){word}\s*\(.*\)(\s*|\s*const\s*)(\{|$)/
    ]
    type: ['*.c', '*.cc', '*.cpp', '*.h', '*.hh', '*.hpp', '*.inc']
    
  Shell:
    word: /[0-9a-zA-Z_]+/
    regex: [
      /(^|\s){word}\s*\(\)\s*\{/
    ]
    type: ['*.sh']
