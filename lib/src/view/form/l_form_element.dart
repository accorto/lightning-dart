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
  final LabelElement labelElement = new LabelElement()
    ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
  /// Element control for std layout
  final DivElement elementControl = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT__CONTROL);

  /// Label Span
  final SpanElement _labelSpan = new SpanElement();
  /// required flag
  final Element _requiredElement = new Element.tag("abbr")
    ..classes.add(LForm.C_REQUIRED)
    ..title = lFormElementRequired();
  /// Hint (adds some px below input)
  final SpanElement _hintElement = new SpanElement()
    ..classes.add(LForm.C_FORM_ELEMENT__HELP);
  bool _hintHide = false;

  /// Parent Editor
  EditorI editor;
  /// Input element (select|textarea|input)
  Element _input;
  /// editor displayed in Grid
  bool inGrid = false;


  /**
   * Base Layout:
   *
   *    div       .from-element
   *      label   .form-element__label
   *      div     .form-element__control
   *        input
   *        hint
   * [inGrid] if true no label
   */
  void createBaseLayout(EditorI editor, {LIcon iconLeft, LIcon iconRight,
      bool withClearValue:false, bool inGrid:false}) {
    this.editor = editor;
    _input = editor.input;
    this.inGrid = inGrid;
    if (inGrid) {
      _hintHide = true;
      _hintElement.classes.add(LVisibility.C_HIDE);
    } else {
      labelElement.append(_requiredElement);
      labelElement.append(_labelSpan);
      element.append(labelElement);
    }
    //
    element.append(elementControl);

    // input
    if (_input is InputElement) {
      _input.classes.add(LForm.C_INPUT);
    } else if (_input is TextAreaElement) {
      _input.classes.add(LForm.C_TEXTAREA);
    }

    // right side (clear or icon)
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
      elementControl.classes.addAll([LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__RIGHT]);
      iconRight.classes.clear();
      iconRight.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      if (iconClear != null) {
        elementControl.classes.add(LForm.C_INPUT_HAS_ICON__RIGHT2);
        elementControl.append(iconClear.element);
      }
      elementControl.append(iconRight.element);
    }
    // left side
    if (iconLeft != null) {
      elementControl.classes.add(LForm.C_INPUT_HAS_ICON__LEFT);
      iconLeft.classes.clear();
      iconLeft.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      elementControl.append(iconLeft.element);
      if (iconRight != null) {
        iconRight.element.style.left = "inherit";
        iconLeft.element.style.right = "inherit";
      }
    }
    elementControl.append(_input);
    if (iconLeft == null && iconRight == null)
      elementControl.append(_hintElement); // __help - no icon pulled down if displayed
    else
      element.append(_hintElement); // __help - display horizontal below label!
  } // createBaseLayout

  /**
   * Checkbox Layout
   *
   *    div       .from-element
   *      div     .form-element__control
   *        label .checkbox
   *        input
   *        span  .checkbox--faux
   *        span  .form-element__label
   *        hint
   */
  void createCheckboxLayout(EditorI editor, bool inGrid, bool asToggle) {
    this.editor = editor;
    this.inGrid = inGrid;
    _input = editor.input;
    labelElement.classes.clear();
    //
    SpanElement faux = new SpanElement()
      ..classes.add(LForm.C_CHECKBOX__FAUX);
    _labelSpan.classes.add(LForm.C_FORM_ELEMENT__LABEL);
    if (asToggle) {
      labelElement.classes.addAll([LForm.C_CHECKBOX__TOGGLE,
        LGrid.C_GRID, LGrid.C_GRID__VERTICAL_ALIGN_CENTER]);
      faux.attributes["data-check-on"] = "On";
      faux.attributes["data-check-off"] = "Off";
      _labelSpan.classes.add(LMargin.C_AROUND__SMALL);
    } else {
      labelElement.classes.add(LForm.C_CHECKBOX);
    }

    labelElement
      ..append(_input)
      ..append(faux)
      ..append(_labelSpan);
    elementControl.append(labelElement);
    element.append(elementControl);

    if (inGrid) {
      element.style.display = "inline-block";
      _labelSpan.remove();
      _hintHide = true;
      _hintElement.classes.add(LVisibility.C_HIDE);
    }
    elementControl.append(_hintElement); // __help
  } // createCheckboxLayout

  /**
   * Select Layout:
   *
   *    div       .from-element
   *      label   .form-element__label
   *      div     .form-element__control
   *        div   .select_container
   *          select
   *        hint
   * [inGrid] if true no label
   */
  void createSelectLayout(EditorI editor, {bool inGrid:false}) {
    this.editor = editor;
    _input = editor.input;
    this.inGrid = inGrid;
    if (inGrid) {
      _hintHide = true;
      _hintElement.classes.add(LVisibility.C_HIDE);
    } else {
      labelElement.append(_requiredElement);
      labelElement.append(_labelSpan);
      element.append(labelElement);
    }
    //
    element.append(elementControl);

    _input.classes.add(LForm.C_SELECT);
    Element inputWrapper = new DivElement()
      ..classes.add (LForm.C_SELECT_CONTAINER)
      ..append(_input);

    elementControl.append(inputWrapper);
    elementControl.append(_hintElement);
  } // createSelectLayout


  /**
   * Lookup Layout:
   *
   *    div       .from-element
   *      label   .form-element__label
   *      div     .form-element__control
   *        input
   *       hint
   * [inGrid] if true no label
   */
  void createLookupLayout(EditorI editor, {LIcon iconLeft, LIcon iconRight,
      bool withClearValue:false, bool inGrid:false}) {
    this.editor = editor;
    _input = editor.input;
    _input.classes.add(LForm.C_INPUT);
    this.inGrid = inGrid;
    if (inGrid) {
      _hintHide = true;
      _hintElement.classes.add(LVisibility.C_HIDE);
    } else {
      labelElement.append(_requiredElement);
      labelElement.append(_labelSpan);
      element.append(labelElement);
    }
    element.append(elementControl);

    // right side (clear / icon)
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
      elementControl.classes.addAll([LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__RIGHT]);
      iconRight.classes.clear();
      iconRight.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      if (iconClear != null) {
        elementControl.classes.add(LForm.C_INPUT_HAS_ICON__RIGHT2);
        elementControl.append(iconClear.element);
      }
      elementControl.append(iconRight.element);
    }
    // left side
    if (iconLeft != null) {
      elementControl.classes.add(LForm.C_INPUT_HAS_ICON__LEFT);
      iconLeft.classes.clear();
      iconLeft.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      elementControl.append(iconLeft.element);
      if (iconRight != null) {
        iconRight.element.style.left = "inherit";
        iconLeft.element.style.right = "inherit";
      }
    }
    elementControl.append(_input);
    element.append(_hintElement); // __help - outside element-control
    //createLeftElement(leftElement);
  } // createStandard

  /// create addon element
  void createAddon(Element leftAddon, Element rightAddon) {
    element.append(_hintElement); // move hint out of element-control
    elementControl.classes.add(LForm.C_INPUT_HAS_FIXED_ADDON);
    if (leftAddon != null) {
      leftAddon.classes.add(LForm.C_FORM_ELEMENT__ADDON);
      elementControl.insertBefore(leftAddon, _input);
    }
    if (rightAddon != null) {
      rightAddon.classes.add(LForm.C_FORM_ELEMENT__ADDON);
      elementControl.append(rightAddon);
    }
  } // createAddon

  /// Create Layout for Lookup Select (pill)
  void createLookupSelectLayout(DivElement pillContainer, LIcon icon, bool multiple) {
    element.children.clear();
    labelElement.append(_requiredElement);
    labelElement.append(_labelSpan);
    element.append(labelElement);
    // element control
    elementControl.children.clear();
    elementControl.classes.addAll([LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__RIGHT]);
    elementControl.append(icon.element);
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
    elementControl.append(pillContainer);
    element.append(elementControl);
  } // createLookupSelectLayout


  /// Get Id
  String get id => _input.id;
  /// Set Id
  void set id (String newValue) {
    if (newValue != null && newValue.isNotEmpty) {
      _input.id = newValue;
      labelElement.htmlFor = newValue;
    }
  }

  /// Get Label
  String get label {
    return _labelSpan.text;
  }
  /// Set Label
  void set label (String newValue) {
    _labelSpan.text = newValue;
  }

  /// set Label value for input element
  void set labelInputText (String newValue) {
    _input.attributes[Html0.ARIA_LABEL] = newValue;
    _input.attributes["label"] = newValue;
  }

  /// Required
  bool get required => _required;
  /// set required
  void set required (bool newValue) {
    _required = newValue;
    if (newValue) {
      element.classes.add(LForm.C_IS_REQUIRED);
      _requiredElement.title = lFormElementRequired();
      _requiredElement.text = "* ";
    } else {
      element.classes.remove(LForm.C_IS_REQUIRED);
      _requiredElement.title = lFormElementNotRequired();
      _requiredElement.text = "";
    }
    if (_input is InputElement)
      (_input as InputElement).required = newValue;
    if (_input is TextAreaElement)
      (_input as TextAreaElement).required = newValue;
    if (_input is SelectElement)
      (_input as SelectElement).required = newValue;
  }
  bool _required = false;

  // PLAN readOnly form element - convert to span?
  // bool get readOnly => false;
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
    if (inGrid)
      return;
    if (_helpTip == null && _help != null && _help.isNotEmpty) {
      LButton _helpButton = new LButton.iconBare("${editor.name}-help",
        new LIconUtility(LIconUtility.INFO), "")
        ..classes.add(LMargin.C_RIGHT__XX_SMALL)
        ..typeButton = true;
      _helpButton.tabIndex = -1;
      _helpTip = new LTooltip();
      _helpTip.showAbove(_helpButton); // shows button

      if (EditorI.isCheckbox(editor.type)) {
      //  element.insertBefore(_helpTip.element, _hintSpan);
        labelElement.append(_helpTip.element);
      } else { // standard
        DivElement _helpLabel = new DivElement()
          ..classes.addAll([LForm.C_FORM_ELEMENT__LABEL, LMargin.C_BOTTOM__X_SMALL])
          ..append(_helpTip.element);
        // replace label
        labelElement.replaceWith(_helpLabel);
        labelElement.classes.clear();
        labelElement.classes.add(LGrid.C_ALIGN_MIDDLE);
        _helpLabel.append(labelElement); // add again
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
      _hintElement.text = "";
      if (_hintHide) {
        _hintElement.classes.add(LVisibility.C_HIDE);
      }
    } else {
      _hintElement.text = text; // __help
      _hintElement.classes.remove(LVisibility.C_HIDE);
    }
  }

  /// hide hint
  void hintHide() {
    _hintHide = true;
    hint = null;
  }
  /// remove hint
  void hintRemove() {
    _hintElement.remove();
  }


  /// set max width of control (editor, hint, ..) - editors have min-width of 120px in table
  void set maxWidth (String newValue) {
    if (elementControl != null) {
      if (newValue == null || newValue.isEmpty) {
        elementControl.style.removeProperty("maxWidth");
      } else {
        elementControl.style.maxWidth = newValue;
      }
    }
  }

  /// set min width of control (editor, hint, ..)
  void set minWidth (String newValue) {
    if (elementControl != null) {
      if (newValue == null || newValue.isEmpty) {
        elementControl.style.removeProperty("minWidth");
      } else {
        elementControl.style.minWidth = newValue;
      }
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

  /// trl
  static String lFormElementClear() => Intl.message("Clear Value", name: "lFormElementClear");
  static String lFormElementRequired() => Intl.message("required", name: "lFormElementRequired");
  static String lFormElementNotRequired() => Intl.message("optional", name: "lFormElementNotRequired");


} // LFormElement
