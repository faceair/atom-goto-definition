# Goto Definition

![demo](http://ww1.sinaimg.cn/large/71ef46c1jw1f0f2vkw1aeg218f0p77rg.gif)

* Support `JavaScript(ES6)`, `CoffeeScript`, `Python`, `Ruby`, `PHP` languages
* Works with Mac OSX, Linux and Windows
* Goto-Definition functionality, by default on `Alt+Cmd+Enter`/`Ctrl+Alt+Enter`

### Notice

* If you want include VCS ignored paths, please turn `Settings -> Exclude VCS Ignored Paths` option off.
* If you want set `Goto Definition` to first right menu, like this

![demo](http://ww4.sinaimg.cn/large/71ef46c1jw1f11og5heiaj20fb04aaan.jpg)

please put this code into your `init.coffee`

    atom.contextMenu.add
      'atom-workspace atom-text-editor:not(.mini)': [
        {
          label: 'Goto Definition',
          command: 'goto-definition:go'
        },
        {
          type: 'separator'
        }
      ]

    atom.contextMenu.itemSets.unshift(atom.contextMenu.itemSets.pop())
