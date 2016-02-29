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
  /// Hint (adds some px below input)
  final SpanElement _hintSpan = new SpanElement()
    ..classes.add(LForm.C_FORM_ELEMENT__HELP);
  bool _hintHide = false;

  /// Parent Editor
  EditorI editor;
  /// Input element (select|textarea|input)
  Element _input;
  DivElement _inputWrapper = null;


  /**
   * Default Layout:
   *
   *    div       .from-element
   *      label   .form-element__label
   *      div     .form-element__control
   *        input
   *        hint
   * [inGrid] if true no label
   */
  void createStandard(EditorI editor, {LIcon iconLeft, LIcon iconRight,
      Element leftElement,
      bool withClearValue:false, bool inGrid:false}) {
    this.editor = editor;
    _input = editor.input;
    if (inGrid) {
      _hintHide = true;
      _hintSpan.classes.add(LVisibility.C_HIDE);
    } else {
      _labelElement.classes.add(LForm.C_FORM_ELEMENT__LABEL);
      element.append(_labelElement);
    }
    //
    _elementControl = new DivElement()
      ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);
    element.append(_elementControl);

    // input
    if (_input is InputElement) {
      _input.classes.add(LForm.C_INPUT);
    } else if (_input is TextAreaElement) {
      _input.classes.add(LForm.C_TEXTAREA);
    } else if (_input is SelectElement) {
      _input.classes.add(LForm.C_SELECT);
    }

    _inputWrapper = null;
    // right side (clear or icon)
    if (iconRight == null) {
      iconRight = getIconRight();
    }
    LIcon iconClear = null;
    if (withClearValue) {
      if (iconRight == null) {
        iconRight = new LIconUtility(LIconUtility.CLEAR)
          ..title = lFormElementClear();
        iconRight.element.onClick.listen(editor.onClearValue);
      } else {
        iconClear = new LIconUtility(LIconUtility.CLEAR)
          ..title = lFormElementClear();
        iconClear.classes.clear();
        iconClear.classes.addAll([LForm.C_INPUT__ICON, LForm.C_INPUT__ICON2, LIcon.C_ICON_TEXT_DEFAULT]);
        iconClear.element.onClick.listen(editor.onClearValue);
      }
    }
    if (iconRight != null) {
      _inputWrapper = new DivElement()
        ..classes.add(LForm.C_INPUT_HAS_ICON)
        ..classes.add(LForm.C_INPUT_HAS_ICON__RIGHT);
      _elementControl.append(_inputWrapper);
      iconRight.classes.clear();
      iconRight.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      if (iconClear != null) {
        _inputWrapper.classes.add(LForm.C_INPUT_HAS_ICON__RIGHT2);
        _inputWrapper.append(iconClear.element);
      }
      _inputWrapper.append(iconRight.element);
    }
    // left side
    if (iconLeft == null) {
      iconLeft = getIconLeft();
    }
    if (iconLeft != null) {
      if (_inputWrapper == null) {
        _inputWrapper = new DivElement()
          ..classes.add(LForm.C_INPUT_HAS_ICON);
        _elementControl.append(_inputWrapper);
      }
      _inputWrapper.classes.add(LForm.C_INPUT_HAS_ICON__LEFT);
      iconLeft.classes.clear();
      iconLeft.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      _inputWrapper.append(iconLeft.element);
      if (iconRight != null) {
        iconRight.element.style.left = "inherit";
        iconLeft.element.style.right = "inherit";
      }
    }
    createStandardLeftElement(leftElement);
  } // createStandard

  /// create left element (before the field)
  void createStandardLeftElement(Element leftElement) {
    Element left = leftElement;
    if (left == null) {
      left = getLeftElement();
    }
    if (left != null) {
      if (_inputWrapper == null) {
        _inputWrapper = new DivElement();
        _elementControl.append(_inputWrapper);
      }
      _inputWrapper.classes.add(LForm.C_INPUT_HAS_PREFIX);
      _inputWrapper.classes.add(LForm.C_INPUT_HAS_PREFIX__LEFT);
      _inputWrapper.append(left);
    }
    if (_inputWrapper == null) {
      _inputWrapper = _elementControl;
    }
    if (_input is SelectElement) { // add select wrapper
      DivElement wrapper = new DivElement()
        ..classes.add(LForm.C_SELECT_CONTAINER)
        ..append(_input);
      _inputWrapper.append(wrapper);
    } else {
      _inputWrapper.append(_input);
    }
    _elementControl.append(_hintSpan); // __help
  }

  /// Create Layout for Lookup Select (pill)
  void createLookupSelect(DivElement pillContainer, LIcon icon, bool multiple) {
    element.children.clear();
    element.append(_labelElement);
    // element control
    _elementControl.children.clear();
    _elementControl.classes.addAll([LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__RIGHT]);
    _elementControl.append(icon.element);
    /*
    if (multiple) {
      _elementControl.append(_input);
      element.append(_elementControl);
      element.append(pillContainer);
    } else { // single
      _elementControl.append(pillContainer);
      _elementControl.append(_input);
      element.append(_elementControl);
    } */
    _elementControl.append(pillContainer);
    element.append(_elementControl);
  } // createLookup

  /**
   * Checkbox Layout
   *
   *    div       .from-element
   *      label   .checkbox
   *      input
   *      span    .checkbox--faux
   *      span    .form-element__label
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
    element.append(_hintSpan); // __help
  } // createCheckbox

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

  /**
   *  --from--
   *    div       .from-element
   *      label   .form-element__label  (_labelElement)
   *      div     .form-element__control
   *        input
   *
   *  --to--
   *    div       .form-element
   *      div     .form_element__label (_helpLabel)
   *        div   (popup)
   *          button
   *          div .popover
   *        label                     (_labelElement)
   *      div     .form-element__control
   *        input
   *
   *  or for cb --from--
   *    div       .from-element
   *      label   .checkbox               (_labelElement)
   *        input
   *        span    .checkbox--faux
   *        span    .form-element__label  (_labelSpan)
   *      span    .form-element__help     (_hintSpan)
   *  --to--
   *    div       .form-element
   *      label   .checkbox               (_labelElement)
   *        input
   *        span    .checkbox--faux
   *        span    .form-element__label  (_labelSpan)
   *        div   (popup)
   *          button
   *          div .popover
   *      span    .form-element__help     (_hintSpan)
   */
  void set help (String newValue) {
    _help = newValue;
    if (_helpTip == null && _help != null && _help.isNotEmpty) {
      LButton _helpButton = new LButton.iconBare("${editor.name}-help",
        new LIconUtility(LIconUtility.INFO), "Help")
        ..classes.add(LMargin.C_RIGHT__XX_SMALL)
        ..typeButton = true;
      _helpButton.tabIndex = -1;
      _helpTip = new LTooltip();
      _helpTip.showAbove(_helpButton); // shows button

      if (EditorI.isCheckbox(editor.type)) {
      //  element.insertBefore(_helpTip.element, _hintSpan);
        _labelElement.append(_helpTip.element);
      } else { // standard
        DivElement _helpLabel = new DivElement()
          ..classes.addAll([LForm.C_FORM_ELEMENT__LABEL, LMargin.C_BOTTOM__X_SMALL])
          ..append(_helpTip.element);
        // replace label
        _labelElement.replaceWith(_helpLabel);
        _labelElement.classes.clear();
        _labelElement.classes.add(LGrid.C_ALIGN_MIDDLE);
        _helpLabel.append(_labelElement);
        // add again
      }
    }
    if (_helpTip != null)
      _helpTip.bodyText = _help;
  }
  String _help;
  LTooltip _helpTip;


  /// Hint Text
  String get hint => _hint;
  void set hint (String newValue) {
    _hint = newValue;
    _hintDisplay(_hint);
  }
  String _hint;
  void _hintDisplay(String text) {
    if (text == null || text.isEmpty) {
      _hintSpan.text = "";
      if (_hintHide) {
        _hintSpan.classes.add(LVisibility.C_HIDE);
      }
    } else {
      _hintSpan.text = text; // __help
      _hintSpan.classes.remove(LVisibility.C_HIDE);
    }
  }

  /// hide hint
  void hintHide() {
    _hintHide = true;
    hint = null;
  }
  /// remove hint
  void hintRemove() {
    _hintSpan.remove();
  }


  /// set max width of control (editor, hint, ..)
  void set maxWidth (String newValue) {
    if (_elementControl != null) {
      if (newValue == null || newValue.isEmpty) {
        _elementControl.style.removeProperty("maxWidth");
      } else {
        _elementControl.style.maxWidth = newValue;
      }
    }
  }

  /// set min width of control (editor, hint, ..)
  void set minWidth (String newValue) {
    if (_elementControl != null) {
      if (newValue == null || newValue.isEmpty) {
        _elementControl.style.removeProperty("minWidth");
      } else {
        _elementControl.style.minWidth = newValue;
      }
    }
  }

  /// get element control directly (internal)
  Element get i_formElementControl => _elementControl;

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

  /// Right side Icon
  LIcon getIconRight() => null;
  /// Left side Icon
  LIcon getIconLeft() => null;
  /// Left Element (called early in constructor)
  Element getLeftElement() => null;

  /// trl
  static String lFormElementClear() => Intl.message("Clear Value", name: "lFormElementClear");


} // LFormElement
