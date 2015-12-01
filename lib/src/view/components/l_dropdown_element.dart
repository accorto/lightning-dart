/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Dropdown Element maintains list
 */
class LDropdownElement
    extends LSelectI {

  static final Logger _log = new Logger("LDropdownElement");

  /// Dropdown Element
  final DivElement element;
  /// Dropdown Items
  final List<LDropdownItem> _dropdownItemList = new List<LDropdownItem>();

  /// Dropdown List
  final UListElement _dropdownList = new UListElement()
    ..classes.add(LDropdown.C_DROPDOWN__LIST)
    ..setAttribute(Html0.ROLE, Html0.ROLE_MENU);

  /// Callback on Change
  EditorChange editorChange;

  /// Dropdown name
  final String name;

  /// Dropdown Element
  LDropdownElement(DivElement this.element, {String this.name: "dd", String idPrefix}) {
    element.append(_dropdownList);
    element.id = LComponent.createId(idPrefix, "dd");
  }


  /// Nub on top
  bool get nubbinTop => element.classes.contains(LDropdown.C_DROPDOWN__NUBBIN_TOP);
  void set nubbinTop (bool newValue) {
    if (newValue)
      element.classes.add(LDropdown.C_DROPDOWN__NUBBIN_TOP);
    else
      element.classes.remove(LDropdown.C_DROPDOWN__NUBBIN_TOP);
  }

  /// Center Position
  bool get center => !element.classes.contains(LDropdown.C_DROPDOWN__LEFT)
  && !element.classes.contains(LDropdown.C_DROPDOWN__RIGHT);
  void set center (bool newValue) {
    if (newValue)
      element.classes.removeAll(LDropdown.POSITIONS);
  }

  /// Right Position (button is right)
  bool get right => element.classes.contains(LDropdown.C_DROPDOWN__RIGHT);
  void set right (bool newValue) {
    if (newValue) {
      element.classes.remove(LDropdown.C_DROPDOWN__LEFT);
      element.classes.add(LDropdown.C_DROPDOWN__RIGHT);
    } else {
      element.classes.remove(LDropdown.C_DROPDOWN__RIGHT);
    }
  }

  /// Left Position (button is left)
  bool get left => element.classes.contains(LDropdown.C_DROPDOWN__LEFT);
  void set left (bool newValue) {
    if (newValue) {
      element.classes.add(LDropdown.C_DROPDOWN__LEFT);
      element.classes.remove(LDropdown.C_DROPDOWN__RIGHT);
    } else {
      element.classes.remove(LDropdown.C_DROPDOWN__LEFT);
    }
  }

  /// Small
  bool get small => element.classes.contains(LDropdown.C_DROPDOWN__SMALL);
  void set small (bool newValue) {
    if (newValue) {
      element.classes.add(LDropdown.C_DROPDOWN__SMALL);
    } else {
      element.classes.remove(LDropdown.C_DROPDOWN__SMALL);
    }
  }

  bool get show => !element.classes.contains(LVisibility.C_HIDE);
  void set show (bool newValue) {
    if (newValue)
      element.classes.remove(LVisibility.C_HIDE);
    else
      element.classes.add(LVisibility.C_HIDE);
  }


  bool get required => _required;
  void set required (bool newValue) {
    _required = newValue;
    if (newValue && _dropdownItemList.isNotEmpty && value == null) {
      value = _dropdownItemList.first.value;
    }
  }
  bool _required = false;
  bool get multiple => false;


  /// Get options
  List<OptionElement> get options {
    List<OptionElement> list = new List<OptionElement>();
    for (LDropdownItem item in _dropdownItemList) {
      list.add(item.asOption());
    }
    return list;
  }
  /// Set options
  void set options (List<OptionElement> list) {
    clearOptions();
    for (OptionElement oe in list) {
      LDropdownItem item = new LDropdownItem.fromOption(oe);
      addDropdownItem(item);
    }
  }
  /// Add Option
  void addOption(OptionElement oe) {
    addDropdownItem(new LDropdownItem.fromOption(oe));
  }
  /// Option Count
  int get length => _dropdownItemList.length;

  /// Selected count
  int get selectedCount {
    String vv = value;
    return vv == null || vv.isEmpty ? 0 : 1;
  }

  /// Get select option list
  List<SelectOption> get selectOptionList {
    List<SelectOption> retValue = new List<SelectOption>();
    for (LDropdownItem item in _dropdownItemList) {
      retValue.add(item.asSelectOption());
    }
    return retValue;
  }
  /// Add Option List
  void set selectOptionList(List<SelectOption> list) {
    for (SelectOption so in list) {
      addSelectOption(so);
    }
  }
  /// Add Option
  void addSelectOption(SelectOption op) {
    LDropdownItem item = new LDropdownItem.fromSelectOption(op);
    addDropdownItem(item);
  }

  /// Clear Items
  void clearOptions() {
    _dropdownItemList.clear();
    _dropdownList.children.clear();
  }

  void addDOption(DOption option) {
    addDropdownItem(new LDropdownItem(option));
  }

  /**
   * Add actual Dropdown Item
   */
  void addDropdownItem(LDropdownItem item) {
    _dropdownItemList.add(item);
    _dropdownList.append(item.element);
    item.onClick.listen(onItemClick);
    // item.hasIconLeft = _selectMode;
  }

  /// Selection (toggle) mode - update value
  bool get selectMode => _selectMode;
  void set selectMode (bool newValue) {
    _selectMode = newValue;
    for (LDropdownItem item in _dropdownItemList) {
    //  item.hasIconLeft = newValue;
    }
  }
  bool _selectMode = false;

  /**
   * Click get value and set new value
   */
  void onItemClick(MouseEvent evt) {
    evt.preventDefault();
    Element telement = evt.target;
    String tvalue = telement.attributes[Html0.DATA_VALUE];
    while (tvalue == null && telement != null) {
      telement = telement.parent;
      tvalue = telement.attributes[Html0.DATA_VALUE];
      if (telement is AnchorElement)
        break;
    }
    LDropdownItem selectedItem = null;
    for (LDropdownItem item in _dropdownItemList) {
      if (item.value == tvalue) {
        if (_selectMode)
          item.selected = true;
        selectedItem = item;
      } else {
        item.selected = false;
      }
    }
    _log.finer("onItemClick ${name} = ${selectedItem == null ? "null" : selectedItem.value}");
    if (editorChange != null) {
      if (selectedItem == null)
        editorChange(name, null, null, null);
      else
        editorChange(name, selectedItem.value, null, selectedItem);
    }
  } // onItemClick (dropdown)


  /// Get Selected Value
  String get value {
    for (LDropdownItem item in _dropdownItemList) {
      if (item.selected)
        return item.value;
    }
    return null;
  }
  /// Set Selected Value (and inform parent)
  void set value (String newValue) {
    LDropdownItem selectedItem = null;
    for (LDropdownItem item in _dropdownItemList) {
      if (item.value == newValue) {
        item.selected = true;
        selectedItem = item;
      } else {
        item.selected = false;
      }
    }
    if (editorChange != null) {
      if (selectedItem == null)
        editorChange(name, null, null, null);
      else
        editorChange(name, selectedItem.value, null, selectedItem);
    }
  } // setValue

  /// return display value or null if not found
  String render(String newValue) {
    if (newValue == null || newValue.isEmpty) {
      return "";
    }
    for (LDropdownItem item in _dropdownItemList) {
      if (item.value == newValue)
        return item.label;
    }
    return null;
  } // render

} // LDropdownElement
