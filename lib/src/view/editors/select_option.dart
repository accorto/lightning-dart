/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Select Option for Select/Picklist/...
 */
class SelectOption implements SelectOptionI {

  /// The Option
  final DOption option;

  OptionElement oe;
  LIElement li ;

  /**
   * Select Option
   */
  SelectOption(DOption this.option) {
  }

  String get id => option.id;
  String get value => option.value;
  String get label => option.label;
  LIcon get icon => null;

  /// create Option Element
  OptionElement asOptionElement() {
    if (oe == null) {
      oe = new OptionElement();
      oe.value = option.value;
      oe.text = option.label;
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
      li.text = option.label;
      // selected/disabled
    }
    return li;
  }

  bool get selected => option.isSelected;
  void set selected (bool newValue) {
    option.isSelected = newValue;
    if (oe != null) {
      oe.selected = newValue;
    }
    if (li != null) { // ?
    }
  } // selected

  bool get disabled => !option.isActive;
  void set disabled (bool newValue) {
    option.isActive = !newValue;
    if (oe != null) {
      oe.disabled = newValue;
    }
    if (li != null) { // ?
    }
  } // disabled

} // SelectOption


/**
 * Select Option Interface
 */
abstract class SelectOptionI {

  String get value;
  String get label;

  bool get selected;
  void set selected (bool newValue);

  bool get disabled;
  void set disabled (bool newValue);

  LIcon get icon;
}
