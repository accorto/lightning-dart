/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Input Editor
 */
class LInput extends LEditor with LFormElement {

  /// Logger
  static final Logger _log = new Logger("LInput");

  /// Input Element
  final InputElement input = new InputElement();

  /**
   * Input Editor
   */
  LInput(String name, String type, {String idPrefix}) {
    createStandard(this);
    input.name = name;
    input.id = createId(idPrefix, name);
    input.type = type;
    //
    _initEditor();
  }

  /**
   * Input Editor
   */
  LInput.from(DColumn column, {String idPrefix, String type}) {
    createStandard(this);
    input.name = column.name;
    input.id = createId(idPrefix, name);
    if (type != null && type.isEmpty) // override
      input.type = type;
    else
      input.type = DataTypeUtil.getInputType(column.dataType);
    //
    this.column = column; // base values
    if (column.hasValFrom())
      min = column.valFrom;
    if (column.hasValTo())
      max = column.valTo;
    _initEditor();
  } // LInput

  /// initialize listeners
  void _initEditor() {
    if (type == EditorI.TYPE_PASSWORD) {
      input.autocomplete = "off";
      input.attributes["autocapitalize"] = "off";
      input.attributes["autocorrect"] = "off";
    }
    /// Changes
    input.onChange.listen(onInputChange);
    /// not a button, checkbox, ..
    if (!EditorI.TYPES_NOLABEL.contains(type)) {
      input.onKeyUp.listen(onInputKeyUp);
    }
    // stepper
    // if (EditorI.isDate(type) || type == EditorI.TYPE_NUMBER)
    if (type == EditorI.TYPE_NUMBER) {
      input.onClick.listen(onInputChange);
    }
  } // initializeEditor

  /// Editor Id
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

  String get pattern => input.pattern;
  void set pattern (String newValue) {
    input.pattern = newValue;
  }

  String get min => input.min;
  void set min (String newValue) {
    input.min = newValue;
  }
  String get max => input.max;
  void set max (String newValue) {
    input.max = newValue;
  }

  /// Validation state from Input
  ValidityState get inputValidationState => input.validity;
  /// Validation Message from Input
  String get inputValidationMsg => input.validationMessage;


  /// Display

  String get placeholder => input.placeholder;
  void set placeholder (String newValue) {
    input.placeholder = newValue;
  }

  /// Data Lists

  /// get Data List Id
  String get listId => input.attributes["list"];
  /// get Data List Id
  void set listId (String newValue) {
    input.attributes["list"] = newValue;
  }
  /// Set Data List
  void set list (SelectDataList dl) {
    input.attributes["list"] = dl.id;
  }

} // LInput
