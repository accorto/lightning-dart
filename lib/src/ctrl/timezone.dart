/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Load Timezones
 */
class Timezone {

  static final Logger _log = new Logger("Timezone");

  /// Fallback to get time zones
  static final String FALLBACK_SERVER = "http://quando.bizquando.com/";


  /**
   * Load Time Zones
   */
  static Future<bool> init(bool onlyIfEmpty) {
    Completer<bool> completer = new Completer<bool>();
    if (onlyIfEmpty && TZ.tzList != null && TZ.tzList.isNotEmpty) {
      completer.complete(true);
      return completer.future;
    }

    String url = "${Service.serverUrl}timeZone";
    HttpRequest.getString(url)
    .then((String jsonText) {
      TZ.tzList = JSON.decode(jsonText);
      _log.config("loadTz #${TZ.tzList.length}");
      completer.complete(true);
    })
    .catchError((error, stackTrace) {
      _log.warning("loadTz for ${url}"); // error=_XMLHttpRequestProgressEvent
      // Fallback
      url = "${FALLBACK_SERVER}timeZone";
      HttpRequest.getString(url)
      .then((String jsonText) {
        TZ.tzList = JSON.decode(jsonText);
        _log.config("loadTz #${TZ.tzList.length}");
        completer.complete(true);
      })
      .catchError((error, stackTrace) {
        _log.warning("loadTz(2) for ${url}");
        // Stop waiting
        TZ.tzList.add(new TZ("{}"));
        completer.complete(false);
      });
    });
    return completer.future;
  } // loadTzData

} // Timezone
