/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

library lightning.exampleWorkspace;

import "dart:async";
import "dart:html";

import "package:lightning/lightning_ctrl.dart";
import 'package:logging/logging.dart';

import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';
import "package:lightning/protoc/rr_login_pb.dart";

import "demo.dart";

part "exampleWorkspaceLogin.dart";

/**
 * Workbench Example
 * - Object Home with records
 */
main() async {

  PageSimple page = null;
  Datasource dataSource = null;
  if (dataSource == null) {
    LightningCtrl.init("LightningWorkspace", "Lightning", "/")
    .then((_){
      page = LightningCtrl.createPageSimple();
      return WorkspaceLogin.login();
    })
    .then((LoginResponse login){
      if (login.response.isSuccess) {
        FkService.instance = new FkService(Service.TRX_DATA, Service.TRX_UI);
        UiService.instance = new UiService(Service.TRX_DATA, Service.TRX_UI);
        dataSource = new Datasource("AD_Table", Service.TRX_DATA, Service.TRX_UI);
      } else {
        print(login.response.msg);
      }
      start(page, dataSource);
    })
    .catchError((error, stackTrace){
      print(error);
      print(stackTrace);
      start(page, dataSource);
    });
  } else {
    await LightningDart.init(); // client env
    page = LightningDart.createPageSimple();
    start(page, dataSource);
  }
} // main

/**
 * Start Apps
 */
void start(PageSimple page, Datasource dataSource) {
  if (dataSource == null) {
    dataSource = new DemoData()
      ..setCount = 3;
  }
  ObjectCtrl ctrl = new ObjectCtrl(dataSource);

  page.element.classes.add(LGrid.C_WRAP);
  page.add(ctrl);
}

