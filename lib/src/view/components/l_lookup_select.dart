/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Select Lookup (Pill)
 */
class LLookupSelect extends LLookup {

  /// Pill Container
  final DivElement _pillContainer = new DivElement()
    ..classes.add(LPill.C_PILL__CONTAINER);
  final List<LPill> _pillList = new List<LPill>();


  /// Single Lookup
  LLookupSelect.single(String name, {String idPrefix})
      : super(name, idPrefix:idPrefix, typeahead: false);

  /// Multi Lookup
  LLookupSelect.multi(String name, {String idPrefix})
      : super(name, idPrefix:idPrefix, multiple:true, typeahead: false);


  /// Init for Select Lookup
  void _initEditor2(bool multiple, bool singleScope, bool typeahead) {
    element.classes.add(LLookup.C_HAS_SELECTION);
    _pillContainer.classes.add(LVisibility.C_SHOW);
    _formElement.createLookupSelect(_pillContainer, icon, multiple); // update

    // toggle dropdown on click
    _pillContainer.onClick.listen((Event evt) {
      showDropdown = !_showDropdown;
    });

  } // initEditor2

  /// focus on pill container
  ElementStream<Event> get onFocus => _pillContainer.onFocus;

  /**
   * Clicked on Item (select)
   */
  void onItemClick(MouseEvent evt) {
    evt.preventDefault();
    if (readOnly) {
      showDropdown = false;
      return;
    }
    Element telement = evt.target;
    String tvalue = telement.attributes[Html0.DATA_VALUE];
    LLookupItem selectedItem = null;
    for (LLookupItem item in lookupItemList) {
      if (item.value == tvalue) {
        selectedItem = item;
        break;
      }
    }
    // Input has aria-activedescendant attribute whose value is the id of the highlighted results list option, no value if nothing's highlighted in the list
    String vv = null;
    if (multiple) {
      input.value = ""; // clear display
      if (selectedItem != null) {
        addSelectedItem(selectedItem);
        vv = value;
        input.attributes[Html0.DATA_VALUE] = vv;
        input.attributes[Html0.ARIA_ACTIVEDECENDNT] = vv;
      }
    } else {
      if (selectedItem == null) {
        _value = "";
        input.value = "";
        input.attributes[Html0.DATA_VALUE] = "";
        input.attributes[Html0.ARIA_ACTIVEDECENDNT] = "";
      } else {
        _value = selectedItem.value;
        input.value = selectedItem.label;
        input.attributes[Html0.DATA_VALUE] = selectedItem.value;
        input.attributes[Html0.ARIA_ACTIVEDECENDNT] = selectedItem.value;
      }
      addSelectedItem(selectedItem);
      vv = value;
    }
    if (editorChange != null) {
      editorChange(name, vv, null, selectedItem);
    }
    showDropdown = false;
    for (LLookupItem item in lookupItemList) { // remove restrictions
      item.show = true;
      item.labelHighlightClear();
    }
  } // onItemClicked


  @override
  String get value {
    String vv = "";
    for (LPill pill in _pillList) {
      if (vv.isNotEmpty)
        vv += ",";
      vv += pill.value;
    }
    return vv;
  } // get value

  @override
  void set value (String newValue) {
    _pillList.clear();
    if (newValue != null && newValue.isNotEmpty) {
      List<String> values = newValue.split(",");
      for (String vv in values) {
        LLookupItem item = null;
        if (vv.isNotEmpty) {
          for (LLookupItem ii in lookupItemList) {
            if (ii.value == newValue) {
              item = ii;
              break;
            }
          }
        }
        if (item != null) {
          _pillList.add(item.asPill(onItemRemoveClick));
        }
      }
    }
    _updateContainer(); // display
  } // set value

  /// add item to selected list
  void addSelectedItem(LLookupItem item) {
    // update list
    if (!multiple) {
      _pillList.clear();
    }
    if (item != null) {
      _pillList.add(item.asPill(onItemRemoveClick));
    }
    _updateContainer();
  } // addSelectedItem

  /// display pills
  void _updateContainer() {
    _pillContainer.children.clear();
    for (LPill pill in _pillList) {
      _pillContainer.append(pill.element);
    }
  }

  /// pill remove clicked
  void onItemRemoveClick(MouseEvent evt) {
    evt.stopPropagation();
    Element target = evt.target;
    String dataValue = target.attributes[Html0.DATA_VALUE];
    while (dataValue == null && target != null) {
      target = target.parent;
      if (target != null)
        dataValue = target.attributes[Html0.DATA_VALUE];
    }
    if (dataValue != null) {
      bool found = true;
      for (LPill pill in _pillList) {
        if (pill.value == dataValue) {
          _pillList.remove(pill);
          found = true;
          break;
        }
      }
      if (found) {
        _updateContainer();
      }
    }
  } // onItemRemoveClick

} // LLookupSelect

