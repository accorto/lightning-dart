/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tooltip
 */
class LTooltip extends LPopbase {


  /// slds-tooltip - Initializes tooltip | Required
  static const String C_TOOLTIP = "slds-tooltip";
  /// slds-tooltip__content - Hook for nubbin positioning | Required
  static const String C_TOOLTIP__CONTENT = "slds-tooltip__content";
  /// slds-tooltip__body - Applies styles for primary content area of tooltip | Required
  static const String C_TOOLTIP__BODY = "slds-tooltip__body";


  /// Popover element
  final DivElement pop = new DivElement()
    ..classes.add(LPopover.C_POPOVER)
    ..attributes[Html0.ROLE] = Html0.ROLE_DIALOG;

  /// Tooltip element
  final DivElement _tooltip = new DivElement()
    ..classes.add(C_TOOLTIP)
    ..attributes[Html0.ROLE] = Html0.ROLE_TOOLTIP;

  final DivElement _content = new DivElement()
    ..classes.add(C_TOOLTIP__CONTENT)
    ..attributes[Html0.ROLE] = Html0.ROLE_DOCUMENT;

  final DivElement body = new DivElement()
    ..classes.add(C_TOOLTIP__BODY);


  /**
   * Tooltip
   */
  LTooltip() {
    pop.append(_tooltip);
    _tooltip.append(_content);
    _content.append(body);
  }
  void set bodyText (String text) {
    body.text = text;
  }

} // LTooltip
