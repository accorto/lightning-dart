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
  RecordSave recordSave;

  /**
   * New|Edit Dialog
   */
  ObjectEdit(UI this.ui) {
    form = new FormCtrl(ui.table.name, ui,
      element: new DivElement(), idPrefix:_ID);
    form.buildPanels();
    form.recordSave = onFormRecordSave;
    // form.formSubmitPre
    form.formSubmitPost = onFormSubmitPost;
    modal.addForm(form);
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
  Future<SResponse> onFormRecordSave(DRecord record) {
    Completer<SResponse> completer = new Completer<SResponse>();
    if (recordSave != null) {
      recordSave(record)
      .then((SResponse response) {
        completer.complete(response); // calls onFormSubmitPost
      });
    } else {
      completer.completeError(null);
    }
    return completer.future;
  } // onFormRecordSaved

  /// Post Form Submit
  void onFormSubmitPost (SResponse response) {
    if (response == null) {
      form.showError(objectEditError());
    } else if (response.isSuccess) {
      modal.show = false;
    } else {
      form.showError(response.msg);
    }
  }



  static String objectEditEdit() => Intl.message("Edit", name: "objectEditEdit");
  static String objectEditNew() => Intl.message("New", name: "objectEditNew");

  static String objectEditError() => Intl.message("Communication Error", name: "objectEditError");

} // ObjectEdit
