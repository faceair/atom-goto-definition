/** @babel */

import helpers from '../spec-helpers';

describe('Fish Goto Definition', () => {
  let [editor, mainModule] = Array.from([]);

  beforeEach(() => {
    waitsForPromise(() => helpers.openFile('test.fish'));
    runs(() => {
      ({ editor, mainModule } = helpers.getPackage());
      helpers.nomalMode();
    });
  });

  it('no definition', () => {
    editor.setText('hello_world');
    editor.setCursorBufferPosition([0, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.fish');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(0);
  });

  it('find function', () => {
    editor.setText(`\
function hello_world
  return 0
hello_world\
`);
    editor.setCursorBufferPosition([3, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.fish');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(1);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world');
  });

  it('find function and variable without saving', () => {
    editor.setText(`\
function hello_world
  return 0
set hello_world hello
alias hello_world='hello'
abbr --add hello_world 'hello'
hello_world\
`);
    editor.setCursorBufferPosition([6, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.fish');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(4);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world');

    expect(mainModule.definitionsView.items[1].line).toEqual(2);
    expect(mainModule.definitionsView.items[1].text).toContain('set hello_world hello');

    expect(mainModule.definitionsView.items[2].line).toEqual(3);
    expect(mainModule.definitionsView.items[2].text).toContain("alias hello_world='hello'");

    expect(mainModule.definitionsView.items[3].line).toEqual(4);
    expect(mainModule.definitionsView.items[3].text).toContain("abbr --add hello_world 'hello'");
  });

  it('find function and variable with saved file', () => {
    editor.setText(`\
function hello_world
  return 0
set hello_world hello
alias hello_world='hello'
abbr --add hello_world 'hello'
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([6, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.fish');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(4);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world');

    expect(mainModule.definitionsView.items[1].line).toEqual(2);
    expect(mainModule.definitionsView.items[1].text).toContain('set hello_world hello');

    expect(mainModule.definitionsView.items[2].line).toEqual(3);
    expect(mainModule.definitionsView.items[2].text).toContain("alias hello_world='hello'");

    expect(mainModule.definitionsView.items[3].line).toEqual(4);
    expect(mainModule.definitionsView.items[3].text).toContain("abbr --add hello_world 'hello'");
  });

  return it('performance mode find function and variable with saved file', () => {
    helpers.performanceMode();

    editor.setText(`\
function hello_world
  return 0
set hello_world hello
alias hello_world='hello'
abbr --add hello_world 'hello'
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([6, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.fish');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(4);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world');

    expect(mainModule.definitionsView.items[1].line).toEqual(2);
    expect(mainModule.definitionsView.items[1].text).toContain('set hello_world hello');

    expect(mainModule.definitionsView.items[2].line).toEqual(3);
    expect(mainModule.definitionsView.items[2].text).toContain("alias hello_world='hello'");

    expect(mainModule.definitionsView.items[3].line).toEqual(4);
    expect(mainModule.definitionsView.items[3].text).toContain("abbr --add hello_world 'hello'");
  });
});
