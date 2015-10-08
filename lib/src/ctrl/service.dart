/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/// Info Server Communication Start (busy)
typedef void ServerStart(String trxName, String info);
/// Info Server Communication Success (busy, msg)
typedef void ServerSuccess(SResponse response, String dataDetail);
/// Info Server Communication Error (busy, msg)
typedef void ServerError(var error);

/// Notification History Tracking
typedef void SendNotification(ServiceResponse level, String subject, String info, Int64 notificationTime, String details);

/**
 * Service Base
 * set callbacks like [onServerStart]
 * handles rr.proto
 * - CRequest, CEnv
 * - SResponse
 */
class Service {

  /** Product Name */
  static String productName = "Accorto";
  /** Client UUID */
  static String clientId = "-";
  /** Server Url */
  static String serverUrl = "/";
  /** Client (ui) Url on core */
  static String clientUrl = "";
  /** Client Url prefix on core */
  static String clientPrefix = "";
  /** Trx No */
  static int trxNo = -1;
  /// Start Time
  static final DateTime startTime = new DateTime.now();
  /// Uptime (duration)
  static Duration get upTime => new DateTime.now().difference(startTime);

  /** Development Mode */
  static bool devMode = false;
  /** Protocol Buffers Header */
  static Map<String, String> requestHeaders = new Map<String, String>();
  /** Add Geo Location automatically */
  static bool addGeo = false;

  /// Call when Server Start (busy)
  static ServerStart onServerStart;
  /// Call when Success
  static ServerSuccess onServerSuccess;
  /// Call when error
  static ServerError onServerError;
  /// Send/Create notification
  static SendNotification sendNotification;

  /// Logger
  static Logger _log;

  /**
   * Initialize Services - optional set [serverUri] when testing
   * e.g. "http://localhost:6666/" updating [serverUrl]
   */
  static void init(String serverUri, {String clientPrefix: "ui/", bool embedded: false, bool test: false}) {
    _log = new Logger("Service");
    Service.clientPrefix = clientPrefix;

    // DartEditor runs on http://localhost:8080/index.html
    // Redirect Server Url /
    String url = window.location.href;
    if (serverUri != null && serverUri.isNotEmpty) {
      if (url.contains("localhost")) {
        serverUrl = serverUri;
        clientUrl = serverUri + clientPrefix;
        test = true;
      }
      if (embedded) {
        serverUrl = serverUri;
        clientUrl = serverUri + clientPrefix;
      }
    }
    if (clientUrl.isEmpty && serverUrl != "/") {
      clientUrl = serverUrl + clientPrefix;
    }
    devMode = test;

    // Server request init
    trxNo = 0;
    requestHeaders["Accept"] = "application/x-google-protobuf";
    requestHeaders["Content-Type"] = "application/x-google-protobuf";

    // ClientId
    String param = LightningCtrl.router.queryParams["clientId"];
    if (param != null && param.isNotEmpty) {
      clientId = param;
    } else {
      Uuid uuid = new Uuid();
      clientId = uuid.v1(); // time based
    }
    //
    //devTimestamp = BizPage.wrap.attributes["data-timestamp"];
    _log.info("href=${window.location.href} (${document.referrer}) serverUrl=${serverUrl} client=${clientUrl} query=${LightningCtrl.router.queryParams}");
  } // init



