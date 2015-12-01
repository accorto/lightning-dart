/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tooltip
 *
 *    Tooltip tip = new LTooltip()
 *      ..bodyText = "x";
 *    tip.showBelow(button);
 *    div.add(tip); // tip is wrapper for button
 *
 */
class LTooltip
      extends LPopbase {

  /// Popover element
  final DivElement pop = new DivElement()
    ..classes.addAll([LPopover.C_POPOVER, LPopover.C_POPOVER__TOOLTIP])
    ..attributes[Html0.ROLE] = Html0.ROLE_DIALOG;

  final DivElement body = new DivElement()
    ..classes.add(LPopover.C_POPOVER__BODY);


  /**
   * Tooltip
   */
  LTooltip() {
    element.append(body);
  }
  void set bodyText (String text) {
    body.text = text;
  }

} // LTooltip
