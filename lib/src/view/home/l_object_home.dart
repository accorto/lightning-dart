/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Object Home
 * - List view of the Object with Record Lookup / Search
 */
class LObjectHome extends LPageHeader {

  /// Top Row - Icon - Title - Label - Follow - Actions
  final DivElement _header = new DivElement()
    ..classes.add(LGrid.C_GRID);
  /// Top row left
  final DivElement _headerLeft = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_HAS_FLEXI_TRUNCATE]);
  final ParagraphElement _headerLeftRecordType = new ParagraphElement()
    ..classes.add(LText.C_TEXT_HEADING__LABEL);

  LObjectHomeLookup _lookup;

  /// Top row left
  final DivElement _headerRight = new DivElement()
    ..classes.addAll([LGrid.C_COL, LGrid.C_NO_FLEX, LGrid.C_ALIGN_BOTTOM]);
  final LButtonGroup _actionButtonGroup = new LButtonGroup();

  final ParagraphElement _summary = new ParagraphElement()
    ..classes.addAll([LText.C_TEXT_BODY__SMALL, LMargin.C_TOP__X_SMALL]);

  /**
   * Object Home
   */
  LObjectHome() {
    _initComponent();
  }

  /// Object Home from UI
  LObjectHome.ui(UI ui) {
    _initComponent();
    recordType = ui.table.label + "s"; // TODO plural

  } // LObjectHome.ui

  /// Initialize Component Structure
  void _initComponent() {
    // Header Row
    element.append(_header);
    // div .slds-col
    // - p
    _header.append(_headerLeft);
    _headerLeft.append(_headerLeftRecordType);
    // - div .slds-grid
    // -- div .slds-grid focus
    // --- h1
    // --- button
    // -- button more
    // -- button save
    DivElement headerLeftGrid = new DivElement()
      ..classes.add(LGrid.C_GRID);
    _headerLeft.append(headerLeftGrid);
    // options
    List<DOption> options = new List<DOption>();
    options.add(new DOption()
      ..value = "recent"
      ..label = "Recently Viewed");
    options.add(new DOption()
      ..value = "all"
      ..label = "All Records");
    _lookup = new LObjectHomeLookup(options, onSavedQueryChange);
    headerLeftGrid.append(_lookup.element);

    LButton headerLeftGridMore = new LButton(new ButtonElement(), "more", null,
    buttonClasses: [LButton.C_BUTTON, LButton.C_BUTTON__ICON_MORE, LGrid.C_SHRINK_NONE, LMargin.C_LEFT__LARGE]);
    headerLeftGrid.append(headerLeftGridMore.element);

    LButton headerLeftGridSave = new LButton(new ButtonElement(), "save", lObjectHomeSave(),
    buttonClasses: [LButton.C_BUTTON, LButton.C_BUTTON__BRAND, "slds-button-space-left", // TODO
    LMargin.C_RIGHT__MEDIUM, LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_MIDDLE, "slds-hide"]);
    headerLeftGrid.append(headerLeftGridSave.element);

    _header.append(_headerRight);
    _headerRight.append(_actionButtonGroup.element);
    // Actions
    LButton newButton = new LButton.base("new", "New");
    _actionButtonGroup.add(newButton);

    element.append(_summary);
  } // LObjectHome

  /// Record Type Text
  String get recordType => _headerLeftRecordType.text;
  /// Record Type Text
  void set recordType(String newValue) {
    _headerLeftRecordType.text = newValue;
  }


  void onSavedQueryChange(DOption option) {
    print("saved query ${option.value}");
  }

  void set recordList (List<DRecord> records) {
    _recordList = records;
    display();
  }
  List<DRecord> _recordList;


  void display() {
    if (_recordList == null || _recordList.isEmpty) {
      _summary.text = "0 items";
    } else {
      _summary.text = "${_recordList.length} items * Sorted by x";
    }
  } // display


  // Trl
  static String lObjectHomeSave() => Intl.message("Save", name: "lObjectHomeSave", args: []);

} // LObjectHome


/**
 * Search List Lookup
 */
class LObjectHomeLookup {

  static final Logger _log = new Logger("LObjectHomeLookup");