  /**
   * Create Client Request for [serverUri] with user [info].
   * Request GeoLocation [withGeo] for this - defaults to [addGeo]
   */
  CRequest createCRequest(String serverUri, String info, {bool withGeo: false}) {
    trxNo++;
    DateTime now = new DateTime.now();
    //
    CEnv env = new CEnv()
      ..clientUrl = window.location.href
      ..serverUrl= serverUrl
      ..locale = ClientEnv.localeName
      ..timeZone = now.timeZoneName // initial guess
      ..timeZoneUtcOffset = now.timeZoneOffset.inMinutes
      ..isDevMode = devMode;
    // geo
    try {
      if (addGeo || withGeo) {
        CGeo.get(env);
      } else {
        CGeo.set(env); // if available
      }
    } catch (error, stackTrace) {
      _log.config("geo", error, stackTrace);
    }
    // tz
    if (ClientEnv.timeZone == null)
      env.timeZone = TzRef.alias(now.timeZoneName);
    else
      env.timeZone = ClientEnv.timeZone.id; // user selection
    //
    CRequest request = new CRequest()
      ..trxType = serverUri
      ..trxNo = trxNo
      ..info = info
      ..clientRequestTime = new Int64(now.millisecondsSinceEpoch)
      ..clientId = clientId
      ..env = env;
    if (ClientEnv.session != null) {
      if (ClientEnv.session.hasSid())
        request.sid = ClientEnv.session.sid;
      if (ClientEnv.session.hasSfEndpoint())
        request.sfEndpoint = ClientEnv.session.sfEndpoint;
      if (ClientEnv.session.hasSfToken())
        request.sfToken = ClientEnv.session.sfToken;
    }
    //
    _log.fine("${serverUri} ${trxNo}: ${info}");
    return request;
  } // createCRequest

  /**
   * Send Request (Template/Example)
   *
      Future<SResponse> _sendTemplate (String trx, String info) {
      CRequest request = createCRequest(trx, info);
      //
      Completer<SResponse> completer = new Completer<SResponse>();
      sendRequest(trx, request.writeToBuffer(), info)
      .then((HttpRequest httpRequest) {
      List<int> buffer = new Uint8List.view(httpRequest.response);
      SResponse response = new SResponse.fromBuffer(buffer);
      handleSuccess(info, response);
      completer.complete(response);
      })
      .catchError((Event error, StackTrace stackTrace) {
      String message = handleError(trx, error, stackTrace);
      completer.completeError(message);
      });
      return completer.future;
      } */

  /**
   * Create+Send protocol buffers HttpRequest to [trx] with [data]
   */
  Future<HttpRequest> sendRequest(String serverUri, Uint8List data, String info, {bool setBusy: true}) {
    if (setBusy && onServerStart != null) {
      onServerStart(serverUri, info);
    }
    Uri uri = Uri.parse("${serverUrl}${serverUri}");
    String url = uri.toString();
    return HttpRequest.request(url,
      method: "POST",
      withCredentials: false,
      responseType: "arraybuffer",
      mimeType: "application/x-google-protobuf",
      requestHeaders: requestHeaders,
      sendData: data);
  } // sendRequest

  /**
   * Handle Success - send notifications, unlock ui
   */
  String handleSuccess(String subject, SResponse sresponse, int length, {bool setBusy: true}) {
    sresponse.clientReceiptTime = new Int64(new DateTime.now().millisecondsSinceEpoch);
    String details = "${sresponse.trxType}#${sresponse.trxNo} ${subject} ${ServiceTracker.formatDuration(sresponse)} ${ClientEnv.numberFormat_1.format(length/1024)}k";
    if (setBusy && onServerSuccess != null)
      onServerSuccess(sresponse, details);
    if (sendNotification != null) {
      sendNotification(sresponse.isSuccess ? ServiceResponse.Ok : ServiceResponse.Error,
        subject, sresponse.msg, sresponse.clientReceiptTime, details);
    }
    return details;
  } // handleSuccess

  /**
   * Handle Error and return string error message
   */
  String handleError(String trx, Event error, StackTrace stackTrace) {
    RequestResponse rr = new RequestResponse(trx, error, stackTrace, popup: true);
    String subject = rr.subject;
    String message = rr.toString();
    //
    if (onServerError != null) {
      if (message == null || message.isEmpty)
        onServerError(subject);
      else
        onServerError("${subject}: ${message}");
    }
    if(sendNotification != null)
      sendNotification(ServiceResponse.Failure, subject, message, null, null);
    return message;
  } // handleError


