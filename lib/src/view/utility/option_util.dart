/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * (Select) Option Utility
 */
class OptionUtil {

  /// create DOption
  static DOption option(String value, String label, {
      String id, bool selected, bool disabled, bool isDefault, String title}) {
    DOption doption = new DOption();
    if (value != null)
      doption.value = value;
    if (label != null)
      doption.label = label;
    if (id != null)
      doption.id = id;
    if (selected != null && selected)
      doption.isSelected = true;
    if (disabled != null && disabled)
      doption.isActive = false;
    if (isDefault != null && isDefault)
      doption.isDefault = true;
    if (title != null)
      doption.description = title;
    return doption;
  }

  /// create DOption from OptionElement
  static DOption optionFromElement(OptionElement option) {
    DOption doption = new DOption()
      ..value = option.value
      ..label = option.label;
    if (option.id.isNotEmpty)
      doption.id = option.id;
    if (option.defaultSelected)
      doption.isDefault = true;
    if (option.selected)
      doption.isSelected = true;
    if (option.disabled)
      doption.isActive = false;
    return doption;
  }

  /// create DOption from FK
  static DOption optionFromFk(DFK fk) {
    DOption doption = new DOption()
      ..id = fk.id
      ..value = fk.id // fk.urv
      ..label = fk.drv;
    return doption;
  }

  /// create Option Element
  static OptionElement element(DOption option) {
    OptionElement element = new OptionElement()
      ..label = option.label
      ..value = option.value
      ..text = option.label; // FF requires
    if (option.hasId())
      element.id = option.id;
    if (option.hasIsDefault() && option.isDefault)
      element.defaultSelected = true;
    if (option.hasIsSelected() && option.isSelected)
      element.selected = true;
    if (option.hasIsActive() && !option.isActive)
      element.disabled = true;
    return element;
  }

  /// option list with yes/no
  static List<DOption> optionsYesNo(bool optional) {
    List<DOption> retValue = new List<DOption>();
    if (optional)
      retValue.add(new DOption());
    DOption doption = new DOption()
      ..value = Html0.V_TRUE
      ..label = optionUtilYes();
    retValue.add(doption);
    doption = new DOption()
      ..value = Html0.V_FALSE
      ..label = optionUtilNo();
    retValue.add(doption);
    return retValue;
  }

  /// Compare by label
  static int compareLabel(DOption one, DOption two){
    return one.label.compareTo(two.label);
  }

  /// is the newValue a synonym of the option
  static bool isSynonym(DOption option, String newValue) {
    if (option == null || newValue == null || newValue.isEmpty)
      return false;
    if (option.value == newValue || option.label == newValue || option.id == newValue)
      return true;

    return false;
  } // isSynonym

  /// Get sorted [table] Column name/label list
  static List<DOption> columnOptions(DTable table) {
    if (table == null)
      return null;
    if (table.name == _lastTableName && _lastColumnList != null) {
      return _lastColumnList;
    }
    _lastTableName = table.name;
    _lastColumnList = new List<DOption>();
    for (DColumn column in table.columnList) {
      DOption op = new DOption()
          ..value = column.name
          ..label = column.label
          ..iconImage = DataTypeUtil.getIconImage(column.dataType);
      _lastColumnList.add(op);
    }
    _lastColumnList.sort(compareLabel);
    return _lastColumnList;
  }
  static String _lastTableName;
  static List<DOption> _lastColumnList;

  static String optionUtilYes() => Intl.message("Yes", name: "optionUtilYes");
  static String optionUtilNo() => Intl.message("No", name: "optionUtilNo");

} // OptionUtil
