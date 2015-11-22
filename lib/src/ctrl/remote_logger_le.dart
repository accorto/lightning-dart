/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Remote Logging LogEntries
 * to enable:
 * <script src="packages/lightning/assets/scripts/le.min.js"></script>
 * api doc
 * https://github.com/logentries/le_js/wiki/API
 */
class RemoteLoggerLe {

  /// Logging token
  static String token;

  /// Get Remote Logger (or null)
  static RemoteLoggerLe get() {
    if (token == null || token.isEmpty)
      return null;
    if (_instance == null) {
      _instance = new RemoteLoggerLe._internal();
    }
    if (_instance.valid)
      return _instance;
    return null;
  }
  static RemoteLoggerLe _instance;

  /// LE object
  JsObject le;

  /**
   * Remote Logging
   */
  RemoteLoggerLe._internal() {
    le = context['LE'];
    if (le == null)
      return;

    // default: js.logentries.com/v1
    // window.LEENDPOINT = window.location.host + '/le/v1';
    // in LE: _endpoint = (_SSL ? "https://" : "http://") + _endpoint + "/logs/" + _token;

    Map<String,String> initParams = new Map<String,String>();
    initParams['token'] = token;
    // initParams['ssl'] = 'true';
    initParams['catchall'] = 'true';
    initParams['trace'] = 'true';
    initParams['page_info'] = 'per-page';
    // initParams['print'] = 'true';
    le.callMethod('init', [new JsObject.jsify(initParams)]);
  }
  // logger valid
  bool get valid => le != null;

  void error (String msg) => le.callMethod('error', [msg]);
  void warn (String msg) => le.callMethod('warn', [msg]);
  void info (String msg) => le.callMethod('info', [msg]);
  void log (String msg) => le.callMethod('log', [msg]);

  /**
   * Log Record
   */
  void logRecord(LogRecord rec) {
    String logObject = "${rec.loggerName} ${rec.message}";
    String prefix = "";
    if (rec.error != null) {
      logObject += "\n  ${rec.error}";
      prefix = "\n ";
    }
    if (rec.stackTrace != null) {
      Trace t = new Trace.from(rec.stackTrace);
      logObject += "\n${t}";
      prefix = "\n ";
    }
    logObject != ClientEnv.logInfo(prefix);

    //
    if (rec.level == Level.INFO) {
      le.callMethod('info', [logObject]);
    }
    else if (rec.level == Level.WARNING) {
      le.callMethod('warn', [logObject]);
    }
    else if (rec.level == Level.SEVERE || rec.level == Level.SHOUT) {
      le.callMethod('error', [logObject]);
    }
    else {
      le.callMethod('log', [logObject]);
    }
  } // logRecord

} // RemoteLoggerLe