  /** Add Tab with Service Info
  static void addServiceTab(BsTab tab) {
    DivElement content = tab.addTab("srv", "Service", iconClass: "icon-power");
    MiniTable mt = new MiniTable(responsive: true);
    content.append(mt.element);

    mt.addRowHdrData("Started", startTime);
    mt.addRowHdrData("Uptime", upTime);

    mt.addRowHdrData("Server Url", serverUrl);
    mt.addRowHdrData("Client Url", clientUrl);
    mt.addRowHdrData("Client Href", window.location.href);
    mt.addRowHdrData("Client Id", clientId);

    mt.addRowHdrData("Dev Mode", devMode.toString());
    mt.addRowHdrData("Timestamp", devTimestamp);
    mt.addRowHdrData("Geo info", addGeo.toString());

    mt.addRowHdrData("Client Transactions", trxNo);
  } // addServiceTab */

} // Service

/// Service Response
enum ServiceResponse {
  Ok, Error, Failure
}


/**
 * HttpRequest Response
 */
class RequestResponse {

  /// subject
  String subject;
  /// http status number
  int status;
  /// http status text
  String statusText;
  /// message
  String message;
  /// response type
  String type;
  /// response headers
  Map<String,String> headers;

  /**
   * HttpRequest Response
   */
  RequestResponse (String trx, Event error, StackTrace stackTrace, {bool popup: false}) {
    subject = "Cannot contact Server ${Service.serverUrl}${trx}";
    if (error.target is HttpRequest) {
      HttpRequest request = error.target;
      try {
        status = request.status;
        statusText = request.statusText;
        if (status != 0 || statusText.isNotEmpty)
          subject = "${Service.serverUrl}${trx}: ${statusText} (${status})";
      } catch (ex) {}

      try {
        type = request.responseType;
        headers = request.responseHeaders;
        message = request.responseText;
      } catch (ex) {}

      try {
        if (type == "arraybuffer") {
          Object response = request.response;
          List<int> buffer = new Uint8List.view(response);
          message = _getServerMsg(buffer);
        }
        else {
        }
      } catch (ex) {}
    } // HttpRequest

    if (popup)
      showPopup();
  } // RequestResponse

  /// message and headers
  @override
  String toString() {
    if (headers != null && headers.isNotEmpty) {
      if (message == null && message.isEmpty)
        return headers.toString();
      return "${message} ${headers}";
    }
    return message;
  } // toString

  /// subject - message
  String toStringX() {
    if (message == null || message.isEmpty)
      return subject;
    return "${subject} - ${toString()}";
  } // toString

  /**
   * Get Server (Error) Message
   */
  String _getServerMsg(List<int> buffer) {
    if (buffer == null)
      return "";
    String html;
    try {
      html = new String.fromCharCodes(buffer);
      // get heading 1
      RegExp exp = new RegExp(r"<h1>.*</h1>");
      String info = exp.stringMatch(html);
      if (info != null && info.isNotEmpty)
        return info.replaceAll("<h1>", "").replaceAll("</h1>", "");
      // get title
      exp = new RegExp(r"<title>.*</title>");
      info = exp.stringMatch(html);
      if (info != null && info.isNotEmpty)
        return info.replaceAll("<title>", "").replaceAll("</title>", "");
      //
      return html;
    } catch (e) {
      return "";
    }
  } // getServerMsg

  /**
   * Show popup if error
   */
  void showPopup() {
    if (status == 0 || status >= 300)
      _showModal(status == 0 || status >= 400);
  } // showPopup

