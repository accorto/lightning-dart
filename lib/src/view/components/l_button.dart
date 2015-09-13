/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Buttons
 */
class LButton extends LComponent {

  /// slds-button - Initializes a 2.25 rem (36px) height button | Required
  static const String C_BUTTON = "slds-button";
  /// slds-button--small - Creates a smaller 2 rem (32px) button |
  static const String C_BUTTON__SMALL = "slds-button--small";
  /// slds-button--neutral - Creates the gray border with white background default style |
  static const String C_BUTTON__NEUTRAL = "slds-button--neutral";
  /// slds-button--brand - Creates the brand blue Salesforce style |
  static const String C_BUTTON__BRAND = "slds-button--brand";
  /// slds-button--inverse - Creates the inverse style for dark backgrounds |
  static const String C_BUTTON__INVERSE = "slds-button--inverse";
  /// slds-button--icon-bare - Creates a button that looks like a plain icon |
  static const String C_BUTTON__ICON_BARE = "slds-button--icon-bare";
  /// slds-button--icon-container - Creates a button that looks like a plain icon |
  static const String C_BUTTON__ICON_CONTAINER = "slds-button--icon-container";
  /// slds-button--icon-border - Creates an icon button with a border |
  static const String C_BUTTON__ICON_BORDER = "slds-button--icon-border";
  /// slds-button--icon-border-filled - Creates an icon button with a border |
  static const String C_BUTTON__ICON_BORDER_FILLED = "slds-button--icon-border-filled";
  /// slds-button--icon-small - Creates an icon button at the smaller 2 rem (32px) size |
  static const String C_BUTTON__ICON_SMALL = "slds-button--icon-small";
  /// slds-button--icon-more - Used for the style where only two icons are in a button |
  static const String C_BUTTON__ICON_MORE = "slds-button--icon-more";
  /// slds-button__icon - Sets the size and color of the icon inside a button |
  static const String C_BUTTON__ICON = "slds-button__icon";
  /// slds-button__icon--stateful - This makes the icon the same color as the text in the button |
  static const String C_BUTTON__ICON__STATEFUL = "slds-button__icon--stateful";
  /// slds-button__icon--left - Puts the icon on the left side of the button |
  static const String C_BUTTON__ICON__LEFT = "slds-button__icon--left";
  /// slds-button__icon--right - Puts the icon on the right side of the button |
  static const String C_BUTTON__ICON__RIGHT = "slds-button__icon--right";
  /// slds-button__icon--inverse - Gives a white icon color on a dark background |
  static const String C_BUTTON__ICON__INVERSE = "slds-button__icon--inverse";
  /// slds-button__icon--x-small - Creates a .5rem (8px) size icon |
  static const String C_BUTTON__ICON__X_SMALL = "slds-button__icon--x-small";
  /// slds-button__icon--small - Creates a .75rem (12px) size icon |
  static const String C_BUTTON__ICON__SMALL = "slds-button__icon--small";
  /// slds-button__icon--large - Creates a 1.5rem (24px) size icon |
  static const String C_BUTTON__ICON__LARGE = "slds-button__icon--large";
  /// slds-button__icon--hint - Creates a grayed out icon until the parent is hovered |
  static const String C_BUTTON__ICON__HINT = "slds-button__icon--hint";
  /// slds-button-space-left - adds space on the left of a button wrapped in a parent |
  static const String C_BUTTON_SPACE_LEFT = "slds-button-space-left";

  static const String C_BUTTON__ICON_BORDER_SMALL = "slds-button--icon-border-small";


  /// Hint
  static const String C_BUTTON__HINT = "slds-button--hint";
  /// Hint Wrapper
  static const String C_HINT_PARENT = "slds-hint-parent";

  static const String C_NOT_SELECTED = "slds-not-selected";
  static const String C_IS_SELECTED = "slds-is-selected";

  static const String C_CLOSE = "close";


  /// The Button / Link
  final Element element;
  /// Label
  Element _labelElement;
  /// The Label
  String _label;
  /// Optional Button Icon
  LIcon _icon;
  /// Icon left
  bool _iconLeft;
  /// true = button icon is 1rem gray - false = icon is 2rem white
  bool _iconButton = true;
  /// Optional Assistive Text Element
  SpanElement _assistive;
  /// Optional Assistive Text
  String _assistiveText;

