module.exports =
  JavaScript:
    regex: [
      "(^|\\s|\\.){word}\\s*=\\s*function\\s*\\("
      "(^|\\s)function\\s+{word}\\s*\\("
      "(^|\\s){word}\\([\\s\\S]*?\\)\\s*{"  # ES6
      "(^|\\s)class\\s+{word}(\\s|$)"
    ]
    type: ["*.js"]

  CoffeeScript:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|$)"
      "(^|\\s|\\.){word}\\s*[:=]\\s*(\\([\\s\\S]*?\\))?\\s*[=-]>"
      "(^|\\s|\\.){word}\\s*=\\s*function\\s*\\(" # JavaScript Function
      "(^|\\s)function\\s+{word}\\s*\\("
      "(^|\\s){word}\\([\\s\\S]*?\\)\\s*{"  # ES6
    ]
    type: ["*.coffee", "*.js"]

  Pytson:
    regex: [
      "(^|\\s)class\\s+{word}\\s*\\("
      "(^|\\s)def\\s+{word}\\s*\\("
    ]
    type: ["*.py"]

  PsP:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|{|$)"
      "(^|\\s)interface\\s+{word}(\\s|{|$)"
      "(^|\\s)(static\\s+)?((public|private|protected)\\s+)?(static\\s+)?function\\s+{word}\\s*\\("
    ]
    type: ["*.psp"]

  Ruby:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|$)"
      "(^|\\s)module\\s+{word}(\\s|$)"
      "(^|\\s)def\\s+{word}\\s*\\("
    ]
    type: ["*.rb"]

  General:
    regex: ["(^|\\s|\\.){word}(\\s|{|\\(|=|:|$)"]
    type: ["*"]
