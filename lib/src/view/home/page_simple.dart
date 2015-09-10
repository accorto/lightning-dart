/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Simple Page with Status Toast
 */
class PageSimple extends LComponent {

  /// Search for classes to find main element
  static final List<String> MAIN_CLASSES = [LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID,
    LGrid.C_CONTAINER__LARGE, LGrid.C_CONTAINER__MEDIUM, LGrid.C_CONTAINER__SMALL, LGrid.C_GRID];

  /// Page Element
  final Element element;


  /**
   * Simple Page
   * optional [classList] (if mot defined, container/fluid)
   */
  PageSimple(Element this.element, String id, List<String> classList){
    element.classes.clear();
    if (classList != null && classList.isNotEmpty) {
      element.classes.addAll(classList);
    } else {
      element.classes.addAll([LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID]);
    }
    element.id = id;
  } // PageSimple


  /// Server Start (busy)
  void onServerStart(String trxName, String info) {
    setStatus(LTheme.C_THEME__ALT_INVERSE, new LIconUtility(LIconUtility.SPINNER), "... ${LSpinner.lSpinnerWorking()} ...", null, "busy", "");
    busy = true;
  }
  /// Info Server Communication Success (busy/msg)
  void onServerSuccess(SResponse response) {
    busy = false;
    if (response.isSuccess)
      setStatusSuccess(response.msg);
    else
      setStatusWarning(response.msg);
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
  } // onServerError

  /// Info Status with (i)
  void setStatusInfo(String message, {String detail, String dataSuccess, String dataDetail}) {
    setStatus(LTheme.C_THEME__SHADE, new LIconUtility(LIconUtility.INFO), message, detail, dataSuccess, dataDetail);
  }
  /// Success Status with check
  void setStatusSuccess(String message, {String detail, String dataSuccess: "true", String dataDetail}) {
    setStatus(LTheme.C_THEME__SUCCESS, null, message, detail, dataSuccess, dataDetail);
  }
  /// Warning Status with triange
  void setStatusWarning(String message, {String detail, String dataSuccess: "false", String dataDetail}) {
    setStatus(LTheme.C_THEME__WARNING, null, message, detail,  dataSuccess, dataDetail);
  }
  /// Error Status with fire
  void setStatusError(String message, {String detail, String dataSuccess: "error", String dataDetail}) {
    setStatus(LTheme.C_THEME__ERROR, null, message, detail, dataSuccess, dataDetail);
  }
  /// Default Status
  void setStatusDefault(String message, {String detail, String dataSuccess, String dataDetail}) {
    setStatus(LTheme.C_THEME__SHADE, new LIconUtility(LIconUtility.ANNOUNCEMENT), message, detail, dataSuccess, dataDetail);
  }

  /**
   * Clear/Empty Status
   */
  void setStatusClear() {
    setStatus(null, null, null, null, null, null);
  }

  /**
   * [color] theme color
   * [dataSuccess] e.g. busy, true, false, error
   */
  void setStatus(String color, LIcon icon, String message, String detail,
      String dataSuccess, String dataDetail) {

    if (detail != null && detail.isNotEmpty) {
      LToast toast = new LToast(label:message, idPrefix:"status", icon:icon,
        text:detail, addDefaultIcon: true,
        color:color);
      toast.showBottomRight(element, autohideSeconds:10);
    }
    //
    element.attributes["data-success"] = dataSuccess == null ? "" : dataSuccess;
    element.attributes["data-detail"] = dataDetail == null ? "" : dataDetail;
  } // setStatus

} // PageSimple
