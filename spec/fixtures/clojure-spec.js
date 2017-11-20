/** @babel */

import helpers from '../spec-helpers';

function getSelectedWord() {
  const { editor, mainModule } = helpers.getPackage();
  return mainModule.getSelectedWord(editor, /[*+!\-_'?a-zA-Z][*+!\-_'?a-zA-Z0-9]*/);
}

describe('Clojure Goto Definition', () => {
  let [editor, mainModule] = Array.from([]);

  beforeEach(() => {
    waitsForPromise(() => helpers.openFile('test.clj'));
    runs(() => {
      ({ editor, mainModule } = helpers.getPackage());
      helpers.nomalMode();
    });
  });

  it('no definition', () => {
    editor.setText('(hello-world)');
    editor.setCursorBufferPosition([0, 2]);

    expect(getSelectedWord()).toEqual('hello-world');
    expect(helpers.getFileTypes()).toContain('*.clj');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(0);
  });

  it('find function', () => {
    editor.setText(`\
(defn hello-world [] (list))
(hello-world)\
`);
    editor.setCursorBufferPosition([1, 2]);

    expect(getSelectedWord()).toEqual('hello-world');
    expect(helpers.getFileTypes()).toContain('*.clj');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(1);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('(defn hello-world [] (list))');
  });

  it('find ns, fn, and def without saving', () => {
    editor.setText(`\
(ns hello-world)
(defn hello-world [] (list))
(def hello-world "")
(hello-world)\
`);
    editor.setCursorBufferPosition([3, 2]);

    expect(getSelectedWord()).toEqual('hello-world');
    expect(helpers.getFileTypes()).toContain('*.clj');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(3);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('(ns hello-world)');

    expect(mainModule.definitionsView.items[1].line).toEqual(1);
    expect(mainModule.definitionsView.items[1].text).toContain('(defn hello-world [] (list))');

    expect(mainModule.definitionsView.items[2].line).toEqual(2);
    expect(mainModule.definitionsView.items[2].text).toContain('(def hello-world "")');
  });

  it('find ns, fn, and def with saved file', () => {
    editor.setText(`\
(ns hello-world)
(defn hello-world [] (list))
(def hello-world "")
(hello-world)\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([3, 1]);

    expect(getSelectedWord()).toEqual('hello-world');
    expect(helpers.getFileTypes()).toContain('*.clj');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(3);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('(ns hello-world)');

    expect(mainModule.definitionsView.items[1].line).toEqual(1);
    expect(mainModule.definitionsView.items[1].text).toContain('(defn hello-world [] (list))');

    expect(mainModule.definitionsView.items[2].line).toEqual(2);
    expect(mainModule.definitionsView.items[2].text).toContain('(def hello-world "")');
  });

  return it('performance mode find ns, fn, and def with saved file', () => {
    helpers.performanceMode();

    editor.setText(`\
(ns hello-world)
(defn hello-world [] (list))
(def hello-world "")
(hello-world)\
`);
    helpers.editorSave();
    editor.setCursorBufferPosition([3, 1]);

    expect(getSelectedWord()).toEqual('hello-world');
    expect(helpers.getFileTypes()).toContain('*.clj');
    expect(helpers.sendComand()).toBe(true);

    waitsForPromise(() => helpers.waitsComplete());

    expect(mainModule.definitionsView.items.length).toEqual(3);
    expect(mainModule.definitionsView.items[0].line).toEqual(0);
    expect(mainModule.definitionsView.items[0].text).toContain('(ns hello-world)');

    expect(mainModule.definitionsView.items[1].line).toEqual(1);
    expect(mainModule.definitionsView.items[1].text).toContain('(defn hello-world [] (list))');

    expect(mainModule.definitionsView.items[2].line).toEqual(2);
    expect(mainModule.definitionsView.items[2].text).toContain('(def hello-world "")');
  });
});
