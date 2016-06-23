/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Popover with head/conent
 */
class LPopover
    extends LPopbase {

  /// slds-popover (div): Initializes popover
  static const String C_POPOVER = "slds-popover";
  /// slds-popover__header (div): Applies styles for top area of popover
  static const String C_POPOVER__HEADER = "slds-popover__header";
  /// slds-popover__body (div): Applies syles for primary content area of popover
  static const String C_POPOVER__BODY = "slds-popover__body";
  /// slds-popover--tooltip (slds-popover): Modifier used to apply tooltip specific styles
  static const String C_POPOVER__TOOLTIP = "slds-popover--tooltip";
  /// slds-popover--panel (slds-popover): Modifier used to apply panel specific styles
  static const String C_POPOVER__PANEL = "slds-popover--panel";

  /// slds-nubbin--top (slds-popover): Triangle that points upwards which is horizontally centered
  static const String C_NUBBIN__TOP = "slds-nubbin--top";
  /// slds-nubbin--top-left (slds-popover): Triangle that points upwards which is left aligned
  static const String C_NUBBIN__TOP_LEFT = "slds-nubbin--top-left";
  /// slds-nubbin--top-right (slds-popover): Triangle that points upwards which is right aligned
  static const String C_NUBBIN__TOP_RIGHT = "slds-nubbin--top-right";
  /// slds-nubbin--bottom (slds-popover): Triangle that points downwards which is horizontally centered
  static const String C_NUBBIN__BOTTOM = "slds-nubbin--bottom";
  /// slds-nubbin--bottom-left (slds-popover): Triangle that points downwards which is left aligned
  static const String C_NUBBIN__BOTTOM_LEFT = "slds-nubbin--bottom-left";
  /// slds-nubbin--bottom-right (slds-popover): Triangle that points downwards which is right aligned
  static const String C_NUBBIN__BOTTOM_RIGHT = "slds-nubbin--bottom-right";
  /// slds-nubbin--left (slds-popover): Triangle that points to the left which is vertically centered
  static const String C_NUBBIN__LEFT = "slds-nubbin--left";
  /// slds-nubbin--left-top (slds-popover): Triangle that points to the left which is top aligned
  static const String C_NUBBIN__LEFT_TOP = "slds-nubbin--left-top";
  /// slds-nubbin--left-bottom (slds-popover): Triangle that points to the right which is bottom aligned
  static const String C_NUBBIN__LEFT_BOTTOM = "slds-nubbin--left-bottom";
  /// slds-nubbin--right (slds-popover): Triangle that points to the right which is vertically centered
  static const String C_NUBBIN__RIGHT = "slds-nubbin--right";
  /// slds-nubbin--right-top (slds-popover): Triangle that points to the right which is top aligned
  static const String C_NUBBIN__RIGHT_TOP = "slds-nubbin--right-top";
  /// slds-nubbin--right-bottom (slds-popover): Triangle that points to the right which is bottom aligned
  static const String C_NUBBIN__RIGHT_BOTTOM = "slds-nubbin--right-bottom";

  /// Nubbin Positions
  static final List<String> _NUBBINS = [C_NUBBIN__TOP, C_NUBBIN__TOP_LEFT, C_NUBBIN__TOP_RIGHT,
    C_NUBBIN__RIGHT, C_NUBBIN__RIGHT_TOP, C_NUBBIN__RIGHT_BOTTOM,
    C_NUBBIN__BOTTOM, C_NUBBIN__BOTTOM_LEFT, C_NUBBIN__BOTTOM_RIGHT,
    C_NUBBIN__LEFT, C_NUBBIN__LEFT_TOP, C_NUBBIN__LEFT_BOTTOM];

  /// Nubbin Positions
  static final List<String> _NUBBINS_TOP = [C_NUBBIN__TOP, C_NUBBIN__TOP_LEFT, C_NUBBIN__TOP_RIGHT];
  static final List<String> _NUBBINS_RIGHT = [C_NUBBIN__RIGHT, C_NUBBIN__RIGHT_TOP, C_NUBBIN__RIGHT_BOTTOM];
  static final List<String> _NUBBINS_BOTTOM = [C_NUBBIN__BOTTOM, C_NUBBIN__BOTTOM_LEFT, C_NUBBIN__BOTTOM_RIGHT];
  static final List<String> _NUBBINS_LEFT = [C_NUBBIN__LEFT, C_NUBBIN__LEFT_TOP, C_NUBBIN__LEFT_BOTTOM];


  /// Popover element
  final DivElement pop = new DivElement()
    ..classes.add(C_POPOVER)
    ..attributes[Html0.ROLE] = Html0.ROLE_DIALOG;

  final DivElement _head = new DivElement()
    ..classes.add(C_POPOVER__HEADER);
  ParagraphElement _headParagraph;

  final DivElement body = new DivElement()
    ..classes.add(C_POPOVER__BODY);


  /**
   * Popover with text
   */
  LPopover() {
    pop.append(_head);
    pop.append(body);
  } // LPopover

  /// optional header text
  void set headText (String text) {
    if (_headParagraph == null) {
      _headParagraph = new ParagraphElement()
        ..classes.addAll([LText.C_TEXT_HEADING__SMALL, LMargin.C_TOP__X_SMALL, LMargin.C_LEFT__SMALL]);
      _head.append(_headParagraph);
    }
    _headParagraph.text = text;
  }
  /// body text
  void set bodyText (String text) {
    body.text = text;
  }
  /// body text
  void set bodyLines (List<String> lines) {
    body.children.clear();
    for (String text in lines) {
      body.append(new ParagraphElement()..text = text);
    }
  }

} // LPopover
