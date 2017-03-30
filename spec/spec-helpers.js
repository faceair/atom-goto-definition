/** @babel */

import fs from 'fs';

function getPackage() {
  const editor = atom.workspace.getActiveTextEditor();
  const { mainModule } = atom.packages.getActivePackage('goto-definition');
  return { editor, mainModule };
}

function openFile(filename) {
  return atom.workspace.open(filename).then(() => atom.packages.activatePackage('goto-definition'));
}

function editorSave() {
  const { editor } = getPackage();
  return editor.save();
}

function editorDelete() {
  const { editor } = getPackage();
  try {
    return fs.unlinkSync(editor.getPath());
  } catch (e) {
    return null;
  }
}

function getSelectedWord() {
  const { editor, mainModule } = getPackage();
  return mainModule.getSelectedWord(editor, /[$0-9a-zA-Z_]+/);
}

function getFileTypes() {
  const { editor, mainModule } = getPackage();
  return mainModule.getScanOptions(editor).fileTypes;
}

function sendComand() {
  const { editor } = getPackage();
  return atom.commands.dispatch(atom.views.getView(editor), 'goto-definition:go');
}

function waitsComplete() {
  const { mainModule } = getPackage();
  return new Promise((resolve) => {
    const timer = setInterval(() => {
      if (mainModule.state === 'completed') {
        resolve();
        clearInterval(timer);
      }
    }, 1);
  });
}

function nomalMode() {
  return atom.config.set('goto-definition.performanceMode', false);
}

function performanceMode() {
  return atom.config.set('goto-definition.performanceMode', true);
}

export default {
  openFile,
  editorSave,
  editorDelete,
  getPackage,
  getSelectedWord,
  getFileTypes,
  sendComand,
  waitsComplete,
  nomalMode,
  performanceMode,
};
