/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Collection of Related Lists
 */
class RecordCtrlRelated extends LComponent {

  final DivElement element = new DivElement();

  final UI ui;

  List<RecordCtrlRelatedItem> _items = new List<RecordCtrlRelatedItem>();

  /**
   * Related Records Tab
   */
  RecordCtrlRelated(UI this.ui) {
    // id set via tab

    for (UILink link in ui.linkList) {
      RecordCtrlRelatedItem item = new RecordCtrlRelatedItem(link);
      _items.add(item);
      element.append(item.element);
    }
  } // RecordCtrlRelated


  /// Parent Record
  DRecord get record => _record;
  /// Parent Record
  void set record (DRecord newValue) {
    _record = newValue;
    display();
  } // setData
  DRecord _record;

  /// init display
  void display() {
    for (RecordCtrlRelatedItem item in _items) {
      item.setParent(_record);
    }
  }

} // RecordCtrlRelated
