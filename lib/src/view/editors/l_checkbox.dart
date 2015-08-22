/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Checkbox (handles input + presentation)
 */
class LCheckbox extends LEditor with LFormElement {

  /// The input
  final InputElement input = new InputElement()
    ..type = "checkbox";

  /**
   * Checkbox
   * (note that if id is not unique, it does not work!)
   */
  LCheckbox(String name, {String idPrefix}) {
    createCheckbox(input);
    input.name = name;
    input.id = createId(idPrefix, name);
  }

  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => input.name;
  String get type => input.type;


  /// String Value

  String get value => input.value;
  void set value (String newValue) {
    input.value = newValue;
  }

  String get defaultValue => input.defaultValue;
  void set defaultValue (String newValue) {
    input.defaultValue = newValue;
  }


  /// base editor methods

  bool get readOnly => input.readOnly;
  void set readOnly (bool newValue) {
    input.readOnly = newValue;
  }

  bool get disabled => input.disabled;
  void set disabled (bool newValue) {
    input.disabled = newValue;
  }

  @override
  void set required (bool newValue) {
    _required = newValue; // don't make input required (= checked)
    if (newValue) {
      element.classes.add(LForm.C_IS_REQUIRED);
    } else {
      element.classes.remove(LForm.C_IS_REQUIRED);
    }
  }

  bool get spellcheck => input.spellcheck;
  void set spellcheck (bool newValue) { // ignore
  }

  bool get autofocus => input.autofocus;
  void set autofocus (bool newValue) {
    input.autofocus = newValue;
  }

  /// Validation

  int get maxlength => input.maxLength;
  void set maxlength (int newValue) { // ignore
  }

  String get pattern => input.pattern;
  void set pattern (String newValue) { // ignore
  }

  /// Validation state from Input
  ValidityState get validationState => input.validity;
  /// Validation Message from Input
  String get validationMsg => input.validationMessage;

  /// Display

  String get placeholder => input.placeholder;
  void set placeholder (String newValue) { // ignore
  }

} // LCheckbox
