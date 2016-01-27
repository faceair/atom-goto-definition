module.exports =
  JavaScript:
    regex: [
      "{word}\\s*=\\s*function\\("
      "function\\s*{word}\\s*\\("
    ]
    type: "*.js"

  CoffeeScript:
    regex: [
      "class\\s+{word}\\s*(extends)?"
      "{word}\\s*[:=]\\s*(\\(.*\\))?\\s*[=-]>"
      "{word}\\s*=\\s*function\\(" # JavaScript Function
      "function\\s*{word}\\s*\\("
    ]
    type: "*.coffee"

  Python:
    regex: [
      "class\\s+{word}\\s*\\("
      "def\\s+{word}\\s*\\("
    ]
    type: "*.py"

  PHP:
    regex: [
      "class\\s+{word}\\s*(extends)?\\s*(implements)?"
      "(static)?\\s*(public|private|protected)?\\s*(static)?\\s*function\\s+{word}\\s*\\("
    ]
    type: "*.php"

  General:
    regex: ["{word}"]
    type: "*"
