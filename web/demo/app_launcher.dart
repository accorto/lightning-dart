/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class AppLauncher extends DemoFeature {

  AppLauncher()
      : super("app-launcher", "App Launcher",
      sldsStatus: DemoFeature.SLDS_PROTOTYPE,
      devStatus: DemoFeature.STATUS_NIY,
      hints: [],
      issues: [],
      plans: []);

  LComponent get content {
    return null;
  }
  String get source {
    return '''
    ''';
  }

}
