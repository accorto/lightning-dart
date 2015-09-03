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

  /**
   * Send Message to Logging service
   */
  static void sendLogMsg(String subject, String message) {
    _instance.appsMsg(subject, message);
  }


  /**
   * Logging Setup
   */
  factory RemoteLogger() => _instance;
  static RemoteLogger _instance = new RemoteLogger._internal();
  RemoteLogger._internal() {
    // Error Logger
    Logger.root.onRecord.listen((LogRecord record) {
      if (record.level.value >= Level.INFO.value) // info and higher
        appsLogger(record);
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
    sendWebLog(map);
  } // appsMsg

  /// log record
  void appsLogger(LogRecord record) {
    var map = {
      "seq" : record.sequenceNumber,
      "time" : record.time.millisecondsSinceEpoch,
      "logger" : record.loggerName,
      "level" : record.level.name,
      "message" : record.message
    };
    if (record.error != null) {
      map["error"] = record.error.toString();
      if (record.error is StackTrace) {
        try {
          Trace t = new Trace.from(record.error); // js
          map["errorStack"] = t.toString();
        } catch (error) {
          map["errorError"] = "${error}";
        }
      }
      if (record.error is Event) {
        Event evt = record.error as Event;
        if (evt.target is HttpRequest) {
          HttpRequest request = evt.target;
          try {
            map["errorText"] = request.responseText;
          } catch (ex) {}
          try {
            map["errorStatus"] = request.statusText;
          } catch (ex) {}
        }
      }
    }
    if (record.stackTrace != null) {
      map["stack"] = record.stackTrace.toString();
    }
    // add context
    ClientEnv.addToLogRecord(map);
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
    if (_sendWebLogErrors > 9) {
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
