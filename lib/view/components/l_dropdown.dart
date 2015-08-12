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
  static const String C_DROPDOWN_TRIGGER = "slds-dropdown-trigger";
  static const String C_DROPDOWN__HEADER = "slds-dropdown__header";

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
    ..setAttribute("aria-haspopup", "true");

  /// Dropdown Button
  final LButton button;

  /// Dropdown Panel
  final DivElement dropdown = new DivElement()
    ..classes.addAll([C_DROPDOWN, C_DROPDOWN__MENU]);
  /// Heading Label
  SpanElement dropdownHeadingLabel;
  /// Dropdown List
  final UListElement dropdownList = new UListElement()
    ..classes.add(C_DROPDOWN__LIST)
    ..setAttribute(Html0.A_ROLE, Html0.V_ROLE_MENU);

  /// Dropdown Items
  final List<LDropdownItem> items = new List<LDropdownItem>();
  /// Id Prefix
  final String idPrefix;

  
  /**
   * Dropdown for [button] (classes are set here)
   * div  .trigger
   * - button
   * - div  .dropdown
   * -- div .header
   * -- ul .dropdown__list
   */
  LDropdown(LButton this.button, String this.idPrefix) {
    button.classes.addAll([LButton.C_BUTTON, LButton.C_BUTTON__ICON_CONTAINER]);
    button.icon.classes.add(LButton.C_BUTTON__ICON);
    append(button);
    //
    element.append(dropdown);
    dropdown.append(dropdownList);
  } // LDropdown

  /// Settings Button+Dropdown
  LDropdown.settings(String idPrefix) : this(new LButton("settings", null,
      icon: new LIcon.utility("settings"),
      assistiveText: "Settings"), idPrefix);

  LDropdown.action(String idPrefix) : this(new LButton("more", null,
      buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED],
      icon: new LIcon.utility("down"), // slds-dropdown--right slds-dropdown--actions
      assistiveText: "More"), idPrefix);


  /**
   * Search Drop Down
   */
  LDropdown.search(LButton this.button, InputElement input, String this.idPrefix, {
      String placeholder: "Find in list...",
      String headingLabel: "List"}) {
    button.classes.addAll([LButton.C_BUTTON, LButton.C_BUTTON__ICON_CONTAINER]);
    button.icon.classes.add(LButton.C_BUTTON__ICON);
    append(button);
    //
    dropdown.classes.add(C_DROPDOWN__SMALL);
    element.append(dropdown);
    //
    DivElement header = new DivElement()
      ..classes.add(C_DROPDOWN__HEADER);
    element.append(header);
    DivElement searchDiv = new DivElement()
      ..classes.addAll([
        LEditor.C_INPUT_HAS_ICON, LEditor.C_INPUT_HAS_ICON__LEFT, LMargin.C_BOTTOM__X_SMALL]);
    header.append(searchDiv);
    LIcon searchIcon = new LIcon.utility("search", className: "slds-input__icon");
    searchDiv.append(searchIcon.element);
    input
      ..type = "search"
      ..placeholder = placeholder
      ..classes.add(LEditor.C_INPUT)
      ..id = idPrefix + "-search";
    LabelElement labelEle = new LabelElement()
      ..classes.add(LButton.C_ASSISTIVE_TEXT)
      ..htmlFor = input.id
      ..text = placeholder;
    searchDiv.append(labelEle);
    searchDiv.append(input);
    //
    dropdownHeadingLabel = new SpanElement()
      ..classes.add(LText.C_TEXT_HEADING__LABEL)
      ..text = placeholder;
    header.append(dropdownHeadingLabel);
    //
    dropdown.append(dropdownList);
  } // search


  /// Heading Label
  String get headingLabel => dropdownHeadingLabel == null ? null : dropdownHeadingLabel.text;
  /// Heading Label
  void set headingLabel (String newValue) {
    if (dropdownHeadingLabel == null) {
    DivElement dropdownHeading = new DivElement()
      ..classes.add(C_DROPDOWN__HEADER);
    dropdownHeadingLabel = new SpanElement()
      ..classes.add(LText.C_TEXT_HEADING__LABEL);
    dropdownHeading.append(dropdownHeadingLabel);
    dropdown.insertBefore(dropdownHeading, dropdownList);
    }
    dropdownHeadingLabel.text = newValue;
  }


  /**
   * Add Menu Item
   */
  void addMenuItem(LDropdownItem item) {
    items.add(item);
    dropdownList.append(item.element);
  }

  /// Nub on top
  bool get nubbinTop => dropdown.classes.contains(C_DROPDOWN__NUBBIN_TOP);
  void set nubbinTop (bool newValue) {
    if (newValue)
      dropdown.classes.add(C_DROPDOWN__NUBBIN_TOP);
    else
      dropdown.classes.remove(C_DROPDOWN__NUBBIN_TOP);
  }

  /// Center Position
  bool get center => !dropdown.classes.contains(C_DROPDOWN__LEFT) && !dropdown.classes.contains(C_DROPDOWN__RIGHT);
  void set center (bool newValue) {
    if (newValue)
      dropdown.classes.removeAll(POSITIONS);
  }

  /// Right Position (button is right)
  bool get right => dropdown.classes.contains(C_DROPDOWN__RIGHT);
  void set right (bool newValue) {
    if (newValue) {
      dropdown.classes.remove(C_DROPDOWN__LEFT);
      dropdown.classes.add(C_DROPDOWN__RIGHT);
    } else {
      dropdown.classes.remove(C_DROPDOWN__RIGHT);
    }
  }

  /// Left Position (button is left)
  bool get left => dropdown.classes.contains(C_DROPDOWN__LEFT);
  void set left (bool newValue) {
    if (newValue) {
      dropdown.classes.add(C_DROPDOWN__LEFT);
      dropdown.classes.remove(C_DROPDOWN__RIGHT);
    } else {
      dropdown.classes.remove(C_DROPDOWN__LEFT);
    }
  }

  /// Small
  bool get small => dropdown.classes.contains(C_DROPDOWN__SMALL);
  void set small (bool newValue) {
    if (newValue) {
      dropdown.classes.add(C_DROPDOWN__SMALL);
    } else {
      dropdown.classes.remove(C_DROPDOWN__SMALL);
    }
  }


} // LDropdown


