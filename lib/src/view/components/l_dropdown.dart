/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Dropdown with triggering button
 */
class LDropdown extends LComponent {

  /// slds-dropdown - Initializes dropdown | Required
  static const String C_DROPDOWN = "slds-dropdown";
  /// slds-dropdown-trigger - Initializes dropdown hover interactions | Required
  static const String C_DROPDOWN_TRIGGER = "slds-dropdown-trigger";
  /// slds-dropdown__item - Initializes dropdown item | Required
  static const String C_DROPDOWN__ITEM = "slds-dropdown__item";
  /// slds-dropdown--left - Positions dropdown to left side of target
  static const String C_DROPDOWN__LEFT = "slds-dropdown--left";
  /// slds-dropdown--right - Positions dropdown to right side of target
  static const String C_DROPDOWN__RIGHT = "slds-dropdown--right";
  /// slds-dropdown--small - Sets min-width of 15rem/240px
  static const String C_DROPDOWN__SMALL = "slds-dropdown--small";
  /// slds-dropdown--medium - Sets min-width of 20rem/320px
  static const String C_DROPDOWN__MEDIUM = "slds-dropdown--medium";
  /// slds-dropdown--large - Sets min-width of 25rem/400px
  static const String C_DROPDOWN__LARGE = "slds-dropdown--large";
  /// slds-dropdown--nubbin-top - Applies triangle indicator pointing at content
  static const String C_DROPDOWN__NUBBIN_TOP = "slds-dropdown--nubbin-top";
  /// slds-dropdown__header - Adds padding to area above dropdown menu list
  static const String C_DROPDOWN__HEADER = "slds-dropdown__header";
  /// slds-has-icon - Lets dropdown item know how to position icon
  static const String C_HAS_ICON = "slds-has-icon";
  /// has-icon--left - Position icon in dropdown item to the left
  static const String C_HAS_ICON__LEFT = "slds-has-icon--left";
  /// has-icon--right - Position icon in dropdown item to the right
  static const String C_HAS_ICON__RIGHT = "slds-has-icon--right";
  /// slds-is-selected - Applies selected state to dropdown item
  static const String C_IS_SELECTED = "slds-is-selected";


  static const String C_CLICK_TO_SHOW = "slds-click-to-show";

  static const String C_DROPDOWN__MENU = "slds-dropdown--menu";
  static const String C_DROPDOWN__ACTIONS = "slds-dropdown--actions";


  static const String C_DROPDOWN__LIST = "slds-dropdown__list";

  static const String C_HAS_DIVIDER = "slds-has-divider";
  /// Item
  static const String C_ICON__LEFT = "slds-icon--left";
  static const String C_ICON__RIGHT = "slds-icon--right";

  static List<String> POSITIONS = [C_DROPDOWN__LEFT, C_DROPDOWN__RIGHT];

  /// Dropdown with Button
  final DivElement element = new DivElement()
    ..classes.add(C_DROPDOWN_TRIGGER)
    ..setAttribute(Html0.ARIA_HASPOPUP, "true");

  /// Dropdown Button
  final LButton button;

  /// Dropdown Panel
  final LDropdownElement dropdown = new LDropdownElement(new DivElement()
    ..classes.addAll([C_DROPDOWN, C_DROPDOWN__MENU]));
  /// Heading Label
  SpanElement _dropdownHeading;

  /// Id Prefix
  final String idPrefix;
  /// Show Label for selected value
  bool showValueLabel = false;


  /**
   * Dropdown for [button] (classes are set here)
   * div  .trigger
   * - button
   * - div  .dropdown
   * -- div .header
   * -- ul .dropdown__list
   */
  LDropdown(LButton this.button, String this.idPrefix, {List<String> dropdownClasses}) {
    button.classes.addAll([LButton.C_BUTTON]);
    if (button.icon != null)
      button.icon.classes.add(LButton.C_BUTTON__ICON);
    add(button);
    //
    if (dropdownClasses != null) {
      dropdown.element.classes.addAll(dropdownClasses);
    }
    element.append(dropdown.element);
  } // LDropdown

