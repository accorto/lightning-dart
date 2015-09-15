/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Page Main Header - Logo (for the moment)
 */
class AppsHeader extends LComponent {

  final Element element = new Element.header()
    ..classes.add(LMargin.C_AROUND__SMALL)
    ..id = "a-header";

  /**
   * Set Application
   */
  void set(AppsCtrl apps) {
    element.children.clear();
    if (apps.imageSrc != null) {
      LImage img = new LImage.srcMedium(apps.imageSrc, apps.label, circle: false);
      element.append(img.element);
    }
  } // set

} // AppsHeader

