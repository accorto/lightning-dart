/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import "demo.dart";

/**
 * Index (Main Page)
 */
main() async {
  // LightningDart.init() // client env
  await LightningCtrl.init("Lightning", "Lightning", LightningDart.VERSION, uaCode: "UA-32129178-8"); // server env
  IntroPage intro = new IntroPage(); // get static content
  //
  AppsMain page = LightningCtrl.createAppsMain();
  AppsCtrl apps = new AppsCtrl("ldart", "Lightning Dart Demo",
      imageSrc: "packages/lightning/assets/images/LightningDartLogo.svg")
    ..info = "Lightning Experience in Dart"
    ..helpUrl = "http://lightning.accorto.com";
  apps.add(intro);
  apps.add(new DemoPage("desktop", new LIconUtility(LIconUtility.DESKTOP), "Desktop", page));
  apps.add(new DemoFrame("tablet", new LIconUtility(LIconUtility.TABLET_PORTRAIT), "Tablet", 768));
  apps.add(new DemoFrame("phone", new LIconUtility(LIconUtility.PHONE_PORTRAIT), "Phone", 480));
  apps.add(new ExampleForm());
  apps.add(new ExampleWorkspace());
  apps.add(new AppsSettings());
  //apps.add(new SupportLink());
  page.set(apps);
} // main
