module.exports =
  JavaScript:
    regex: [
      "(^|\\h|\\.){word}\\s*=\\s*function\\s*\\("
      "(^|\\h)function\\s+{word}\\s*\\("
      "(^|\\h){word}\\([\\s\\S]*?\\)\\s*{"  # ES6
      "(^|\\h)class\\s+{word}(\\s|$)"
    ]
    type: ["*.js"]

  CoffeeScript:
    regex: [
      "(^|\\h)class\\s+{word}(\\s|$)"
      "(^|\\h|\\.){word}\\s*[:=]\\s*(\\([\\s\\S]*?\\))?\\s*[=-]>"
      "(^|\\h|\\.){word}\\s*=\\s*function\\s*\\(" # JavaScript Function
      "(^|\\h)function\\s+{word}\\s*\\("
      "(^|\\h){word}\\([\\s\\S]*?\\)\\s*{"  # ES6
    ]
    type: ["*.coffee", "*.js"]

  Python:
    regex: [
      "(^|\\h)class\\s+{word}\\s*\\("
      "(^|\\h)def\\s+{word}\\s*\\("
    ]
    type: ["*.py"]

  PHP:
    regex: [
      "(^|\\h)class\\s+{word}(\\s|{|$)"
      "(^|\\h)interface\\s+{word}(\\s|{|$)"
      "(^|\\h)(static\\s+)?((public|private|protected)\\s+)?(static\\s+)?function\\s+{word}\\s*\\("
    ]
    type: ["*.php"]

  Ruby:
    regex: [
      "(^|\\h)class\\s+{word}(\\s|$)"
      "(^|\\h)module\\s+{word}(\\s|$)"
      "(^|\\h)def\\s+{word}\\s*\\("
    ]
    type: ["*.rb"]

  General:
    regex: ["(^|\\h|\\.){word}(\\s|{|\\(|=|:|$)"]
    type: ["*"]
