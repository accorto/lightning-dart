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

  static const String C_BUTTON = "slds-button";
  static const String C_BUTTON__NEUTRAL = "slds-button--neutral";
  static const String C_BUTTON__BRAND = "slds-button--brand";
  static const String C_BUTTON__INVERSE = "slds-button--inverse";


  static const String C_BUTTON__SMALL = "slds-button--small";

  static const String C_BUTTON__ICON = "slds-button__icon";
  static const String C_BUTTON__ICON__LEFT = "slds-button__icon--left";
  static const String C_BUTTON__ICON__RIGHT = "slds-button__icon--right";

  static const String C_BUTTON_SPACE_LEFT = "slds-button-space-left";

  /// Stateful Button
  static const String C_BUTTON__ICON__STATEFUL = "slds-button__icon--stateful";

  static const String C_NOT_SELECTED = "slds-not-selected";
  static const String C_IS_SELECTED = "slds-is-selected";

  static const String C_TEXT_NOT_SELECTED = "slds-text-not-selected";
  static const String C_TEXT_SELECTED = "slds-text-selected";
  static const String C_TEXT_SELECTED_FOCUS = "slds-text-selected-focus";


  static const String C_BUTTON__ICON_BARE = "slds-button--icon-bare";
  static const String C_BUTTON__ICON_CONTAINER = "slds-button--icon-container";
  static const String C_BUTTON__ICON_BORDER = "slds-button--icon-border";
  static const String C_BUTTON__ICON_BORDER_FILLED = "slds-button--icon-border-filled";
  static const String C_BUTTON__ICON_BORDER_SMALL = "slds-button--icon-border-small";
  static const String C_BUTTON__ICON__HINT = "slds-button__icon--hint";

  /// Icon Size
  static const String C_BUTTON__ICON__X_SMALL = "slds-button__icon--x-small";
  static const String C_BUTTON__ICON__SMALL = "slds-button__icon--small";
  static const String C_BUTTON__ICON__LARGE = "slds-button__icon--large";
  /// More Icon
  static const String C_BUTTON__ICON_MORE = "slds-button--icon-more";

  static const String C_BUTTON__ICON__INVERSE = "slds-button__icon--inverse";

  /// Hint
  static const String C_BUTTON__HINT = "slds-button--hint";
  /// Hint Wrapper
  static const String C_HINT_PARENT = "slds-hint-parent";

  static const String C_CLOSE = "close";


  /// The Button
  final Element element;
  /// Optional Button Icon
  final LIcon icon;
  /// Optional Assistive Text
  SpanElement assistive;

  /**
   * Button with [name] and optional [label]
   * [element] can be a button, anchor, or input
   * if [idPrefix] is provided, the id will be idPrefix-name, if empty - the name
   */
  LButton(Element this.element, String name, String label, {String idPrefix, Element labelElement,
      List<String> buttonClasses, String href,
      LIcon this.icon, bool iconLeft: false, String assistiveText}) {
    element.classes.add(C_BUTTON);
    if (element is ButtonElement) {
      (element as ButtonElement).name = name;
    } else if (element is InputElement) {
        (element as InputElement).name = name;
        (element as InputElement).value = label;
    } else {
      element.attributes[Html0.DATA_NAME] = name;
      if (href != null && href.isNotEmpty && element is AnchorElement) {
        (element as AnchorElement).href = href;
      }
    }
    if (idPrefix != null) {
      if (idPrefix.isEmpty)
        element.id = name;
      else
        element.id = "${idPrefix}-${name}";
    }
    if (icon == null) {
      if (labelElement != null)
        element.append(labelElement);
      else if (label != null)
        element.appendText(label);
    } else {
      icon.element.classes.add(C_BUTTON__ICON);
      if (label == null && labelElement == null) {
        element.append(icon.element);
      } else {
        if (iconLeft) {
          icon.element.classes.add(C_BUTTON__ICON__LEFT);
          element.append(icon.element);
          if (labelElement != null)
            element.append(labelElement);
          else if (label != null)
            element.appendText(label);
        } else {
          icon.element.classes.add(C_BUTTON__ICON__RIGHT);
          if (labelElement != null)
            element.append(labelElement);
          else if (label != null)
            element.appendText(label);
          element.append(icon.element);
        }
      }
    } // LButton

    // classes + more
    if (buttonClasses != null) {
      element.classes.addAll(buttonClasses);
      /// Add More (down) icon
      if (buttonClasses.contains(C_BUTTON__ICON_MORE)) {
        element.setAttribute(Html0.ARIA_HASPOPUP, "true");
        LIcon more = new LIconUtility("down", className: C_BUTTON__ICON, size: C_BUTTON__ICON__X_SMALL);
        element.append(more.element);
      }
    }

    if (assistiveText != null) {
      this.assistiveText = assistiveText;
    }
  } // LButton

  /// Default Button
  LButton.base(String name, String label)
    : this(new ButtonElement(), name, label);

  /// Neutral Button
  LButton.neutral(String name, String label)
    : this(new ButtonElement(), name, label,
        buttonClasses: [C_BUTTON__NEUTRAL]);
  /// Neutral Anchor
  LButton.neutralAnchor(String name, String label, {String href})
    : this(new AnchorElement(href: "#"), name, label, href:href,
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
  /// Brand Button
  LButton.brandAnchor(String name, String label, {String href})
      : this(new AnchorElement(href: "#"), name, label, href:href,
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

  /// Button name
  String get name {
    if (element is ButtonElement)
      return (element as ButtonElement).name;

    return element.attributes[Html0.DATA_NAME];
  }
  /// Button id
  String get id => element.id;

  /// Set Assistive Text
  void set assistiveText (String newValue) {
    if (assistive == null) {
      assistive = new SpanElement()
        ..classes.add(LText.C_ASSISTIVE_TEXT);
      element.append(assistive);
    }
    assistive.text = newValue;
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

  /// Icon Size
  void setIconSizeXSmall() {
    if (icon != null)
      icon.element.classes.add(C_BUTTON__ICON__X_SMALL);
  }
  /// Icon Size
  void setIconSizeSmall() {
    if (icon != null)
      icon.element.classes.add(C_BUTTON__ICON__SMALL);
  }
  /// Icon Size
  void setIconSizeLarge() {
    if (icon != null)
      icon.element.classes.add(C_BUTTON__ICON__LARGE);
  }
  /// Icon Inverse
  void setIconInverse() {
    if (icon != null)
      icon.element.classes.add(C_BUTTON__ICON__INVERSE);
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
   * Returns div with button appended
   */
  DivElement hint() {
    DivElement div = new DivElement()
      ..classes.add(C_HINT_PARENT);
    div.append(element);
    return div;
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
    if (idPrefix != null) {
      if (idPrefix.isEmpty)
        element.id = name;
      else
        element.id = "${idPrefix}-${name}";
    }
    element.classes.add(LButton.C_BUTTON__NEUTRAL);
    element.classes.add(LButton.C_NOT_SELECTED);
    element.setAttribute(Html0.ARIA_LIVE, Html0.ARIA_LIVE_ASSERTIVE);
    //
    addState(new LButtonStatefulState(new LIconUtility(LIconUtility.ADD), textNotSelected, LButton.C_TEXT_NOT_SELECTED));
    addState(new LButtonStatefulState(new LIconUtility(LIconUtility.CHECK), textSelected, LButton.C_TEXT_SELECTED));
    addState(new LButtonStatefulState(new LIconUtility(LIconUtility.CLOSE), textSelectedFocus, LButton.C_TEXT_SELECTED_FOCUS));

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
    state.icon.element.classes.addAll([LButton.C_BUTTON__ICON__STATEFUL, LButton.C_BUTTON__ICON__LEFT]);
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

  final ButtonElement element = new ButtonElement()
    ..classes.addAll([LButton.C_BUTTON, LButton.C_BUTTON__ICON_BORDER]);

  final SpanElement _span = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT);

  /**
   * Stateful Icon
   */
  LButtonIconStateful(String name, String assistiveText, LIcon icon, {String idPrefix,
      void onButtonClick(MouseEvent evt)}) {
    icon.classes.add(LButton.C_BUTTON__ICON);
    element.append(icon.element);
    //
    if (assistiveText != null)
      _span.text = assistiveText;
    element.append(_span);
    //
    element.onClick.listen((MouseEvent evt){
      bool newState = toggle();
    //  _log.fine("${name} selected=${newState}");
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
