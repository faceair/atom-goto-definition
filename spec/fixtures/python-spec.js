/** @babel */

import helpers from '../spec-helpers';

describe('Python Goto Definition', () => {
  let [editor, mainModule] = Array.from([]);

  beforeEach(() => {
    waitsForPromise(() => helpers.openFile('test.py'));
    runs(() => {
      ({ editor, mainModule } = helpers.getPackage());
      helpers.nomalMode();
    });
  });

  it('no definition', () => {
    editor.setText('hello_world');
    editor.setCursorBufferPosition([0, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.py');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(0);
  });

  it('find function', () => {
    editor.setText(`\
def hello_world():
  return True
hello_world\
`);
    editor.setCursorBufferPosition([3, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.py');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(1);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('def hello_world():');
  });

  it('find function and class without saved', () => {
    editor.setText(`\
class hello_world(object):
  def hello_world(self):
    pass
hello_world\
`);
    editor.setCursorBufferPosition([4, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.py');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(2);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('class hello_world(object):');
    expect(mainModule.definitionsView.items[1].line).toEqual(1);
    expect(mainModule.definitionsView.items[1].text).toContain('def hello_world(self):');
  });

  it('find function and class with saved', () => {
    editor.setText(`\
class hello_world(object):
  def hello_world(self):
    pass
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([4, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.py');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());
    helpers.editorDelete();

    expect(mainModule.definitionsView.items.length).toEqual(2);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('class hello_world(object):');
    expect(mainModule.definitionsView.items[1].line).toEqual(1);
    expect(mainModule.definitionsView.items[1].text).toContain('def hello_world(self):');
  });

  it('performance mode find function and class with saved', () => {
    helpers.performanceMode();

    editor.setText(`\
class hello_world(object):
  def hello_world(self):
    pass
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([4, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.py');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());
    helpers.editorDelete();

    expect(mainModule.definitionsView.items.length).toEqual(2);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('class hello_world(object):');
    expect(mainModule.definitionsView.items[1].line).toEqual(1);
    expect(mainModule.definitionsView.items[1].text).toContain('def hello_world(self):');
  });
});
