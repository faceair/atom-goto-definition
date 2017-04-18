/** @babel */

export default {
  HtmlTemplete: {
    word: /[$0-9a-zA-Z_]+/,
    regexes: [],
    files: ['*.html'],
    dependencies: ['JavaScript', 'CoffeeScript', 'TypeScript', 'PHP'],
  },

  JavaScriptTemplete: {
    word: /[$0-9a-zA-Z_]+/,
    regexes: [],
    files: ['*.jsx', '*.vue', '*.jade'],
    dependencies: ['JavaScript', 'CoffeeScript', 'TypeScript'],
  },

  JavaScript: {
    word: /[$0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s|\.){word}\s*[:=]\s*function\s*\(/,
      /(^|\s)function\s+{word}\s*\(/,
      /(^|\s)class\s+{word}(\s|$)/,
      /(^|\s){word}\s*\([^(]*?\)\s*\{/,
    ],
    files: ['*.js'],
    dependencies: ['CoffeeScript', 'TypeScript'],
  },

  CoffeeScript: {
    word: /[$0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)class\s+{word}(\s|$)/,
      /(^|\s|\.|@){word}\s*[:=]\s*(\([^(]*?\))?\s*[=-]>/,
    ],
    files: ['*.coffee'],
    dependencies: ['JavaScript', 'TypeScript'],
  },

  TypeScript: {
    word: /[$0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s|\.){word}\s*[:=]\s*function\s*\(/,
      /(^|\s)function\s+{word}\s*\(/,
      /(^|\s)interface\s+{word}(\s|$)/,
      /(^|\s)class\s+{word}(\s|$)/,
      /(^|\s){word}\([^(]*?\)\s*\{/,
      /(^|\s|\.|@){word}\s*[:=]\s*(\([^(]*?\))?\s*[=-]>/,
    ],
    files: ['*.ts'],
    dependencies: ['JavaScript', 'CoffeeScript'],
  },

  Python: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)class\s+{word}\s*\(/,
      /(^|\s)def\s+{word}\s*\(/,
    ],
    files: ['*.py'],
  },

  PHP: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)class\s+{word}(\s|\{|$)/,
      /(^|\s)interface\s+{word}(\s|\{|$)/,
      /(^|\s)trait\s+{word}(\s|\{|$)/,
      /(^|\s)(static\s+)?((public|private|protected)\s+)?(static\s+)?function\s+{word}\s*\(/,
      /(^|\s)const\s+{word}(\s|=|;|$)/,
    ],
    files: ['*.php', '*.php3', '*.phtml'],
  },

  ASP: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)(function|sub)\s+{word}\s*\(/,
    ],
    files: ['*.asp'],
  },

  Hack: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)class\s+{word}(\s|\{|$)/,
      /(^|\s)interface\s+{word}(\s|\{|$)/,
      /(^|\s)(static\s+)?((public|private|protected)\s+)?(static\s+)?function\s+{word}\s*\(/,
    ],
    files: ['*.hh'],
  },

  Ruby: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)class\s+{word}(\s|$)/,
      /(^|\s)module\s+{word}(\s|$)/,
      /(^|\s)def\s+(?:self\.)?{word}\s*\(?/,
      /(^|\s)scope\s+:{word}\s*\(?/,
      /(^|\s)attr_accessor\s+:{word}(\s|$)/,
      /(^|\s)attr_reader\s+:{word}(\s|$)/,
      /(^|\s)attr_writer\s+:{word}(\s|$)/,
      /(^|\s)define_method\s+:?{word}\s*\(?/,
    ],
    files: ['*.rb', '*.ru', '*.haml', '*.erb', '*.rake'],
  },

  Puppet: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)class\s+{word}(\s|$)/,
    ],
    files: ['*.pp'],
  },

  KRL: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)DEF\s+{word}\s*\(/,
      /(^|\s)DECL\s+\w*?{word}\s*=?/,
      /(^|\s)(SIGNAL|INT|BOOL|REAL|STRUC|CHAR|ENUM|EXT|\s)\s*\w*{word}.*/,
    ],
    files: ['*.src', '*.dat'],
  },

  Perl: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)sub\s+{word}\s*\{/,
      /(^|\s)package\s+(\w+::)*{word}\s*;/,
    ],
    files: ['*.pm', '*.pl'],
  },

  'C/C++': {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s)class\s+{word}(\s|:)/,
      /(^|\s)struct\s+{word}(\s|\{|$)/,
      /(^|\s)enum\s+{word}(\s|\{|$)/,
      /(^|\s)#define\s+{word}(\s|\(|$)/,
      /(^|\s)filesdef\s.*(\s|\*|\(){word}(\s|;|\)|$)/,
      /(^|\s|\*|:|&){word}\s*\(.*\)(\s*|\s*const\s*)(\{|$)/,
    ],
    files: ['*.c', '*.cc', '*.cpp', '*.cxx', '*.h', '*.hh', '*.hpp', '*.inc'],
  },

  Shell: {
    word: /[0-9a-zA-Z_]+/,
    regexes: [
      /(^|\s){word}\s*\(\)\s*\{/,
    ],
    files: ['*.sh'],
  },
};
