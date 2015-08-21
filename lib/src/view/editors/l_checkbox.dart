/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Checkbox (handles input + presentation)
 */
class LCheckbox extends LEditor {

  static const String C_CHECKBOX = "slds-checkbox";
  static const String C_CHECKBOX__FAUX = "slds-checkbox--faux";
  static const String C_FORM_ELEMENT__LABEL = "slds-form-element__label";

  /// The input
  final InputElement input = new InputElement()
    ..type = "checkbox";

  /**
   * Checkbox
   * (note that if id is not unique, it does not work!)
   */
  LCheckbox(String name, {String idPrefix}) {
    input.name = name;
    input.id = createId(idPrefix, name);
  }

  String get id => input.id;
  void set id (String newValue) {
    if (newValue != null && newValue.isNotEmpty) {
      input.id = newValue;
      if (_labelElement != null)
        _labelElement.htmlFor = newValue;
    }
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

  bool get required => _required;
  void set required (bool newValue) {
    _required = newValue; // don't male inut required (= checked)
    if (newValue) {
      element.classes.add(LForm.C_IS_REQUIRED);
    } else {
      element.classes.remove(LForm.C_IS_REQUIRED);
    }
  }
  bool _required = false;

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

  String get title => input.title;
  void set title (String newValue) {
    input.title = newValue;
  }

  @override
  LabelElement get labelElement {
    if (_labelElement == null) {
      _labelElement = new LabelElement()
        ..classes.add(C_CHECKBOX);
      _labelElement.append(input);
      _labelElement.append(new SpanElement()
          ..classes.add(C_CHECKBOX__FAUX));
      _labelSpan = new SpanElement()
        ..classes.add(C_FORM_ELEMENT__LABEL);
      _labelElement.append(_labelSpan);
      //
      if (id != null || id.isNotEmpty)
        _labelElement.htmlFor = id;
      if (label != null)
        _labelSpan.text = label;
    }
    return _labelElement;
  }
  LabelElement _labelElement;
  SpanElement _labelSpan;

  /// Get Editor Form Element
  @override
  DivElement get element {
    if (_element == null) {
      _element = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _element.append(labelElement);
    }
    return _element;
  }
  DivElement _element;

  /// Get Editor Label
  @override
  Element get labelSmall {
    if (_labelSmall == null) {
      _labelSmall = new Element.tag("small");
      if (label != null)
        _labelSmall.text = label;
    }
    return _labelSmall;
  }
  Element _labelSmall;


  /// Set Label Text
  void set label (String newValue) {
    super.label = newValue;
    if (_labelSpan != null)
      _labelSpan.text = newValue;
    if (_labelSmall != null)
      _labelSmall.text = newValue;
  }


} // LCheckbox
