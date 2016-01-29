/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Dropdown with triggering button
 */
class LDropdown
    extends LComponent {

  /// slds-dropdown - Initializes dropdown | Required
  static const String C_DROPDOWN = "slds-dropdown";
  /// slds-dropdown-trigger - Enables dropdown to show on hover | Required
  static const String C_DROPDOWN_TRIGGER = "slds-dropdown-trigger";
  /// slds-dropdown-trigger--click - Modifier that enables dropdown to show on click
  static const String C_DROPDOWN_TRIGGER__CLICK = "slds-dropdown-trigger--click";
  /// slds-dropdown__item - Initializes dropdown item | Required
  static const String C_DROPDOWN__ITEM = "slds-dropdown__item";
  /// slds-dropdown--bottom - Positions dropdown to above target
  static const String C_DROPDOWN__BOTTOM = "slds-dropdown--bottom";
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
  /// slds-dropdown__header - Adds padding to area above dropdown menu list
  static const String C_DROPDOWN__HEADER = "slds-dropdown__header";

  /// slds-nubbin--top - Triangle that points upwards which is horizontally centered
  static const String C_NUBBIN__TOP = "slds-nubbin--top";
  /// slds-nubbin--top-left - Triangle that points upwards which is left aligned
  static const String C_NUBBIN__TOP_LEFT = "slds-nubbin--top-left";
  /// slds-nubbin--top-right - Triangle that points upwards which is right aligned
  static const String C_NUBBIN__TOP_RIGHT = "slds-nubbin--top-right";
  /// slds-nubbin--bottom - Triangle that points downwards which is horizontally centered
  static const String C_NUBBIN__BOTTOM = "slds-nubbin--bottom";
  /// slds-nubbin--bottom-left - Triangle that points downwards which is left aligned
  static const String C_NUBBIN__BOTTOM_LEFT = "slds-nubbin--bottom-left";
  /// slds-nubbin--bottom-right - Triangle that points downwards which is right aligned
  static const String C_NUBBIN__BOTTOM_RIGHT = "slds-nubbin--bottom-right";

  /// slds-is-selected - Applies selected state to dropdown item
  static const String C_IS_SELECTED = "slds-is-selected";
  /// slds-dropdown--nubbin-top - Applies triangle indicator pointing at content
  static const String C_DROPDOWN__NUBBIN_TOP = "slds-dropdown--nubbin-top";
  /// slds-has-icon - Lets dropdown item know how to position icon
  //static const String C_HAS_ICON = "slds-has-icon";
  /// slds-has-icon--left - Position icon in dropdown item to the left
  //static const String C_HAS_ICON__LEFT = "slds-has-icon--left";
  /// slds-has-icon--right - Position icon in dropdown item to the right
  //static const String C_HAS_ICON__RIGHT = "slds-has-icon--right";

  /// slds-action-overflow--touch - Positions the Action overflow for touch to take up full screen
  static const String C_ACTION_OVERFLOW__TOUCH = "slds-action-overflow--touch";
  /// slds-action-overflow--touch__container - Pushes the menu to the bottom of the screen.
  static const String C_ACTION_OVERFLOW__TOUCH__CONTAINER = "slds-action-overflow--touch__container";
  /// slds-action-overflow--touch__content - Creates a scrolling area that is pushed down the screen by a third of the viewport height.
  static const String C_ACTION_OVERFLOW__TOUCH__CONTENT = "slds-action-overflow--touch__content";
  /// slds-action-overflow--touch__body - Draws the white menu.
  static const String C_ACTION_OVERFLOW__TOUCH__BODY = "slds-action-overflow--touch__body";
  /// slds-action-overflow--touch__footer - Creates the footer for the Cancel button.
  static const String C_ACTION_OVERFLOW__TOUCH__FOOTER = "slds-action-overflow--touch__footer";


  static const String C_DROPDOWN__MENU = "slds-dropdown--menu";
  static const String C_DROPDOWN__ACTIONS = "slds-dropdown--actions";


  static const String C_DROPDOWN__LIST = "slds-dropdown__list";

  static const String C_HAS_DIVIDER = "slds-has-divider";
  /// Item
  static const String C_ICON__LEFT = "slds-icon--left";
  static const String C_ICON__RIGHT = "slds-icon--right";

  static List<String> POSITIONS = [C_DROPDOWN__LEFT, C_DROPDOWN__RIGHT];


  static final Logger _log = new Logger("LDropdown");

  /// Dropdown with Button
  final DivElement element = new DivElement()
    ..classes.add(C_DROPDOWN_TRIGGER);

  /// Dropdown Button
  final LButton button;

  /// Dropdown Panel
  LDropdownElement dropdown;
  /// Heading Label
  SpanElement _dropdownHeading;

  /// Id Prefix
  final String idPrefix;
  /// Show Label for selected value
  bool showValueLabel = false;

  /// Callback on Change
  EditorChange editorChange;

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
    button.element.setAttribute(Html0.ARIA_HASPOPUP, "true");
    if (button.icon != null)
      button.icon.classes.add(LButton.C_BUTTON__ICON);
    add(button);
    dropdown = new LDropdownElement(new DivElement()
        ..classes.addAll([C_DROPDOWN, C_DROPDOWN__MENU]),
      name:button.name, idPrefix:idPrefix);
    //
    if (dropdownClasses != null) {
      dropdown.element.classes.addAll(dropdownClasses);
    }
    element.append(dropdown.element);
    button.onClick.listen(onButtonClick);
  } // LDropdown

  /// Settings Icon Button + Dropdown
  LDropdown.settings({String idPrefix, String title: "Settings"})
    : this(new LButton(new ButtonElement(), "settings", null,
        icon: new LIconUtility(LIconUtility.SETTINGS),
        buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
        assistiveText: title,
        idPrefix:idPrefix),
    idPrefix);

  /// Icon Button + Dropdown
  LDropdown.icon (String name, LIcon icon, {String idPrefix, String assistiveText})
    : this(new LButton(new ButtonElement(), name, null,
        icon:icon,
        buttonClasses: [LButton.C_BUTTON__ICON_CONTAINER],
        assistiveText:assistiveText,
        idPrefix:idPrefix),
    idPrefix);

  /// Action: More Button + Dropdown
  LDropdown.action({String idPrefix, String title: "More"})
    : this(new LButton(new ButtonElement(), "more", null,
        buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED],
        icon: new LIconUtility(LIconUtility.DOWN),
        assistiveText: title,
        idPrefix:idPrefix),
      idPrefix,
      dropdownClasses: [C_DROPDOWN__RIGHT, C_DROPDOWN__ACTIONS]);

  /**
   * Select Dropdown
   */
  LDropdown.selectIcon({String idPrefix})
    : this(new LButton(new ButtonElement(), "select", null,
        buttonClasses: [LButton.C_BUTTON__ICON_MORE], idPrefix:idPrefix),
      idPrefix,
      dropdownClasses: [C_DROPDOWN__SMALL]);


  /**
   * Search Drop Down
   */
  @deprecated
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
        LForm.C_INPUT_HAS_ICON, LForm.C_INPUT_HAS_ICON__LEFT, LMargin.C_BOTTOM__X_SMALL]);
    header.append(searchDiv);
    LIcon searchIcon = new LIconUtility(LIconUtility.SEARCH, className: "slds-input__icon");
    searchDiv.append(searchIcon.element);
    input
      ..type = "search"
      ..placeholder = placeholder
      ..classes.add(LForm.C_INPUT)
      ..id = LComponent.createId(idPrefix, "-search");
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

  /// button name
  String get name => button.name;

  /// left aligned  |=
  bool get left => dropdown.left;
  void set left (bool newValue) {
    dropdown.left = newValue;
  }
  /// right aligned  =|
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

  /// Get Value
  String get value => dropdown.value;
  /// Set Value
  void set value (String newValue) {
    selectMode = true;
    dropdown.value = newValue;
  } // value

  /// Set Button - Label/Icon
  void _setValue(ListItem item) {
    if (showValueLabel && item != null && item.label != null && item.label.isNotEmpty) {
      button.label = item.label;
    } else {
      button.label = "";
    }
    // button icon
    if (item != null && item.icon != null) {
      button.icon = item.icon.copy();
    } else {
      button.icon = null;
    }
  } // _setValue

  /// Selection (toggle) mode - update value
  bool get selectMode => dropdown.selectMode;
  void set selectMode (bool newValue) {
    dropdown.selectMode = newValue;
    if (newValue)
      dropdown.editorChange = onEditorChange;
  }

  /// Editor Change callback
  void onEditorChange(String name, String newValue, DEntry ignored, var details) {
    if (details is ListItem) {
      _setValue(details as ListItem);
    }
    if (editorChange != null) // if this were an EditorI
      editorChange(name, newValue, ignored, details);
  }

  void onButtonClick(MouseEvent evt) {
    _log.config("onButtonClick ${name}");
    dropdown.show = !dropdown.show;
  }

  @override
  String toString() {
    int length = 0;
    if (dropdown != null)
      length = dropdown.length;
    return "LDropdown[${name}=${value} #${length}]";
  }

} // LDropdown
