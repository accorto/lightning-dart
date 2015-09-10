/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Page Application - assigned to main menu - list of menu items
 */
class AppsCtrl {

  final String name;
  final String label;

  final LIcon icon;
  final String imageSrc;

  List<AppsPage> entries = new List<AppsPage>();

  /**
   * Application with either [icon] or [imageSrc]
   */
  AppsCtrl(String this.name, String this.label,
      {LIcon this.icon, String this.imageSrc}) {
  }

  /// Add Page to Application
  void add(AppsPage entry) {
    entries.add(entry);
  }

} // AppsCtrl
