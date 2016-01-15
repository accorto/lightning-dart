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
  static List<SelectOption> createListFromText(Iterable<String> textList) {
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
  DOption option;
  /// Select Option
  OptionElement oe;

  /**
   * Select Option
   * - selected is synced for [option] from [oe] when [selected] is read
   */
  SelectOption(DOption this.option) {
    oe = OptionUtil.element(option);
  }

  /**
   * Select Option
   */
  SelectOption.fromElement(OptionElement this.oe) {
    option = OptionUtil.optionFromElement(oe);
  }


  /// Get Id
  String get id => option.id;
  /// Id
  void set id(String newValue) {
    option.id = newValue;
    oe.id = newValue;
  }

  /// Get Label
  String get label => option.label;
  /// Label
  void set label(String newValue) {
    option.label = newValue;
    oe.label = newValue;
  }

  /// Description
  String get description => option.description;

  /// Label with (description)
  String get labelDescription {
    if (option.hasDescription()) {
      return "${option.label} (${option.description})";
    }
    return option.label;
  }

  /// Get Value
  String get value => option.value;
  /// Value
  void set value (String newValue) {
    option.value = newValue == null ? "" : newValue;
    oe.value = newValue;
  }

  /// Option Element
  OptionElement asOptionElement() => oe;

  /// Show/Hide option
  bool get show => !oe.classes.contains(LVisibility.C_HIDE);
  void set show (bool newValue) {
    if (newValue)
      oe.classes.remove(LVisibility.C_HIDE);
    else
      oe.classes.add(LVisibility.C_HIDE);
  }

  bool get selected {
    option.isSelected = oe.selected;
    return option.isSelected;
  }
  void set selected (bool newValue) {
    option.isSelected = newValue;
    oe.selected = newValue;
  } // selected

  bool get disabled => !option.isActive;
  void set disabled (bool newValue) {
    option.isActive = !newValue;
    oe.disabled = newValue;
  } // disabled

  String toString() => "SelectOption[${option.value}]";

} // SelectOption

