/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Buttons
 */
class LButton
    extends LComponent {

  /// slds-button (button or link): Initializes a 2.25rem (36px) height button - This neutralizes all the base styles making it look like a text link
  static const String C_BUTTON = "slds-button";
  /// slds-button--small (slds-button): Creates a smaller 2rem (32px) button
  static const String C_BUTTON__SMALL = "slds-button--small";
  /// slds-button--neutral (slds-button): Creates the gray border with white background default style
  static const String C_BUTTON__NEUTRAL = "slds-button--neutral";
  /// slds-button--brand (slds-button): Creates the brand blue Salesforce style
  static const String C_BUTTON__BRAND = "slds-button--brand";
  /// slds-button--destructive (slds-button): Creates a red button style - The use case for this button is things like delete, cancel, and end call rather than errors.
  static const String C_BUTTON__DESTRUCTIVE = "slds-button--destructive";
  /// slds-button--inverse (slds-button): Creates the inverse style for dark backgrounds
  static const String C_BUTTON__INVERSE = "slds-button--inverse";
  /// slds-button--icon-bare (slds-button): Creates a button that looks like a plain icon - This is 1rem×1rem like an icon, not a regular button
  static const String C_BUTTON__ICON_BARE = "slds-button--icon-bare";
  /// slds-button--icon-container (slds-button): Creates a button that looks like a plain icon - This is 2.25rem×2.25rem like a button
  static const String C_BUTTON__ICON_CONTAINER = "slds-button--icon-container";
  /// slds-button--icon-border (slds-button): Creates an icon button with a border - There is no background color until hover for this style
  static const String C_BUTTON__ICON_BORDER = "slds-button--icon-border";
  /// slds-button--icon-border-filled (slds-button): Creates an icon button with a border - This is 2.25rem×2.25rem like a button
  static const String C_BUTTON__ICON_BORDER_FILLED = "slds-button--icon-border-filled";
  /// slds-button--icon-inverse (slds-button): Gives a white icon color on a dark background - When used alone it has a subtle hover. When used in a button-group it assumes the hover state of the buttons next to it.
  static const String C_BUTTON__ICON_INVERSE = "slds-button--icon-inverse";
  /// slds-button--icon-small (slds-button): Creates an icon button at the smaller 2rem (32px) size - Be aware that this sizes the button, not the icon
  static const String C_BUTTON__ICON_SMALL = "slds-button--icon-small";
  /// slds-button--icon-x-small (slds-button): Creates an icon button at the smaller 1.25rem (20px) size - Be aware that this sizes the button, not the icon
  static const String C_BUTTON__ICON_X_SMALL = "slds-button--icon-x-small";
  /// slds-button--icon-more (slds-button): Used for the style where only two icons are in a button - This is usually an icon with a down arrow icon next to it. Each svg within is sized separately
  static const String C_BUTTON__ICON_MORE = "slds-button--icon-more";
  /// slds-x-small-button--stacked (slds-button): Stacking buttons with spacing for at least x-small breakpoint.
  static const String C_X_SMALL_BUTTON__STACKED = "slds-x-small-button--stacked";
  /// slds-small-button--stacked (slds-button): Stacking buttons with spacing for at least small breakpoint.
  static const String C_SMALL_BUTTON__STACKED = "slds-small-button--stacked";
  /// slds-medium-button--stacked (slds-button): Stacking buttons with spacing for at least medium breakpoint.
  static const String C_MEDIUM_BUTTON__STACKED = "slds-medium-button--stacked";
  /// slds-large-button--stacked (slds-button): Stacking buttons with spacing for at least large breakpoint.
  static const String C_LARGE_BUTTON__STACKED = "slds-large-button--stacked";
  /// slds-x-small-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at least x-small breakpoint.
  static const String C_X_SMALL_BUTTONS__STACKED = "slds-x-small-buttons--stacked";
  /// slds-small-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at least small breakpoint.
  static const String C_SMALL_BUTTONS__STACKED = "slds-small-buttons--stacked";
  /// slds-medium-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at least medium breakpoint.
  static const String C_MEDIUM_BUTTONS__STACKED = "slds-medium-buttons--stacked";
  /// slds-large-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at least large breakpoint.
  static const String C_LARGE_BUTTONS__STACKED = "slds-large-buttons--stacked";
  /// slds-max-x-small-button--stacked (slds-button): Stacking buttons with spacing for at most x-small breakpoint.
  static const String C_MAX_X_SMALL_BUTTON__STACKED = "slds-max-x-small-button--stacked";
  /// slds-max-small-button--stacked (slds-button): Stacking buttons with spacing for at most small breakpoint.
  static const String C_MAX_SMALL_BUTTON__STACKED = "slds-max-small-button--stacked";
  /// slds-max-medium-button--stacked (slds-button): Stacking buttons with spacing for at most medium breakpoint.
  static const String C_MAX_MEDIUM_BUTTON__STACKED = "slds-max-medium-button--stacked";
  /// slds-max-large-button--stacked (slds-button): Stacking buttons with spacing for at most large breakpoint.
  static const String C_MAX_LARGE_BUTTON__STACKED = "slds-max-large-button--stacked";
  /// slds-max-x-small-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at most x-small breakpoint.
  static const String C_MAX_X_SMALL_BUTTONS__STACKED = "slds-max-x-small-buttons--stacked";
  /// slds-max-small-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at most small breakpoint.
  static const String C_MAX_SMALL_BUTTONS__STACKED = "slds-max-small-buttons--stacked";
  /// slds-max-medium-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at most medium breakpoint.
  static const String C_MAX_MEDIUM_BUTTONS__STACKED = "slds-max-medium-buttons--stacked";
  /// slds-max-large-buttons--stacked (parent of .slds-button): Stacking buttons inside of this class with spacing for at most large breakpoint.
  static const String C_MAX_LARGE_BUTTONS__STACKED = "slds-max-large-buttons--stacked";
  /// slds-x-small-button--horizontal (slds-button): Giving horizontal buttons spacing for at least x-small breakpoint.
  static const String C_X_SMALL_BUTTON__HORIZONTAL = "slds-x-small-button--horizontal";
  /// slds-small-button--horizontal (slds-button): Giving horizontal buttons spacing for at least small breakpoint.
  static const String C_SMALL_BUTTON__HORIZONTAL = "slds-small-button--horizontal";
  /// slds-medium-button--horizontal (slds-button): Giving horizontal buttons spacing for at least medium breakpoint.
  static const String C_MEDIUM_BUTTON__HORIZONTAL = "slds-medium-button--horizontal";
  /// slds-large-button--horizontal (slds-button): Giving horizontal buttons spacing for at least large breakpoint.
  static const String C_LARGE_BUTTON__HORIZONTAL = "slds-large-button--horizontal";
  /// slds-x-small-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at least x-small breakpoint.
  static const String C_X_SMALL_BUTTONS__HORIZONTAL = "slds-x-small-buttons--horizontal";
  /// slds-small-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at least small breakpoint.
  static const String C_SMALL_BUTTONS__HORIZONTAL = "slds-small-buttons--horizontal";
  /// slds-medium-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at least medium breakpoint.
  static const String C_MEDIUM_BUTTONS__HORIZONTAL = "slds-medium-buttons--horizontal";
  /// slds-large-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at least large breakpoint.
  static const String C_LARGE_BUTTONS__HORIZONTAL = "slds-large-buttons--horizontal";
  /// slds-max-x-small-button--horizontal (slds-button): Giving horizontal buttons spacing for at most x-small breakpoint.
  static const String C_MAX_X_SMALL_BUTTON__HORIZONTAL = "slds-max-x-small-button--horizontal";
  /// slds-max-small-button--horizontal (slds-button): Giving horizontal buttons spacing for at most small breakpoint.
  static const String C_MAX_SMALL_BUTTON__HORIZONTAL = "slds-max-small-button--horizontal";
  /// slds-max-medium-button--horizontal (slds-button): Giving horizontal buttons spacing for at most medium breakpoint.
  static const String C_MAX_MEDIUM_BUTTON__HORIZONTAL = "slds-max-medium-button--horizontal";
  /// slds-max-large-button--horizontal (slds-button): Giving horizontal buttons spacing for at most large breakpoint.
  static const String C_MAX_LARGE_BUTTON__HORIZONTAL = "slds-max-large-button--horizontal";
  /// slds-max-x-small-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at most x-small breakpoint.
  static const String C_MAX_X_SMALL_BUTTONS__HORIZONTAL = "slds-max-x-small-buttons--horizontal";
  /// slds-max-small-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at most small breakpoint.
  static const String C_MAX_SMALL_BUTTONS__HORIZONTAL = "slds-max-small-buttons--horizontal";
  /// slds-max-medium-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at most medium breakpoint.
  static const String C_MAX_MEDIUM_BUTTONS__HORIZONTAL = "slds-max-medium-buttons--horizontal";
  /// slds-max-large-buttons--horizontal (parent of .slds-button): Giving horizontal buttons inside of this class spacing for at most large breakpoint.
  static const String C_MAX_LARGE_BUTTONS__HORIZONTAL = "slds-max-large-buttons--horizontal";
  /// slds-max-small-button--stretch (slds-button): Stretches buttons a full 100% width for small form factors
  static const String C_MAX_SMALL_BUTTON__STRETCH = "slds-max-small-button--stretch";
  /// slds-max-small-buttons--stretch (div or whatever parent is holding the buttons.): A parent container that stretches buttons within it to 100% width.
  static const String C_MAX_SMALL_BUTTONS__STRETCH = "slds-max-small-buttons--stretch";
  /// slds-button__icon (svg): Sets the size and color of the icon inside a button
  static const String C_BUTTON__ICON = "slds-button__icon";
  /// slds-button__icon--stateful (svg): This makes the icon the same color as the text in the button - This is not used in addition to .slds-button__icon but instead of
  static const String C_BUTTON__ICON__STATEFUL = "slds-button__icon--stateful";
  /// slds-button__icon--left (slds-button__icon): Puts the icon on the left side of the button
  static const String C_BUTTON__ICON__LEFT = "slds-button__icon--left";
  /// slds-button__icon--right (slds-button__icon): Puts the icon on the right side of the button
  static const String C_BUTTON__ICON__RIGHT = "slds-button__icon--right";
  /// slds-button__icon--x-small (slds-button__icon): Creates a .5rem (8px) size icon - This is added to the icon inside the .slds-button, not the button itself
  static const String C_BUTTON__ICON__X_SMALL = "slds-button__icon--x-small";
  /// slds-button__icon--small (slds-button__icon): Creates a .75rem (12px) size icon
  static const String C_BUTTON__ICON__SMALL = "slds-button__icon--small";
  /// slds-button__icon--large (slds-button__icon): Creates a 1.5rem (24px) size icon
  static const String C_BUTTON__ICON__LARGE = "slds-button__icon--large";
  /// slds-button__icon--hint (slds-button__icon): Creates a grayed out icon until the parent is hovered - The parent must have the .slds-hint-parent class applied
  static const String C_BUTTON__ICON__HINT = "slds-button__icon--hint";
  /// slds-button-space-left (button parent): Adds space on the left of a button wrapped in a parent - Only required if the .slds-button is wrapped. ie- to include a dropdown
  static const String C_BUTTON_SPACE_LEFT = "slds-button-space-left";


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
  bool _iconLeft = false;
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
  LButton(Element this.element,
      String name,
      String label,
      {String idPrefix,
      Element labelElement,
      List<String> buttonClasses,
      LIcon icon,
      bool iconLeft: false,
      String assistiveText}) {
    element.classes.add(C_BUTTON);
    if (element is ButtonElement) {
      (element as ButtonElement).name = name;
    } else if (element is InputElement) {
        (element as InputElement).name = name;
        (element as InputElement).value = label;
    } else { // anchor
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
    //
    _assistiveText = assistiveText;
    if (assistiveText != null && assistiveText.isNotEmpty) {
      element.title = assistiveText;
    }
    typeButton = true; // default = submit
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
  LButton.base(String name, String label, {String idPrefix})
    : this(new ButtonElement(), name, label, idPrefix:idPrefix);

  /// Neutral Button
  LButton.neutral(String name, String label, {String idPrefix})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL], idPrefix:idPrefix);
  /// Neutral Anchor
  LButton.neutralAnchor(String name, String label,
      {String href, String target:"_blank", String idPrefix})
    : this(new AnchorElement(href:(href == null ? "#" : href)) ..target = target,
        name, label,
        buttonClasses: [C_BUTTON__NEUTRAL], idPrefix:idPrefix);
  /// Neutral Input Button
  LButton.neutralInput(String name, String label, {String idPrefix})
    : this(new InputElement(type: "button"), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL], idPrefix:idPrefix);

  /// Neutral Button with Icon
  LButton.neutralIcon(String name, String label, LIcon icon,
      {bool iconLeft: false, String idPrefix})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL], icon:icon, iconLeft:iconLeft, idPrefix:idPrefix);
  /// Neutral Anchor
  LButton.neutralAnchorIcon(String name, String label, LIcon icon,
      {String href, String target:"_blank", bool iconLeft: false, String idPrefix})
    : this(new AnchorElement(href:(href == null ? "#" : href)) ..target = target,
        name, label,
        buttonClasses: [C_BUTTON__NEUTRAL], icon:icon, iconLeft:iconLeft, idPrefix:idPrefix);

  /// (Neutral) Icon Button with More
  LButton.more(String name, String label, LIcon icon, String assistiveText, {String idPrefix})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__ICON_MORE], icon:icon, assistiveText:assistiveText, idPrefix:idPrefix);

  /// Brand Button
  LButton.brand(String name, String label, {String idPrefix})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__BRAND], idPrefix:idPrefix);
  /// Brand Button with Icon
  LButton.brandIcon(String name, String label, LIcon icon, {bool iconLeft: false, String idPrefix})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__BRAND], icon:icon, iconLeft:iconLeft, idPrefix:idPrefix);
  /// Brand Button
  LButton.brandAnchor(String name, String label,
      {String href, String target:"_blank", String idPrefix})
    : this(new AnchorElement(href: (href == null ? "#" : href)) ..target = target,
        name, label,
        buttonClasses: [C_BUTTON__BRAND], idPrefix:idPrefix);

  /// Inverse Button
  LButton.inverse(String name, String label, {String idPrefix})
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__INVERSE], idPrefix:idPrefix);

  /// Destructive Button
  LButton.destructive(String name, String label, {String idPrefix})
    : this(new ButtonElement(), name, label,
  buttonClasses: [C_BUTTON__DESTRUCTIVE], idPrefix:idPrefix);
  /// Destructive Button with Icon
  LButton.destructiveIcon(String name, String label, LIcon icon, {bool iconLeft: false, String idPrefix})
    : this(new ButtonElement(), name, label,
      buttonClasses: [C_BUTTON__DESTRUCTIVE], icon:icon, iconLeft:iconLeft, idPrefix:idPrefix);


  /// Icon Only - bare
  LButton.iconBare(String name, LIcon icon, String assistiveText, {String idPrefix})
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BARE], assistiveText:assistiveText, idPrefix:idPrefix);
  /// Icon Only - container
  LButton.iconContainer(String name, LIcon icon, String assistiveText, {String idPrefix})
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_CONTAINER], assistiveText:assistiveText, idPrefix:idPrefix);
  /// Icon Only - border
  LButton.iconBorder(String name, LIcon icon, String assistiveText, {String idPrefix})
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BORDER], assistiveText:assistiveText, idPrefix:idPrefix);
  /// Icon Only - border filled
  LButton.iconBorderFilled(String name, LIcon icon, String assistiveText, {String idPrefix})
    : this(new ButtonElement(), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BORDER_FILLED], assistiveText:assistiveText, idPrefix:idPrefix);

  /// Icon Only - border filled
  LButton.iconBorderFilledAnchor(String name, LIcon icon, String assistiveText, {String href, String idPrefix})
    : this(new AnchorElement(href: (href == null ? "#" : href)), name, null, icon:icon,
        buttonClasses: [C_BUTTON__ICON_BORDER_FILLED], assistiveText:assistiveText, idPrefix:idPrefix);


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

  /// auto focus if button or input
  void set autofocus (bool newValue) {
    if (element is ButtonElement)
      (element as ButtonElement).autofocus = newValue;
    else if (element is InputElement)
      (element as InputElement).autofocus = newValue;
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
  /// Button Icon Left
  bool get iconLeft => _iconLeft;

  /// Assistive Text
  String get assistiveText => _assistiveText;
  /// Add/Set Assistive Text
  void set assistiveText (String newValue) {
    _assistiveText = newValue;
    element.title = (_assistiveText == null ? "" : _assistiveText);
    _rebuild();
  }

  /// title
  String get title => element.title;
  /// title
  void set title (String newValue) {
    element.title = newValue;
  }

  /// Set href if Anchor
  void set href (String newValue) {
    if (element is AnchorElement) {
      (element as AnchorElement).href = newValue;
    }
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
    _icon.classes.add(C_BUTTON__ICON_INVERSE);
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

  /// Focus on Button
  void focus() {
    element.focus();
  }

} // LButton


/**
 * (Toggle) Button with multiple states
 */
class LButtonStateful
    extends LButton {

  static final Logger _log = new Logger("LButtonStateful");

  final List<LButtonStatefulState> states = new List<LButtonStatefulState>();

  /**
   * Toggle Button with [name] (default Follow)
   * if [onButtonClick] is provided, it will be called after state change
   */
  LButtonStateful(String name,
        LButtonStatefulState notSelectedState,
        LButtonStatefulState selectedState,
        LButtonStatefulState selectedFocusState,
        {String idPrefix, void onButtonClick(MouseEvent evt)})
      : super(new ButtonElement(), name, null, idPrefix: idPrefix) {

    element.classes.add(LButton.C_BUTTON__NEUTRAL);
    element.classes.add(LButton.C_NOT_SELECTED);
    element.setAttribute(Html0.ARIA_LIVE, Html0.ARIA_LIVE_ASSERTIVE);
    //
    addState(notSelectedState);
    addState(selectedState);
    addState(selectedFocusState);

    element.onClick.listen((MouseEvent evt) {
      if (!disabled) {
        bool newState = toggle();
        _log.fine("${name} selected=${newState}");
        if (onButtonClick != null)
          onButtonClick(evt);
      }
    });
  } // LButtonStateful

  /**
   * Follow Toggle Button
   */
  LButtonStateful.follow(String name, {String idPrefix,
        String notSelected:"Follow",
        String selected:"Following",
        String selectedFocus:"Unfollow",
        void onButtonClick(MouseEvent evt)})
    : this (name,
      new LButtonStatefulState(new LIconUtility(LIconUtility.ADD),
          notSelected, LText.C_TEXT_NOT_SELECTED),
      new LButtonStatefulState(new LIconUtility(LIconUtility.CHECK),
          selected, LText.C_TEXT_SELECTED),
      new LButtonStatefulState(new LIconUtility(LIconUtility.CLOSE),
          selectedFocus, LText.C_TEXT_SELECTED_FOCUS),
      idPrefix:idPrefix, onButtonClick:onButtonClick);

  /// Selected Toggle Button
  LButtonStateful.select(String name, {
      String notSelected:"Not Selected",
      String selected:"Selected",
      String selectedFocus:"Unselect",
      String idPrefix, void onButtonClick(MouseEvent evt)})
    : this (name,
      new LButtonStatefulState(new LIconUtility(LIconUtility.CLEAR),
          notSelected, LText.C_TEXT_NOT_SELECTED),
      new LButtonStatefulState(new LIconUtility(LIconUtility.SUCCESS),
          selected, LText.C_TEXT_SELECTED),
      new LButtonStatefulState(new LIconUtility(LIconUtility.CLOSE),
          selectedFocus, LText.C_TEXT_SELECTED_FOCUS),
      idPrefix:idPrefix, onButtonClick:onButtonClick);

  /// Edit/View Toggle Button
  LButtonStateful.view(String name, {
      String notSelected:"Edit",
      String selected:"View",
      String selectedFocus:"Read/Write",
      String idPrefix, void onButtonClick(MouseEvent evt)})
    : this (name,
      new LButtonStatefulState(new LIconUtility(LIconUtility.EDIT),
          notSelected, LText.C_TEXT_NOT_SELECTED),
      new LButtonStatefulState(new LIconUtility(LIconUtility.LOCK),
          selected, LText.C_TEXT_SELECTED),
      new LButtonStatefulState(new LIconUtility(LIconUtility.UNLOCK),
          selectedFocus, LText.C_TEXT_SELECTED_FOCUS),
      idPrefix:idPrefix, onButtonClick:onButtonClick);

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
 */
class LButtonStatefulIcon
    extends LButton {

  static final Logger _log = new Logger("LButtonIconStateful");

  /**
   * Stateful Icon
   */
  LButtonStatefulIcon(String name, String assistiveText, LIcon icon,
        {String idPrefix, void onButtonClick(MouseEvent evt)})
    : super(new ButtonElement(), name, null,
        buttonClasses:[LButton.C_BUTTON__ICON_BORDER],
        idPrefix:idPrefix, icon:icon, assistiveText:assistiveText) {

    element.onClick.listen((MouseEvent evt){
      if (!disabled) {
        bool newState = toggle();
        _log.fine("${name} selected=${newState}");
        if (onButtonClick != null)
          onButtonClick(evt);
      }
    });
    selected = false;
  } // LButtonStatefulIcon


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

} // LButtonStatefulIcon
