/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Standard Form Editor with Label and Field (presentation)
 */
abstract class LEditorStd extends LEditor {

  /// Get Editor Label
  @override
  LabelElement get labelElement {
    if (_labelElement == null) {
      _labelElement = new LabelElement()
        ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
      if (id != null || id.isNotEmpty)
        _labelElement.htmlFor = id;
      if (label != null)
        _labelElement.text = label;
    }
    return _labelElement;
  }
  LabelElement _labelElement;

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

  /**
   * Get Editor Form Element
   * div  element .form_element
   * - label .form-element--label
   * - div elementControl .form_element--control
   * -- input .input
   */
  @override
  DivElement get element {
    if (_element == null) {
      _element = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _element.append(labelElement);
      //
      _elementControl = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);
      _element.append(_elementControl);
      input.classes.add(LEditor.C_INPUT);
      _elementControl.append(input);
    }
    return _element;
  }
  DivElement _element;
  DivElement _elementControl;

  /**
   * Get Editor Form Element for Lookup
   * div  element .form_element
   * - label .form-element--label
   * - div elementControl .lookup--control .input-has-icon
   * -- input .input--bare
   */
  DivElement get elementLookup {
    if (_element == null) {
      _element = new DivElement()
        ..classes.add(LForm.C_FORM_ELEMENT);
      _element.append(labelElement);
      //
      _elementControl = new DivElement()
        ..classes.addAll([LLookup.C_LOOKUP__CONTROL, LEditor.C_INPUT_HAS_ICON, LEditor.C_INPUT_HAS_ICON__RIGHT]);
      _element.append(_elementControl);
      LIcon search = new LIconUtility(LIconUtility.SEARCH,
        className: LEditor.C_INPUT__ICON);
      _elementControl.append(search.element);
      input
      //..type = "text"
        ..classes.add(LEditor.C_INPUT__BARE)
        ..attributes[Html0.ARIA_HASPOPUP] = "true"
        ..attributes[Html0.ARIA_AUTOCOMPLETE] = Html0.ARIA_AUTOCOMPLETE_LIST
        ..attributes[Html0.ROLE] = Html0.ROLE_COMBOBOX;
      _elementControl.append(input);
    }
    return _element;
  } // elementLookup


  /// Set Label Text
  void set label (String newValue) {
    super.label = newValue;
    if (_labelElement != null)
      _labelElement.text = newValue;
    if (_labelSmall != null) {
      _labelSmall.text = newValue;
    }
    labelInputText = newValue;
  } // labelText

  /// set Label value for input element
  void set labelInputText (String newValue) {
    input.attributes[Html0.ARIA_LABEL] = newValue;
    input.attributes["label"] = newValue;
  }

  /// set required
  void set required (bool newValue) {
    if (newValue) {
      element.classes.add(LForm.C_IS_REQUIRED);
    } else {
      element.classes.remove(LForm.C_IS_REQUIRED);
    }
  }

} // LEditorStd
