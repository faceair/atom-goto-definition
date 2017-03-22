# Goto Definition

[![Build Status](https://travis-ci.org/r-chris/atom-goto-definition.svg?branch=master)](https://travis-ci.org/r-chris/atom-goto-definition)

![demo](http://ww1.sinaimg.cn/large/71ef46c1ly1fdt8wgbaiqg20zi0j8hdu.gif)

* Support for `JavaScript(ES6 && JSX)`, `TypeScript`, `CoffeeScript`, `Python`, `Ruby`, `PHP`, `Hack`, `Perl`, `KRL`, `Erb`, `Haml`, `C/C++`, `Puppet`, `ASP`
* Works with Mac OSX, Linux and Windows
* Goto-Definition functionality, by default on `Alt+Cmd+Enter`/`Ctrl+Alt+Enter`
* Support [hyperclick](https://atom.io/packages/hyperclick), `<cmd-click>` on a word to jump it's declaration

## Installing
Install the package ```goto-definition``` in Atom (Preferences->Install) or use Atom's package manager from a shell:  
```
$ apm install goto-definition
```

## Performance Mode

Performance mode is 10x faster then nomal model. if you want a better experience, please open the performance mode.

Steps:

1. Install `ripgrep`, see [https://github.com/BurntSushi/ripgrep#installation](https://github.com/BurntSushi/ripgrep#installation). Yeap, now we use `ripgrep` to search definitions, because of it's incredibly fast.
2. Turn `Settings -> Packages -> goto-definition -> Settings -> Performance Mode` on.
3. Enjoy it.

Now the performance model is still testing, welcome suggestions and feedback. If it goes well, we will open the performance mode by default in the next version.

### Ignoring files

In performance mode, if you want ignore some files, you can create a file called `.ignore` in the root of the project, it working like `.gitignore`.

### Notice

* In nomal model, if you want include VCS ignored paths, please turn `Settings -> Exclude VCS Ignored Paths` option off.
