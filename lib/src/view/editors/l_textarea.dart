/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

class LTextArea extends LEditor with LFormElement {

  /// Input Element
  final TextAreaElement input = new TextAreaElement();

  LTextArea(String name, {String idPrefix}) {
    createStandard(input);
    input.name = name;
    input.id = createId(idPrefix, name);
  }

  LTextArea.from(DColumn column, {String idPrefix}) {
    createStandard(input);
    input.name = column.name;
    input.id = createId(idPrefix, name);
    //
    this.column = column;
  }

  /// Editor Id
  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => input.name;
  String get type => input.type;


  int get rows => input.rows;
  void set rowd (int newValue) {
    input.rows = newValue;
  }

  int get cols => input.cols;
  void set cols (int newValue) {
    input.cols = newValue;
  }

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

  bool get spellcheck => input.spellcheck;
  void set spellcheck (bool newValue) {
    input.spellcheck = newValue;
  }

  bool get autofocus => input.autofocus;
  void set autofocus (bool newValue) {
    input.autofocus = newValue;
  }

  /// Validation

  int get maxlength => input.maxLength;
  void set maxlength (int newValue) {
    input.maxLength = newValue;
  }

  /// Validation state from Input
  ValidityState get validationState => input.validity;
  /// Validation Message from Input
  String get validationMsg => input.validationMessage;

} // LTextArea

