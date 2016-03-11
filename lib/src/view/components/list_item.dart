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
 * Used in [LLookup], [LDropdown], [LPicklist] via [LLookupItem], [LDropdownItem]
 */
class ListItem
    extends SelectOption {

  /// A Href No Op
  static const String VOID = "javascript:void(0)";

  /// The List Item
  final LIElement element = new LIElement();
  /// The Link
  final AnchorElement a = new AnchorElement(href: "#");
  /// Reference
  Object reference = null;

  /**
   * List Item from Option (referenceId == href)
   */
  ListItem(DOption option, LIcon leftIcon, LIcon rightIcon, bool dropdown)
      : super(option) {
    element.append(a);
    this.id = option.id;
    if (option.hasValue())
      this.value = option.value;
    if (option.hasReferenceId())
      this.href = option.referenceId;
    if (option.isSelected)
      this.selected = true;
    if (!option.isActive)
      this.disabled = true;
    //
    if (option.hasIconImage()) {
      if (leftIcon == null && !dropdown) { // used for select
        leftIcon = LIcon.create(option.iconImage);
        leftIcon.classes.addAll([LIcon.C_ICON_TEXT_DEFAULT,
          LMargin.C_RIGHT__SMALL, LGrid.C_SHRINK_NONE]);
      } else if (rightIcon == null) {
        rightIcon = LIcon.create(option.iconImage);
      }
    }
    this.leftIcon = leftIcon;
    this.rightIcon = rightIcon; // rebuilds

    if (_rightIcon != null) {
      _rightIcon.classes.addAll([LIcon.C_ICON_TEXT_DEFAULT,
        LMargin.C_LEFT__SMALL, LGrid.C_SHRINK_NONE]);
    }
  } // ListItem

  /// Id
  void set id(String newValue) {
    super.id = newValue;
    if (newValue != null && newValue.isNotEmpty) {
      a.id = newValue;
      element.id = newValue + "-item";
    }
  }

  /// create id
  void createId(String idPrefix) {
    String id0 = LComponent.createId(idPrefix, value);
    id = LUtil.toVariableName(id0);
  }

  /// Label
  void set label(String newValue) {
    super.label = newValue;
    _rebuild(null);
  }

  /// Value
  void set value (String newValue) {
    super.value = newValue;
    a.attributes[Html0.DATA_VALUE] = newValue == null ? "" : newValue;
  }

  /// Href
  String get href => option.referenceId;
  /// Href only valid if link
  void set href (String newValue) {
    if (newValue == null || newValue.isEmpty) {
      option.clearReferenceId();
      element.attributes["href"] = "";
      a.href = VOID;
    } else {
      option.referenceId = newValue;
      element.attributes["href"] = newValue;
      a.href = newValue;
    }
  }

  /// Show/Hide option
  bool get show => !element.classes.contains(LVisibility.C_HIDE);
  void set show (bool newValue) {
    if (newValue)
      element.classes.remove(LVisibility.C_HIDE);
    else
      element.classes.add(LVisibility.C_HIDE);
  }

  /// Disabled
  void set disabled (bool newValue) {
    super.disabled = newValue;
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
  StreamSubscription<MouseEvent> _disabledClick;

  /// Selected
  void set selected(bool newValue) {
    super.selected = newValue;
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
    _rebuild(null); // selected icon
  }


  /// Right Icon (usually selected check)
  LIcon get rightIcon => _rightIcon;
  /// Right Icon
  void set rightIcon (LIcon rightIcon) {
    _rightIcon = rightIcon;
    if (rightIcon != null) {
      _rightIcon.size = LIcon.C_ICON__X_SMALL;
      _rightIcon.classes.addAll([LIcon.C_ICON, LDropdown.C_ICON__RIGHT]);
    }
    _rebuild(null);
  }
  LIcon _rightIcon;

  /// Left Icon
  LIcon get leftIcon => _leftIcon;
  /// Left Icon
  void set leftIcon (LIcon leftIcon) {
    _leftIcon = leftIcon;
    if (leftIcon != null) {
      _leftIcon.size = LIcon.C_ICON__X_SMALL;
      _leftIcon.classes.addAll([LIcon.C_ICON, LDropdown.C_ICON__LEFT]);
    }
    _rebuild(null);
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
  void _rebuild(RegExp exp) {
    a.children.clear();
    ParagraphElement p = null;
    // Icon left
    if (_leftIcon != null) {
      p = new ParagraphElement()
        ..classes.add(LText.C_TRUNCATE);
      a.append(p);
      p.append(_leftIcon.element);
    }
    // Label
    if (exp == null) {
      if (p == null) {
        a.appendText(option.label);
      } else {
        p.appendText(option.label);
      }
    } else {
      HtmlEscape esc = new HtmlEscape();
      String html = option.label.splitMapJoin(exp,
        onMatch:    (m) => "<b>${m.group(0)}</b>",
        onNonMatch: (n) => esc.convert(n));
      if (p == null) {
        a.appendHtml(html);
      } else {
        p.appendHtml(html);
      }
    }
    // Description
    String description = option.description;
    if (description != null && description.isNotEmpty) {
      Element descriptionElement = new Element.tag("small")
        ..classes.add("description");
      if (exp == null) {
        descriptionElement.text = description;
      } else {
        HtmlEscape esc = new HtmlEscape();
        String html = description.splitMapJoin(exp,
            onMatch:    (m) => "<b>${m.group(0)}</b>",
            onNonMatch: (n) => esc.convert(n));
        descriptionElement.appendHtml(html);
      }
      if (p == null) {
        a.append(descriptionElement);
      } else {
        p.append(descriptionElement);
      }
    }
    // Icon r
    if (_rightIcon != null) {
      a.append(_rightIcon.element);
    }
  } // rebuild

  /// return true if [exp] matches option label or description
  bool labelHighlight(RegExp exp) {
    if (option.label.contains(exp)) {
      _rebuild(exp);
      return true;
    } else if (option.description != null) {
      if (option.description.contains(exp)) {
        _rebuild(exp);
        return true;
      }
    }
    // no match
    _rebuild(null);
    return false;
  } // labelHighlight

  /// clear highlight
  void labelHighlightClear() {
    _rebuild(null);
  }

  /// Conversion to Option
  OptionElement asOption() {
    return new OptionElement(data:label, value:value, selected:selected)
      ..disabled = disabled
      ..selected = selected;
  }

  /// Conversion to Option
  DOption asDOption() {
    return OptionUtil.option(value, label,
      id:id, selected:selected, disabled:disabled);
  }

  /// Convert to Select Option
  SelectOption asSelectOption() {
    return new SelectOption(asDOption());
  }

  String toString() => "ListItem[${option.value}]";

} // ListItem
