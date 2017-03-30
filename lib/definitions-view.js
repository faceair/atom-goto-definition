/** @babel */

/* eslint class-methods-use-this: ["error", { "exceptMethods": ["getFilterKey", "viewForItem"] }] */
// fork from https://github.com/sadovnychyi/autocomplete-python/blob/master/lib/definitions-view.coffee

import { $, $$, SelectListView } from 'atom-space-pen-views';

export default class DefinitionsView extends SelectListView {
  constructor() {
    super();
    this.storeFocusedElement();
    this.addClass('symbols-view');
    this.setState('ready');
    this.setLoading('Looking for definitions');

    this.panel = atom.workspace.addModalPanel({ item: this, visible: false });
    this.items = [];

    this.list.unbind('mouseup');
    this.list.on('click', 'li', (e) => {
      if ($(e.target).closest('li').hasClass('selected')) {
        this.confirmSelection();
      }
      e.preventDefault();
      return false;
    });
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

  viewForItem({ text, fileName, line }) {
    const relativePath = atom.project.relativizePath(fileName)[1];
    return $$(function itemView() {
      this.li({ class: 'two-lines' }, () => {
        this.div(`${text}`, { class: 'primary-line' });
        this.div(`${relativePath}, line ${line + 1}`, { class: 'secondary-line' });
      });
    });
  }

  addItems(items) {
    if (!['ready', 'loding'].includes(this.state)) {
      return null;
    }
    this.setState('loding');

    if (this.items.length === 0) {
      this.setItems(items);
    } else {
      this.show();
      for (let i = 0; i < items.length; i++) {
        const item = items[i];
        this.items.push(item);
        const itemView = $(this.viewForItem(item));
        itemView.data('select-list-item', item);
        this.list.append(itemView);
      }
    }
    return null;
  }

  getFilterKey() {
    return 'fileName';
  }

  showEmpty() {
    this.show();
    this.setError('No definition found');
    this.setLoading();
  }

  confirmedFirst() {
    if (this.items.length > 0) {
      this.confirmed(this.items[0]);
    }
  }

  confirmed({ fileName, line, column }) {
    if (this.state !== 'loding') {
      return null;
    }
    this.cancelPosition = null;
    this.cancelled();
    const promise = atom.workspace.open(fileName);
    promise.then((editor) => {
      editor.setCursorBufferPosition([line, column]);
      editor.scrollToCursorPosition();
    });
    return null;
  }

  show() {
    if (['ready', 'loding'].includes(this.state) && !this.panel.visible) {
      this.panel.show();
      this.focusFilterEditor();
    }
  }

  cancelled() {
    if (['ready', 'loding'].includes(this.state)) {
      this.setState('cancelled');
      this.panel.destroy();
    }
  }
}
