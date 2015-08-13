/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * List Item
 * li
 * - a
 * -- icon / text / icon
 */
class ListItem {

  /// The List Item
  final LIElement element = new LIElement();
  /// The Link
  final AnchorElement a = new AnchorElement();

  /**
   * Create List Item
   */
  ListItem({String id, String label, String href, LIcon leftIcon, LIcon rightIcon}) {
    element.append(a);
    if (id != null)
      this.id = id;
    _label = label;
    this.href = href;
    this.leftIcon = leftIcon;
    this.rightIcon = rightIcon;
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
    if (newValue == null || newValue.isEmpty) {
      element.attributes["href"] = "#";
      a.href = "#";
    } else {
      element.attributes["href"] = newValue;
      a.href = newValue;
    }
  }

  /// Disabled
  bool get disabled => _disabled;
  void set disabled (bool newValue) {
    _disabled = newValue;
    if (newValue) {
      element.attributes[Html0.A_DISABLED] = "";
      a.attributes[Html0.A_DISABLED] = "";
      a.attributes[Html0.A_ARIA_DISABLED] = "true";
    } else {
      element.attributes.remove(Html0.A_DISABLED);
      a.attributes.remove(Html0.A_DISABLED);
      a.attributes.remove(Html0.A_ARIA_DISABLED);
    }
  }
  bool _disabled = false;

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

  /// Right Icon
  LIcon get rightIcon => _rightIcon;
  /// Right Icon
  void set rightIcon (LIcon rightIcon) {
    _rightIcon = rightIcon;
    if (rightIcon != null) {
      _rightIcon.size = LIcon.C_ICON__SMALL;
      _rightIcon.classes.add(LDropdown.C_ICON__RIGHT);
    }
    // hasIconRight = rightIcon != null;
    _rebuildLink();
  }
  LIcon _rightIcon;

  /// Left Icon
  LIcon get leftIcon => _rightIcon;
  /// Left Icon
  void set leftIcon (LIcon leftIcon) {
    _leftIcon = leftIcon;
    if (leftIcon != null) {
      _leftIcon.size = LIcon.C_ICON__SMALL;
      _leftIcon.classes.add(LDropdown.C_ICON__LEFT);
    }
    hasIconLeft = leftIcon != null;
    _rebuildLink();
  }
  LIcon _leftIcon;

  /// Rebuild Link
  void _rebuildLink() {
    a.children.clear();
    if (_leftIcon == null) {
      a.append(_leftIcon.element);
    }
    a.appendText(_label);
    if (_rightIcon != null) {
      a.append(_rightIcon.element);
    }
  } // rebuildLink

} // ListItem
