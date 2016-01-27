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
  /// reset/undo
  static const String RESET = "reset";
  static const String REFRESH = "refresh";

  static const String LAYOUT = "layout";

  static const String UP = "up";
  static const String DOWN = "down";

  static const String YES = "yes";
  static const String NO = "no";


  /// Standard New Action
  static AppsAction createNew(AppsActionTriggered callback) {
    return new AppsAction(NEW, appsActionNew(), callback)
      ..icon = new LIconUtility(LIconUtility.NEW);
  }
  /// Standard Delete Action
  static AppsAction createDelete(AppsActionTriggered callback) {
    return new AppsAction(DELETE, appsActionDelete(), callback)
      ..icon = new LIconUtility(LIconUtility.DELETE);
  }
  /// Standard Delete Selected Action
  static AppsAction createDeleteSelected(AppsActionTriggered callback) {
    return new AppsAction(DELETE_SELECTED, appsActionDeleteSelected(), callback)
      ..icon = new LIconUtility(LIconUtility.DELETE);
  }
  /// Standard Edit Action
  static AppsAction createEdit(AppsActionTriggered callback) {
    return new AppsAction(EDIT, appsActionEdit(), callback)
      ..icon = new LIconUtility(LIconUtility.EDIT);
  }
  /// Standard Save Action
  static AppsAction createSave(AppsActionTriggered callback) {
    return new AppsAction(SAVE, appsActionSave(), callback)
      ..icon = new LIconUtility(LIconUtility.CHECK);
  }

  /// Standard Reset Action
  static AppsAction createReset(AppsActionTriggered callback) {
    return new AppsAction(RESET, appsActionReset(), callback)
      ..icon = new LIconUtility(LIconUtility.UNDO);
  }
  /// Standard Refresh Action
  static AppsAction createRefresh(AppsActionTriggered callback) {
    return new AppsAction(REFRESH, appsActionRefresh(), callback)
      ..icon = new LIconUtility(LIconUtility.REFRESH);
  }

  /// Standard Layout Action
  static AppsAction createLayout(AppsActionTriggered callback) {
    return new AppsAction(LAYOUT, appsActionLayout(), callback)
      ..icon = new LIconUtility(LIconUtility.LAYOUT);
  }

  /// Standard Seq Action
  static AppsAction createUp(AppsActionTriggered callback) {
    return new AppsAction(UP, appsActionUp(), callback)
      ..icon = new LIconUtility(LIconUtility.UP);
  }
  /// Standard Seq Action
  static AppsAction createDown(AppsActionTriggered callback) {
    return new AppsAction(DOWN, appsActionDown(), callback)
      ..icon = new LIconUtility(LIconUtility.DOWN);
  }


  /// Standard Yes Action
  static AppsAction createYes(AppsActionTriggered callback) {
    return new AppsAction(YES, appsActionYes(), callback)
      ..icon = new LIconUtility(LIconUtility.SUCCESS);
  }
  /// Standard No Action
  static AppsAction createNo(AppsActionTriggered callback) {
    return new AppsAction(NO, appsActionNo(), callback)
      ..icon = new LIconUtility(LIconUtility.CLEAR);
  }


  /// Callback
  AppsActionTriggered callback;
  /// Option Info
  DOption option;
  /// Action Specific Variable
  var actionVar;
  /// show label in buttons
  bool showLabel = true;
  /// Action Icon
  LIcon icon;
  /// Assitive Text
  String assistiveText;
  /// Button Classes e.g. [LButton.C_BUTTON__NEUTRAL], [C_BUTTON__BRAND];
  List<String> buttonClasses;


  /// Apps Action from option
  AppsAction.from(DOption this.option,
      AppsActionTriggered this.callback);

  /// Apps Action with [value]
  AppsAction(String value,
      String label,
      AppsActionTriggered this.callback) {
    option = new DOption()
      ..value = value
      ..label = label;
  }

  String get value => option.value;
  String get label => option.label;

  /// disabled
  bool get disabled => _disabled;
  /// set disabled
  void set disabled (bool newValue) {
    _disabled = newValue;
    if (_btn != null) {
      _btn.disabled = _disabled;
    }
    if (_item != null) {
      _item.disabled = _disabled;
    }
  }
  bool _disabled = false;

  /// as Button - [createClick] to call [callback]
  LButton asButton(bool createOnClick,
      {DataRecord data,
      String idPrefix,
      bool recreate:false}) {

    if (_btn != null && !recreate) {
      return _btn;
    }
    _btn = new LButton(new ButtonElement(), value,
        showLabel ? label : null,
        icon:icon,
        idPrefix:idPrefix,
        buttonClasses:buttonClasses,
        assistiveText: assistiveText == null ? label : assistiveText);
    //
    _btn.disabled = _disabled;
    if (createOnClick && callback != null) {
      _btn.onClick.listen((MouseEvent evt){
        if (!disabled) {
          if (data != null)
            callback(value, data.record, null, actionVar);
          else
            callback(value, null, null, actionVar);
        }
      });
    }
    return _btn;
  } // asButton
  LButton _btn;

  /// as Dropdown Item
  LDropdownItem asDropdown(bool createOnClick,
      {bool recreate:false}) {

    if (_item != null && !recreate) {
      return _item;
    }
    LIcon theIcon = null;
    if (icon != null)
      theIcon = icon.copy();
    _item = new LDropdownItem(option, rightIcon:theIcon);
    _item.disabled = _disabled;
    if (createOnClick && callback != null) {
      _item.onClick.listen((MouseEvent evt){
        evt.stopImmediatePropagation();
        evt.preventDefault();
        if (!disabled) {
          callback(value, null, null, actionVar);
        }
      });
    }
    return _item;
  } // adDropdown
  LDropdownItem _item;

  String toString() {
    return "AppsAction[${value}]";
  }

  static String appsAction() => Intl.message("Action", name: "appsAction");
  static String appsActions() => Intl.message("Actions", name: "appsActions");

  static String appsActionNew() => Intl.message("New", name: "appsActionNew");
  static String appsActionEdit() => Intl.message("Edit", name: "appsActionEdit");
  static String appsActionSave() => Intl.message("Save", name: "appsActionSave");
  static String appsActionReset() => Intl.message("Reset", name: "appsActionReset");
  static String appsActionRefresh() => Intl.message("Refresh", name: "appsActionRefresh");
  static String appsActionDelete() => Intl.message("Delete", name: "appsActionDelete");
  static String appsActionDeleteSelected() => Intl.message("Delete Selected", name: "appsActionDeleteSelected");

  static String appsActionLayout() => Intl.message("Layout", name: "appsActionLayout");

  static String appsActionUp() => Intl.message("Up", name: "appsActionUp");
  static String appsActionDown() => Intl.message("Down", name: "appsActionDown");

  static String appsActionYes() => Intl.message("Yes", name: "appsActionYes");
  static String appsActionNo() => Intl.message("No", name: "appsActionNo");


} // AppsAction
