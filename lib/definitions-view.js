/** @babel */

/* eslint class-methods-use-this: ["error", {
  "exceptMethods": ["getFilterKey", "elementForItem", "didChangeSelection", "didLoseFocus"]
}] */

import SelectListView from 'atom-select-list';

SelectListView.prototype.didLoseFocus = function didLoseFocus(event) {
  this.props.didLoseFocus(event);
};


export default class DefinitionsView {
  constructor(emptyMessage = 'No definition found', maxResults = null) {
    this.selectListView = new SelectListView({
      maxResults,
      emptyMessage,
      items: [],
      filterKeyForItem: item => item.fileName,
      elementForItem: this.elementForItem.bind(this),
      didChangeSelection: this.didChangeSelection.bind(this),
      didConfirmSelection: this.didConfirmSelection.bind(this),
      didConfirmEmptySelection: this.didConfirmEmptySelection.bind(this),
      didCancelSelection: this.didCancelSelection.bind(this),
      didLoseFocus: this.didLoseFocus.bind(this),
    });
    this.element = this.selectListView.element;
    this.element.classList.add('symbols-view');
    this.panel = atom.workspace.addModalPanel({ item: this, visible: false });
  }

  attach() {
    this.previouslyFocusedElement = document.activeElement;
    this.panel.show();
    this.selectListView.reset();
    this.selectListView.focus();
  }

  getFilterKey() {
    return 'fileName';
  }

  elementForItem({ fileName, text, line }) {
    const relativePath = atom.project.relativizePath(fileName)[1];

    const li = document.createElement('li');
    li.classList.add('two-lines');

    const primaryLine = document.createElement('div');
    primaryLine.classList.add('primary-line');
    primaryLine.textContent = text;
    li.appendChild(primaryLine);

    const secondaryLine = document.createElement('div');
    secondaryLine.classList.add('secondary-line');
    secondaryLine.textContent = `${relativePath}, line ${line + 1}`;
    li.appendChild(secondaryLine);

    return li;
  }

  addItems(items) {
    this.selectListView.update({ items });
  }

  async cancel() {
    if (!this.isCanceling) {
      this.isCanceling = true;
      await this.selectListView.update({ items: [] });
      this.panel.hide();
      if (this.previouslyFocusedElement) {
        this.previouslyFocusedElement.focus();
        this.previouslyFocusedElement = null;
      }
      this.isCanceling = false;
    }
  }

  didCancelSelection() {
    this.cancel();
  }

  didConfirmEmptySelection() {
    this.cancel();
  }

  didLoseFocus() {

  }

  async didConfirmSelection({ fileName, line, column }) {
    const promise = atom.workspace.open(fileName);
    promise.then((editor) => {
      editor.setCursorBufferPosition([line, column]);
      editor.scrollToCursorPosition();
    });
    await this.cancel();
  }

  didChangeSelection() {
  }

  async destroy() {
    await this.cancel();
    this.panel.destroy();
    return this.selectListView.destroy();
  }
}
