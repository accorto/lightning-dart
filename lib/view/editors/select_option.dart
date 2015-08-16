/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Select Option for Select/Picklist/...
 */
class SelectOption {

  /// create Option
  static SelectOption createOption(String value, String label) {
    return new SelectOption(createDOption(value, label));
  }

  /// create DOption
  static DOption createDOption(String value, String label) {
    DOption option = new DOption()
      ..value = value
      ..display = label;
    return option;
  }

  /// The Option
  final DOption option;

  OptionElement oe;
  LIElement li ;

  /**
   * Select Option
   */
  SelectOption(DOption this.option) {
  }

  String get value => option.value;
  String get label => option.display;


  /// create Option Element
  OptionElement asOptionElement() {
    if (oe == null) {
      oe = new OptionElement();
      oe.value = option.value;
      oe.text = option.display;
      if (option.isSelected)
        oe.selected = true;
      if (!option.isActive)
        oe.disabled = true;
    }
    return oe;
  }

  /// create List Element
  LIElement asListElement() {
    if (li == null) {
      li = new LIElement();
      li.attributes[Html0.DATA_VALUE] = option.value;
      li.text = option.display;
    }
    return li;
  }

  bool get selected => option.isSelected;
  void set selected (bool newValue) {
    option.isSelected = newValue;
    if (oe != null) {
      oe.selected = newValue;
    }
    if (li != null) {

    }
  } // selected

  bool get disabled => !option.isActive;
  void set disabled (bool newValue) {
    option.isActive = !newValue;
    if (oe != null) {
      oe.disabled = newValue;
    }
    if (li != null) {

    }
  } // disabled

} // SelectOption