  /// Settings Button+Dropdown
  LDropdown.settings(String idPrefix)
    : this(new LButton(new ButtonElement(), "settings", null,
        icon: new LIconUtility(LIconUtility.SETTINGS),
        buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
        assistiveText: "Settings",
        idPrefix:idPrefix),
    idPrefix);

  LDropdown.action(String idPrefix)
    : this(new LButton(new ButtonElement(), "more", null,
        buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED],
        icon: new LIconUtility(LIconUtility.DOWN),
        assistiveText: "More",
        idPrefix:idPrefix),
      idPrefix,
      dropdownClasses: [LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS]);

  /**
   * Select Dropdown
   */
  LDropdown.selectIcon(String idPrefix)
    : this(new LButton(new ButtonElement(), "select", null,
        buttonClasses: [LButton.C_BUTTON__ICON_MORE], idPrefix:idPrefix),
      idPrefix,
      dropdownClasses: [LDropdown.C_DROPDOWN__SMALL]);


  /**
   * Search Drop Down
   */
  LDropdown.search(String this.idPrefix, LButton this.button, InputElement input, {
      String placeholder: "Find in list...",
      String headingLabel: "List"}) {
    button.classes.addAll([LButton.C_BUTTON, LButton.C_BUTTON__ICON_CONTAINER]);
    button.icon.classes.add(LButton.C_BUTTON__ICON);
    add(button);
    //
    dropdown.element.classes.add(C_DROPDOWN__SMALL);
    element.append(dropdown.element);
    //
    DivElement header = new DivElement()
      ..classes.add(C_DROPDOWN__HEADER);
    element.append(header);
    DivElement searchDiv = new DivElement()
      ..classes.addAll([
        LEditor.C_INPUT_HAS_ICON, LEditor.C_INPUT_HAS_ICON__LEFT, LMargin.C_BOTTOM__X_SMALL]);
    header.append(searchDiv);
    LIcon searchIcon = new LIconUtility(LIconUtility.SEARCH, className: "slds-input__icon");
    searchDiv.append(searchIcon.element);
    input
      ..type = "search"
      ..placeholder = placeholder
      ..classes.add(LEditor.C_INPUT)
      ..id = idPrefix + "-search";
    LabelElement labelEle = new LabelElement()
      ..classes.add(LText.C_ASSISTIVE_TEXT)
      ..htmlFor = input.id
      ..text = placeholder;
    searchDiv.append(labelEle);
    searchDiv.append(input);
    //
    _dropdownHeading = new SpanElement()
      ..classes.add(LText.C_TEXT_HEADING__LABEL)
      ..text = placeholder;
    header.append(_dropdownHeading);
  } // search


  bool get left => dropdown.left;
  void set left (bool newValue) {
    dropdown.left = newValue;
  }
  bool get right => dropdown.right;
  void set right (bool newValue) {
    dropdown.right = newValue;
  }

  /// Heading Label
  String get headingLabel => _dropdownHeading == null ? null : _dropdownHeading.text;
  /// Heading Label
  void set headingLabel (String newValue) {
    if (_dropdownHeading == null) {
      DivElement dropdownHeading = new DivElement()
        ..classes.add(C_DROPDOWN__HEADER);
      _dropdownHeading = new SpanElement()
        ..classes.add(LText.C_TEXT_HEADING__LABEL);
      dropdownHeading.append(_dropdownHeading);
      dropdown.element.insertBefore(dropdownHeading, dropdown._dropdownList);
    }
    _dropdownHeading.text = newValue;
  }

  /// Click to Show (vs. hover)
  bool get clickToShow => element.classes.contains(C_CLICK_TO_SHOW);
  /// Click to Show (vs. hover)
  void set clickToShow (bool newValue) {
    if (newValue) {
      element.classes.add(C_CLICK_TO_SHOW);
      if (_clickToShow == null) {
        _clickToShow = element.onClick.listen((MouseEvent evt) {
          element.classes.toggle(LVisibility.C_ACTIVE);
        });
      }
    } else {
      element.classes.remove(C_CLICK_TO_SHOW);
      element.classes.remove(LVisibility.C_ACTIVE);
      if (_clickToShow != null) {
        _clickToShow.cancel();
        _clickToShow = null;
      }
    }
  }
  StreamSubscription<MouseEvent> _clickToShow;


  /// Get Value
  String get value => dropdown.value;
  /// Set Value
  void set value (String newValue) {
    selectMode = true;
    dropdown.value = newValue;
  } // value

  /// Set Button - label
  void _setValue(LDropdownItem item) {
    if (showValueLabel && item.label != null && item.label.isNotEmpty) {
      button.label = item.label;
    } else {
      button.label = null;
    }
    // button icon
    if (item.icon != null) {
      button.icon = item.icon.copy();
    }
  }

  /// Selection (toggle) mode - update value
  bool get selectMode => dropdown.selectMode;
  void set selectMode (bool newValue) {
    dropdown.selectMode = newValue;
    if (newValue)
      dropdown.editorChange = onEditorChange;
  }

  /// Editor Change callback
  void onEditorChange(String name, String newValue, bool temporary, var details) {
    if (details is LDropdownItem) {
      _setValue(details as LDropdownItem);
    }
  }

} // LDropdown


