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
  FormCtrl form;
  /// Base UI
  final UI ui;
  /// Callback when save
  RecordSaved recordSaved;

  /**
   * New|Edit Dialog
   */
  ObjectEdit(UI this.ui) {
    form = new FormCtrl(ui.table.name, ui,
      element: new DivElement(), idPrefix:_ID);
    form.buildPanels();
    form.recordSaved = onFormRecordSaved;
    modal.addForm(form);
    // _form.addResetButton().onClick.listen(onReset);
    // _form.onRecordSaved = filterRecordSaved;
  } // ObjectEdit

  /// set Record
  void setRecord(DRecord record, int rowNo) {
    if (record.hasRecordId() && record.hasDrv())
      modal.setHeader("${objectEditEdit()} ${ui.table.label}: ${record.drv}");
    else
      modal.setHeader("${objectEditNew()} ${ui.table.label}");
    //
    form.setRecord(record, rowNo);
  }

  /// close Modal
  Future<SResponse> onFormRecordSaved(DRecord record) {
    Completer<SResponse> completer = new Completer<SResponse>();
    if (recordSaved != null) {
      recordSaved(record)
      .then((SResponse response) {
        completer.complete(response);
        modal.show = !response.isSuccess;
      });
    } else {
      completer.completeError("NoServer");
    }
    return completer.future;
  }


  static String objectEditEdit() => Intl.message("Edit", name: "objectEditEdit");
  static String objectEditNew() => Intl.message("New", name: "objectEditNew");

} // ObjectEdit