  final DivElement element = new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN_TRIGGER]);

  final DivElement label = new DivElement()
    ..classes.addAll([LGrid.C_GRID, LText.C_TYPE_FOCUS, LGrid.C_NO_SPACE]);

  /// label
  HeadingElement _h1 = new HeadingElement.h1()
    ..classes.addAll([LText.C_TEXT_HEADING__MEDIUM, LText.C_TRUNCATE]);
  /// Drop down Button
  LButton _button = new LButton(new ButtonElement(), "more", null,
    icon: new LIconUtility(LIconUtility.DOWN),
    buttonClasses: [LButton.C_BUTTON__ICON_BARE, LGrid.C_SHRINK_NONE, LGrid.C_ALIGN_MIDDLE, LMargin.C_LEFT__X_SMALL],
    assistiveText:lObjectHomeLookupMore());

  DivElement _dropdown = new DivElement()
    ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__LEFT, LDropdown.C_DROPDOWN__SMALL, LDropdown.C_DROPDOWN__MENU]);
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

  /// Callback
  var optionSelected;

  /**
   * Lookup
   */
  LObjectHomeLookup(List<DOption> options, void this.optionSelected(DOption option)) {
    element.append(label);
    label.append(_h1);
    label.append(_button.element);

    element.append(_dropdown);
    _dropdown.append(_dropdownHeader);
    _dropdownHeader.append(_dropdownHeaderFind);
    _dropdownHeaderFind.append(new LIconUtility(LIconUtility.SEARCH, className: LForm.C_INPUT__ICON).element);
    _dropdownHeaderFindInput.onKeyUp.listen(onSearchKeyUp);
    _dropdownHeaderFind.append(_dropdownHeaderFindInput);
    _dropdownHeader.append(_dropdownHeaderLabel);
    _dropdownElement = new LDropdownElement(_dropdown); // adds List
    _dropdownElement.selectMode = true;
    _dropdownElement.editorChange = onEditorChange;
    //
    LDropdownItem first = null;
    for (DOption option in options) {
      LDropdownItem item = new LDropdownItem(option);
      _dropdownElement.addItem(item);
      if (first == null)
        first = item;
    }
    onEditorChange(null, null, null, first);
  } // LObjectHomeLookup


  void onSearchKeyUp(KeyboardEvent evt) {
    lookupUpdateList(false);
  }

  /// update lookup list and display
  void lookupUpdateList(bool showAll) {
    String restriction = _dropdownHeaderFindInput.value;
    RegExp exp = null;
    if (!showAll && restriction.isNotEmpty) {
      exp = LLookup._createRegExp(restriction);
    }
    int count = 0;
    for (LDropdownItem item in _dropdownElement._items) {
      if (exp == null) {
        item.show = true;
        item.labelHighlightClear();
        //item.exampleUpdate();
        count++;
      }
      else if (item.labelHighlight(exp) || item.descriptionHighlight(exp)) {
        item.show = true;
        //item.exampleUpdate();
        count++;
      }
      else { // no match
        item.show = false;
      }
    }
    if (count == 0 && _dropdownElement._items.isNotEmpty) {
    //  input.setCustomValidity("No matching options"); // TODO Trl
      _dropdownHeaderFind.classes.add(LForm.C_HAS_ERROR);
    } else {
    //  input.setCustomValidity("");
      _dropdownHeaderFind.classes.remove(LForm.C_HAS_ERROR);
    }
    //doValidate();
    _log.fine("lookupUpdateList '${restriction}' ${count} of ${_dropdownElement._items.length}");
  } // lookupUpdateList


  /**
   * Dropdown Selected
   */
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    if (details is ListItem) {
      ListItem value = (details as ListItem);
      _h1.text = value.label;
      optionSelected(value.option); // callback
    }
  }

  // Trl
  static String lObjectHomeLookupMore() => Intl.message("More", name: "lObjectHomeLookupMore");
  static String lObjectHomeLookupFindInList() => Intl.message("Find in List", name: "lObjectHomeLookupFindInList");
  static String lObjectHomeLookupList() => Intl.message("List", name: "lObjectHomeLookupList");

} // LObjectHomeLookup
