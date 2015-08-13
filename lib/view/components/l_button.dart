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
  /// Icon Size
  static const String C_BUTTON__ICON__X_SMALL = "slds-button__icon--x-small";
  static const String C_BUTTON__ICON__SMALL = "slds-button__icon--small";
  static const String C_BUTTON__ICON__LARGE = "slds-button__icon--large";
  /// More Icon
  static const String C_BUTTON__ICON_MORE = "slds-button--icon-more";

  static const String C_BUTTON__ICON__INVERSE = "slds-button__icon--inverse";

  /// Hint Wrapper
  static const String C_HINT_PARENT = "slds-hint-parent";
  /// Icon Text
  static const String C_ASSISTIVE_TEXT = "slds-assistive-text";


  /// The Button
  final ButtonElement element = new ButtonElement()
    ..classes.add(C_BUTTON);
  /// Optional Button Icon
  final LIcon icon;
  /// Optional Assistive Text
  SpanElement assistive;

  /**
   * Button with [name] and optional [label]
   * if [idPrefix] is provided, the id will be idPrefix-name, if empty - the name
   */
  LButton(String name, String label, {String idPrefix,
      List<String> buttonClasses,
      LIcon this.icon, bool iconLeft: false, String assistiveText}) {
    element.name = name;
    if (idPrefix != null) {
      if (idPrefix.isEmpty)
        element.id = name;
      else
        element.id = "${idPrefix}-${name}";
    }
    if (icon == null) {
      if (label != null)
        element.appendText(label);
    } else {
      icon.element.classes.add(C_BUTTON__ICON);
      if (label == null) {
        element.append(icon.element);
      } else {
        if (iconLeft) {
          icon.element.classes.add(C_BUTTON__ICON__LEFT);
          element.append(icon.element);
          element.appendText(label);
        } else {
          icon.element.classes.add(C_BUTTON__ICON__RIGHT);
          element.appendText(label);
          element.append(icon.element);
        }
      }
    } // LButton

    if (buttonClasses != null) {
      element.classes.addAll(buttonClasses);
    }

    if (assistiveText != null) {
      this.assistiveText = assistiveText;
    }
  } // LButton

  /// Neutral Button
  LButton.neutral(String name, String label)
      : this(name, label, buttonClasses: [C_BUTTON__NEUTRAL]);

  /// Neutral Button with Icon
  LButton.neutralIcon(String name, String label, LIcon icon, {bool iconLeft: false})
      : this(name, label, icon:icon, iconLeft:iconLeft );
  /// Brand Button
  LButton.brand(String name, String label)
      : this(name, label, buttonClasses: [C_BUTTON__BRAND]);
  /// Inverse Button
  LButton.inverse(String name, String label)
      : this(name, label, buttonClasses: [C_BUTTON__INVERSE]);


  /// Icon Only - bare
  LButton.iconBare(String name, LIcon icon, String assistiveText)
      : this(name, null, buttonClasses: [C_BUTTON__ICON_BARE], assistiveText:assistiveText);
  /// Icon Only - container
  LButton.iconContainer(String name, LIcon icon, String assistiveText)
      : this(name, null, buttonClasses: [C_BUTTON__ICON_CONTAINER], assistiveText:assistiveText);
  /// Icon Only - border
  LButton.iconBorder(String name, LIcon icon, String assistiveText)
      : this(name, null, buttonClasses: [C_BUTTON__ICON_BORDER], assistiveText:assistiveText);
  /// Icon Only - border filled
  LButton.iconBorderFilled(String name, LIcon icon, String assistiveText)
      : this(name, null, buttonClasses: [C_BUTTON__ICON_BORDER_FILLED], assistiveText:assistiveText);

  /// Button name
  String get name => element.name;
  /// Button id
  String get id => element.id;

  /// Set Assistive Text
  void set assistiveText (String newValue) {
    if (assistive == null) {
      assistive = new SpanElement()
        ..classes.add(C_ASSISTIVE_TEXT);
      element.append(assistive);
    }
    assistive.text = newValue;
  }

  /// Button Size
  void setButtonSizeSmall() {
      element.classes.add(C_BUTTON__SMALL);
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

  /// Add More (down) icon
  void addIconMore() {
    element.classes.add(C_BUTTON__ICON_MORE);
    element.setAttribute(Html0.A_ARIA_HASPOPUP, "true");
    LIcon more = new LIcon.utility("down");
    more.element.classes.addAll([C_BUTTON__ICON, C_BUTTON__ICON__X_SMALL]);
    element.append(more.element);
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


  bool get disabled => element.disabled;
  void set disabled(bool newValue) {
    element.disabled = newValue;
  }

  /// Button Click
  ElementStream<MouseEvent> get onClick => element.onClick;

} // LButton


/**
 * (Toggle) Button with multiple states
 */
class LButtonStateful {

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
    element.setAttribute(Html0.A_ARIA_LIVE, "assertive");
    //
    addState(new LButtonStatefulState(new LIcon.utility("add"), textNotSelected, LButton.C_TEXT_NOT_SELECTED));
    addState(new LButtonStatefulState(new LIcon.utility("check"), textSelected, LButton.C_TEXT_SELECTED));
    addState(new LButtonStatefulState(new LIcon.utility("close"), textSelectedFocus, LButton.C_TEXT_SELECTED_FOCUS));

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

