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

  static const String C_DROPDOWN = "slds-dropdown";
  static const String C_DROPDOWN__HEADER = "slds-dropdown__header";

  static const String C_DROPDOWN_TRIGGER = "slds-dropdown-trigger";
  static const String C_CLICK_TO_SHOW = "slds-click-to-show";

  static const String C_DROPDOWN__MENU = "slds-dropdown--menu";
  static const String C_DROPDOWN__NUBBIN_TOP = "slds-dropdown--nubbin-top";
  static const String C_DROPDOWN__ACTIONS = "slds-dropdown--actions";

  static const String C_DROPDOWN__LEFT = "slds-dropdown--left";
  static const String C_DROPDOWN__RIGHT = "slds-dropdown--right";
  static const String C_DROPDOWN__SMALL = "slds-dropdown--small";

  static const String C_DROPDOWN__LIST = "slds-dropdown__list";
  static const String C_DROPDOWN__ITEM = "slds-dropdown__item";

  static const String C_HAS_DIVIDER = "slds-has-divider";
  /// Item
  static const String C_HAS_ICON__LEFT = "slds-has-icon--left";
  static const String C_IS_SELECTED = "slds-is-selected";
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
      dropdown.element.insertBefore(dropdownHeading, dropdown.dropdownList);
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
    for (LDropdownItem item in dropdown.items) {
      if (item.value == newValue) {
        item.selected = true;
        _setValue(item);
      } else {
        item.selected = false;
      }
      item._itemClicked = false;
    }
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

  /// Selection mode - update value
  bool get selectMode => _selectMode != null && _selectMode;
  void set selectMode (bool newValue) {
    for (LDropdownItem item in dropdown.items) {
      item.hasIconLeft = true;
      if (newValue && _selectMode == null) { // only once
        item.a.onClick.listen(item.onItemClick); // toggle value
        item.a.onClick.listen(onItemClick); // update value
      }
    }
    if (newValue)
      _selectMode = true;
    else if (_selectMode != null)
      _selectMode = false;
  }
  bool _selectMode;

  /// get value and set new value
  void onItemClick(MouseEvent evt) {
    if (_selectMode != null && _selectMode) {
      evt.preventDefault();
      for (LDropdownItem item in dropdown.items) {
        if (item._itemClicked && item.selected) {
          print("dropdown ${item.value}");
          _setValue(item);
        } else {
          item.selected = false;
        }
        item._itemClicked = false;
      }
    }
  } // onItemClick (dropdown)



} // LDropdown


/**
 * Dropdown Element maintains list
 * TODO Same API as Select
 */
class LDropdownElement {

  /// Dropdown Element
  final DivElement element;
  /// Dropdown Items
  final List<LDropdownItem> items = new List<LDropdownItem>();


  /// Dropdown List
  final UListElement dropdownList = new UListElement()
    ..classes.add(LDropdown.C_DROPDOWN__LIST)
    ..setAttribute(Html0.ROLE, Html0.ROLE_MENU);

  /// Dropdown Element
  LDropdownElement(DivElement this.element) {
    element.append(dropdownList);
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

  /**
   * Add Dropdown Item
   */
  void addItem(LDropdownItem item) {
    items.add(item);
    dropdownList.append(item.element);
  }


  /// Get Selected Value
  String get value {
    for (LDropdownItem item in items) {
      if (item.selected)
        return item.value;
    }
    return null;
  }
  /// Set Selected Value
  void set value (String newValue) {
    for (LDropdownItem item in items) {
      item.selected = (item.value == newValue);
    }
  }

} // LDropdownElement



/**
 * Dropdown Item
 */
class LDropdownItem extends ListItem {

  /**
   * Dropdown item
   */
  LDropdownItem({String id, String label, String value, String href, LIcon leftIcon, LIcon icon})
      : super(id:id, label:label, value:value, href:href, leftIcon:leftIcon, rightIcon:icon) {
    element
      ..classes.add(LDropdown.C_DROPDOWN__ITEM)
      ..tabIndex = -1
      ..attributes[Html0.ROLE] = Html0.ROLE_MENUITEM + " " + Html0.ROLE_OPTION;
    a
      ..classes.add(LText.C_TRUNCATE)
      ..tabIndex = -1;
  } // LDropdownItem

  LDropdownItem.from(ListItem item) // not copied: selected/disabled
  : this(id:item.id, label:item.label, value:item.value, href:item.href, leftIcon:item.leftIcon, rightIcon:item.rightIcon);

  /// create drop-down from button - with left icon!
  LDropdownItem.fromButton(LButton button) : this(id:button.id,
    label:button.label,
    leftIcon:button.icon == null ? null : button.icon.copy());


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
  void _rebuildLink() {
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
    super._rebuildLink();
  }
  LIcon _selectedIcon;

  /// Right Icon (left icon used for select)
  LIcon get icon => _rightIcon;

  /// on item click - prevent default + toggle selection
  void onItemClick(MouseEvent evt) {
    evt.preventDefault();
    if (!disabled) {
      if (!selected)
        selected = true; // do not de-select
      _itemClicked = true;
    }
  }
  bool _itemClicked = false;

} // LDropdownItem