/**
 * Dropdown Item
 */
class LDropdownItem {

  /// Dropdown Item
  LIElement element = new LIElement()
    ..classes.add(LDropdown.C_DROPDOWN__ITEM)
    ..tabIndex = -1;

  AnchorElement a = new AnchorElement()
    ..classes.add(LText.C_TRUNCATE)
    ..tabIndex = -1;

  LDropdownItem() {
    element.attributes[Html0.A_ROLE] = "menuitem option";
    // role="menuitemcheckbox", or role="menuitemradio"
  }


  /// Label
  String get label => _label;
  void set label(String newValue) {
    _label = newValue;
    _rebuildLink();
  }
  String _label;

  /// Id
  String get id => a.id;
  void set id(String newValue) {
    a.id = newValue;
    element.id = newValue + "-item";
  }

  /// Href
  String get href => a.href;
  void set href (String newValue) {
    a.href = newValue;
    element.attributes["href"] = newValue;
  }

  /// Disabled
  bool get disabled => _disabled;
  void set disabled (bool newValue) {
    _disabled = newValue;
    if (newValue) {
      element.attributes[Html0.A_DISABLED] = "";
      a.attributes[Html0.A_DISABLED] = "";
    } else {
      element.attributes.remove(Html0.A_DISABLED);
      a.attributes.remove(Html0.A_DISABLED);
    }
  }
  bool _disabled = false;

  /// Divider
  bool get divider => element.classes.contains(LDropdown.C_HAS_DIVIDER);
  void set divider (bool newValue) {
    if (newValue)
      element.classes.add(LDropdown.C_HAS_DIVIDER);
    else
      element.classes.remove(LDropdown.C_HAS_DIVIDER);
  }

  /// Left icon (e.g. for selection)
  bool get hasIconLeft => element.classes.contains(LDropdown.C_HAS_ICON__LEFT);
  void set hasIconLeft (bool newValue) {
    if (newValue)
      element.classes.add(LDropdown.C_HAS_ICON__LEFT);
    else
      element.classes.remove(LDropdown.C_HAS_ICON__LEFT);
  }

  /// Selected
  bool get selected => _selected;
  void set selected(bool newValue) {
    _selected = newValue;
    if (newValue)
      element.classes.add(LDropdown.C_IS_SELECTED);
    else
      element.classes.add(LDropdown.C_IS_SELECTED);
    _rebuildLink();
  }
  bool _selected;

  LIcon get icon => _rightIcon;
  /// Richt Icon
  void set icon (LIcon rightIcon) {
    _rightIcon = rightIcon;
    _rightIcon.size = LIcon.C_ICON__SMALL;
    _rightIcon.classes.add(LDropdown.C_ICON__RIGHT);
    _rebuildLink();
  }
  LIcon _rightIcon;

  /**
   * Create Link
   */
  void _rebuildLink() {
    a.children.clear();
    if (_selected) {
      if (_selectedIcon == null) {
        _selectedIcon = new LIcon.standard("task2", size: LIcon.C_ICON__SMALL)
          ..classes.add(LDropdown.C_ICON__LEFT);
      }
      a.append(_selectedIcon.element);
    }
    a.appendText(_label);
    if (_rightIcon != null) {
      a.append(_rightIcon.element);
    }
  }
  LIcon _selectedIcon;

} // LDropdownItem
