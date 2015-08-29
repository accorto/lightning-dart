/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Form Element - maintains structure and
 * id, label, title, required, help
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
  /// Hint
  final SpanElement _hintSpan = new SpanElement()
    ..classes.add(LForm.C_FORM_ELEMENT__HELP);

  /// Parent Editor
  EditorI editor;
  /// Input element (select|textarea|input)
  Element _input;


  /**
   * Default Layout
   * label
   * div control
   * - input
   */
  void createStandard(EditorI editor) {
    this.editor = editor;
    _input = editor.input;
    _labelElement.classes.add(LForm.C_FORM_ELEMENT__LABEL);
    element.append(_labelElement);
    //
    _elementControl = new DivElement()
      ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);
    element.append(_elementControl);
    // input
    if (_input is InputElement)
      _input.classes.add(LForm.C_INPUT);
    if (_input is TextAreaElement)
      _input.classes.add(LForm.C_TEXTAREA);
    if (_input is SelectElement)
      _input.classes.add(LForm.C_SELECT);
    _elementControl.append(_input);
    _elementControl.append(_hintSpan);
  }

  /**
   * Checkbox Layout
   * label .checkbox
   * - input
   * - span .faux
   * - span .label
   */
  void createCheckbox(EditorI editor) {
    this.editor = editor;
    _input = editor.input;
    _labelElement.classes.add(LForm.C_CHECKBOX);
    element.append(_labelElement);
    //
    _labelElement.append(_input);
    SpanElement faux = new SpanElement()
      ..classes.add(LForm.C_CHECKBOX__FAUX);
    _labelElement.append(faux);
    _labelSpan = new SpanElement()
      ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
    _labelElement.append(_labelSpan);
    _labelElement.append(_hintSpan);
  }

  /// Get Id
  String get id => _input.id;
  /// Set Id
  void set id (String newValue) {
    if (newValue != null && newValue.isNotEmpty) {
      _input.id = newValue;
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
    _input.attributes[Html0.ARIA_LABEL] = newValue;
    _input.attributes["label"] = newValue;
  }

  /// Small input size
  void set small (bool newValue) {
    if (newValue) {
      _input.classes.add(LForm.C_INPUT__SMALL);
      _labelElement.classes.add(LForm.C_FORM_ELEMENT__LABEL__SMALL);
    } else {
      _input.classes.remove(LForm.C_INPUT__SMALL);
      _labelElement.classes.remove(LForm.C_FORM_ELEMENT__LABEL__SMALL);
    }
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
    if (_input is InputElement)
      (_input as InputElement).required = newValue;
    if (_input is TextAreaElement)
      (_input as TextAreaElement).required = newValue;
    if (_input is SelectElement)
      (_input as SelectElement).required = newValue;
  }
  bool _required = false;


  // bool get readOnly => false; // TODO ro
  // void set readOnly (bool newValue) {
    // https://www.lightningdesignsystem.com/components/forms/#read-only-state&role=regular&status=all
    // convert label+input to span
  //}

  String get title => _input.title;
  void set title (String newValue) {
    _input.title = newValue;
  }

  /// Help Text
  String get help => _help;
  void set help (String newValue) {
    _help = newValue;

  }
  String _help;


  /// Hint Text
  String get hint => _hint;
  void set hint (String newValue) {
    _hint = newValue;
    _hintDisplay(_hint);
  }
  String _hint;
  void _hintDisplay(String text) {
    _hintSpan.text = text == null ? "" : text;
    if (text == null || text.isEmpty) {
      _hintSpan.classes.add(LVisibility.C_HIDE);
    } else {
      _hintSpan.classes.remove(LVisibility.C_HIDE);
    }
  }

  /**
   * Update Field Status display
   */
  void updateStatusValidationState() {
    bool valid = editor.statusValid;
    if (valid) {
      element.classes.remove(LForm.C_HAS_ERROR);
    } else {
      element.classes.add(LForm.C_HAS_ERROR);

    }
    String error = editor.statusText;
    if (error == null || error.isEmpty) {
      _hintDisplay(_hint);
    } else {
      String text = error;
      if (_hint != null && _hint.isNotEmpty)
        text += " - " + _hint;
      _hintDisplay(text);
    }
  } // updateStatusValidationState


  /// hack
  void setMarginTopSmall() {
    element.style.marginTop = ".5rem"; // from 1
  }

} // LFormElement
