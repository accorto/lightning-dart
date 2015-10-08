/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * User Analytics
 * - initial
 *    - page load info
 * - trx
 *    - user wait + server time
 * - page change
 *    - time on (last) page
 * - unload
 *    - total time
 */
class ServiceAnalytics {

  /** Transaction Name */
  static const TRX = "webAnalysis"; // WebAnalysisServlet _sourceCategory=BizAnalysis

  /// Enable Analytics
  static bool enabled = false;

  /// initial web info
  static bool _initialSent = false;

  /**
   * Application Timing
   * [utv] timing variable
   */
  static void sendTimingApp(String utv, SResponse response, String details) {
    if (sendTimingWeb(utv, response))
      return;
    // initial
    DateTime now = new DateTime.now();
    Map<String, String> data = _createMap(now);
    data["utv"] = utv;
    _timingResponse(data, response, now);
    if (details != null && details.isNotEmpty)
      data["details"] = details;
    _send(data);
  } // sendTimingApp

  /**
   * Initial User Timing [utc] Category - [utv] Variable name - [utt] Time(ms) - [utl] Label
   * [plt] Page Load Time
   *
   * [rrt] redirect response time
   * [dns] dns time
   * [tcp] tcp connect time
   * [srt] server response time
   * [pdt] page download Time
   * [dit] dom interactive time
   * [clt] content load time
   */
  static bool sendTimingWeb(String utv, SResponse response) {
    if (_initialSent)
      return false;
    _initialSent = response != null;
    DateTime now = new DateTime.now();
    Map<String, String> data = _timingWeb(utv, response, now);
    _send(data);
    return true;
  } // sendTimingWeb

  /**
   * Get Performance Map
   */
  static Map<String, String> _timingWeb(String utv, SResponse response, DateTime now) {
    Map<String, String> data = _createMap(now);
    data["utv"] = utv; // variable name
    if (response.hasInfo())
      data["info"] = response.info;
    Performance perf = window.performance;
    if (perf == null) {
      return data;
    }
    PerformanceTiming timing = perf.timing;
    if (timing == null) {
      return data;
    }

    int utt = now.millisecondsSinceEpoch - timing.navigationStart;
    data["utt"] = utt.toString(); // user total time
    int plt = timing.loadEventEnd - timing.navigationStart;
    data["plt"] = plt.toString(); // page load time
    //
    int rrt = timing.redirectEnd - timing.redirectStart;
    data["rrt"] = rrt.toString(); // redirect response time
    int dns = timing.domainLookupEnd - timing.domainLookupStart;
    data["dns"] = dns.toString(); // dns time
    int tcp = timing.connectEnd - timing.connectStart;
    data["tcp"] = tcp.toString(); // tcp connect time
    int srt = timing.responseStart - timing.requestStart;
    data["srt"] = srt.toString(); // server response time
    int pdt = timing.responseEnd - timing.responseStart;
    data["pdt"] = pdt.toString(); // page download Time
    int dit = timing.domComplete - timing.domLoading;
    data["dit"] = dit.toString(); // dom interactive time
    int clt = timing.loadEventEnd - timing.loadEventStart;
    data["clt"] = clt.toString(); // content load time

    // request response
    if (response != null) {
      _timingResponse(data, response, now, uttName: "ut2");
      int del = response.clientRequestTime.toInt() - timing.navigationStart;
      data["del"] = del.toString();
      // delay
    }
    // general
    data["ul"] = window.navigator.language;
    data["ua"] = window.navigator.userAgent;
    return data;
  } // timingWeb

