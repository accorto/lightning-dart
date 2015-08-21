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

  /// The Option
  final DOption option;

  OptionElement oe;

  /**
   * Select Option
   */
  SelectOption(DOption this.option) {
  }

  String get id => option.id;
  String get value => option.value;
  String get label => option.label;

  /// create Option Element
  OptionElement asOptionElement() {
    if (oe == null) {
      oe = OptionUtil.element(option);
    }
    return oe;
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

