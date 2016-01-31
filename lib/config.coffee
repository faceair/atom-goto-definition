module.exports =
  JavaScript:
    regex: [
      "(^|\\s|\\.){word}\\s*=\\s*function\\s*\\("
      "(^|\\s)function\\s+{word}\\s*\\("
    ]
    type: ["*.js"]

  CoffeeScript:
    regex: [
      "(^|\\s)class\\s+{word}\\s+(extends)?"
      "(^|\\s|\\.){word}\\s*[:=]\\s*(\\([\\s\\S]*?\\))?\\s*[=-]>"
      "(^|\\s|\\.){word}\\s*=\\s*function\\s*\\(" # JavaScript Function
      "(^|\\s)function\\s+{word}\\s*\\("
    ]
    type: ["*.coffee", "*.js"]

  Python:
    regex: [
      "(^|\\s)class\\s+{word}\\s*\\("
      "(^|\\s)def\\s+{word}\\s*\\("
    ]
    type: ["*.py"]

  PHP:
    regex: [
      "(^|\\s)class\\s+{word}\\s+(extends|implements)?"
      "(^|\\s)(static\\s+)?((public|private|protected)\\s+)?(static\\s+)?function\\s+{word}\\s*\\("
    ]
    type: ["*.php"]

  General:
    regex: ["{word}"]
    type: ["*"]
