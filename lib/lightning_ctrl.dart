/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

library lightning_ctrl;

/**
 * Lightning Controller Functionality
 */

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


part 'src/ctrl/form_ctrl.dart';
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
part 'src/ctrl/timezone.dart';

/**
 * Lightning Controller
 */
class LightningCtrl {

  /// Router Instance
  static final Router router = new Router();


  /**
   * Initialize Logging, Locale, Intl, Date
   * optional [serverUri] to overwrite target
   */
  static Future<List<Future>> init(String serverUri,
      {String clientPrefix: "ui/", bool embedded: false, bool test: false}) {

    Completer<List<Future>> completer = new Completer<List<Future>>();
    List<Future> futures = new List<Future>();
    if (Service.trxNo != -1) { // // already initialized
      completer.complete(futures);
      return completer.future;
    }
    //
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
  static PageMain createPageMain({String id: "wrap",
      bool clearContainer: true, List<String> classList}) {
    if (router.hasParam(Router.P_LOADDIV)) {
      id = router.param(Router.P_LOADDIV);
    }
    if (router.hasParam(Router.P_CLEARCONTAINER)) {
      clearContainer = "true" == router.param(Router.P_CLEARCONTAINER);
    }

    PageMain page = LightningDart.createPageMain(id:id, clearContainer:clearContainer, classList:classList);
    Service.onServerStart = page.onServerStart;
    Service.onServerSuccess = page.onServerSuccess;
    Service.onServerError = page.onServerError;
    return page;
  } // createPageMain

} // LightningCtrl



/**
 * Utilities
 */
class LUtil {

  /// format bytes
  static String formatBytes(int b) {
    if (b < 1024)
      return "${b}B";
    double kb = b / 1024;
    if (kb < 10)
      return "${kb.toStringAsFixed(1)}kB";
    double mb = kb / 1024;
    if (mb < 1)
      return "${kb.toInt()}kB";
    if (mb < 10)
      return "${mb.toStringAsFixed(1)}MB";
    double gb = mb / 1024;
    if (gb < 1)
      return "${mb.toInt()}MB";
    return "${gb.toStringAsFixed(1)}GB";
  }

  /// convert [data] map to json string
  static String toJsonString(Map<String,String> data) {
    StringBuffer sb = new StringBuffer();
    String sep = "{";
    data.forEach((K,V){
      String value = "${V}".replaceAll(_reQuote, "'"); // replace "
      sb.write('${sep}"${K}":"${value}"');
      sep = ",";
    });
    sb.write("}");
    return sb.toString();
  }
  static RegExp _reQuote = new RegExp(r'"');

  /// convert [rext] to html - replace cr with <br/>
  static String textToHtml(String text) {
    if (text == null || text.isEmpty)
      return "";
    String text0 = text.replaceAll(_apro, "'"); // should be text apostrophe
    String text1 = _sanitizer.convert(text0);
    String text2 = text1.replaceAll(_crlf, "<br/>");
    return text2;
  }
  static RegExp _apro = new RegExp(r'&#39;');
  static RegExp _crlf = new RegExp(r'[\n\r]');
  static HtmlEscape _sanitizer = new HtmlEscape(HtmlEscapeMode.ELEMENT);


  /// Same day
  static bool isSameDay(DateTime one, DateTime two) {
    if (one == null || two == null)
      return false;
    return one.year == two.year
    && one.month == two.month
    && one.day == two.day;
  } // isSameDay


} // LUtil
