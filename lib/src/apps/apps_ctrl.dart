/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Page Application
 * - assigned to apps menu
 * maintains list of menu items = pages
 */
class AppsCtrl {

  /// Apps Name
  final String name;
  /// Apps Label
  final String label;


  final LIcon icon;
  final String imageSrc;

  /// Apps Pages
  final List<AppsPage> pages = new List<AppsPage>();

  /**
   * Application with either [icon] or [imageSrc]
   */
  AppsCtrl(String this.name, String this.label,
      {LIcon this.icon, String this.imageSrc}) {
  }

  /// Add Page to Application
  void add(AppsPage page) {
    pages.add(page);
  }

} // AppsCtrl
