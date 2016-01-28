module.exports =
  JavaScript:
    regex: [
      "(^|\\s|\\.){word}\\s*=\\s*function\\s*\\("
      "function\\s*{word}\\s*\\("
    ]
    type: ["*.js"]

  CoffeeScript:
    regex: [
      "class\\s+{word}\\s*(extends)?"
      "{word}\\s*[:=]\\s*(\\(.*\\))?\\s*[=-]>"
      "(^|\\s|\\.){word}\\s*=\\s*function\\s*\\(" # JavaScript Function
      "function\\s*{word}\\s*\\("
    ]
    type: ["*.coffee", "*.js"]

  Python:
    regex: [
      "class\\s+{word}\\s*\\("
      "def\\s+{word}\\s*\\("
    ]
    type: ["*.py"]

  PHP:
    regex: [
      "class\\s+{word}\\s*(extends)?\\s*(implements)?"
      "(static)?\\s*(public|private|protected)?\\s*(static)?\\s*function\\s+{word}\\s*\\("
    ]
    type: "*.php"

  General:
    regex: ["{word}"]
    type: ["*"]