/**
 * Dropdown Element maintains list
 */
class LDropdownElement implements LSelectI {

  /// Dropdown Element
  final DivElement element;
  /// Dropdown Items
  final List<LDropdownItem> _items = new List<LDropdownItem>();

  /// Dropdown List
  final UListElement _dropdownList = new UListElement()
    ..classes.add(LDropdown.C_DROPDOWN__LIST)
    ..setAttribute(Html0.ROLE, Html0.ROLE_MENU);

  /// Callback on Change
  EditorChange editorChange;

  /// Dropdown Element
  LDropdownElement(DivElement this.element) {
    element.append(_dropdownList);
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


  bool get required => false;
  void set required (bool newValue) {
    // TOOD
  }
  bool get multiple => false;


  /// Get options
  List<OptionElement> get options {
    List<OptionElement> list = new List<OptionElement>();
    for (LDropdownItem item in _items) {
      list.add(item.toOption());
    }
    return list;
  }
  /// Set options
  void set options (List<OptionElement> list) {
    for (OptionElement oe in list) {
      LDropdownItem item = new LDropdownItem.fromOption(oe);
      addItem(item);
    }
  }
  /// Add Option
  void addOption(OptionElement oe) {
    addItem(new LDropdownItem.fromOption(oe));
  }

  /// Add Option
  void addSelectOption(SelectOption op) {
    LDropdownItem item = new LDropdownItem.fromSelectOption(op);
    addItem(item);
  }
  /// Add Option List
  void addSelectOptions(List<SelectOption> list) {
    for (SelectOption so in list)
      addSelectOption(so);
  }
  /// Add Option List
  void addDOptions(List<DOption> options) {
    for (DOption op in options) {
      SelectOption so = new SelectOption(op);
      addSelectOption(so);
    }
  }

  /// Clear Items
  void clear() {
    _items.clear();
    _dropdownList.children.clear();
  }

  /**
   * Add Dropdown Item
   */
  void addItem(LDropdownItem item) {
    _items.add(item);
    _dropdownList.append(item.element);
    item.onClick.listen(onItemClick);
  }

  /// Selection (toggle) mode - update value
  bool get selectMode => _selectMode;
  void set selectMode (bool newValue) {
    _selectMode = newValue;
    for (LDropdownItem item in _items) {
      item.hasIconLeft = newValue;
    }
  }
  bool _selectMode = false;

  /// get value and set new value
  void onItemClick(MouseEvent evt) {
    evt.preventDefault();
    Element telement = evt.target;
    String tvalue = telement.attributes[Html0.DATA_VALUE];
    LDropdownItem selectedItem = null;
    for (LDropdownItem item in _items) {
      if (item.value == tvalue) {
        item.selected = true;
        selectedItem = item;
      } else {
        item.selected = false;
      }
    }
    if (editorChange != null) {
      if (selectedItem == null)
        editorChange("", null, false, null);
      else
        editorChange("", selectedItem.value, false, selectedItem);
    }
  } // onItemClick (dropdown)


  /// Get Selected Value
  String get value {
    for (LDropdownItem item in _items) {
      if (item.selected)
        return item.value;
    }
    return null;
  }
  /// Set Selected Value (and inform parent)
  void set value (String newValue) {
    LDropdownItem selectedItem = null;
    for (LDropdownItem item in _items) {
      if (item.value == newValue) {
        item.selected = true;
        selectedItem = item;
      } else {
        item.selected = false;
      }
    }
    if (editorChange != null) {
      if (selectedItem == null)
        editorChange("", null, false, null);
      else
        editorChange("", selectedItem.value, false, selectedItem);
    }
  } // setValue

} // LDropdownElement



/**
 * Dropdown Item
 */
class LDropdownItem extends ListItem {

