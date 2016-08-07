module.exports =
  'JavaScript (JSX)':
    regex: [
      "(^|\\s|\\.){word}\\s*[:=]\\s*function\\s*\\("
      "(^|\\s)function\\s+{word}\\s*\\("
      "(^|\\s){word}\\([\\s\\S]*?\\)\\s*{"  # ES6
      "(^|\\s)class\\s+{word}(\\s|$)"
    ]
    type: ["*.jsx", "*.js", "*.html"]

  CoffeeScript:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|$)"
      "(^|\\s|\\.){word}\\s*[:=]\\s*(\\([\\s\\S]*?\\))?\\s*[=-]>"
      "(^|\\s|\\.){word}\\s*[:=]\\s*function\\s*\\(" # JavaScript Function
      "(^|\\s)function\\s+{word}\\s*\\("
      "(^|\\s){word}\\([\\s\\S]*?\\)\\s*{"  # ES6
    ]
    type: ["*.coffee", "*.js", "*.html"]

  TypeScript:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|$)"
      "(^|\\s|\\.){word}\\s*[:=]\\s*(\\([\\s\\S]*?\\))?\\s*[=-]>"
      "(^|\\s|\\.){word}\\s*[:=]\\s*function\\s*\\(" # JavaScript Function
      "(^|\\s)function\\s+{word}\\s*\\("
      "(^|\\s){word}\\([\\s\\S]*?\\)\\s*{"  # ES6
    ]
    type: ["*.ts", "*.html"]

  Python:
    regex: [
      "(^|\\s)class\\s+{word}\\s*\\("
      "(^|\\s)def\\s+{word}\\s*\\("
    ]
    type: ["*.py"]

  PHP:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|{|$)"
      "(^|\\s)interface\\s+{word}(\\s|{|$)"
      "(^|\\s)(static\\s+)?((public|private|protected)\\s+)?(static\\s+)?function\\s+{word}\\s*\\("
    ]
    type: ["*.php"]
    
  Hack:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|{|$)"
      "(^|\\s)interface\\s+{word}(\\s|{|$)"
      "(^|\\s)(static\\s+)?((public|private|protected)\\s+)?(static\\s+)?function\\s+{word}\\s*\\("
    ]
    type: ["*.hh"]

  Ruby:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|$)"
      "(^|\\s)module\\s+{word}(\\s|$)"
      "(^|\\s)def\\s+(?:self\\.)?{word}\\s*\\(?"
      "(^|\\s)define_method\\s+:?{word}\\s*\\(?"
    ]
    type: ["*.rb"]

  KRL:
    regex: [
      "(^|\\s)DEF\\s+{word}\\s*\\("
      "(^|\\s)DECL\\s+\\w*?{word}\\s*\\=?"
      "(^|\\s)(SIGNAL|INT|BOOL|REAL|STRUC|CHAR|ENUM|EXT|\\s)\\s*\\w*{word}.*"
    ]
    type: ["*.src","*.dat"]

  Perl:
    regex: [
      "(^|\\s)sub\\s+{word}\\s*\\{"
      "(^|\\s)package\\s+(\\w+::)*{word}\\s*\\;"
    ]
    type: ["*.pm","*.pl"]
