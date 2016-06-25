/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning.exampleWorkspace;

/**
 * Login
 */
class WorkspaceLogin
    extends Service {

  static final Logger _log = new Logger("WorkspaceLogin");
  static const String TRX = "webLogin";

  static Future<LoginResponse> login() {
    LoginInfo info = new LoginInfo()
      ..un = "demoadministrator@demo"
      ..pw = "demo";
    WorkspaceLogin service = new WorkspaceLogin();
    return service.send(info, "example login");
  }

  Future<LoginResponse> send (LoginInfo loginInfo, String info) {
    _log.config("send ${info}");
    LoginRequest request = new LoginRequest();
    request.request = createCRequest(TRX, info);
    request.loginInfo = loginInfo;
    //
    Completer<LoginResponse> completer = new Completer<LoginResponse>();
    Uint8List data = null;
    try {
      data = request.writeToBuffer();
    } catch (error, stackTrace) {
      _log.warning("${request}");
      _log.warning("request", error, stackTrace);
      completer.completeError(error);
      return completer.future;
    }

    sendRequest(TRX, data, info, false)
    .then((HttpRequest request) {
      DateTime now = new DateTime.now();
      List<int> buffer = new Uint8List.view(request.response);
      LoginResponse response = new LoginResponse.fromBuffer(buffer);
      SResponse sresponse = response.response;
      sresponse.clientReceiptTime = new Int64(now.millisecondsSinceEpoch);
      String details = handleSuccess(info, sresponse, buffer.length, false);
      ServiceTracker track = new ServiceTracker(response.response, info, details);
      if (response.hasSession()) {
        ClientEnv.session = response.session;
        if (sresponse.isSuccess && AppsMain.instance != null)
          AppsMain.instance.loggedIn = true;
      }
      completer.complete(response);
      _log.info("received ${details}"); // session=${response.hasSession()}
      track.send();
    })

    .catchError((error, StackTrace stackTrace) {
      print(error);
      String message = handleError(TRX, error, stackTrace);
      completer.completeError(message);
    });
    return completer.future;
  } // send

} // WorkspaceLogin
