/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Modal New|Edit Dialog
 *
 * ObjectEdit oe = new ObjectEdit(ui);
 * oe.setRecord(record, rowNo);
 * oe.modal.showInElement(element);
 */
class ObjectEdit {

  static const String _ID = "oe";

  /// Modal
  LModal modal = new LModal(_ID);
  /// The Form
  FormCtrl _form;

  final UI ui;

  /**
   * New|Edit Dialog
   */
  ObjectEdit(UI this.ui) {
    _form = new FormCtrl(ui.table.name, ui,
      element: new DivElement(), idPrefix:_ID);
    _form.build();
    modal.addFooterFormButtons(_form);
    // _form.addResetButton().onClick.listen(onReset);
    // _form.onRecordSaved = filterRecordSaved;
    modal.add(_form);
  } // ObjectEdit

  /// set Record
  void setRecord(DRecord record, int rowNo) {
    if (record.hasRecordId() && record.hasDrv())
      modal.setHeader("${objectEditEdit()} ${ui.table.label}: ${record.drv}");
    else
      modal.setHeader("${objectEditNew()} ${ui.table.label}");
    //
    _form.setRecord(record, rowNo);
  }


  static String objectEditEdit() => Intl.message("Edit", name: "objectEditEdit");
  static String objectEditNew() => Intl.message("New", name: "objectEditNew");

} // ObjectEdit
