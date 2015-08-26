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

  LightningDart.init() // client env
  .then((_) {

    PageSimple page = PageSimple.create();
    DemoPage demo = new DemoPage("demo", new LIconUtility(LIconUtility.DESKTOP), "Demo");
    page.append(demo.element);

  });


} // main
