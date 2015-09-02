/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Action was Triggered with action [value] (name) - potentially providing [record] and/or [entry] context
 */
typedef void AppsActionTriggered(String value, DRecord record, DEntry entry, var actionVar);


/**
 * Application Action
 */
class AppsAction {

  static const String NEW = "new";
  static const String EDIT = "edit";
  static const String SAVE = "save";
  static const String DELETE = "delete";
  static const String DELETE_SELECTED = "deleteSelected";

  static const String YES = "yes";
  static const String NO = "no";


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

  /// Standard Yes Action
  static AppsAction createYes(AppsActionTriggered callback) {
    return new AppsAction(YES, appsActionYes(), callback);
  }
  /// Standard Yes Action
  static AppsAction createNo(AppsActionTriggered callback) {
    return new AppsAction(NO, appsActionNo(), callback);
  }


  /// Callback
  AppsActionTriggered callback;
  /// Option Info
  DOption option;
  /// Action Specific Variable
  var actionVar;

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


  /// as Button - [createClick] to call [callback]
  LButton asButton(bool createOnClick, {DataRecord data, List<String> buttonClasses}) {
    LButton btn = new LButton(new ButtonElement(), value, label);
    if (buttonClasses != null) {
      btn.classes.addAll(buttonClasses);
    }
    if (createOnClick && callback != null) {
      btn.onClick.listen((MouseEvent evt){
        if (data != null)
          callback(value, data.record, null, actionVar);
        else
          callback(value, null, null, actionVar);
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
  static String appsActionSave() => Intl.message("Save", name: "appsActionSave");
  static String appsActionDelete() => Intl.message("Delete", name: "appsActionDelete");
  static String appsActionDeleteSelected() => Intl.message("Delete Selected", name: "appsActionDeleteSelected");

  static String appsActionYes() => Intl.message("Yes", name: "appsActionYes");
  static String appsActionNo() => Intl.message("No", name: "appsActionNo");


} // AppsAction
