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

  // Header Icon/Image
  LIcon icon;
  String imageSrc;

  /// Apps Title/Label
  String label;
  String labelSub;

  /// Info
  String info;
  /// Help Url
  String helpUrl;

  /// Additional Header Element
  Element additionalHeader;

  /// Apps Pages
  final List<AppsPage> pageList = new List<AppsPage>();

  /**
   * Application with either [icon] or [imageSrc]
   */
  AppsCtrl(String this.name, String this.label,
      {LIcon this.icon, String this.imageSrc}) {
  }

  /// Add Page to Application
  void add(AppsPage page) {
    pageList.add(page);
  }



} // AppsCtrl
