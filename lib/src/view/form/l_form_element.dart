/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Form Element - maintains structure and
 * id, label, title, required
 */
class LFormElement {

  /// Form Element
  final DivElement element = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT);

  /// Label Element
  final LabelElement _labelElement = new LabelElement();
  /// Element control for std layout
  DivElement _elementControl;
  /// Label Span (cb)
  SpanElement _labelSpan;
  /// Input element (select|textarea|input)
  Element input;


  /**
   * Default Layout
   * label
   * div control
   * - input
   */
  void createStandard(Element input) {
    this.input = input;
    _labelElement.classes.add(LForm.C_FORM_ELEMENT__LABEL);
    element.append(_labelElement);
    //
    _elementControl = new DivElement()
      ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);
    element.append(_elementControl);
    // input
    if (input is InputElement)
      input.classes.add(LForm.C_INPUT);
    if (input is TextAreaElement)
      input.classes.add(LForm.C_TEXTAREA);
    if (input is SelectElement)
      input.classes.add(LForm.C_SELECT);
    _elementControl.append(input);
  }

  /**
   * Checkbox Layout
   * label .checkbox
   * - input
   * - span .faux
   * - span .label
   */
  void createCheckbox(Element input) {
    this.input = input;
    _labelElement.classes.add(LForm.C_CHECKBOX);
    element.append(_labelElement);
    //
    _labelElement.append(input);
    SpanElement faux = new SpanElement()
      ..classes.add(LForm.C_CHECKBOX__FAUX);
    _labelElement.append(faux);
    _labelSpan = new SpanElement()
      ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
    _labelElement.append(_labelSpan);
  }

  /// Get Id
  String get id => input.id;
  /// Set Id
  void set id (String newValue) {
    if (newValue != null && newValue.isNotEmpty) {
      input.id = newValue;
      _labelElement.htmlFor = newValue;
    }
  }

  /// Get Label
  String get label {
    if (_labelSpan != null) {
      return _labelSpan.text;
    }
    return _labelElement.text;
  }
  /// Set Label
  void set label (String newValue) {
    if (_labelSpan != null) {
      _labelSpan.text = newValue;
    } else {
      _labelElement.text = newValue;
    }
  }

  /// set Label value for input element
  void set labelInputText (String newValue) {
    input.attributes[Html0.ARIA_LABEL] = newValue;
    input.attributes["label"] = newValue;
  }

  /// Required
  bool get required => _required;
  /// set required
  void set required (bool newValue) {
    _required = newValue;
    if (newValue) {
      element.classes.add(LForm.C_IS_REQUIRED);
    } else {
      element.classes.remove(LForm.C_IS_REQUIRED);
    }
    if (input is InputElement)
      (input as InputElement).required = newValue;
    if (input is TextAreaElement)
      (input as TextAreaElement).required = newValue;
    if (input is SelectElement)
      (input as SelectElement).required = newValue;
  }
  bool _required = false;


  // bool get readOnly => false; // TODO ro
  // void set readOnly (bool newValue) {
    // https://www.lightningdesignsystem.com/components/forms/#read-only-state&role=regular&status=all
    // convert label+input to span
  //}

  String get title => input.title;
  void set title (String newValue) {
    input.title = newValue;
  }

} // LFormElement
