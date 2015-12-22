/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Scrollable
 */
class LScrollable extends LComponent {

  /// slds-scrollable--x (surrounding div): Forces element to scroll horizontally when content exceeds elements width
  static const String C_SCROLLABLE__X = "slds-scrollable--x";
  /// slds-scrollable--y (surrounding div): Forces element to scroll vertically when content exceeds elements height
  static const String C_SCROLLABLE__Y = "slds-scrollable--y";

  /// Scollable
  final Element element;

  /// Scrollable x+y
  LScrollable(Element this.element, bool x, bool y) {
    if (x)
      element.classes.add(C_SCROLLABLE__X);
    if (y)
      element.classes.add(C_SCROLLABLE__Y);
  }

  /// Scrollable div x
  LScrollable.x() : this(new DivElement(), true, false);

  /// Scrollable div y
  LScrollable.y() : this(new DivElement(), false, true);


} // LScrollable
