/** @babel */

import helpers from '../spec-helpers';

describe('CoffeeScript Goto Definition', () => {
  let [editor, mainModule] = Array.from([]);

  beforeEach(() => {
    waitsForPromise(() => helpers.openFile('test.coffee'));
    runs(() => {
      ({ editor, mainModule } = helpers.getPackage());
      helpers.nomalMode();
    });
  });

  it('no definition', () => {
    editor.setText('hello_world');
    editor.setCursorBufferPosition([0, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.coffee');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    return expect(mainModule.definitionsView.items.length).toEqual(0);
  });

  it('find function', () => {
    editor.setText(`\
hello_world = (word) ->
  return true
hello_world\
`);
    editor.setCursorBufferPosition([3, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.coffee');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(1);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('hello_world = (word) ->');
  });

  it('find function and class without saved', () => {
    editor.setText(`\
hello_world = (word) ->
  return true
class hello_world
  @hello_world: ->
  hello_world: () =>
hello_world\
`);
    editor.setCursorBufferPosition([6, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.coffee');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(4);

    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('hello_world = (word) ->');

    expect(mainModule.definitionsView.items[1].line).toEqual(2);
    expect(mainModule.definitionsView.items[1].text).toContain('class hello_world');

    expect(mainModule.definitionsView.items[2].line).toEqual(3);
    expect(mainModule.definitionsView.items[2].text).toContain('@hello_world: ->');

    expect(mainModule.definitionsView.items[3].line).toEqual(4);
    expect(mainModule.definitionsView.items[3].text).toContain('hello_world: () =>');
  });

  it('find function and class with saved', () => {
    editor.setText(`\
hello_world = (word) ->
  return true
class hello_world
  @hello_world: ->
  hello_world: () =>
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([6, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.coffee');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());
    helpers.editorDelete();

    expect(mainModule.definitionsView.items.length).toEqual(4);

    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('hello_world = (word) ->');

    expect(mainModule.definitionsView.items[1].line).toEqual(2);
    expect(mainModule.definitionsView.items[1].text).toContain('class hello_world');

    expect(mainModule.definitionsView.items[2].line).toEqual(3);
    expect(mainModule.definitionsView.items[2].text).toContain('@hello_world: ->');

    expect(mainModule.definitionsView.items[3].line).toEqual(4);
    expect(mainModule.definitionsView.items[3].text).toContain('hello_world: () =>');
  });

  return it('performance mode find function and class with saved', () => {
    helpers.performanceMode();

    editor.setText(`\
hello_world = (word) ->
  return true
class hello_world
  @hello_world: ->
  hello_world: () =>
hello_world\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([6, 1]);

    expect(helpers.getSelectedWord()).toEqual('hello_world');
    expect(helpers.getFileTypes()).toContain('*.coffee');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());
    helpers.editorDelete();

    expect(mainModule.definitionsView.items.length).toEqual(4);

    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('hello_world = (word) ->');

    expect(mainModule.definitionsView.items[1].line).toEqual(2);
    expect(mainModule.definitionsView.items[1].text).toContain('class hello_world');

    expect(mainModule.definitionsView.items[2].line).toEqual(3);
    expect(mainModule.definitionsView.items[2].text).toContain('@hello_world: ->');

    expect(mainModule.definitionsView.items[3].line).toEqual(4);
    expect(mainModule.definitionsView.items[3].text).toContain('hello_world: () =>');
  });
});