  // Service Error Dialog
  void _showModal(bool reload) {
    LModal modal = new LModal("error-rr");
    modal.setHeader(serviceComErrorTitle(), tagLine:subject, icon:new LIconUtility(LIconUtility.OFFLINE));
    if (message != null) {
      ParagraphElement p = new ParagraphElement()
        ..text = message;
      modal.append(p);
    }
    //
    LTable details = new LTable("error-details", optionRowSelect:false);
    modal.add(details);
    details.addRowHdrData("Status", "${status} ${statusText}");
    details.addRowHdrData("Url", window.location.href);
    // Parameter
    LightningCtrl.router.queryParams.forEach((String key, String value){
      details.addRowHdrData("P: ${key}", value);
    });
    //
    ParagraphElement p = new ParagraphElement()
      ..text = serviceComErrorMsg();
    modal.append(p);
    //
    if (reload) {
      LButton reload = modal.addFooterButtons(saveNameOverride:serviceComErrorButton(), addCancel:false);
      reload.onClick.listen((e){
        window.location.reload();
      });
    }
    modal.showInElement(AppsMain.modals);
  } // _showModal


  // Translation
  static String serviceComErrorTitle() => Intl.message("Communication Error", name: "serviceComErrorTitle");
  static String serviceComErrorMsg() => Intl.message("Sorry about this - please try again later.", name: "serviceComErrorMsg");
  static String serviceComErrorButton() => Intl.message("Reload Page", name: "serviceComErrorButton");

} // RequestResponse


/**
 * GeoLocation
 */
class CGeo {

  static Logger _log = new Logger("CGeo");

  /// last position
  static Geoposition lastPos;
  /// last error
  static PositionError lastError;
  /// API error
  static int _errorCode = null;

  /**
   * Set CEnv lat/lon if supported and available
   */
  static void set(CEnv env) {
    if (env != null) {
      if (_errorCode != null) {
        env.geoError = _errorCode;
        return;
      }

      if (lastPos != null && lastPos.coords != null) {
        if (lastPos.coords.latitude != null)
          env.lat = lastPos.coords.latitude;
        if (lastPos.coords.longitude != null)
          env.lon = lastPos.coords.longitude;
        if (lastPos.coords.altitude != null)
          env.alt = lastPos.coords.altitude;
        if (lastPos.coords.heading != null)
          env.dir = lastPos.coords.heading;
        if (lastPos.coords.speed != null)
          env.speed = lastPos.coords.speed;
      } else if (lastError != null && lastError.code != null) {
        env.geoError = lastError.code;
      }
    }
  } // set

  /**
   * Get Geoposition and set (async)
   */
  static void get(CEnv env) {
    if (_errorCode != null) {
      if (env != null)
        env.geoError = _errorCode;
      return;
    }
    if (window.navigator.geolocation != null) {
      set(env); // previous - might be a long delay if manually approved
      // https://developer.mozilla.org/en-US/docs/Web/API/Geolocation/getCurrentPosition
      window.navigator.geolocation.getCurrentPosition()
      .then((Geoposition pos){
        if (pos == null) {
          _log.config("get noPosition");
        } else {
          if (pos.coords == null) {
            _log.config("get noCoords ${pos}");
          } else {
            _log.config("get lat=${pos.coords.latitude} lon=${pos.coords.longitude} alt=${pos.coords.altitude} dir=${lastPos.coords.heading} speed=${lastPos.coords.speed}");
            lastPos = pos;
            _errorCode = null;
            set(env);
          }
        }
      })
      .catchError((error, stackTrace){
        if (error is PositionError) {
          lastError = error;
          _log.config("get code=${lastError.code} message=${lastError.message}");
          if (lastError.code == PositionError.PERMISSION_DENIED // 1
          //|| lastError.code == PositionError.POSITION_UNAVAILABLE // 2
          //|| lastError.code == PositionError.TIMEOUT // 3
          )
            _errorCode = lastError.code;
        } else {
          _log.config("get error", error, stackTrace);
          _errorCode = -1;
        }
        if (_errorCode != null)
          env.geoError = _errorCode;
        else if (lastError != null && lastError.code != null)
          env.geoError = lastError.code;
      });
    }
  } // get

} // CGeo

