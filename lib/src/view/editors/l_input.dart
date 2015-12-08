/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Input Editor
 */
class LInput
    extends LEditor with LFormElement {

  /// Logger
  static final Logger _log = new Logger("LInput");

  /// Input Element
  final InputElement input = new InputElement();

  /// Editor in Grid
  final bool inGrid;

  /**
   * Input Editor
   */
  LInput(String name, String type, {String idPrefix, bool this.inGrid:false, bool withClearValue:false}) {
    createStandard(this, withClearValue:withClearValue, inGrid:inGrid);
    input.name = name;
    input.id = createId(idPrefix, name);
    input.type = type;
    //
    hint = null;
    _initEditor(type);
  } // LInput

  /**
   * Input Editor
   */
  LInput.from(DataColumn dataColumn, String type, {String idPrefix, bool this.inGrid:false, bool withClearValue:false}) {
    createStandard(this, withClearValue:withClearValue, inGrid:inGrid);
    input.name = dataColumn.name;
    input.id = createId(idPrefix, input.name);
    input.type = type;

    this.column = dataColumn; // base values
    _initEditor(type);
  } // LInput

  /// initialize listeners with original type
  void _initEditor(String type) {
    if (type == EditorI.TYPE_PASSWORD) {
      input.autocomplete = "off"; // https://html.spec.whatwg.org/multipage/forms.html#autofill
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
    if (type == EditorI.TYPE_NUMBER) { // onClick=stepper onChange=+key onInput=+wheel
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

  /// Set Column (input min/max)
  void set column (DataColumn newValue) {
    super.dataColumn = newValue;

    if (dataColumn.tableColumn.hasValFrom())
      min = dataColumn.tableColumn.valFrom;
   if (dataColumn.tableColumn.hasValTo())
      max = dataColumn.tableColumn.valTo;
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
