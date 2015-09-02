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
  final DataRecord data;


  RecordCtrlRelated(UI this.ui, DataRecord this.data) {

  }


  DRecord get record => data.record;
  void set record (DRecord newValue) {
    data.setRecord(newValue, 0);
    display();
  } // setData

  void display() {
  }

}
