/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import "package:lightning/lightning_ctrl.dart";
import 'package:lightning/protoc/check_pb.dart';
import 'package:logging/logging.dart';
import 'package:fixnum/fixnum.dart';

import 'dart:typed_data';

import 'dart:async';
import 'dart:html';

/**
 * Example 2
    https://lightningdart.com/exampleForm2.html
 */
main() async {

  await LightningCtrl.init("LightningExample", "Lightning"
  //    productionUri: "https://psa.bizfabrik.net/"
  );

  PageSimple page = LightningDart.createPageSimple();
  page.append(new ExampleForm2().element);

} // main



/// Example Form
class ExampleForm2 {

  static const String ID = "ex2";
  static final Logger _log = new Logger("ExampleForm2");

  Element element = new Element.section()
    ..classes.add(LMargin.C_AROUND__MEDIUM);

  /// example form
  ExampleForm2() {
    UI ui = createUi();
    FormCtrl form = new FormCtrl(ui.tableName, ui, idPrefix: ID)
      ..buildPanels(showSection1label: false)
      ..recordSave = onRecordSave;
    element.append(form.element);
  }


  /// save
  Future<SResponse> onRecordSave(DRecord record) {
    Completer<SResponse> completer = new Completer<SResponse>();

    CheckRequest request = new CheckRequest();
    request.recordList.add(record);

    String info = "ex2";
    ExampleService service = new ExampleService();
    try {
      service.send(request, info, level: Level.INFO)
      .then((CheckResponse response) {
        completer.complete(response.response); // update form
      });
    } catch (error, stackTrace) {
      _log.severe(info, error, stackTrace);
    }

    return completer.future;
  } // onRecordSave


  /// create UI
  UI createUi() {
    UI ui = new UI()
      ..name = "Example2"
      ..label = "Example 2";
    DTable table = new DTable()
      ..name = "example2"
      ..label = "Example Two";

    UiUtil util = new UiUtil(ui);
    util.setTable(table);

    util.addColumn(util.addDColumn("name", "Name", DataType.STRING));
    util.addColumn(util.addDColumn("description", "Description", DataType.TEXT));

    util.addColumn(util.addDColumn("attach", "Attachment", DataType.IMAGE));

    return ui;
  } // createUi

} // ExampleForm2



/**
 * Example Service
 */
class ExampleService extends Service {

  static final Logger _log = new Logger("ExampleService");

  // Example Service
  static final String TRX = "proto";

  /**
   * Send Check request
   */
  Future<CheckResponse> send(CheckRequest request, String info,
      {bool doTrack:true,
      bool setBusy:true,
      bool withGeo:false,
      Level level:Level.CONFIG}) {

    _log.log(level, "send ${info}");
    request.request = createCRequest(TRX, info);
    //
    Completer<CheckResponse> completer = new Completer<CheckResponse>();
    Uint8List data = null;
    try {
      data = request.writeToBuffer();
    } catch (error, stackTrace) {
      _log.warning("send ${info} request", error, stackTrace);
      _log.warning("${request}");
      completer.completeError(error);
      return completer.future;
    }
    _log.log(level, "send ${info} size=${data.length}");
    bool trackProgress = level.value > Level.CONFIG.value;

    sendRequest(TRX, data, info, setBusy:setBusy, trackProgress:trackProgress)
    .then((HttpRequest httpRequest) {
      _log.info("send ${info} received ${httpRequest.status} ${httpRequest.statusText}");
      DateTime now = new DateTime.now();
      List<int> buffer = new Uint8List.view(httpRequest.response);
      CheckResponse response = new CheckResponse.fromBuffer(buffer);
      SResponse sresponse = response.response;
      sresponse.clientReceiptTime = new Int64(now.millisecondsSinceEpoch);
      String details = handleSuccess(info, sresponse, buffer.length);
      ServiceTracker track = new ServiceTracker(response.response, info, details);
      completer.complete(response);
      _log.info("send ${info} received ${details}");
      // if (doTrack) // router sends stats for login
      track.send();
    })

    .catchError((error, StackTrace stackTrace) {
      _log.warning("send ${info} error", error, stackTrace);
      print(error);
      String message = handleError(TRX, error, stackTrace);
      completer.completeError(message);
    });
    return completer.future;
  } // send


} // ExampleService
