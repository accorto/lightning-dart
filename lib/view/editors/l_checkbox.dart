/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Checkbox
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
    input.id = newValue;
    if (_labelElement != null)
      _labelElement.htmlFor = newValue;
  }

  String get name => input.name;
  String get type => input.type;


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
  DivElement get formElement {
    if (_formElement == null) {
      _formElement = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _formElement.append(labelElement);
    }
    return _formElement;
  }
  DivElement _formElement;

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

  bool get required => _required;
  void set required (bool newValue) {
    _required = newValue;
    if (newValue) {
      formElement.classes.add(LForm.C_IS_REQUIRED);
    } else {
      formElement.classes.remove(LForm.C_IS_REQUIRED);
    }
  }
  bool _required = false;

} // LCheckbox
