/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Detail View
 */
class RecordCtrlDetails extends LForm {


  RecordCtrlDetails(UI ui, DataRecord data)
      : super(new FormElement(), ui.tableName, LForm.C_FORM__STACKED,
        idPrefix:"details", data:data) {

  } // RecordCtrlDetails


  DRecord get record => data.record;
  void set record (DRecord newValue) {
    data.setRecord(newValue, 0);
    display();
  } // setData


  /// Display data
  void display() {
    super.display();
  }

} // RecordCtrlDetails
