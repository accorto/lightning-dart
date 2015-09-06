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


  RecordCtrlRelated(UI this.ui) {

  }


  /// Parent Record
  DRecord get record => _record;
  /// Parent Record
  void set record (DRecord newValue) {
    _record = newValue;
    display();
  } // setData
  DRecord _record;

  void display() {
  }

}
