/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Form Editor
 * (LLookup extends LEditor but not with LFormElement)
 */
abstract class LEditor
    extends EditorI {

  /// Auto Id Numbering
  static int _autoId = 1;

  /// Get Form Element -- via with LFormElement or own
  Element get element;

  /// Editor in Grid
  bool get inGrid;

  /// Showing
  bool get show => !element.classes.contains(LVisibility.C_HIDE);

  /// Show/Hide
  void set show(bool newValue) {
    if (newValue) {
      element.classes.remove(LVisibility.C_HIDE);
      if (inGrid)
        input.classes.remove(LVisibility.C_HIDE);
    } else {
      element.classes.add(LVisibility.C_HIDE);
      if (inGrid)
        input.classes.add(LVisibility.C_HIDE);
    }
  } // show

  /// called by sub class
  String createId(String idPrefix, String name) {
    String theId = idPrefix;
    if (idPrefix == null || idPrefix.isEmpty) {
      theId = "ed-${_autoId++}";
    }
    if (name != null && name.isNotEmpty)
      theId = "${theId}-${name}";
    return theId;
  }

  /// Small Editor/Label
  void set small(bool newValue);


  /// return true if [newValue] is null, empty or nullValue
  bool _isEmpty(String newValue) => DataUtil.isEmpty(newValue);

  /// return true if [newValue] is null, empty or nullValue
  bool _isNotEmpty(String newValue) => DataUtil.isNotEmpty(newValue);

  /**
   * Original Value (creates als default value)
   */
  String get valueOriginal => _valueOriginal;

  /// Set Original value
  void set valueOriginal(String newValue) {
    if (_isEmpty(newValue)) {
      _valueOriginal = "";
      defaultValue = "";
    } else {
      _valueOriginal = newValue;
      render(newValue, true)
          .then((String display) {
        defaultValue = display; // variables;
      });
    }
  }

  String _valueOriginal;

  /// Is the value changed from original
  bool get changed {
    String v = value;
    if (v == null)
      v = "";
    String o = _valueOriginal == null ? "" : _valueOriginal;
    if (v != o) {
      if (type == EditorI.TYPE_COLOR) {
        return o.isNotEmpty; // defaults to #000000
      }
      // if (v != o)
      //  print("EditorI ${name} changed original=${o} value=${v}");
    }
    return v != o;
  } // isChanged


  /// get Data List Id
  String get listId => null;

  /// get Data List Id
  void set listId(String newValue) {
  }

  /// Set Data List
  void set list(SelectDataList dl) {
  }

  /// focus next slds-input element within form
  bool focusNextInput() {
    return focusNextInputParent(_getFormElement(input), input);
  }
  /// focus next slds-input element within parent
  static bool focusNextInputParent(Element parent, Element e) {
    if (parent == null)
      return false;
    ElementList<Element> list = parent.querySelectorAll(
        ".${LForm.C_INPUT}, .${LForm.C_SELECT}, .${LForm.C_TEXTAREA}"); // lookup?
    if (list.isEmpty)
      return false;
    int index = list.indexOf(e) + 1;
    if (index >= list.length) {
      return false; // last
    }
    Element target = list[index];
    // is it visible?
    while (!_canFocus(target)) {
      index++;
      if (index < list.length) {
        target = list[index];
      } else {
        target = null;
        break;
      }
    }
    if (target != null) {
      target.focus();
      return true;
    }
    return false;
  } // focusNextInput

  /// can focus for input
  static bool _canFocus(Element element) {
    if (element == null || element.clientHeight == 0)
      return false;
    if (element is InputElement) {
      if (element.readOnly || element.disabled)
        return false;
    } else if (element is SelectElement) {
      if (element.disabled)
        return false;
    } else if (element is TextAreaElement) {
      if (element.readOnly || element.disabled)
        return false;
    }
    return true;
  } // canFocus

  static Element _getFormElement(Element e) {
    if (e is InputElement) {
      return e.form;
    } else if (e is SelectElement) {
      return e.form;
    } else if (e is TextAreaElement) {
      return e.form;
    }
    Element f = e.parent;
    while (f != null) {
      if (f is FormElement)
        return f;
      if (f.classes.contains(LForm.C_FORM__HORIZONTAL)
          || f.classes.contains(LForm.C_FORM__STACKED)
          || f.classes.contains(LForm.C_FORM__INLINE))
        return f;
      f = f.parent;
    }
    return null;
  }

} // LEditor
