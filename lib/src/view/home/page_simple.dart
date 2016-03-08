/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Simple Page with Status Toast
 *
 * create directly -or-
 *
 *    // example: http://lightningdart.com/exampleForm.html
 *    // https://github.com/accorto/lightning-dart/blob/master/web/exampleForm.dart
 *    LightningDart.createPageSimple();
 *
 * -or-
 *
 *    LightningCtrl.createPageSimple();
 *
 *  status
 *  - busy: element(#wrap) has class "busy"
 *  - process: element(#wrap) attributes data-success/data-detail
 *
 * Testing:
 * element .status-info (hidden at document end) or .status-test changes the id
 * - status-none, status-busy, status-ok, status-error
 * containing last status details
 */
class PageSimple
    extends LComponent {

  static final Logger _log = new Logger("PageSimple");

  /// Current Instance
  static PageSimple instance;

  /// Search for classes to find main element
  static final List<String> MAIN_CLASSES = [LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID,
    LGrid.C_CONTAINER__LARGE, LGrid.C_CONTAINER__MEDIUM, LGrid.C_CONTAINER__SMALL, LGrid.C_GRID];

  static const String STATUS_ID_NONE = "status-none";
  static const String STATUS_ID_BUSY = "status-busy";
  static const String STATUS_ID_OK = "status-ok";
  static const String STATUS_ID_ERROR = "status-error";

  /// Outer Page Element
  final Element element;
  /// Status Element
  final DivElement _statusElement = new DivElement()
    ..id = STATUS_ID_NONE
    ..text = ".";

  /// Status messages
  static final List<StatusMessage> statusMessages = new List<StatusMessage>();

  /**
   * Simple Page
   * optional [classList] (if mot defined, container/fluid)
   */
  PageSimple(Element this.element, String id,
        {List<String> classList}){
    instance = this;
    element.classes.clear();
    if (classList != null && classList.isNotEmpty) {
      element.classes.addAll(classList);
    } else {
      element.classes.addAll([LGrid.C_GRID, LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID]);
    }
    element.id = id;
    // add status
    if (element.parent == null) {
      element.append(_statusElement);
    } else {
      element.parent.append(_statusElement);
    }
    updateTestMode();
  } // PageSimple

  /// Test Mode Update
  void updateTestMode() {
    // status info
    if (ClientEnv.testMode) {
      _statusElement.classes.remove("status-info");
      _statusElement.classes.add("status-test");
    } else {
      _statusElement.classes.remove("status-test");
      _statusElement.classes.add("status-info");
    }
  }

  /// Server Start (busy)
  void onServerStart(String trxName, String info) {
    _statusElement.id = STATUS_ID_BUSY;
    setStatus(StatusMessage.busy);
    busy = true;
  }
  /// Info Server Communication Success (busy/msg)
  void onServerSuccess(SResponse response, String details) {
    busy = false;
    setStatus(new StatusMessage.response(response, details));
    _statusElement.id = STATUS_ID_OK;
  }
  /// Info Server Communication Error
  void onServerError(var error) {
    busy = false;
    setStatus(new StatusMessage.errorInfo(error));
    _statusElement.id = STATUS_ID_ERROR;
  } // onServerError

  /// Info Status with (i)
  void setStatusInfo(String message, {String detail, String dataSuccess, String dataDetail}) {
    setStatus(new StatusMessage.info(message, detail, dataSuccess, dataDetail));
  }
  /// Success Status with check
  void setStatusSuccess(String message, {String detail, String dataSuccess: Html0.V_TRUE, String dataDetail}) {
    setStatus(new StatusMessage.success(message, detail, dataSuccess, dataDetail));
  }
  /// Warning Status with triangle
  void setStatusWarning(String message, {String detail, String dataSuccess: Html0.V_FALSE, String dataDetail}) {
    setStatus(new StatusMessage.warning(message, detail,  dataSuccess, dataDetail));
  }
  /// Error Status with fire
  void setStatusError(String message, {String detail, String dataSuccess: StatusMessage.ERROR, String dataDetail}) {
    setStatus(new StatusMessage.error(message, detail, dataSuccess, dataDetail));
  }
  /// Default Status
  void setStatusDefault(String message, {String detail, String dataSuccess, String dataDetail}) {
    setStatus(new StatusMessage.announce(message, detail, dataSuccess, dataDetail));
  }

  /**
   * Clear/Empty Status
   */
  void setStatusClear() {
    setStatus(null);
  }

  /// Add Status Message directly but don't show
  void addStatusMessage(StatusMessage sm) {
    statusMessages.add(sm);
  }

  /**
   * Show Status Message
   */
  void setStatus(StatusMessage sm) {

    if (_statusToast != null) {
      _statusToast.hide(); // hide previous
    }
    if (sm != null) {
      if (sm.dataSuccess != StatusMessage._BUSY) {
        addStatusMessage(sm);
      }
      _statusToast = new LToast(
          label: sm.message, idPrefix: "status", icon: sm.icon,
          text: sm.detail, addDefaultIcon: true, color: sm.color);
      _statusToast.showBottomRight(element, autohideSeconds: 10);
    }
    //
    element.attributes["data-success"] = (sm == null || sm.dataSuccess == null) ? "" : sm.dataSuccess;
    element.attributes["data-detail"] = (sm == null || sm.dataDetail == null) ? "" : sm.dataDetail;
    //
    _statusElement.text = (sm == null) ? "."
        : "${sm.message}; \ndetail=${sm.detail}; \ndataSuccess=${sm.dataSuccess}; \ndataDetail=${sm.dataDetail};";
  } // setStatus
  /// Status Toast
  LToast _statusToast;

} // PageSimple

/**
 * Status Message
 * [color] theme color
 * [dataSuccess] e.g. busy, true, false, error
 */
class StatusMessage {

  /// Busy Status (working)
  static StatusMessage busy = new StatusMessage(
      LTheme.C_THEME__ALT_INVERSE, new LIconUtility(LIconUtility.SPINNER),
      "... ${LSpinner.lSpinnerWorking()} ...",
      null, _BUSY, null);

  /// dataSuccess
  static const String _BUSY = "busy";
  /// Data Success value
  static const String ERROR = "error";

  String color;
  LIcon icon;
  String message;
  String detail;
  String dataSuccess;
  String dataDetail;

  /// Default/Detail constructor
  StatusMessage(String this.color, LIcon this.icon, String this.message,
                String this.detail, String this.dataSuccess, String this.dataDetail);

  /// Message from Server Response
  StatusMessage.response(SResponse response, String details) {
    _initResponse(response, details);
  }

  /// Message from Server Response (success as info)
  StatusMessage.responseInfo(SResponse response, String details) {
    _initResponse(response, details);
    if (response.isSuccess) {
      color = LTheme.C_THEME__INFO;
      icon = new LIconUtility(LIconUtility.INFO);
    }
  }

  /// init info from response
  void _initResponse(SResponse response, String details) {
    if (response.isSuccess) {
      color = LTheme.C_THEME__SUCCESS;
      dataSuccess = Html0.V_TRUE;
    } else {
      color = LTheme.C_THEME__WARNING;
      dataSuccess = Html0.V_FALSE;
    }
    message = response.msg;
    detail = response.info;
    dataDetail = dataDetail;
    if (details != null && details.isNotEmpty)
      dataDetail = details;
  }


  /// message from error
  StatusMessage.errorInfo(var error) {
    color = LTheme.C_THEME__ERROR;
    dataSuccess = ERROR;
    //
    message = "${error}";
    if (error is Event && error.target is HttpRequest) {
      HttpRequest request = error.target;
      try {
        detail = request.responseText;
      } catch (ex) {}
      try {
        if (detail == null || detail.isEmpty)
          detail = request.statusText;
        else if (request.statusText.isNotEmpty)
          detail += " " + request.statusText;
      } catch (ex) {}
    }
  }

  /// Info (dark blue)
  StatusMessage.info(String this.message,
                     String this.detail, String this.dataSuccess, String this.dataDetail) {
    color = LTheme.C_THEME__ALT_INVERSE;
    icon = new LIconUtility(LIconUtility.INFO);
  }

  /// Announcement (pale blue)
  StatusMessage.announce(String this.message,
                             String this.detail, String this.dataSuccess, String this.dataDetail) {
    color = LTheme.C_THEME__INVERSE_TEXT;
    icon = new LIconUtility(LIconUtility.ANNOUNCEMENT);
  }

  /// Success Status with check (green)
  StatusMessage.success(String this.message,
                     String this.detail, String this.dataSuccess, String this.dataDetail) {
    color = LTheme.C_THEME__SUCCESS;
  }

  /// Warning Status with triangle (yellow)
  StatusMessage.warning(String this.message,
                        String this.detail, String this.dataSuccess, String this.dataDetail) {
    color = LTheme.C_THEME__WARNING;
  }

  /// Error Status with (-)
  StatusMessage.error(String this.message,
                       String this.detail, String this.dataSuccess, String this.dataDetail) {
    color = LTheme.C_THEME__ERROR;
  }

} // StatusMessage
