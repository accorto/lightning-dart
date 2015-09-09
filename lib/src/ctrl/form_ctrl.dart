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

  final List<DataColumn> dataColumns = new List<DataColumn>();

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
        DataColumn dataColumn = DataColumn.fromUi(ui, pc.columnName, tableColumn:pc.column, panelColumn:pc);
        dataColumns.add(dataColumn);
        if (dataColumn.isActivePanel) {
          LEditor editor = EditorUtil.createfromColumn(null, dataColumn, false,
            idPrefix: element.id, data:data);
          addEditor(editor);
        }
      }
    }
    addResetButton();
    addSaveButton();
  } // build

} // FormCtrl
