/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Logout Page
 */
class AppsNewWindow
    extends AppsPage {

  static const String NAME = "newWindow";

  final DivElement element = new DivElement();
  final NewWindow button = new NewWindow();

  /// New Window
  AppsNewWindow() : super(NAME, NAME,
      new LIconUtility(LIconUtility.NEW_WINDOW),
      appsNewWindow(),
      appsNewWindow()) {

    menuEntry.onClick.listen(button.onClick); // stopImmediate
  } // AppsLogout


  /// Showing
  void showingNow() {
    // should not through click but menu navigation
    button.onClick(null);
    window.history.back();
  }

  static String appsNewWindow() => Intl.message("New Window", name: "appsNewWindow");

} // AppsNewWindow
