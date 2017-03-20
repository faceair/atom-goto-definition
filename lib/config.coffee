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
      "(^|\\s)trait\\s+{word}(\\s|{|$)"
      "(^|\\s)(static\\s+)?((public|private|protected)\\s+)?(static\\s+)?function\\s+{word}\\s*\\("
      "(^|\\s)const\\s+{word}(\\s|=|;|$)"
    ]
    type: ["*.php", "*.php3", "*.phtml"]

  ASP:
    regex: [
      "(^|\\s)(function|sub)\\s+{word}\\s*\\("
    ]
    type: ["*.asp"]

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
      "(^|\\s)scope\\s+:{word}\\s*\\(?"
      "(^|\\s)attr_accessor\\s+:{word}(\\s|$)"
      "(^|\\s)attr_reader\\s+:{word}(\\s|$)"
      "(^|\\s)attr_writer\\s+:{word}(\\s|$)"
      "(^|\\s)define_method\\s+:?{word}\\s*\\(?"
    ]
    type: ["*.rb", "*.ru", "*.haml", "*.erb"]

  Puppet:
    regex: [
      "(^|\\s)class\\s+{word}(\\s|$)"
    ]
    type: ["*.pp"]

  KRL:
    regex: [
      "(^|\\s)DEF\\s+{word}\\s*\\("
      "(^|\\s)DECL\\s+\\w*?{word}\\s*\\=?"
      "(^|\\s)(SIGNAL|INT|BOOL|REAL|STRUC|CHAR|ENUM|EXT|\\s)\\s*\\w*{word}.*"
    ]
    type: ["*.src", "*.dat"]

  Perl:
    regex: [
      "(^|\\s)sub\\s+{word}\\s*\\{"
      "(^|\\s)package\\s+(\\w+::)*{word}\\s*\\;"
    ]
    type: ["*.pm", "*.pl"]

  'C/C++':
    regex: [
      "(^|\\s)class\\s+{word}(\\s|:)"
      "(^|\\s)struct\\s+{word}(\\s|{|$)"
      "(^|\\s)enum\\s+{word}(\\s|{|$)"
      "(^|\\s)#define\\s+{word}(\\s|\\(|$)"
      "(^|\\s)typedef\\s.*(\\s|\\*|\\(){word}(\\s|;|\\)|$)"
      "^[^,=/(]*[^,=/(\\s]+\\s*(\\s|\\*|:|&){word}\\s*\\(.*\\)(\\s*|\\s*const\\s*)({|$)"
    ]
    type: ["*.c", "*.cc", "*.cpp", "*.h", "*.hh", "*.hpp", "*.inc"]

  Perl6:
    regex: [
      "(^|\\s)(class|grammar|module|role)\\s+{word}\\s*\\{"
      "(^|\\s)(multi|method|sub)\\s+{word}\\s*[({]"
      "(^|\\s)(sub|multi)\\s+\\w+fix:<{word}>\\s*[({]"
      "(^|\\s)sub\\s+{&word}\\s*[({]"
      "(^|\\s)(state|my|constant)\\s+(\\S+\\s+)?(\\\\|&)?{word}\\s*[=;]"
      "(^|\\s)subset\\s+{word}\\s"
      "(\\(|\\s)->\\s+(\\S+\\s*,\\s*)*{word}(\\s|\\{|,)"
    ]
    type: ["*.pm6","*.pl6", "*.p6"]

  'Clojure/ClojureScript':
    regex: [
      "\\(\\s*def\\s+{word}(\\s|\\))"
      "\\(\\s*def\\s+{@word}(\\s|\\))"
      "\\(\\s*defn\\s+{word}(\\s|\\[)"
      "\\(\\s*defmacro\\s+{word}(\\s|\\[)"
    ]
    type: ["*.clj","*.cljs"]
