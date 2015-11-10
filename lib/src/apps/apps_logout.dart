/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Logout Page
 */
class AppsLogout
    extends AppsPage {

  final DivElement element = new DivElement();

  /// Logout
  AppsLogout() : super("logout", "logout",
        new LIconUtility(LIconUtility.LOGOUT),
        appsLogoutLabel(), appsLogoutLabel()) {
  } // AppsLogout


  /// Showing
  void showingNow() {
    if (AppsMain.instance != null) {
      AppsMain.instance.loggedIn = false;
    }
    ClientEnv.logout();
    LightningCtrl.router.goto(Route.NAME_LOGIN);
  }

  static String appsLogoutLabel() => Intl.message("Logout", name: "appsLogoutLabel");

} // AppsLogout
