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
 * (see LLookupItem, LDropdownItem)
 */
class ListItem implements SelectOptionI {

  /// A Href No Op
  static const String VOID = "javascript:void(0)";

  /// The List Item
  final LIElement element = new LIElement();
  /// The Link
  final AnchorElement a = new AnchorElement(href: "#");

  /**
   * Create List Item - if [href] is null, a span element is used
   */
  ListItem({String id, String label, String value, String href,
      LIcon leftIcon, LIcon rightIcon, bool selected, bool disabled}) {
    element.append(a);
    this.id = id;
    _label = label;
    this.value = value;
    this.href = href;
    this.leftIcon = leftIcon;
    this.rightIcon = rightIcon; // rebuilds
    if (selected != null)
      this.selected = selected;
    if (disabled != null)
      this.disabled = disabled;
  }

  /// Id
  String get id => a.id;
  void set id(String newValue) {
    if (newValue != null) {
      a.id = newValue;
      element.id = newValue + "-item";
    }
  }

  /// Label
  String get label => _label;
  void set label(String newValue) {
    _label = newValue;
    _rebuild();
  }
  String _label;

  /// Value
  String get value => a.attributes[Html0.DATA_VALUE];
  void set value (String newValue) {
    a.attributes[Html0.DATA_VALUE] = newValue == null ? "" : newValue;
  }

  /// Href
  String get href => _href;
  /// Href only valid if link
  void set href (String newValue) {
    _href = newValue;
    if (newValue == null || newValue.isEmpty) {
      element.attributes["href"] = "";
      a.href = VOID;
    } else {
      element.attributes["href"] = newValue;
      a.href = newValue;
    }
  }
  String _href = null;

  /// Disabled
  bool get disabled => _disabled;
  void set disabled (bool newValue) {
    _disabled = newValue;
    if (newValue) {
      element.attributes[Html0.DISABLED] = Html0.DISABLED;
      a.attributes[Html0.ARIA_DISABLED] = "true";
      a.attributes[Html0.DISABLED] = Html0.DISABLED;
      if (_disabledClick == null) {
        _disabledClick = a.onClick.listen((MouseEvent evt) {
          evt.preventDefault();
          evt.stopImmediatePropagation();
        });
      }
    } else {
      element.attributes.remove(Html0.DISABLED);
      a.attributes.remove(Html0.ARIA_DISABLED);
      a.attributes.remove(Html0.DISABLED);
      if (_disabledClick != null) {
        _disabledClick.cancel();
      }
      _disabledClick = null;
    }
  }
  bool _disabled = false;
  StreamSubscription<MouseEvent> _disabledClick;

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
    if (newValue) {
      element.classes.add(LDropdown.C_IS_SELECTED);
      element.tabIndex = 0;
      a.tabIndex = 0;
    } else {
      element.classes.remove(LDropdown.C_IS_SELECTED);
      element.tabIndex = -1;
      a.tabIndex = -1;
    }
    element.attributes[Html0.ARIA_SELECTED] = newValue.toString();
    _rebuild(); // selected icon
  }
  bool _selected;

  /// Right Icon (usually selected check)
  LIcon get rightIcon => _rightIcon;
  /// Right Icon
  void set rightIcon (LIcon rightIcon) {
    _rightIcon = rightIcon;
    if (rightIcon != null) {
      _rightIcon.size = LIcon.C_ICON__SMALL;
      _rightIcon.classes.addAll([LIcon.C_ICON, LDropdown.C_ICON__RIGHT]);
    }
    // hasIconRight = rightIcon != null;
    _rebuild();
  }
  LIcon _rightIcon;

  /// Left Icon
  LIcon get leftIcon => _leftIcon;
  /// Left Icon
  void set leftIcon (LIcon leftIcon) {
    _leftIcon = leftIcon;
    if (leftIcon != null) {
      _leftIcon.size = LIcon.C_ICON__SMALL;
      _leftIcon.classes.addAll([LIcon.C_ICON, LDropdown.C_ICON__LEFT]);
    }
    hasIconLeft = leftIcon != null;
    _rebuild();
  }
  LIcon _leftIcon;

  /// left or right icon
  LIcon get icon {
    if (_leftIcon != null)
      return _leftIcon;
    if (_rightIcon != null)
      return _rightIcon;
    return null;
  }

  /// Rebuild Link
  void _rebuild() {
    a.children.clear();
    if (_leftIcon != null) {
      a.append(_leftIcon.element);
    }
    a.appendText(_label);
    if (_rightIcon != null) {
      a.append(_rightIcon.element);
    }
  } // rebuild


  bool get hide => element.classes.contains(LVisibility.C_HIDE);
  void set hide (bool newValue) {
    if (newValue)
      element.classes.add(LVisibility.C_HIDE);
    else
      element.classes.remove(LVisibility.C_HIDE);
  }

  /// return true if [exp] matches [label]
  bool labelHighlight(RegExp exp) {
    if (_label.contains(exp)) {
    /*  if (_heading != null) {
        String html = _labelText.splitMapJoin((exp),
        onMatch:    (m) => "<ins>${m.group(0)}</ins>",
        onNonMatch: (n) => n);
        _heading.innerHtml = html;
      } else {
        String html = _labelText.splitMapJoin((exp),
        onMatch:    (m) => "<b>${m.group(0)}</b>",
        onNonMatch: (n) => n);
        if (_label != null)
          _label.innerHtml = html;
        else
          li.innerHtml = html;
      }
      _highlighted = true; */
      return true;
    } else { // no match
    /*  if (_heading != null)
        _heading.text = _labelText;
      else if (_label != null)
        _label.text = _labelText;
      else
        li.text = _labelText; */
      return false;
    }
  } // labelHighlight

  /// return true if [exp] matches [descriptionl]
  bool descriptionHighlight(RegExp exp) {
  //  if (_description == null)
      return false;
  /*  if (_descriptionText.contains(exp)) {
      String html = _descriptionText.splitMapJoin((exp),
      onMatch:    (m) => "<b>${m.group(0)}</b>",
      onNonMatch: (n) => n);
      _description.innerHtml = html;
      _highlighted = true;
      return true;
    } else {
      _description.text = _descriptionText;
      return false;
    } */
  } // descriptionHighlight

  /// Conversion to Option
  OptionElement toOption() {
    return new OptionElement(data:label, value:value, selected:selected)
      ..disabled = disabled
      ..selected = selected;
  }

} // ListItem
