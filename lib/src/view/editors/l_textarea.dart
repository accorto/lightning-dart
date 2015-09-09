/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Text Area Input
 */
class LTextArea extends LEditor with LFormElement {

  /// Input Element
  final TextAreaElement input = new TextAreaElement();
  /// Grid
  final bool inGrid;

  /**
   * Text Area Input
   */
  LTextArea(String name, {String idPrefix, bool this.inGrid:false}) {
    createStandard(this);
    input.name = name;
    input.id = createId(idPrefix, name);
    _initEditor();
  }

  LTextArea.from(DataColumn dataColumn, {String idPrefix, bool this.inGrid:false}) {
    createStandard(this);
    input.name = dataColumn.name;
    input.id = createId(idPrefix, input.name);
    //
    this.dataColumn = dataColumn;
    _initEditor();
  }

  void _initEditor() {
    if (inGrid) {
      rows = 1;
      input.onFocus.listen((Event evt){
        rows = 3;
      });
      input.onBlur.listen((Event evt){
        rows = 1;
      });
    } else {
      rows = 3;
    }

    /// Changes
    input.onChange.listen(onInputChange);
    input.onKeyUp.listen(onInputKeyUp);
  } // initializeEditor

  /// Editor Id
  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => input.name;
  String get type => input.type;


  int get rows => input.rows;
  void set rows (int newValue) {
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
  ValidityState get inputValidationState => input.validity;
  /// Validation Message from Input
  String get inputValidationMsg => input.validationMessage;

} // LTextArea

