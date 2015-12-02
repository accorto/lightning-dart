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
   */
  static Map<String,dynamic> _logMap(LogRecord rec) {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data['trace'] = Service.clientId;
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
    ClientEnv.addToLogMap(data);
    return data;
  } // _logMap

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
    le = RemoteLoggerLe.get();
    if (le == null) {
      window.console.info('log');
      Logger.root.onRecord.listen((LogRecord record) {
        if (record.level.value >= Level.INFO.value) { // info and higher
          appsLogger(record);
        }
      });
    } else {
      window.console.info('le');
      Logger.root.onRecord.listen((LogRecord record) {
        if (record.level.value >= Level.INFO.value) { // info and higher
          le.logRecord(record);
        }
      });
    }
    // unload
    window.onUnload.listen((e){
      ServiceAnalytics.sendUnload();
    });

  } // RemoteLogger
  RemoteLoggerLe le;

  /**
   * Publish to Log service of Apps Server
   */
  void appsMsg(String subject, String message) {
    if (le != null) {
      le.info("${subject}: ${message}");
      return;
    }
    var map = {
      "subject" : subject,
      "message" : message
    };
    sendWebLog(map);
  } // appsMsg

  /// log record
  void appsLogger(LogRecord record) {
    Map<String, dynamic> map = _logMap(record);
    // send
    try {
      sendWebLog(map);
    } catch (error, stackTrace) {
      print(new RequestResponse(TRX, error, stackTrace, popup: false).toStringX()
      + " (1) errors=${_sendWebLogErrors}");
    }
  } // appsLogger


  /// Publish [data] to /webLog
  void sendWebLog(Map<String,String> data) {
    if (!enabled || _sendWebLogErrors > 9) {
      return;
    }
    String dataString = LUtil.toJsonString(data);

    String url = "${Service.serverUrl}${TRX}";
    HttpRequest
    .request(url, method: 'POST', sendData: dataString)
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

  /**
   * Publish to SNS
   * https://github.com/aws/aws-sdk-js
   * https://sdk.amazonaws.com/js/aws-sdk-2.0.0-rc13.js
   * https://sdk.amazonaws.com/js/aws-sdk-2.0.0-rc13.min.js
   * http://www.slideshare.net/AmazonWebServices/writing-javascript-applications-with-the-aws-sdk-tls303-aws-reinvent-2013-28869340
   */
  void toSns(String subject, String message) {
    // http://docs.aws.amazon.com/sns/latest/api/API_Publish.html
    // AWS.config.update({accessKeyId: 'akid', secretAccessKey: 'secret'});
    // AWS.config.region = 'us-west-1';
    // http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/frames.html#!AWS/SNS.html
    // var aws = new JsObject(context['AWS']);
  }

} // RemoteLogger