  /**
   * Button with [name] and optional [label]
   * [element] can be a button, anchor, or input
   * if [idPrefix] is provided, the id will be idPrefix-name, if empty - the name
   */
  LButton(Element this.element, String name, String label, {String idPrefix,
      Element labelElement,
      List<String> buttonClasses,
      LIcon icon, bool iconLeft: false, String assistiveText}) {
    element.classes.add(C_BUTTON);
    if (element is ButtonElement) {
      (element as ButtonElement).name = name;
    } else if (element is InputElement) {
        (element as InputElement).name = name;
        (element as InputElement).value = label;
    } else {
      element.attributes[Html0.DATA_NAME] = name;
    }
    element.id = LComponent.createId(idPrefix, name);
    // classes
    if (buttonClasses != null) {
      element.classes.addAll(buttonClasses);
    }
    _label = label;
    _labelElement = labelElement;
    _icon = icon;
    _iconLeft = iconLeft;
    _assistiveText = assistiveText;
    _rebuild();
  } // LButton

  void _rebuild() {
    element.children.clear();
    if (_icon == null) {
      if (_labelElement != null)
        element.append(_labelElement);
      else if (_label != null)
        element.appendText(_label);
    } else {
      if (_iconButton) {
        _icon.classes.add(C_BUTTON__ICON); // 1rem gray
        _icon.classes.remove(LIcon.C_ICON); // 2rem white
      } else {
        _icon.classes.remove(C_BUTTON__ICON); // 1rem gray
        _icon.classes.add(LIcon.C_ICON); // 2rem white
      }
      _icon.classes.remove(C_BUTTON__ICON__LEFT);
      _icon.classes.remove(C_BUTTON__ICON__RIGHT);
      if (_label == null && _labelElement == null) {
        element.append(_icon.element);
      } else {
        if (_iconLeft) {
          if (_iconButton)
            _icon.classes.add(C_BUTTON__ICON__LEFT);
          element.append(_icon.element);
          if (_labelElement != null)
            element.append(_labelElement);
          else if (_label != null)
            element.appendText(_label);
        } else {
          if (_iconButton)
            _icon.classes.add(C_BUTTON__ICON__RIGHT);
          if (_labelElement != null)
            element.append(_labelElement);
          else if (_label != null)
            element.appendText(_label);
          element.append(_icon.element);
        }
      }
    }
    if (_assistiveText != null) {
      if (_assistive == null) {
        _assistive = new SpanElement()
          ..classes.add(LText.C_ASSISTIVE_TEXT);
        element.append(_assistive);
      }
      _assistive.text = _assistiveText;
    }
    /// Add More (down) icon
    if (element.classes.contains(C_BUTTON__ICON_MORE)) {
      element.setAttribute(Html0.ARIA_HASPOPUP, "true");
      LIcon more = new LIconUtility("down", className: C_BUTTON__ICON, size: C_BUTTON__ICON__X_SMALL);
      element.append(more.element);
    }
  } // rebuild

  /// Default Button
  LButton.base(String name, String label)
    : this(new ButtonElement(), name, label);

