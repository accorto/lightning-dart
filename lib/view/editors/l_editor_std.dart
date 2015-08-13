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

  /**
   * Get Editor Form Element
   * div  formElement .form_element
   * - label .form-element--label
   * - div formElementControl .form_element--control
   * -- input .input
   */
  @override
  DivElement get formElement {
    if (_formElement == null) {
      _formElement = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _formElement.append(label);
      //
      _formElementControl = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);
      _formElement.append(_formElementControl);
      input.classes.add(LEditor.C_INPUT);
      _formElementControl.append(input);
    }
    return _formElement;
  }
  DivElement _formElement;
  DivElement _formElementControl;

  /**
   * Get Editor Form Element for Lookup
   * div  formElement .form_element
   * - label .form-element--label
   * - div formElementControl .lookup--control .input-has-icon
   * -- input .input--bare
   */
  DivElement get formElementLookup {
    if (_formElement == null) {
      _formElement = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _formElement.append(label);
      //
      _formElementControl = new DivElement()
        ..classes.addAll([LLookup.C_LOOKUP__CONTROL, LEditor.C_INPUT_HAS_ICON, LEditor.C_INPUT_HAS_ICON__RIGHT]);
      _formElement.append(_formElementControl);
      LIcon search = new LIcon.utility("search",
        className: LEditor.C_INPUT__ICON);
      _formElementControl.append(search.element);
      input
      //..type = "text"
        ..classes.add(LEditor.C_INPUT__BARE)
        ..attributes[Html0.A_ARIA_HASPOPUP] = "true"
        ..attributes[Html0.A_ARIA_AUTOCOMPLETE] = "list"
        ..attributes[Html0.A_ROLE] = Html0.V_ROLE_COMBOBOX;
      _formElementControl.append(input);
    }
    return _formElement;
  } // formElementLooku


  /// Set Label Text
  void set labelText (String newValue) {
    super.labelText = newValue;
    if (_label != null)
      _label.text = newValue;
    if (_labelSmall != null) {
      _labelSmall.text = newValue;
    }
    labelInputText = newValue;
  } // labelText

  /// set Label value for input element
  void set labelInputText (String newValue) {
    input.attributes[Html0.A_ARIA_LABEL] = newValue;
    input.attributes["label"] = newValue;
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
