/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Search List Lookup
 */
class LObjectHomeFilterLookup {

  static final Logger _log = new Logger("LObjectHomeFilterLookup");

  /// Callback
  EditorChange editorChange;

  final DivElement element = new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN_TRIGGER]);

  final DivElement label = new DivElement()
    ..classes.addAll([LGrid.C_GRID, LText.C_TYPE_FOCUS, LGrid.C_NO_SPACE]);

  /// label
  HeadingElement _h1 = new HeadingElement.h1()
    ..classes.addAll([LPageHeader.C_PAGE_HEADER__TITLE, LText.C_TRUNCATE]);
  /// Drop down Button
  LButton _button = new LButton(new ButtonElement(), "more", null,
      icon: new LIconUtility(LIconUtility.DOWN),
      buttonClasses: [LButton.C_BUTTON__ICON, LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_MIDDLE, LMargin.C_LEFT__X_SMALL],
      assistiveText:lObjectHomeLookupMore());

  DivElement _dropdown = new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__LEFT, LDropdown.C_DROPDOWN__SMALL]);
  DivElement _dropdownHeader = new DivElement()
    ..classes.add(LDropdown.C_DROPDOWN__HEADER);
  DivElement _dropdownHeaderFind = new DivElement()
    ..classes.addAll([LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__LEFT, LMargin.C_BOTTOM__X_SMALL]);
  InputElement _dropdownHeaderFindInput = new InputElement(type: "text")
    ..classes.add(LForm.C_INPUT)
    ..placeholder = lObjectHomeLookupFindInList();
  SpanElement _dropdownHeaderLabel = new SpanElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL)
    ..text = lObjectHomeLookupList();

  LDropdownElement _dropdownElement;

  /**
   * Lookup
   */
  LObjectHomeFilterLookup() {
    element.append(label);
    label.append(_h1);
    label.append(_button.element);
    label.onClick.listen(onLabelClick);

    element.append(_dropdown);
    _dropdown.append(_dropdownHeader);
    _dropdownHeader.append(_dropdownHeaderFind);
    _dropdownHeaderFind.append(new LIconUtility(LIconUtility.SEARCH, className: LForm.C_INPUT__ICON).element);
    _dropdownHeaderFindInput.onKeyUp.listen(onSearchKeyUp);
    _dropdownHeaderFind.append(_dropdownHeaderFindInput);
    _dropdownHeader.append(_dropdownHeaderLabel);
    //
    _dropdownElement = new LDropdownElement(_dropdown, name: "filter"); // adds List
    _dropdownElement.selectMode = true;
    _dropdownElement.required = true;
    _dropdownElement.editorChange = onEditorChange;
  } // LObjectHomeLookup


  String get value => _dropdownElement.value;
  void set value (String newValue) {
    _dropdownElement.value = newValue;
  }

  /// Set Options
  void set options (List<DOption> options) {
    _dropdownElement.dOptionList = options;
  } // setOptions

  /// display dropdown toggle
  void onLabelClick(MouseEvent evt) {
    _dropdownElement.show = !_dropdownElement.show;
  }

  void onSearchKeyUp(KeyboardEvent evt) {
    lookupUpdateList(false);
  }

  /// update lookup list and display
  void lookupUpdateList(bool showAll) {
    String restriction = _dropdownHeaderFindInput.value;
    RegExp exp = null;
    if (!showAll && restriction.isNotEmpty) {
      exp = LUtil.createRegExp(restriction);
    }
    int count = 0;
    for (LDropdownItem item in _dropdownElement._dropdownItemList) {
      if (exp == null) {
        item.show = true;
        item.labelHighlightClear();
        //item.exampleUpdate();
        count++;
      }
      else if (item.labelHighlight(exp)) {
        item.show = true;
        //item.exampleUpdate();
        count++;
      }
      else { // no match
        item.show = false;
      }
    }
    if (count == 0 && _dropdownElement._dropdownItemList.isNotEmpty) {
      //  input.setCustomValidity("No matching options");
      _dropdownHeaderFind.classes.add(LForm.C_HAS_ERROR);
    } else {
      //  input.setCustomValidity("");
      _dropdownHeaderFind.classes.remove(LForm.C_HAS_ERROR);
    }
    //doValidate();
    _log.fine("lookupUpdateList '${restriction}' ${count} of ${_dropdownElement._dropdownItemList.length}");
  } // lookupUpdateList


  /**
   * Dropdown Selected
   */
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    if (details is ListItem) {
      ListItem value = details; // as ListItem);
      _h1.title = value.label;
      _h1.text = value.label;
      if (editorChange != null) // LObjectHomeFilter.onSavedQueryChange
        editorChange(name, newValue, null, null); // callback
    }
  }

  // Trl
  static String lObjectHomeLookupMore() => Intl.message("More", name: "lObjectHomeLookupMore");
  static String lObjectHomeLookupFindInList() => Intl.message("Find in Filter List", name: "lObjectHomeLookupFindInList");
  static String lObjectHomeLookupList() => Intl.message("Filter List", name: "lObjectHomeLookupList");

} // LObjectHomeFilterLookup