  /// Neutral Button
  LButton.neutral(String name, String label)
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL]);
  /// Neutral Anchor
  LButton.neutralAnchor(String name, String label, {String href})
    : this(new AnchorElement(href:(href == null ? "#" : href)), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL]);
  /// Neutral Input Button
  LButton.neutralInput(String name, String label)
    : this(new InputElement(type: "button"), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL]);

  /// Neutral Button with Icon
  LButton.neutralIcon(String name, String label, LIcon icon, {bool iconLeft: false})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL], icon:icon, iconLeft:iconLeft);

  /// (Neutral) Icon Button with More
  LButton.more(String name, String label, LIcon icon, String assistiveText)
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__ICON_MORE], icon:icon, assistiveText:assistiveText);

  /// Brand Button
  LButton.brand(String name, String label)
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__BRAND]);
  /// Neutral Button with Icon
  LButton.brandIcon(String name, String label, LIcon icon, {bool iconLeft: false})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__BRAND], icon:icon, iconLeft:iconLeft);
  /// Brand Button
  LButton.brandAnchor(String name, String label, {String href})
    : this(new AnchorElement(href: (href == null ? "#" : href)), name, label,
        buttonClasses: [C_BUTTON__BRAND]);

  /// Inverse Button
  LButton.inverse(String name, String label)
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__INVERSE]);


  /// Icon Only - bare
  LButton.iconBare(String name, LIcon icon, String assistiveText)
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BARE], assistiveText:assistiveText);
  /// Icon Only - container
  LButton.iconContainer(String name, LIcon icon, String assistiveText)
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_CONTAINER], assistiveText:assistiveText);
  /// Icon Only - border
  LButton.iconBorder(String name, LIcon icon, String assistiveText)
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BORDER], assistiveText:assistiveText);
  /// Icon Only - border filled
  LButton.iconBorderFilled(String name, LIcon icon, String assistiveText)
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BORDER_FILLED], assistiveText:assistiveText);

  /// Icon Only - border filled
  LButton.iconBorderFilledAnchor(String name, LIcon icon, String assistiveText, {String href})
    : this(new AnchorElement(href: (href == null ? "#" : href)), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BORDER_FILLED], assistiveText:assistiveText);


  /// Button id
  String get id => element.id;
  /// Button name
  String get name {
    if (element is ButtonElement)
      return (element as ButtonElement).name;
    else if (element is InputElement)
      return (element as InputElement).name;
    return element.attributes[Html0.DATA_NAME];
  }

  /// Button Type (null for link)
  String get type {
    if (element is ButtonElement)
      return (element as ButtonElement).type;
    else if (element is InputElement)
      return (element as InputElement).type;
    return null;
  }
  /// Button Type (button|submit|reset) - ignored if link
  void set type (String type) {
    if (element is ButtonElement)
      (element as ButtonElement).type = type;
    else if (element is InputElement)
      (element as InputElement).type = type;
  }
  bool get typeButton => type == "button";
  void set typeButton (bool newValue) {
    type = "button"; // regardless
  }
  bool get typeSubmit => type == "submit";
  void set typeSubmit (bool newValue) {
    type = newValue ? "submit" : "button";
  }
  bool get typeReset => type == "reset";
  void set typeReset (bool newValue) {
    type = newValue ? "reset" : "button";
  }



  /// Button Label
  String get label {
    if (_labelElement != null) {
      return _labelElement.text;
    }
    return _label;
  }
  /// Button Label
  void set label (String newValue) {
    if (_labelElement != null) {
      _labelElement.text = newValue;
    } else {
      _label = newValue;
    }
    _rebuild();
  }
  /// Button icon
  LIcon get icon => _icon;
  /// Button icon
  void set icon (LIcon newValue) {
    _icon = newValue;
    _rebuild();
  }

  /// Assistive Text
  String get assistiveText => _assistiveText;
  /// Add/Set Assistive Text
  void set assistiveText (String newValue) {
    _assistiveText = newValue;
    _rebuild();
  }

  /// title
  String get title => element.title;
  /// title
  void set title (String newValue) {
    element.title = newValue;
  }

  /// Button Size
  bool get small => element.classes.contains(C_BUTTON__SMALL);
  /// Button Size
  void set small (bool newValue) {
    if (newValue) {
      element.classes.add(C_BUTTON__SMALL);
    } else {
      element.classes.remove(C_BUTTON__SMALL);
    }
  }

  /// button icon is 1rem gray (default) - icon is 2rem white
  void set iconButton (bool newValue) {
    _iconButton = newValue;
    _rebuild();
  }

  /// Set Icon Size e.g. C_BUTTON__ICON__X_SMALL
  void set iconSize(String newValue) {
    if (_icon != null)
      _icon.classes.add(newValue);
  }
  /// Icon Size
  void iconSizeXSmall() {
    iconSize = C_BUTTON__ICON__X_SMALL;
  }
  /// Icon Size
  void iconSizeSmall() {
    iconSize = C_BUTTON__ICON__SMALL;
  }
  /// Icon Size
  void iconSizeLarge() {
    iconSize = C_BUTTON__ICON__LARGE;
  }
  /// Icon Inverse
  void iconInverse() {
    _icon.classes.add(C_BUTTON__ICON__INVERSE);
  }

  /// Set Selected State
  void set state (bool selected) {
    if (selected) {
      element.classes.add(C_IS_SELECTED);
      element.classes.remove(C_NOT_SELECTED);
    } else {
      element.classes.add(C_IS_SELECTED);
      element.classes.remove(C_NOT_SELECTED);
    }
  }

  /**
   * Hint Button wrapper - grayed out until hovered over
   * Returns div hint container with button appended
   */
  DivElement hintParent() {
    DivElement div = new DivElement()
      ..classes.add(C_HINT_PARENT);
    div.append(element);
    hint = true;
    return div;
  }

  /// Hint button
  bool get hint => _icon != null && _icon.classes.contains(C_BUTTON__ICON__HINT);
    /// Set Hint (needs to be in hint-parent)
  void set hint(bool newValue) {
    if (_icon != null) {
      if (newValue)
        _icon.classes.add(C_BUTTON__ICON__HINT);
      else
        _icon.classes.remove(C_BUTTON__ICON__HINT);
    }
  }

  /// disabled
  bool get disabled {
    if (element is ButtonElement)
      return (element as ButtonElement).disabled;
    if (element is InputElement)
      return (element as InputElement).disabled;
    return Html0.DISABLED == element.attributes[Html0.DISABLED];
  }
  /// disabled
  void set disabled(bool newValue) {
    if (element is ButtonElement) {
      (element as ButtonElement).disabled = newValue;
    }
    else if (element is InputElement) {
      (element as InputElement).disabled = newValue;
    }
    else if (newValue) {
      element.attributes[Html0.ARIA_DISABLED] = "true";
      element.attributes[Html0.DISABLED] = Html0.DISABLED;
      if (_disabledClick == null) {
        _disabledClick = element.onClick.listen((MouseEvent evt) {
          evt.preventDefault();
          evt.stopImmediatePropagation();
        });
      }
    } else {
      element.attributes.remove(Html0.DISABLED);
      if (_disabledClick != null) {
        _disabledClick.cancel();
      }
      _disabledClick = null;
    }
  }
  StreamSubscription<MouseEvent> _disabledClick;

  /// Button Click
  ElementStream<MouseEvent> get onClick => element.onClick;


  /// As List Item
  DOption asDOption() {
    DOption option = new DOption();
    String theId = id;
    if (theId != null && theId.isNotEmpty)
      option.id = theId;
    String theName = name;
    if (theName != null && theName.isNotEmpty)
      option.value = name;
    String theLabel = label;
    if (theLabel != null && theLabel.isNotEmpty)
      option.label = theLabel;
    if (disabled)
      option.isActive = false;
    // no selected (otherwise button group overflow will not work)
    return option;
  } // asListItem

  /// As List Item
  ListItem asListItem({bool iconLeft:true}) {
    DOption option = asDOption();
    if (icon != null) {
      if (iconLeft)
        return new ListItem(option, leftIcon: icon.copy());
      return new ListItem(option, rightIcon: icon.copy());
    }
    return new ListItem(option);
  } // asListItem

} // LButton


