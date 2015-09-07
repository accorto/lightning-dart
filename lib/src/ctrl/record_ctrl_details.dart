/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Detail View
 */
class RecordCtrlDetails extends FormCtrl {


  RecordCtrlDetails(UI ui, String idPrefix)
      : super(ui.tableName, ui, idPrefix:idPrefix) {
    build();
    element.classes.add(LMargin.C_HORIZONTAL__LARGE);
  } // RecordCtrlDetails


  /// The Form Record
  DRecord get record => data.record;
  /// The Form Record
  void set record (DRecord newValue) {
    data.setRecord(newValue, 0);
    display();
  } // setData


  /// Display data
  void display() {
    super.display();
  }

} // RecordCtrlDetails
