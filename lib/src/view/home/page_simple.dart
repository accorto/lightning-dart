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
 */
class PageSimple
    extends LComponent {

  static final Logger _log = new Logger("PageSimple");

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
    ..style.display = "none"
    ..id = STATUS_ID_NONE;

  /// Status messages
  static final List<StatusMessage> statusMessages = new List<StatusMessage>();

  /**
   * Simple Page
   * optional [classList] (if mot defined, container/fluid)
   */
  PageSimple(Element this.element, String id,
        {List<String> classList}){
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
  } // PageSimple


  /// Server Start (busy)
  void onServerStart(String trxName, String info) {
    _statusElement.id = STATUS_ID_BUSY;
    setStatus(StatusMessage.busy);
    busy = true;
  }
  /// Info Server Communication Success (busy/msg)
  void onServerSuccess(SResponse response, String dataDetail) {
    busy = false;
    if (response.isSuccess) {
      setStatusSuccess(response.msg, detail: response.info, dataDetail: dataDetail);
    } else {
      setStatusWarning(response.msg, detail: response.info, dataDetail: dataDetail);
    }
    _statusElement.id = STATUS_ID_OK;
  }
  /// Info Server Communication Error
  void onServerError(var error) {
    busy = false;
    setStatusError("${error}");
    if (error is Event && error.target is HttpRequest) {
      HttpRequest request = error.target;
      String msg = null;
      try {
        msg = request.responseText;
      } catch (ex) {}
      try {
        if (msg == null || msg.isEmpty)
          msg = request.statusText;
        else if (request.statusText.isNotEmpty)
          msg += " " + request.statusText;
      } catch (ex) {}
      if (msg != null && msg.isNotEmpty)
        setStatusError(msg);
    }
    _statusElement.id = STATUS_ID_ERROR;
  } // onServerError

  /// Info Status with (i)
  void setStatusInfo(String message, {String detail, String dataSuccess, String dataDetail}) {
    setStatus(new StatusMessage.info(message, detail, dataSuccess, dataDetail));
  }
  /// Success Status with check
  void setStatusSuccess(String message, {String detail, String dataSuccess: "true", String dataDetail}) {
    setStatus(new StatusMessage.success(message, detail, dataSuccess, dataDetail));
  }
  /// Warning Status with triangle
  void setStatusWarning(String message, {String detail, String dataSuccess: "false", String dataDetail}) {
    setStatus(new StatusMessage.warning(message, detail,  dataSuccess, dataDetail));
  }
  /// Error Status with fire
  void setStatusError(String message, {String detail, String dataSuccess: "error", String dataDetail}) {
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

  /**
   * Show Status Message
   */
  void setStatus(StatusMessage sm) {

    if (_statusToast != null) {
      _statusToast.hide(); // hide previous
    }
    if (sm != null) {
      if (sm.dataSuccess != StatusMessage._BUSY) {
        statusMessages.add(sm);
      }
      _statusToast = new LToast(
          label: sm.message, idPrefix: "status", icon: sm.icon,
          text: sm.detail, addDefaultIcon: true, color: sm.color);
      _statusToast.showBottomRight(element, autohideSeconds: 10, onWindow: true);
    }
    //
    element.attributes["data-success"] = (sm == null || sm.dataSuccess == null) ? "" : sm.dataSuccess;
    element.attributes["data-detail"] = (sm == null || sm.dataDetail == null) ? "" : sm.dataDetail;
    //
    _statusElement.text = (sm == null) ? ""
        : "message=${sm.message} \ndetail=${sm.detail} \ndataSuccess=${sm.dataSuccess} \ndataDetail=${sm.dataDetail}";
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

  /// dataSuccess
  static const String _BUSY = "busy";

  String color;
  LIcon icon;
  String message;
  String detail;
  String dataSuccess;
  String dataDetail;

  /// Default/Detail constructor
  StatusMessage(String this.color, LIcon this.icon, String this.message,
                String this.detail, String this.dataSuccess, String this.dataDetail);

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

  /// Busy Status (working)
  static StatusMessage busy = new StatusMessage(
      LTheme.C_THEME__ALT_INVERSE, new LIconUtility(LIconUtility.SPINNER),
      "... ${LSpinner.lSpinnerWorking()} ...",
      null, _BUSY, null);

} // StatusMessage