  /**
   * Get Performance Map
   */
  static void _timingResponse(Map<String, String> data, SResponse response, DateTime now, {String uttName: "utt"}) {
    // total
    int utt = now.millisecondsSinceEpoch - response.clientRequestTime.toInt();
    data[uttName] = utt.toString();
    if (response.hasInfo())
      data["info"] = response.info;

    int svr = response.serverDurationMs.toInt();
    data["svr"] = svr.toString();   // server time
    int sq = response.serverQueueMs;
    data["sq"] = sq.toString();     // server queue
    if (response.hasRemoteMs() && response.remoteMs > 0)  // remote time
      data["rem"] = response.remoteMs.toString();
    int net = response.clientReceiptTime.toInt() - response.clientRequestTime.toInt();
    data["net"] = net.toString();   // net time

    data["trx_type"] = response.trxType;
    data["trx_no"] = response.trxNo.toString();
    data["trx_msg"] = response.msg;
    if (!response.isSuccess)
      data["trx"] = "error";
  } // timingResponse


  /**
   * Send Page with optional page [hash] overwrite
   */
  static void sendPage(DateTime now, String hash, String currentPath, DateTime currentPathTime) {
    Map<String, String> data = _createMap(now);

    data["dh"] = window.location.host;        // document host
    if (hash == null || hash.isEmpty) {
      data["dp"] = window.location.pathname;  // document path
    } else {
      data["dp"] = hash;
    }

    if (currentPath == null) {
      if (document.referrer != null && document.referrer.isNotEmpty)
        data["dr"] = document.referrer;       // document referrer
    } else {
      data["dr"] = currentPath;               // document referrer
      if (currentPathTime != null)
        data["drd"] = now.difference(currentPathTime).inSeconds.toString();
    }
    // general
    Screen scr = window.screen;
    data["sr"] = "${scr.width}x${scr.height}"; // screen resolution
    data["vt"] = "${window.innerWidth}x${window.innerHeight}"; // viewport size
    data["sd"] = "${scr.pixelDepth}-bits"; // screen colors
    _send(data);
  } // sendPage

  /**
   * Send Unload
   */
  static void sendUnload() {
    Map<String, String> data = _createMap(null);
    data["utv"] = "unload"; // variable name

    data["dl"] = window.location.href; // document location
    data["dt"] = document.title; // document title
    data["dr"] = document.referrer; // document referrer

    //
    Screen scr = window.screen;
    data["sr"] = "${scr.width}x${scr.height}"; // screen resolution
    data["vt"] = "${window.innerWidth}x${window.innerHeight}"; // viewport size
    data["sd"] = "${scr.pixelDepth}-bits"; // screen colors
    //
    data["ul"] = window.navigator.language;
    data["ua"] = window.navigator.userAgent;
    //
    data["up"] = Service.upTime.toString(); // uptime
    ClientEnv.addToLogRecord(data);
    //
    String dataString = LUtil.toJsonString(data);
    String url = "${Service.serverUrl}${TRX}";
    if (enabled) {
      window.navigator.sendBeacon(url, dataString);
    }
  } // sendUnload

  /// create map with time based on optional [now]
  static Map<String,String> _createMap(DateTime now) {
    Map<String, String> data = new Map<String, String>();
    if (now == null) {
      data["time"] = new DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      data["time"] = now.millisecondsSinceEpoch.toString();
    }
    return data;
  }

  /// send map
  static void _send(Map<String,String> data) {
    if (!enabled || _sendWebLogErrors > 9) {
      return;
    }
    data["up"] = Service.upTime.inSeconds.toString(); // uptime
    print("analytics ${data}");
    data["upd"] = Service.upTime.toString(); // uptime
    ClientEnv.addToLogRecord(data);
    String dataString = LUtil.toJsonString(data);

    String url = "${Service.serverUrl}${TRX}";
    HttpRequest
    .request(url, method: 'POST', sendData: dataString)
    .then((HttpRequest response){
      _sendWebLogErrors = 0;
    })
    .catchError((Event error, StackTrace stackTrace) {
      _sendWebLogErrors++;
      print(new RequestResponse(TRX, error, stackTrace, popup: false).toStringX());
    });
  }
  static int _sendWebLogErrors = 0;

} // ServiceAnalytics
