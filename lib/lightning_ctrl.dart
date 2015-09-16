/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

/**
 * Lightning Dart Controller level Functionality - extends Lightning Dart and provides component controller functionality.
 *
 * Lightning Dart Controller main entry point
 *
 *     LightningCtrl.init()
 *     .then((_){
 *       // application code
 *     });
 *
 */
library lightning_ctrl;

import 'dart:html';
import 'dart:js';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

// Packages
import 'package:logging/logging.dart';
import 'package:fixnum/fixnum.dart';
import 'package:uuid/uuid.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:intl/intl.dart';


import 'lightning.dart';
export 'lightning.dart';

part 'src/apps/apps_ctrl.dart';
part 'src/apps/apps_header.dart';
part 'src/apps/apps_main.dart';
part 'src/apps/apps_menu.dart';
part 'src/apps/apps_page.dart';

part 'src/ctrl/datasource.dart';
part 'src/ctrl/form_ctrl.dart';
part 'src/ctrl/meta_cache.dart';
part 'src/ctrl/object_ctrl.dart';
part 'src/ctrl/object_edit.dart';
part 'src/ctrl/object_filter.dart';
part 'src/ctrl/object_filter_filter.dart';
part 'src/ctrl/object_filter_sort.dart';
part 'src/ctrl/record_ctrl.dart';
part 'src/ctrl/record_ctrl_details.dart';
part 'src/ctrl/record_ctrl_related.dart';

part 'src/ctrl/remote_logger.dart';
part 'src/ctrl/router.dart';
part 'src/ctrl/service.dart';
part 'src/ctrl/service_analytics.dart';
part 'src/ctrl/service_fk.dart';
part 'src/ctrl/service_tracker.dart';
part 'src/ctrl/table_ctrl.dart';
part 'src/ctrl/table_layout.dart';
part 'src/ctrl/timezone.dart';

/**
 * Lightning Dart Controller main entry point
 *
 *     LightningCtrl.init()
 *     .then((_){
 *       // application code
 *     });
 *
 */
class LightningCtrl {

  static final Logger _log = new Logger("LightningCtrl");

  /// Router Instance
  static final Router router = new Router();

  /**
   * Initialize Logging, Locale, Intl, Date
   * optional [serverUri] to overwrite target
   */
  static Future<List<Future>> init({String serverUri: "/",
      String clientPrefix: "ui/", bool embedded: false, bool test: false}) {

    Completer<List<Future>> completer = new Completer<List<Future>>();
    List<Future> futures = new List<Future>();
    if (Service.trxNo != -1) { // // already initialized
      completer.complete(futures);
      return completer.future;
    }
    //
    ServiceAnalytics.enabled = true;
    RemoteLogger.enabled = true;
    new RemoteLogger();
    futures.add(LightningDart.init()); // ClientEnv, Locale Intl, Date
    futures.add(Preference.init());
    futures.add(Timezone.init(false));

    router.loadConfig();
    bool embedded = false;
    if (router.hasParam(Router.P_SERVERURI)) {
      serverUri = router.param(Router.P_SERVERURI);
      embedded = true;
    }
    if (router.hasParam(Router.P_TEST)) {
      test = ("true" == router.param(Router.P_TEST));
    }
    Service.init(serverUri, clientPrefix:clientPrefix, embedded:embedded, test:test);

    //
    completer.complete(Future.wait(futures));
    return completer.future;
  } // init


  /**
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   * optional [classList] (if mot defined, container/fluid)
   */
  static PageSimple createPageSimple({String id: "wrap",
      bool clearContainer: true, List<String> classList}) {
    if (router.hasParam(Router.P_LOADDIV)) {
      id = router.param(Router.P_LOADDIV);
    }
    if (router.hasParam(Router.P_CLEARCONTAINER)) {
      clearContainer = "true" == router.param(Router.P_CLEARCONTAINER);
    }
    /*
    if (router.hasParam(Router.P_FLUID)) {
      fluid = "true" == router.param(Router.P_FLUID);
    }
    if (router.hasParam(Router.P_ADDHEADER)) {
      addHeader = "true" == router.param(Router.P_ADDHEADER);
    }
    if (router.hasParam(Router.P_ADDNAV)) {
      addNav = "true" == router.param(Router.P_ADDNAV);
    }
    */

    PageSimple page = LightningDart.createPageSimple(id:id, clearContainer:clearContainer, classList:classList);
    Service.onServerStart = page.onServerStart;
    Service.onServerSuccess = page.onServerSuccess;
    Service.onServerError = page.onServerError;
    return page;
  } // createPageSimple


  /**
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   * optional [classList] (if mot defined, container/fluid)
   */
  static AppsMain createAppsMain({String id: "wrap",
      bool clearContainer: true, List<String> classList}) {
    if (router.hasParam(Router.P_LOADDIV)) {
      id = router.param(Router.P_LOADDIV);
    }
    if (router.hasParam(Router.P_CLEARCONTAINER)) {
      clearContainer = "true" == router.param(Router.P_CLEARCONTAINER);
    }
    // Top Level Main
    Element e = querySelector("#${id}");
    if (e == null) {
      for (String cls in PageSimple.MAIN_CLASSES) {
        e = querySelector(".${cls}");
        if (e != null) {
          break;
        }
      }
    }
    AppsMain main = null;
    if (e == null) {
      Element body = document.body; // querySelector("body");
      main = new AppsMain(new DivElement(), id, classList:classList);
      body.append(main.element);
    } else {
      LightningDart.devTimestamp = e.attributes["data-timestamp"];
      if (clearContainer) {
        e.children.clear();
      }
      main = new AppsMain(e, id, classList:classList);
    }
    //
    Service.onServerStart = main.onServerStart;
    Service.onServerSuccess = main.onServerSuccess;
    Service.onServerError = main.onServerError;

    _log.info("createAppsMain ${id} version=${LightningDart.VERSION} timestamp=${LightningDart.devTimestamp}");
    return main;
  } // createAppsMain

} // LightningCtrl
