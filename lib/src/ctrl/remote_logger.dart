/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 *  (Remote) Logging services
 *    static Logger _log = new Logger("x");
 *  send messages
 *    RemoteLogger.sendLogMsg("s","m");
 */
class RemoteLogger {

  /** Transaction Name */
  static const String TRX = "webLog";
  /// Enable Logging
  static bool enabled = false;

  /**
   * Log Record to Map
   *
  static Map<String,dynamic> _formatMap(LogRecord rec) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['level'] = rec.level.toString();
    data['logger'] = rec.loggerName;
    data['event'] = rec.message;
    // error
    if (rec.error != null) {
      data["error"] = rec.error.toString();
      if (rec.error is StackTrace) {
        try {
          Trace t = new Trace.from(rec.error); // js
          data["errorStack"] = t.toString();
        } catch (error) {
          data["errorError"] = "${error}";
        }
      }
      if (rec.error is Event) {
        Event evt = rec.error as Event;
        if (evt.target is HttpRequest) {
          HttpRequest request = evt.target;
          try {
            data["errorText"] = request.responseText;
          } catch (ex) {}
          try {
            data["errorStatus"] = request.statusText;
          } catch (ex) {}
        }
      }
    }
    if (rec.stackTrace != null) {
      if (rec.stackTrace is StackTrace) {
        Trace t = new Trace.from(rec.stackTrace); // js
        data["stack"] = t.toString();
      } else {
        data["stackString"] = rec.stackTrace.toString();
      }
    }
    //
    data["seq"] = rec.sequenceNumber;
    data["time"] = rec.time.millisecondsSinceEpoch;
    //
    // add context
    data['clientId'] = Service.clientId;
    ClientEnv.logInfoMap(data);
    return data;
  } // _formatMap */

  /**
   * Log Record to String
   */
  static String _format(LogRecord rec) {
    // log local time
    String s = "${rec.time} ${rec.level} ${rec.loggerName} ${rec.message}";
    // error
    if (rec.error != null) {
      s += " error=${rec.error}";
      if (rec.error is StackTrace) {
        try {
          Trace t = new Trace.from(rec.error); // js
          s += " errorStack=${t}";
        } catch (ex) {}
      }
      if (rec.error is Event) {
        Event evt = rec.error as Event;
        if (evt.target is HttpRequest) {
          HttpRequest request = evt.target;
          try {
            s += " errorText=${request.responseText}";
          } catch (ex) {}
          try {
            s += " errorStatus=${request.statusText}";
          } catch (ex) {}
        }
      }
    }
    if (rec.stackTrace != null) {
      if (rec.stackTrace is StackTrace) {
        Trace t = new Trace.from(rec.stackTrace); // js
        s += " stack=${t}";
      } else {
        s += " stackString=${rec.stackTrace}";
      }
    }

    // add context
    s += ClientEnv.logInfo(" ");
    s += " clientId=${Service.clientId}";
    return s;
  }

  /*
  static Map<String, dynamic> _pageMap () {
    Map<String, dynamic> data = new Map<String, String>();
    data['trace'] = Service.clientId;
    data['level'] = 'PAGE';
    data['url'] = window.location.pathname;
    data['referrer'] = document.referrer;

    Screen scr = window.screen;
    data['screen'] = {
      'width': scr.width,
      'height': scr.height,
      'depth': scr.pixelDepth};
    data['window'] = {
      'width': window.innerWidth,
      'height': window.innerHeight};

    Navigator nav = window.navigator;
    data['browser'] = {
      'name': nav.appName,
      'version': nav.appVersion,
      // 'ua': nav.userAgent,
      'lang': nav.language,
      'cookie_enabled': nav.cookieEnabled,
      'do_not_track': nav.doNotTrack};
    data['platform'] = nav.platform;
    return data;
  } // pageMap */

  /**
   * Send Message to Logging service
   */
  static void sendLogMsg(String subject, String message) {
    _instance.appsMsg(subject, message);
  }

  /**
   * Remote (Error) Logging Setup
   */
  factory RemoteLogger() => _instance;
  static RemoteLogger _instance = new RemoteLogger._internal();
  RemoteLogger._internal() {
    Logger.root.onRecord.listen((LogRecord record) {
      if (record.level.value >= Level.INFO.value) { // info and higher
        appsLogger(record);
      }
    });
    // unload
    window.onUnload.listen((e){
      ServiceAnalytics.sendUnload();
    });
  } // RemoteLogger

  /**
   * Publish to Log service of Apps Server
   */
  void appsMsg(String subject, String message) {
    var map = {
      "subject" : subject,
      "message" : message
    };
    sendWebLogMap(map);
  } // appsMsg

  /// Publish [record] to /webLog
  void appsLogger(LogRecord record) {
    // Map<String, dynamic> data = _formatMap(record);
    String dataString = _format(record);
    // send
    try {
      sendWebLog(dataString);
    } catch (error, stackTrace) {
      print(new RequestResponse(TRX, error, stackTrace, popup: false).toStringX()
      + " (1) errors=${_sendWebLogErrors}");
    }
  } // appsLogger

  /// Publish [data] to /webLog
  void sendWebLogMap(Map<String, dynamic> data) {
    String dataString = LUtil.toJsonString(data);
    // send
    try {
      sendWebLog(dataString);
    } catch (error, stackTrace) {
      print(new RequestResponse(TRX, error, stackTrace, popup: false).toStringX()
          + " (1) errors=${_sendWebLogErrors}");
    }
  }

  /// Publish [dataString] to /webLog
  void sendWebLog(String dataString) {
    if (!enabled || _sendWebLogErrors > 9) {
      return;
    }
    String url = "${Service.serverUrl}${TRX}";
    HttpRequest.request(url, method: 'POST', sendData: dataString)
    .then((HttpRequest response) {
      _sendWebLogErrors = 0;
    })
    .catchError((Event error, StackTrace stackTrace) {
      _sendWebLogErrors++;
      print(new RequestResponse(TRX, error, stackTrace, popup: false).toStringX()
      + " (2) errors=${_sendWebLogErrors}");
    });
  } // toWebLog
  int _sendWebLogErrors = 0;

} // RemoteLogger
