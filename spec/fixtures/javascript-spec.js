/** @babel */

import helpers from '../spec-helpers';

describe('JavaScript Goto Definition', () => {
  let [editor, mainModule] = Array.from([]);

  beforeEach(() => {
    waitsForPromise(() => helpers.openFile('test.js'));
    runs(() => {
      ({ editor, mainModule } = helpers.getPackage());
      helpers.nomalMode();
    });
  });

  it('no definition', () => {
    editor.setText('hello_world');
    editor.setCursorBufferPosition([0, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.js');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(0);
  });

  it('find function', () => {
    editor.setText(`\
function hello_world() {
  return true;
}
hello_world\
`);
    editor.setCursorBufferPosition([3, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.js');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(1);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world() {');
  });

  it('find function and es6 class without saved', () => {
    editor.setText(`\
function hello_world() {
  return true;
}
class hello_world {
  hello_world(x, y) {
    this.x = x;
    this.y = y;
  }
}
hello_world\
`);
    editor.setCursorBufferPosition([10, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.js');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(3);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world() {');

    expect(mainModule.definitionsView.items[1].line).toEqual(3);
    expect(mainModule.definitionsView.items[1].text).toContain('class hello_world {');

    expect(mainModule.definitionsView.items[2].line).toEqual(4);
    expect(mainModule.definitionsView.items[2].text).toContain('hello_world(x, y) {');
  });

  it('find function and es6 class with saved', () => {
    editor.setText(`\
function hello_world() {
  return true;
}
class hello_world {
  hello_world(x, y) {
    this.x = x;
    this.y = y;
  }
}
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([10, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.js');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());
    helpers.editorDelete();

    expect(mainModule.definitionsView.items.length).toEqual(3);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world() {');

    expect(mainModule.definitionsView.items[1].line).toEqual(3);
    expect(mainModule.definitionsView.items[1].text).toContain('class hello_world {');

    expect(mainModule.definitionsView.items[2].line).toEqual(4);
    expect(mainModule.definitionsView.items[2].text).toContain('hello_world(x, y) {');
  });

  return it('performance mode find function and es6 class with saved', () => {
    helpers.performanceMode();

    editor.setText(`\
function hello_world() {
  return true;
}
class hello_world {
  hello_world(x, y) {
    this.x = x;
    this.y = y;
  }
}
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([10, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.js');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());
    helpers.editorDelete();

    expect(mainModule.definitionsView.items.length).toEqual(3);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('function hello_world() {');

    expect(mainModule.definitionsView.items[1].line).toEqual(3);
    expect(mainModule.definitionsView.items[1].text).toContain('class hello_world {');

    expect(mainModule.definitionsView.items[2].line).toEqual(4);
    expect(mainModule.definitionsView.items[2].text).toContain('hello_world(x, y) {');
  });
});
