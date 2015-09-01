/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Action was Triggered with action [value] (name) - potentially providing [record] and/or [entry] context
 */
typedef void AppsActionTriggered(String value, DRecord record, DEntry entry);


/**
 * Application Action
 */
class AppsAction {

  static const String NEW = "new";
  static const String EDIT = "edit";
  static const String SAVE = "save";
  static const String DELETE = "delete";
  static const String DELETE_SELECTED = "deleteSelected";

  /// Standard New Action
  static AppsAction createNew(AppsActionTriggered callback) {
    return new AppsAction(NEW, appsActionNew(), callback);
  }
  /// Standard Delete Action
  static AppsAction createDelete(AppsActionTriggered callback) {
    return new AppsAction(DELETE, appsActionDelete(), callback);
  }
  /// Standard Delete Selected Action
  static AppsAction createDeleteSelected(AppsActionTriggered callback) {
    return new AppsAction(DELETE_SELECTED, appsActionDeleteSelected(), callback);
  }
  /// Standard Edit Action
  static AppsAction createEdit(AppsActionTriggered callback) {
    return new AppsAction(EDIT, appsActionEdit(), callback);
  }


  /// Callback
  AppsActionTriggered callback;
  /// Option Info
  DOption option;

  /// Apps Action from option
  AppsAction.from(DOption this.option, AppsActionTriggered this.callback);

  /// Apps Action with [name] (
  AppsAction(String value, String label, AppsActionTriggered this.callback) {
    option = new DOption()
      ..value = value
      ..label = label;
  }

  String get value => option.value;
  String get label => option.label;


  /// as Button
  LButton asButton(bool createOnClick, {DataRecord data}) {
    LButton btn = new LButton(new ButtonElement(), value, label);
    if (createOnClick && callback != null) {
      btn.onClick.listen((MouseEvent evt){
        if (data != null)
          callback(value, data.record, null);
        else
          callback(value, null, null);
      });
    }
    return btn;
  }

  /// as Dropdown Item
  LDropdownItem asDropdown() {
    LDropdownItem item = new LDropdownItem(option);
    return item;
  }



  static String appsAction() => Intl.message("Action", name: "appsAction");
  static String appsActions() => Intl.message("Actions", name: "appsActions");

  static String appsActionNew() => Intl.message("New", name: "appsActionNew");
  static String appsActionEdit() => Intl.message("Edit", name: "appsActionEdit");
  static String appsActionSave() => Intl.message("Save", name: "appsSave");
  static String appsActionDelete() => Intl.message("Delete", name: "appsDelete");
  static String appsActionDeleteSelected() => Intl.message("Delete Selected", name: "appsDeleteSelected");

} // AppsAction
