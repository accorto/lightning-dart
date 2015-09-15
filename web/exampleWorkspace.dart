/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

library lightning.exampleWorkspace;

import "dart:async";

import "package:lightning/lightning_ctrl.dart";

part "exampleWorkspaceData.dart";

/**
 * Workbench Example
 * - Object Home with records
 */
void main() {

  LightningDart.init() // client env
  .then((_) {
    WorbenchData wbData = new WorbenchData();

    ObjectCtrl ctrl = new ObjectCtrl(wbData);

    PageSimple page = LightningDart.createPageSimple();
    page.add(ctrl);

  });

} // main


