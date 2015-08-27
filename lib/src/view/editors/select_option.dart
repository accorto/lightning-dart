/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Select Option for [LSelect] and [SelectDataList]
 * extended by [ListItem] with icons
 */
class SelectOption {

  /**
   * Create List of Select Options From simple text list
   */
  static List<SelectOption> createListFromText(List<String> textList) {
    List<SelectOption> list = new List<SelectOption>();
    for (String text in textList) {
      DOption option = new DOption()
        ..label = text;
      String value = text.replaceAll(new RegExp(r'[^A-Za-z0-9]'), "_");
      option.value = value;
      list.add(new SelectOption(option));
    }
    return list;
  } // createListFromText


  /// The Option Source
  final DOption option;
  /// Select Option
  OptionElement oe;

  /**
   * Select Option
   */
  SelectOption(DOption this.option) {
  }

  /// Get Id
  String get id => option.id;
  /// Id
  void set id(String newValue) {
    option.id = newValue;
    if (oe != null) {
      oe.id = newValue;
    }
  }
  /// Get Label
  String get label => option.label;
  /// Label
  void set label(String newValue) {
    option.label = newValue;
    if (oe != null) {
      oe.label = newValue;
    }
  }
  /// Get Value
  String get value => option.value;
  /// Value
  void set value (String newValue) {
    option.value = newValue == null ? "" : newValue;
    if (oe != null) {
      oe.value = newValue;
    }
  }


  /// create Option Element
  OptionElement asOptionElement() {
    if (oe == null) {
      oe = OptionUtil.element(option);
    }
    return oe;
  }

  /// Show/Hide option
  bool get show => oe == null || !oe.classes.contains(LVisibility.C_HIDE);
  void set show (bool newValue) {
    if (oe != null) {
      if (newValue)
        oe.classes.remove(LVisibility.C_HIDE);
      else
        oe.classes.add(LVisibility.C_HIDE);
    }
  }

  bool get selected => option.isSelected;
  void set selected (bool newValue) {
    option.isSelected = newValue;
    if (oe != null) {
      oe.selected = newValue;
    }
  } // selected

  bool get disabled => !option.isActive;
  void set disabled (bool newValue) {
    option.isActive = !newValue;
    if (oe != null) {
      oe.disabled = newValue;
    }
  } // disabled

} // SelectOption

