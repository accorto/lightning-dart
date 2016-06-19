/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Scrollable
 */
class LScrollable extends LComponent {

  /// slds-scrollable (surrounding div): Forces element to scroll horizontally and vertically when content exceeds element's width and height
  static const String C_SCROLLABLE = "slds-scrollable";
  /// slds-scrollable--x (surrounding div): Forces element to scroll horizontally when content exceeds element's width
  static const String C_SCROLLABLE__X = "slds-scrollable--x";
  /// slds-scrollable--y (surrounding div): Forces element to scroll vertically when content exceeds element's height
  static const String C_SCROLLABLE__Y = "slds-scrollable--y";

  /// Scollable
  final Element element;

  /// Scrollable x+y
  LScrollable(Element this.element, bool x, bool y) {
    if (x) {
      if (y)
        element.classes.add(C_SCROLLABLE);
      else
        element.classes.add(C_SCROLLABLE__X);
    } else if (y)
      element.classes.add(C_SCROLLABLE__Y);
  }

  /// Scrollable div x
  LScrollable.x() : this(new DivElement(), true, false);

  /// Scrollable div y
  LScrollable.y() : this(new DivElement(), false, true);


} // LScrollable
