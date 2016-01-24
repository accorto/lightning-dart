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

part "exampleWorkspaceData.dart";
part "exampleWorkspaceLogin.dart";

/**
 * Workbench Example
 * - Object Home with records
 */
main() async {

  Datasource dataSource = null;
  if (dataSource == null) {
    LightningCtrl.init()
    .then((_){
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
      start(dataSource);
    })
    .catchError((error, stackTrace){
      print(error);
      print(stackTrace);
      start(dataSource);
    });
  } else {
    await LightningDart.init(); // client env
    start(dataSource);
  }
} // main

/**
 * Start Apps
 */
void start(Datasource dataSource) {
  if (dataSource == null)
    dataSource = new WorkspaceData();
  ObjectCtrl ctrl = new ObjectCtrl(dataSource);

  PageSimple page = LightningDart.createPageSimple();
  page.element.classes.add(LGrid.C_WRAP);
  page.add(ctrl);
}

