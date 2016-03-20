/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Text Area Input
 */
class LTextArea
    extends LEditor with LFormElement {

  /// Input Element
  final TextAreaElement input = new TextAreaElement();

  /**
   * Text Area Input
   */
  LTextArea(String name, {String idPrefix, bool inGrid:false, bool oneLine:false}) {
    createBaseLayout(this, inGrid:inGrid);
    input.name = name;
    id = createId(idPrefix, name);
    _initEditor(oneLine);
  }

  LTextArea.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false, bool oneLine:false}) {
    createBaseLayout(this, inGrid:inGrid);
    input.name = dataColumn.name;
    id = createId(idPrefix, input.name);
    //
    this.dataColumn = dataColumn;
    _initEditor(oneLine);
  }

  /// initialize listeners
  void _initEditor(bool oneLine) {
    if (inGrid || oneLine) {
      rows = 1;
      input.onFocus.listen((Event evt){
        input.rows = 3;
        input.cols = 40;
      });
      input.onBlur.listen((Event evt){
        input.rows = 1;
        input.attributes.remove("cols");
        input.style.removeProperty("height"); // manual resize
        input.style.removeProperty("width");
      });
    } else {
      rows = 3;
    }

    /// Changes
    input.onInput.listen(onInputChange);
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
    if (newValue > 0)
      input.maxLength = newValue;
  }

  /// Validation state from Input
  ValidityState get inputValidationState => input.validity;
  /// Validation Message from Input
  String get inputValidationMsg => input.validationMessage;
  /// set custom validity explicitly
  void setCustomValidity(String newValue) {
    input.setCustomValidity(newValue);
  }
} // LTextArea

