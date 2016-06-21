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

  // standard width in table 120px
  static const String C_W80 = "w80";
  static const String C_W100 = "w100";
  static const String C_W140 = "w140";
  static const String C_W160 = "w160";
  static const String C_W180 = "w180";
  static const String C_W200 = "w200";

  /// Input Element
  final InputElement input = new InputElement();

  /**
   * Input Editor with [type] e.g. EditorI.TYPE_TEXT
   */
  LInput(String name, String type, {String idPrefix, bool inGrid:false, bool withClearValue:false}) {
    createBaseLayout(this, iconLeft: getIconLeft(), iconRight: getIconRight(),
        withClearValue:withClearValue, inGrid:inGrid);
    input.name = name;
    id = createId(idPrefix, name);
    input.type = _validateType(type);
    //
    hint = null;
    _initEditor(type);
  } // LInput

  /**
   * Input Editor
   */
  LInput.from(DataColumn dataColumn, String type,
      {String idPrefix, bool inGrid:false, bool withClearValue:false}) {
    createBaseLayout(this, iconLeft: getIconLeft(), iconRight: getIconRight(),
        withClearValue:withClearValue, inGrid:inGrid);
    input.name = dataColumn.name;
    id = createId(idPrefix, input.name);
    input.type = _validateType(type);

    this.column = dataColumn; // base values
    _initEditor(type);
  } // LInput

  /// Right side Icon
  LIcon getIconRight() => null;
  /// Left side Icon
  LIcon getIconLeft() => null;

  /// check type
  String _validateType (String requestedType) {
    if (ClientEnv.isIE11) {
      if (EditorI.TYPES_HTML.contains(requestedType)
          || EditorI.TYPES_HTML5_IE.contains(requestedType)) {
        return requestedType;
      }
      return EditorI.TYPE_TEXT;
    }
    // other browsers don't fail if unsupported type is used
    return requestedType;
  }

  /// initialize listeners with original type - listen to onChange - onKeyUp
  void _initEditor(String type) {
    if (type == EditorI.TYPE_PASSWORD) {
      autocomplete = false;
      autocapitalize = "none";
      autocorrect = false;
    } else if (type == EditorI.TYPE_EMAIL) {
      autocapitalize = "none";
    }
    // Changes - sequence: onInput - onKeyUp - onChange
    // onInputChange -> DataRecord.onEditorChange -> LForm.onRecordChange
    input.onInput.listen(onInputChange); // first input/textarea only
    //input.onChange.listen(onInputChange); // last/focus lost - also select

    /// not a button, checkbox, ..
    if (!EditorI.TYPES_NOLABEL.contains(type)) {
      input.onKeyUp.listen(onInputKeyUp);
    }
  } // initEditor

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

  /// https://html.spec.whatwg.org/multipage/forms.html#autofill
  bool get autocomplete => input.autocomplete == "on";
  /// https://www.w3.org/wiki/HTML/Elements/input/text
  void set autocomplete (bool newValue) {
    input.autocomplete = newValue ? "on" : "off";
  }

  /// https://developer.apple.com/library/iad/documentation/AppleApplications/Reference/SafariHTMLRef/Articles/Attributes.html#//apple_ref/doc/uid/TP40008058-SW1
  bool get autocorrect => input.attributes["autocorrect"] == "on";
  void set autocorrect (bool newValue) {
    input.attributes["autocorrect"] = newValue ? "on" : "off";
  }

  String get autocapitalize => input.attributes["autocapitalize"];
  /// none|sentences|words|characters
  void set autocapitalize (String newValue) {
    input.attributes["autocapitalize"] = newValue;
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
  /// set custom validity explicitly
  void setCustomValidity(String newValue) {
    input.setCustomValidity(newValue);
  }

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

  @override
  String toString() {
    if (entry != null) {
      String theValue = DataRecord.getEntryValue(entry);
      return "LInput[${name}=${theValue} ${type} changed=${entry.isChanged}]";
    }
    return "LInput[${name}=${value} ${type} changed=${changed}]";
  }

} // LInput
