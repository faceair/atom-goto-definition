/** @babel */

/* eslint class-methods-use-this: ["error", {
  "exceptMethods": ["getFilterKey", "elementForItem", "didChangeSelection", "didLoseFocus"]
}] */

import SelectListView from 'atom-select-list';

let mouseOut = false;
document.addEventListener('mousedown', (event) => {
  if (event.target.firstChild && event.target.firstChild.className === 'select-list symbols-view') {
    mouseOut = true;
  }
}, true);
document.addEventListener('mouseup', () => { mouseOut = false; }, true);

SelectListView.prototype.oriDidLoseFocus = SelectListView.prototype.didLoseFocus;
SelectListView.prototype.didLoseFocus = function didLoseFocus(event) {
  if (mouseOut) {
    this.oriDidLoseFocus(event);
  } else {
    this.focus();
  }
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
    });
    this.element = this.selectListView.element;
    this.element.classList.add('symbols-view');
    this.panel = atom.workspace.addModalPanel({ item: this, visible: false });
    this.items = [];

    this.setState('ready');
    setTimeout(this.show.bind(this), 300);
  }

  setState(state) {
    if (state === 'ready' && !this.state) {
      this.state = 'ready';
      return null;
    }
    if (state === 'loding' && ['ready', 'loding'].includes(this.state)) {
      this.state = 'loding';
      return null;
    }
    if (state === 'cancelled' && ['ready', 'loding'].includes(this.state)) {
      this.state = 'cancelled';
      return null;
    }
    throw new Error('state switch error');
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
    if (!['ready', 'loding'].includes(this.state)) {
      return null;
    }
    this.setState('loding');

    this.items.push(...items);
    this.items.filter((v, i, a) => a.indexOf(v) === i);

    this.selectListView.update({ items: this.items });
    return null;
  }

  confirmedFirst() {
    if (this.items.length > 0) {
      this.didConfirmSelection(this.items[0]);
    }
  }

  show() {
    if (['ready', 'loding'].includes(this.state) && !this.panel.visible) {
      this.previouslyFocusedElement = document.activeElement;
      this.panel.show();
      this.selectListView.reset();
      this.selectListView.focus();
    }
  }

  async cancel() {
    if (['ready', 'loding'].includes(this.state)) {
      if (!this.isCanceling) {
        this.setState('cancelled');
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
  }

  didCancelSelection() {
    this.cancel();
  }

  didConfirmEmptySelection() {
    this.cancel();
  }

  async didConfirmSelection({ fileName, line, column }) {
    if (this.state !== 'loding') {
      return null;
    }
    const promise = atom.workspace.open(fileName);
    await promise.then((editor) => {
      editor.setCursorBufferPosition([line, column]);
      editor.scrollToCursorPosition();
    });
    await this.cancel();
    return null;
  }

  didChangeSelection() {
  }

  async destroy() {
    await this.cancel();
    this.panel.destroy();
    this.selectListView.destroy();
    return null;
  }
}