/**
 * (Toggle) Button with multiple states
 * TODO: same API as Checkbox
 */
class LButtonStateful extends LComponent {

  static final Logger _log = new Logger("LButtonStateful");

  /// The Button
  final ButtonElement element = new ButtonElement()
    ..classes.add(LButton.C_BUTTON);

  final List<LButtonStatefulState> states = new List<LButtonStatefulState>();

  /**
   * Toggle Button with [name] (default Follow)
   * if [onButtonClick] is provided, it will be called after state change
   */
  LButtonStateful(String name, {String idPrefix,
      String textNotSelected: "Follow",
      String textSelected: "Following",
      String textSelectedFocus: "Unfollow",
      void onButtonClick(MouseEvent evt)}) {
    element.name = name;
    element.id = LComponent.createId(idPrefix, name);

    element.classes.add(LButton.C_BUTTON__NEUTRAL);
    element.classes.add(LButton.C_NOT_SELECTED);
    element.setAttribute(Html0.ARIA_LIVE, Html0.ARIA_LIVE_ASSERTIVE);
    //
    addState(new LButtonStatefulState(new LIconUtility(LIconUtility.ADD), textNotSelected, LText.C_TEXT_NOT_SELECTED));
    addState(new LButtonStatefulState(new LIconUtility(LIconUtility.CHECK), textSelected, LText.C_TEXT_SELECTED));
    addState(new LButtonStatefulState(new LIconUtility(LIconUtility.CLOSE), textSelectedFocus, LText.C_TEXT_SELECTED_FOCUS));

    element.onClick.listen((MouseEvent evt){
      bool newState = toggle();
      _log.fine("${name} selected=${newState}");
      if (onButtonClick != null)
        onButtonClick(evt);
    });
  } // LButtonStateful

