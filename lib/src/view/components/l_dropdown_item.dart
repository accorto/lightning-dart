/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Dropdown Item
 */
class LDropdownItem extends ListItem {

  /// Dropdown
  static LDropdownItem create({String value, String label, LIcon icon}) {
    DOption option = OptionUtil.option(value, label);
    return new LDropdownItem(option, rightIcon:icon);
  }

  /**
   * Dropdown item [leftIcon] is used for selection
   */
  LDropdownItem(DOption option, {LIcon leftIcon, LIcon rightIcon})
    : super(option, leftIcon:leftIcon, rightIcon:rightIcon) {

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
    : this(item.option, leftIcon:item.leftIcon, rightIcon:item.rightIcon);

  /// create drop-down from button - with left icon!
  LDropdownItem.fromButton(LButton button)
    : this(button.asDOption(),
      rightIcon:button.icon == null ? null : button.icon.copy());

  /// Lookup Item from Option
  LDropdownItem.fromOption(OptionElement option)
    : this(OptionUtil.optionFromElement(option));

  /// Lookup Item from SelectOption
  LDropdownItem.fromSelectOption(SelectOption option)
    : this(option.option);

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
  void _rebuild(RegExp exp) {
    if (option.hasIsSelected()) {
      if (option.isSelected) {
        if (_selectedIcon == null) {
          _selectedIcon = new LIconStandard(LIconStandard.TASK2, size: LIcon.C_ICON__SMALL)
            ..classes.add(LDropdown.C_ICON__LEFT);
        }
        _leftIcon = _selectedIcon;
      } else {
        _leftIcon = null; // overwrite in selection mode
      }
    }
    super._rebuild(exp);
  }
  LIcon _selectedIcon;

  /// Right Icon (left icon used for select)
  LIcon get icon => _rightIcon;


  String toString() => "LDropdown[${option.value}]";

} // LDropdownItem