  /**
   * Dropdown item
   */
  LDropdownItem({String id, String label, String value, String href,
        LIcon leftIcon, LIcon icon, bool selected, bool disabled})
    : super(id:id, label:label, value:value, href:href,
          leftIcon:leftIcon, rightIcon:icon, selected:selected, disabled:disabled) {
    element
      ..classes.add(LDropdown.C_DROPDOWN__ITEM)
      ..tabIndex = -1
      ..attributes[Html0.ROLE] = Html0.ROLE_MENUITEM + " " + Html0.ROLE_OPTION;
    a
      ..classes.add(LText.C_TRUNCATE)
      ..tabIndex = -1;
  } // LDropdownItem

  /// Dropdown Item from List
  LDropdownItem.from(ListItem item)
      : this(id:item.id, label:item.label, value:item.value, href:item.href,
          leftIcon:item.leftIcon, icon:item.rightIcon, selected:item.selected, disabled:item.disabled);

  /// create drop-down from button - with left icon!
  LDropdownItem.fromButton(LButton button) : this(id:button.id,
    label:button.label,
    leftIcon:button.icon == null ? null : button.icon.copy());

  /// Lookup Item from Option
  LDropdownItem.fromOption(OptionElement option)
      : this(id:option.id, label:option.label, value:option.value, selected:option.selected, disabled:option.disabled);

  /// Lookup Item from SelectOption
  LDropdownItem.fromSelectOption(SelectOption option)
      : this(id:option.id, label:option.label, value:option.value, selected:option.selected, disabled:option.disabled);

  /// On Click
  ElementStream<MouseEvent> get onClick => a.onClick;

  /// Divider
  bool get divider => element.classes.contains(LDropdown.C_HAS_DIVIDER);
  void set divider (bool newValue) {
    if (newValue)
      element.classes.add(LDropdown.C_HAS_DIVIDER);
    else
      element.classes.remove(LDropdown.C_HAS_DIVIDER);
  }

  /**
   * Create Link
   */
  @override
  void _rebuild() {
    if (_selected != null) {
      if (_selected) {
        if (_selectedIcon == null) {
          _selectedIcon = new LIconStandard(LIconStandard.TASK2, size: LIcon.C_ICON__SMALL)
            ..classes.add(LDropdown.C_ICON__LEFT);
        }
        _leftIcon = _selectedIcon;
      } else {
        _leftIcon = null; // overwrite in selection mode
      }
    }
    super._rebuild();
  }
  LIcon _selectedIcon;

  /// Right Icon (left icon used for select)
  LIcon get icon => _rightIcon;

} // LDropdownItem