  /// Button name
  String get name => element.name;
  /// Button id
  String get id => element.id;

  /// add State
  void addState(LButtonStatefulState state) {
    state.icon.classes.clear();
    state.icon.classes.addAll([LButton.C_BUTTON__ICON__STATEFUL, LButton.C_BUTTON__ICON__LEFT]);
    states.add(state);
    element.append(state.element);
  }

  /// Selected
  bool get selected {
    return element.classes.contains(LButton.C_IS_SELECTED);
  }
  /// Selected
  void set selected(bool newValue) {
    if (newValue) {
      element.classes.remove(LButton.C_NOT_SELECTED);
      element.classes.add(LButton.C_IS_SELECTED);
    } else {
      element.classes.add(LButton.C_NOT_SELECTED);
      element.classes.remove(LButton.C_IS_SELECTED);
    }
  } // set selected
  /// toggle state - return new state
  bool toggle() {
    bool newState = !selected;
    selected = newState;
    return newState;
  }


  bool get disabled => element.disabled;
  void set disabled(bool newValue) {
    element.disabled = newValue;
  }

} // LButtonStateful

/// Button State
class LButtonStatefulState {

  final SpanElement element = new SpanElement();
  final LIcon icon;

  /// Button State
  LButtonStatefulState(LIcon this.icon, String text, String spanClass) {
    element.classes.add(spanClass);
    element.append(icon.element);
    element.appendText(text);
  }

} // LButtonStatefulState


/**
 * Stateful Button Icon
 * TODO: Same API as Checkbox
 */
class LButtonIconStateful extends LComponent {

  static final Logger _log = new Logger("LButtonIconStateful");


  final ButtonElement element = new ButtonElement()
    ..classes.addAll([LButton.C_BUTTON, LButton.C_BUTTON__ICON_BORDER]);

  final SpanElement _span = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT);

  /**
   * Stateful Icon
   */
  LButtonIconStateful(String name, String assistiveText, LIcon icon, {String idPrefix,
      void onButtonClick(MouseEvent evt)}) {
    icon.classes.clear();
    icon.classes.add(LButton.C_BUTTON__ICON);
    element.append(icon.element);
    //
    if (assistiveText != null)
      _span.text = assistiveText;
    element.append(_span);
    //
    element.onClick.listen((MouseEvent evt){
      bool newState = toggle();
      _log.fine("${name} selected=${newState}");
      if (onButtonClick != null)
        onButtonClick(evt);
    });
    selected = false;
  } // LButtonIconStateful


  bool get selected => element.classes.contains(LButton.C_IS_SELECTED);
  /// Selected
  void set selected(bool newValue) {
    if (newValue) {
      element.classes.remove(LButton.C_NOT_SELECTED);
      element.classes.add(LButton.C_IS_SELECTED);
    } else {
      element.classes.add(LButton.C_NOT_SELECTED);
      element.classes.remove(LButton.C_IS_SELECTED);
    }
  } // set selected
  /// toggle state - return new state
  bool toggle() {
    bool newState = !selected;
    selected = newState;
    return newState;
  }


  bool get disabled => element.disabled;
  void set disabled(bool newValue) {
    element.disabled = newValue;
  }


} // LButtonIconStateful
