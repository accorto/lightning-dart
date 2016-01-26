/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Display (UI/Table) Service
 */
class UiService
    extends Service {

  /// The Instance
  static UiService instance;

  static final Logger _log = new Logger("UiService");

  /// UI List
  final List<UI> _uiList = new List<UI>();
  /// Table List
  final List<DTable> _tableList = new List<DTable>();

  /// Data Request Server Uri
  final String dataUri;
  /// UI Request Server Uri
  final String uiUri;

  /**
   * FK Service
   */
  UiService(String this.dataUri, String this.uiUri) {
  } // FkService

  /// Get UI By Criteria
  UI getUi({String uiName, String tableName}) {
    for (UI ui in _uiList) {
      if (tableName != null && ui.tableName == tableName)
        return ui;
      if (uiName != null && ui.name == uiName)
        return ui;
    }
    return null;
  } // getUi

  /// Get UI By Criteria
  Future<UI> getUiFuture({String uiName, String tableName}) {
    Completer<UI> completer = new Completer<UI>();
    UI ui = getUi(uiName:uiName, tableName:tableName);
    if (ui != null) {
      completer.complete(ui);
    } else {
      _submit(null, uiName, tableName)
      .then((DisplayResponse response){ // cache already updated
        ui = getUi(uiName:uiName, tableName:tableName);
        if (ui != null)
          completer.complete(ui);
        else
          completer.completeError(new Exception(response.response.msg));
      })
      .catchError((error, stackTrace) {
        completer.completeError(error, stackTrace);
      });
    }
    return completer.future;
  } // getUiFuture

  /// Get Table with table name
  DTable getTable(String tableName) {
    if (tableName != null) {
      for (DTable table in _tableList) {
        if (table.name == tableName)
          return table;
      }
    }
    return null;
  } // getTable

  /// Get Table with table name async
  Future<DTable> getTableFuture(String tableName) {
    Completer<DTable> completer = new Completer<DTable>();
    DTable table = getTable(tableName);
    if (table != null) {
      completer.complete(table);
    } else {
      _submit(null, null, tableName)
      .then((DisplayResponse response){ // cache already updated
        table = getTable(tableName);
        if (table != null)
          completer.complete(table);
        else
          completer.completeError(new Exception(response.response.msg));
      })
      .catchError((error, stackTrace) {
        completer.completeError(error, stackTrace);
      });
    }
    return completer.future;
  } // getTable


  /**
   * Execute Display Request
   */
  Future<DisplayResponse> _submit(String uiId, String uiName, String tableName) {
    DisplayRequest request = new DisplayRequest()
      ..type = DisplayRequestType.GET;
    String info = "ui";
    UIInfo uiInfo = new UIInfo();
    if (uiId != null && uiId.isNotEmpty) {
      uiInfo.uiId = uiId;
      info = "ui_id_${uiId}";
    } else if (uiName != null && uiName.isNotEmpty) {
      uiInfo.uiName = uiName;
      info = "ui_${uiName}";
    } else if (tableName != null) {
      uiInfo.tableName = tableName;
      info = "ui_table_${tableName}";
    }
    request.displayList.add(uiInfo);

    request.request = createCRequest(uiUri, info);
    Completer<DisplayResponse> completer = new Completer<DisplayResponse>();

    _log.config("submit ${info}");
    sendRequest(uiUri, request.writeToBuffer(), info, setBusy:false)
    .then((HttpRequest httpRequest) {
      List<int> buffer = new Uint8List.view(httpRequest.response);
      DisplayResponse response = new DisplayResponse.fromBuffer(buffer);
      String details = handleSuccess(info, response.response, buffer.length, setBusy:false);
      ServiceTracker track = new ServiceTracker(response.response, info, details);
      if (response.response.isSuccess) {
        update(response); // update before complete
        completer.complete(response);
        _log.info("received ${details}");
      } else {
        _log.warning("submit ${details} - ${response.response.msg}");
        completer.completeError(new Exception(response.response.msg));
      }
      track.send();
    })
    .catchError((Event error, StackTrace stackTrace) {
      String message = handleError(uiUri, error, stackTrace);
      _log.warning("submit ${info} ${message}");
      completer.completeError(error, stackTrace); // 1st
    });
    return completer.future;
  } // submit


  /// update cache from response
  void update(DisplayResponse response) {
    for (DTable table in response.tableList) {
      updateTable(table);
    }
    for (UI ui in response.uiList) {
      updateUi(ui);
    }
  } // update

  /// update ui/table cache
  void updateUi(UI ui) {
    // ui
    bool found = false;
    for (int i = 0; i < _uiList.length; i++) {
      UI cache = _uiList[i];
      if (ui.hasUiId()) {
        if (ui.uiId == cache.uiId) {
          _uiList[i] = ui; // replace
          found = true;
          break;
        }
      } else {
        if (ui.name == cache.name) {
          _uiList[i] = ui;
          found = true;
          break;
        }
      }
    }
    if (!found) {
      _uiList.add(ui);
    }
    // table
    if (ui.hasTable()) {
      found = false;
      for (int i = 0; i < _tableList.length; i++) {
        DTable cache = _tableList[i];
        if (ui.table.name == cache.name) {
          _tableList[i] = ui.table; // replace
          found = true;
          break;
        }
      }
      if (!found) {
        _tableList.add(ui.table);
      }
    } else {
      for (DTable table in _tableList) {
        if ((ui.hasTableId() && ui.tableId == table.tableId)
            || ui.tableName == table.name) {
          ui.table = table;
          break;
        }
      }
    }
  } // updateUi

  /// update table cache
  void updateTable(DTable table) {
    bool found = false;
    for (int i = 0; i < _tableList.length; i++) {
      DTable cache = _tableList[i];
      if (table.name == cache.name) {
        _tableList[i] = table;
        found = true;
        break;
      }
    }
    if (!found) {
      _tableList.add(table);
    }
  } // update


} // UiService
