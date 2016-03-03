/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

class FkMultiDialog {

  static final Logger _log = new Logger("FkMultiDialog");

  LModal _modal;


  final List<DColumn> columnList;
  final List<LLookup> _lookupList = new List<LLookup>();
  FkMulti multi;


  FkMultiDialog(String name, List<DColumn> this.columnList) {
    String idPrefix = "fkmd_${name}";
    _modal = new LModal(idPrefix);
    _modal.setHeader(FkDialog.fkDialogTitle()); // temp
    //
    for (DColumn column in columnList) {
      LLookup ll = new LLookup(column.name, idPrefix: idPrefix)
        ..label = column.label
        ..editorChange = onEditorChange;
      _lookupList.add(ll);
      _modal.append(ll.element);
    }

    List<AppsAction> actions = [AppsAction.createReset(onActionReset),
      new AppsAction(AppsAction.SAVE, "Select", onActionSave)
        ..icon = new LIconUtility(LIconUtility.CHECK)];
    _modal.addFooterActions(actions, addCancel: true, hideOnAction: false);
  } // FkMultiDialog


  /// Show after setting parent values
  void show(FkMulti multi) { // assumes modal dialog
    this.multi = multi;
    _modal.setHeader("${FkDialog.fkDialogTitle()} ${multi.label}",icon: new LIconUtility(LIconUtility.JUSTIFY_TEXT));
    _modal.showInElement(AppsMain.modals);
    //
    // fill lookups
    for (int i = 0; i < _lookupList.length; i++) {
    //  fillLookup(i);
    }
  } // show

  /// editor changed
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    LLookup lookup = null;
    int level = 0;
    for (int i = 0; i < _lookupList.length; i++) {
      LLookup ll = _lookupList[i];
      if (name == ll.name) {
        level = i;
        lookup = ll;
        break;
      }
    }
    if (lookup != null) {
      _log.config("onEditorChange ${name} ${level}");


    }
  } // onEditorChange

  /// Reset
  void onActionReset(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionReset");
  }

  /// Check+Save
  void onActionSave(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionReset");

    // close
    _modal.onClickRemove(null);
  }


} // FkMultiDialog
