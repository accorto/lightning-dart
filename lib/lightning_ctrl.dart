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
 *
 * Business Graphics
 * using DRecord and built on Charted
 * include
    <link rel="stylesheet" href="packages/lightning/assets/styles/charted_theme.css">
 *
 */
library lightning_ctrl;

import 'dart:html';
import 'dart:js';
import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'dart:typed_data';

// Packages
import 'package:logging/logging.dart';
import 'package:fixnum/fixnum.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:protobuf/protobuf.dart';
import 'package:intl/intl.dart';

import 'package:charted/charted.dart';
import 'package:observe/observe.dart';

import 'lightning.dart';
export 'lightning.dart';

part 'src/apps/apps_ctrl.dart';
part 'src/apps/apps_header.dart';
part 'src/apps/apps_logout.dart';
part 'src/apps/apps_main.dart';
part 'src/apps/apps_menu.dart';
part 'src/apps/apps_new_window.dart';
part 'src/apps/apps_page.dart';
part 'src/apps/apps_settings.dart';
part 'src/apps/apps_settings_cache.dart';
part 'src/apps/apps_settings_env.dart';
part 'src/apps/apps_settings_tab.dart';

part 'src/ctrl/datasource.dart';
part 'src/ctrl/fk_ctrl.dart';
part 'src/ctrl/fk_dialog.dart';
part 'src/ctrl/fk_multi.dart';
part 'src/ctrl/fk_multi_dialog.dart';
part 'src/ctrl/fk_service.dart';
part 'src/ctrl/fk_service_request.dart';

part 'src/ctrl/form_ctrl.dart';
part 'src/ctrl/object_ctrl.dart';
part 'src/ctrl/object_edit.dart';

part 'src/ctrl/record_ctrl.dart';
part 'src/ctrl/record_ctrl_details.dart';
part 'src/ctrl/record_ctrl_related.dart';
part 'src/ctrl/record_ctrl_related_item.dart';
part 'src/ctrl/record_info.dart';

part 'src/ctrl/remote_logger.dart';
part 'src/ctrl/route.dart';
part 'src/ctrl/router.dart';
part 'src/ctrl/router_path.dart';
part 'src/ctrl/service.dart';
part 'src/ctrl/service_analytics.dart';
part 'src/ctrl/service_tracker.dart';
part 'src/ctrl/table_ctrl.dart';
part 'src/ctrl/table_layout.dart';
part 'src/ctrl/timezone.dart';
part 'src/ctrl/ui_service.dart';

part 'src/graph/graph_calc.dart';
part 'src/graph/graph_engine_panel.dart';
part 'src/graph/graph_panel.dart';
part 'src/graph/engine_base.dart';
part 'src/graph/engine_charted.dart';
part 'src/graph/engine_charted_theme.dart';

/**
 * Lightning Dart Controller main entry point
 *
 *     LightningCtrl.init()
 *     .then((_){
 *       // application code
 *     });
 *
 * - or-
 *
 *    main() async {
 *      await LightningCtrl.init(); // client env
 *      // application code
 *    }
 *
 * To initialize a simple page (ho header, menu, ...)
 *
 *    // example: http://lightningdart.com/exampleForm.html
 *    // https://github.com/accorto/lightning-dart/blob/master/web/exampleForm.dart
 *    LightningCtrl.createPageSimple()
 *      ..add(...content...);
 *
 * or
 *
 *    // example: http://lightningdart.com/exampleWorkspace.html
 *    // https://github.com/accorto/lightning-dart/blob/master/web/exampleWorkspace.dart
 *    LightningCtrl.createAppsMain();
 *
 *
 */
class LightningCtrl {

  static final Logger _log = new Logger("LightningCtrl");

  /// Router Instance
  static final Router router = new Router();
  static String productCode;
  static String productLabel;

  /**
   * Initialize Logging, Locale, Intl, Date
   * [serverUri] e.g. "/"
   */
  static Future<List<Future>> init(String productCode, String productLabel, String serverUri) {
    LightningCtrl.productCode = productCode;
    LightningCtrl.productLabel = productLabel;
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

    bool embedded = router.embedded;
    if (router.hasParam(Router.P_SERVERURI)) {
      serverUri = router.param(Router.P_SERVERURI);
    }
    Service.init(serverUri, embedded:embedded);
    futures.add(Timezone.init(false)); // requires server url
    // FK
    EditorUtil.createLookupCall = FkCtrl.createLookup;
    //
    SettingItem si = Settings.setting(Settings.TEST_MODE);
    si.onChange.listen((String newValue) {
      ClientEnv.testMode = (newValue == Settings.VALUE_TRUE);
      if (PageSimple.instance != null) {
        PageSimple.instance.updateTestMode();
      }
    });
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
      clearContainer = router.param(Router.P_CLEARCONTAINER) == "true";
    }

    PageSimple page = LightningDart.createPageSimple(id:id, clearContainer:clearContainer, classList:classList);
    /* if (router.hasParam(Router.P_ADDHEADER)) {
      addHeader = "true" == router.param(Router.P_ADDHEADER);
    }
    if (router.hasParam(Router.P_ADDNAV)) {
      addNav = "true" == router.param(Router.P_ADDNAV);
    } */
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
      clearContainer = router.param(Router.P_CLEARCONTAINER) == "true";
    }
    // Top Level Main
    Element loadDiv = querySelector("#${id}");
    if (loadDiv == null) {
      for (String cls in PageSimple.MAIN_CLASSES) {
        loadDiv = querySelector(".${cls}");
        if (loadDiv != null) {
          break;
        }
      }
    }
    AppsMain main = null;
    if (loadDiv == null) {
      Element body = document.body; // querySelector("body");
      main = new AppsMain(new DivElement(), id, classList:classList);
      body.append(main.element);
    } else {
      LightningDart.devTimestamp = loadDiv.attributes["data-timestamp"];
      if (clearContainer) {
        loadDiv.children.clear();
      }
      main = new AppsMain(loadDiv, id, classList:classList);
    }
    if (router.hasParam(Router.P_ADDHEADER)) {
      if (router.param(Router.P_ADDHEADER) != "true")
        main.showHeader(false);
    }
    if (router.hasParam(Router.P_ADDNAV)) {
      if (router.param(Router.P_ADDNAV) != "true")
        main.showMenuBar(false);
    }
    //
    Service.onServerStart = main.onServerStart;
    Service.onServerSuccess = main.onServerSuccess;
    Service.onServerError = main.onServerError;
    // third log
    _log.info("createAppsMain ${id} version=${LightningDart.VERSION} ts=${LightningDart.devTimestamp}");
    return main;
  } // createAppsMain

} // LightningCtrl
