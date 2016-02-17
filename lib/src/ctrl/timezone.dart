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
  static const String FALLBACK_SERVER = "http://quando.bizquando.com/";

  /**
   * Load Time Zones
   */
  static Future<bool> init(bool onlyIfEmpty) {
    Completer<bool> completer = new Completer<bool>();
    if (onlyIfEmpty && TZ.tzListJson != null && TZ.tzListJson.isNotEmpty) {
      completer.complete(true);
      return completer.future;
    }

    String url = "${Service.serverUrl}timeZone";
    HttpRequest.getString(url)
    .then((String jsonText) {
      TZ.tzListJson = JSON.decode(jsonText);
      _log.config("loadTz #${TZ.tzListJson.length}");
      completer.complete(true);
    })
    .catchError((error, stackTrace) {
      _log.warning("loadTz for ${url}"); // error=_XMLHttpRequestProgressEvent
      // Fallback
      url = "${FALLBACK_SERVER}timeZone";
      HttpRequest.getString(url)
      .then((String jsonText) {
        TZ.tzListJson = JSON.decode(jsonText);
        _log.config("loadTz #${TZ.tzListJson.length}");
        completer.complete(true);
      })
      .catchError((error, stackTrace) {
        _log.warning("loadTz(2) for ${url}");
        // Stop waiting
        TZ.tzListJson = new List<TZ>();
        completer.complete(false);
      });
    });
    return completer.future;
  } // loadTzData

} // Timezone
