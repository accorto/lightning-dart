/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Form Util - create Form from UI
 */
class FormCtrl extends LForm {

  /// The UI
  final UI ui;

  /**
   * Form Util
   */
  FormCtrl(String name, UI this.ui, {
      Element element,
      String type: LForm.C_FORM__STACKED,
      String idPrefix})
    : super(element == null ? new FormElement() : element, name, type, idPrefix:idPrefix) {

  } // FormUtil



  void build() {
    for (UIPanel panel in ui.panelList) {
      for (UIPanelColumn pc in panel.panelColumnList) {

        LEditor editor = EditorUtil.createfromColumn(null, pc.column, data, false, element.id);
        addEditor(editor);
      }
    }
    addResetButton();
    addSaveButton();
  } // build

} // FormCtrl
