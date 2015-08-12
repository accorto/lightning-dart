/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


/**
 * Standard Form Editor with Label and Field
 */
abstract class LEditorStd extends LEditor {

  /// Get Editor Label
  @override
  LabelElement get label {
    if (_label == null) {
      _label = new LabelElement()
        ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
      if (id != null || id.isNotEmpty)
        _label.htmlFor = id;
      if (labelText != null)
        _label.text = labelText;
    }
    return _label;
  }
  LabelElement _label;

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

  /// Get Editor Form Element
  @override
  DivElement get formElement {
    if (_formElement == null) {
      _formElement = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _formElement.append(label);
      _formElementControl = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);
      _formElement.append(_formElementControl);
      _formElementControl.append(input);
    }
    return _formElement;
  }
  DivElement _formElement;
  DivElement _formElementControl;

  /// Set Label Text
  void set labelText (String newValue) {
    super.labelText = newValue;
    if (_label != null)
      _label.text = newValue;
    if (_labelSmall != null)
      _labelSmall.text = newValue;
  }


  /// set required
  void set required (bool newValue) {
    if (newValue) {
      formElement.classes.add(LForm.C_IS_REQUIRED);
    } else {
      formElement.classes.remove(LForm.C_IS_REQUIRED);
    }
  }


} // LEditorStd
