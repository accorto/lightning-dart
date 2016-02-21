/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import "demo.dart";

/**
 * Demo Page (no menu)
 */
void main() {

  LightningCtrl.init("LightningDemo", "Lightning", "/") // server env
  .then((_) {

    PageSimple page = LightningDart.createPageSimple();
    page.add(new DemoPage("demo", new LIconUtility(LIconUtility.DESKTOP), "Demo", page));

  });


} // main
