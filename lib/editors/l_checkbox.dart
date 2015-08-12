/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

class LCheckbox extends LEditor {

  static const String C_CHECKBOX = "slds-checkbox";
  static const String C_CHECKBOX__FAUX = "slds-checkbox--faux";
  static const String C_FORM_ELEMENT__LABEL = "slds-form-element__label";

  /// The input
  final InputElement input = new InputElement()
    ..type = "checkbox";


  LCheckbox(String name) {
    input.name = name;
  }

  String get id => input.id;
  void set id (String newValue) {
    input.id = newValue;
    if (_label != null)
      _label.htmlFor = newValue;
  }

  String get name => input.name;
  String get type => input.type;


  @override
  LabelElement get label {
    if (_label == null) {
      _label = new LabelElement()
        ..classes.add(C_CHECKBOX);
      _label.append(input);
      _label.append(new SpanElement()
          ..classes.add(C_CHECKBOX__FAUX));
      _labelSpan = new SpanElement()
        ..classes.add(C_FORM_ELEMENT__LABEL);
      //
      if (id != null || id.isNotEmpty)
        _label.htmlFor = id;
      if (labelText != null)
        _labelSpan.text = labelText;
    }
    return _label;
  }
  LabelElement _label;
  SpanElement _labelSpan;

  /// Get Editor Form Element
  @override
  DivElement get formElement {
    if (_formElement == null) {
      _formElement = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _formElement.append(label);
    }
    return _formElement;
  }
  DivElement _formElement;

  /// Get Editor Label
  @override
  Element get labelSmall {
    if (_labelSmall == null) {
      _labelSmall = new Element.tag("small");
      if (labelText != null)
        _labelSmall.text = labelText;
    }
    return _labelSmall;
  }
  Element _labelSmall;


  /// Set Label Text
  void set labelText (String newValue) {
    super.labelText = newValue;
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



}
