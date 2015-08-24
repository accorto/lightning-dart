/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Popover
 */
class LPopover extends LPopbase {

  /// slds-popover - Initializes popover | Required
  static const String C_POPOVER = "slds-popover";
  /// slds-popover__content - Hook for nubbin positioning | Required
  static const String C_POPOVER__CONTENT = "slds-popover__content";
  /// slds-popover__header - Applys styles for top area of popover
  static const String C_POPOVER__HEADER = "slds-popover__header";
  /// slds-popover__body - Applys syles for primary content area of popover
  static const String C_POPOVER__BODY = "slds-popover__body";

  /// slds-nubbin--top - Triangle that points upwards
  static const String C_NUBBIN__TOP = "slds-nubbin--top";
  /// slds-nubbin--bottom - Triangle that points downwards
  static const String C_NUBBIN__BOTTOM = "slds-nubbin--bottom";
  /// slds-nubbin--left - Triangle that points to the left
  static const String C_NUBBIN__LEFT = "slds-nubbin--left";
  /// slds-nubbin--right - Triangle that points to the right
  static const String C_NUBBIN__RIGHT = "slds-nubbin--right";

  /// Nubbin Positions
  static final List<String> NUBBINS = [C_NUBBIN__TOP, C_NUBBIN__RIGHT, C_NUBBIN__BOTTOM, C_NUBBIN__LEFT];

  /// Popover element
  final DivElement element = new DivElement()
    ..classes.add(C_POPOVER)
    ..attributes[Html0.ROLE] = Html0.ROLE_DIALOG;

  final DivElement _content = new DivElement()
    ..classes.add(C_POPOVER__CONTENT)
    ..attributes[Html0.ROLE] = Html0.ROLE_DOCUMENT;
  final DivElement _head = new DivElement()
    ..classes.add(C_POPOVER__HEADER);

  final DivElement body = new DivElement()
    ..classes.add(C_POPOVER__BODY);


  /**
   * Popover with text
   */
  LPopover(String headText, String bodyText) {
    element.append(_content);
    _content.append(_head);
    if (headText != null) {
      ParagraphElement p = new ParagraphElement()
        ..classes.add(LText.C_TEXT_HEADING__SMALL)
        ..text = headText;
      _head.append(p);
    }
    _content.append(body);
    if (bodyText != null)
      body.text = bodyText;
  } // LPopover


} // LPopover


/**
 * Popover/Tooltip management
 */
abstract class LPopbase extends LComponent {

  /// Pop Element
  Element get element;


  void set nubbinTop (bool newValue) {
    element.classes.removeAll(LPopover.NUBBINS);
    if (newValue) {
      element.classes.add(LPopover.C_NUBBIN__TOP);
    }
  }
  void set nubbinRight (bool newValue) {
    element.classes.removeAll(LPopover.NUBBINS);
    if (newValue) {
      element.classes.add(LPopover.C_NUBBIN__RIGHT);
    }
  }
  void set nubbinLeft (bool newValue) {
    element.classes.removeAll(LPopover.NUBBINS);
    if (newValue) {
      element.classes.add(LPopover.C_NUBBIN__LEFT);
    }
  }
  void set nubbinBottom (bool newValue) {
    element.classes.removeAll(LPopover.NUBBINS);
    if (newValue) {
      element.classes.add(LPopover.C_NUBBIN__BOTTOM);
    }
  }


  /// Show pop above [target] and add it to [parent]
  void showAbove(Element target, {Element parent,
      bool showOnHover: true, bool showOnClick: true}) {
    nubbinBottom = true;
    // TODO
  }


  /// remove from parent
  void hide() {
    element.remove();
  }

} // LPopbase
