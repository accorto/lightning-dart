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
   * Default Layout:
   * label
   * div control
   * - input
   */
  void createStandard(EditorI editor, {LIcon iconRight, LIcon iconLeft, bool withClearValue:false}) {
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
    else if (_input is TextAreaElement)
      _input.classes.add(LForm.C_TEXTAREA);
    else if (_input is SelectElement)
      _input.classes.add(LForm.C_SELECT);

    DivElement inputWrapper = null;
    // right side (clear or icon)
    if (iconRight == null) {
      if (withClearValue) {
        iconRight = new LIconUtility(LIconUtility.CLEAR);
        iconRight.element.onClick.listen((MouseEvent evt){
          editor.clearValue();
        });
      } else {
        iconRight = getIconRight();
      }
    }
    if (iconRight != null) {
      inputWrapper = new DivElement()
        ..classes.add(LForm.C_INPUT_HAS_ICON)
        ..classes.add(LForm.C_INPUT_HAS_ICON__RIGHT);
      _elementControl.append(inputWrapper);
      iconRight.classes.clear();
      iconRight.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      inputWrapper.append(iconRight.element);
    }
    // left side
    if (iconLeft == null) {
      iconLeft = getIconLeft();
      if (iconLeft == null && withClearValue)
        iconLeft = getIconRight();
    }
    if (iconLeft != null) {
      if (inputWrapper == null) {
        inputWrapper = new DivElement()
          ..classes.add(LForm.C_INPUT_HAS_ICON);
        _elementControl.append(inputWrapper);
      }
      inputWrapper.classes.add(LForm.C_INPUT_HAS_ICON__LEFT);
      iconLeft.classes.clear();
      iconLeft.classes.addAll([LForm.C_INPUT__ICON, LIcon.C_ICON_TEXT_DEFAULT]);
      inputWrapper.append(iconLeft.element);
      if (iconRight != null) {
        iconRight.element.style.left = "inherit";
        iconLeft.element.style.right = "inherit";
      }
    }
    Element left = getLeftElement();
    if (left != null) {
      if (inputWrapper == null) {
        inputWrapper = new DivElement();
        _elementControl.append(inputWrapper);
      }
      inputWrapper.classes.add(LForm.C_INPUT_HAS_PREFIX);
      inputWrapper.classes.add(LForm.C_INPUT_HAS_PREFIX__LEFT);
      inputWrapper.append(left);
    }
    //
    if (inputWrapper == null)
      inputWrapper = _elementControl;
    inputWrapper.append(_input);
    inputWrapper.append(_hintSpan); // __help
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
    element.append(_hintSpan); // __help
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
    if (_helpLabel == null && _help != null && _help.isNotEmpty) {
      _helpLabel = new DivElement()
        ..classes.addAll([LForm.C_FORM_ELEMENT__LABEL, LMargin.C_BOTTOM__X_SMALL]);
      LButton _helpButton = new LButton.iconBare("${editor.name}-hb",
        new LIconUtility(LIconUtility.INFO),
        "Help")
        ..classes.add(LMargin.C_RIGHT__XX_SMALL)
        ..typeButton = true;
      _helpTip = new LTooltip();
      _helpTip.showAbove(_helpButton); // shows button
      _helpLabel.append(_helpTip.element);
      // replace label
      _labelElement.replaceWith(_helpLabel);
      _labelElement.classes.clear();
      _labelElement.classes.add(LGrid.C_ALIGN_MIDDLE);
      _helpLabel.append(_labelElement); // add again
    }
    if (_helpLabel != null)
      _helpTip.bodyText = _help;
  }
  String _help;
  DivElement _helpLabel;
  LTooltip _helpTip;


  /// Hint Text
  String get hint => _hint;
  void set hint (String newValue) {
    _hint = newValue;
    _hintDisplay(_hint);
  }
  String _hint;
  void _hintDisplay(String text) {
    _hintSpan.text = text == null ? "" : text; // __help
    if (text == null || text.isEmpty) {
      _hintSpan.classes.add(LVisibility.C_HIDE);
    } else {
      _hintSpan.classes.remove(LVisibility.C_HIDE);
    }
  }


  /// set width of control (editor, hint, ..)
  void set maxWidth (String newValue) {
    if (_elementControl != null) {
      if (newValue == null || newValue.isEmpty) {
        _elementControl.style.removeProperty("maxWidth");
      } else {
        _elementControl.style.maxWidth = newValue;
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

  /// Right side Icon
  LIcon getIconRight() => null;
  /// Left side Icon
  LIcon getIconLeft() => null;
  /// Left Element
  Element getLeftElement() => null;

} // LFormElement
