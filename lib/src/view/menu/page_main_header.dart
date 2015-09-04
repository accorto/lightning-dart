/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Page Main Header - Logo (for the moment)
 */
class PageMainHeader extends LComponent {

  final Element element = new Element.header()
    ..classes.add(LMargin.C_AROUND__SMALL);

  /**
   * Set Application
   */
  void set(PageApplication apps) {
    element.children.clear();
    if (apps.imageSrc != null) {
      LImage img = new LImage.srcMedium(apps.imageSrc, apps.label, circle: false);
      element.append(img.element);
    }
  } // set

} // PageMainHeader

