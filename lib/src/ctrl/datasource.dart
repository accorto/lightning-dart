/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Datasource - Meta Data and Persistence Interface
 */
abstract class Datasource
    extends Service {

  static final Logger _log = new Logger("Datasource");
  /// current WindowNo
  static int _s_windowNo = 0;


  /// Table Name
  final String tableName;
  /// Data Request Server Uri
  final String dataUri;
  /// UI Request Server Uri
  final String uiUri;

  /// Record Sort List
  final RecordSorting recordSorting = new RecordSorting();

  /// WindowNo
  final int windowNo = ++_s_windowNo;
  /// Parent query
  final List<DFilter> queryParentList = new List<DFilter>();
  /// Parent context
  final List<DKeyValue> parentContext = new List<DKeyValue>();

  /// Total
  int totalRows = 0;
  /// Cache Start / Offset
  int cacheStart = 0;
  /// Cache Size
  int cacheSize = 0;
  /// record List
  List<DRecord> recordList;
  /// Statistics List
  List<DStatistics> statisticList;

  /// Filter List
  final List<DFilter> queryFilterList = new List<DFilter>();
  /// Filter Logic
  String queryFilterLogic = "";
  /// Server Find
  final List<DFilter> queryFilterFindList = new List<DFilter>();


  /**
   * Init Data Source for [tableName]
   * to server uri [serverUrl][dataUri] or [uiUri]
   */
  Datasource(String this.tableName, String this.dataUri, String this.uiUri) {
    recordSorting.sortExecute = sortExecute;
  }

  /// Data Source Initialized
  bool get initialized => _ui != null;

  /// Initialize and get ui
  Future<UI> ui() {
    Completer<UI> completer = new Completer<UI>();
    // check cache
    if (_ui == null) {
      _ui = MetaCache.getUi(tableName: tableName);
    }
    // go to server
    if (_ui == null) {
      execute_ui()
      .then((DisplayResponse response) {
        for (UI ui in response.uiList) {
          if (ui.tableName == tableName) {
            _ui = ui;
            _table = ui.table;
            break;
          }
        }
        if (_ui == null) {
          completer.completeError("UI not found");
          _log.warning("ui ${tableName}: - not found response: #${response.uiList.length} ${response.response.msg}");
        } else {
          completer.complete(_ui);
        }
      })
      .catchError((Object error, StackTrace stackTrace){
        completer.completeError(error, stackTrace); // 2nd
      });
    } else {
      completer.complete(_ui);
    }
    return completer.future;
  }
  /// ui direct - might be null
  UI get uiDirect => _ui;
  UI _ui;

  /// table direct - might be null
  DTable get tableDirect => _table;
  DTable _table;

  /**
   * Send UI Request to Server
   */
  Future<DisplayResponse> execute_ui({String info, bool setBusy:true}) {
    DisplayRequest request = new DisplayRequest()
      ..type = DisplayRequestType.GET;
    UIInfo uiInfo = new UIInfo()
      ..tableName = tableName;
    request.displayList.add(uiInfo);
    //
    if (info == null)
      info = "UI ${tableName}";
    _log.config("execute_ui ${tableName}");
    request.request = createCRequest(uiUri, info);
    Completer<DisplayResponse> completer = new Completer<DisplayResponse>();

    sendRequest(uiUri, request.writeToBuffer(), info, setBusy: setBusy)
    .then((HttpRequest httpRequest) {
      List<int> buffer = new Uint8List.view(httpRequest.response);
      DisplayResponse response = new DisplayResponse.fromBuffer(buffer);
      handleSuccess(info, response.response, setBusy: setBusy);
      completer.complete(response);
      MetaCache.update(response);
    })
    .catchError((Event error, StackTrace stackTrace) {
      String message = handleError(uiUri, error, stackTrace);
      completer.completeError(message); // 1st
    });
    return completer.future;
  } // execute_ui


  /// Execute Sort
  bool sortExecute() {
    bool sortLocal = true;
    // local sort
    if (totalRows == recordList.length) {
      recordSorting.sortList(recordList);
    } else {
      sortLocal = false;
    }
    return sortLocal;
  }


  /// query
  Future<DataResponse> query() {
    Completer<DataResponse> completer = new Completer<DataResponse>();
    //
    DataRequest req = _createRequest(DataRequestType.QUERY);
    //
    execute_data(req)
    .then((DataResponse response) {
      totalRows = response.totalRows;
      recordList = response.recordList;
      statisticList = response.statisticList;
      completer.complete(response);
    });
    return completer.future;
  } // query

  /// query count
  Future<int> queryCount () {
    Completer<int> completer = new Completer<int>();
    DataRequest req = _createRequest(DataRequestType.QUERYCOUNT);
    //
    execute_data(req)
    .then((DataResponse response){
      completer.complete(response.totalRows);
    });
    return completer.future;
  }

  /// save
  Future<DataResponse> save(DRecord record) {
    Completer<DataResponse> completer = new Completer<DataResponse>();
    //
    DataRequest req = _createRequest(DataRequestType.SAVE);
    req.recordList.add(record);
    //
    execute_data(req)
    .then((DataResponse response) {
      totalRows = response.totalRows;
      recordList = response.recordList;
      statisticList = response.statisticList;
      completer.complete(response);
    });
    return completer.future;
  }

  /// save All
  Future<DataResponse> saveAll(List<DRecord> records) {
    Completer<DataResponse> completer = new Completer<DataResponse>();
    //
    DataRequest req = _createRequest(DataRequestType.SAVE);
    req.recordList.addAll(records);
    //
    execute_data(req)
    .then((DataResponse response) {
      totalRows = response.totalRows;
      recordList = response.recordList;
      statisticList = response.statisticList;
      completer.complete(response);
    });
    return completer.future;
  }

  /// delete
  Future<DataResponse> delete(DRecord record) {
    Completer<DataResponse> completer = new Completer<DataResponse>();
    //
    DataRequest req = _createRequest(DataRequestType.DELETE);
    req.recordList.add(record);
    //
    execute_data(req)
    .then((DataResponse response) {
      totalRows = response.totalRows;
      recordList = response.recordList;
      statisticList = response.statisticList;
      completer.complete(response);
    });
    return completer.future;
  }

  /// delete All
  Future<DataResponse> deleteAll(List<DRecord> records) {
    Completer<DataResponse> completer = new Completer<DataResponse>();
    //
    DataRequest req = _createRequest(DataRequestType.DELETE);
    req.recordList.addAll(records);
    //
    execute_data(req)
    .then((DataResponse response) {
      totalRows = response.totalRows;
      recordList = response.recordList;
      statisticList = response.statisticList;
      completer.complete(response);
    });
    return completer.future;
  }

  /// new record server side
  Future<DRecord> newRecord (Datasource list, DRecord record)  {
    Completer<DRecord> completer = new Completer<DRecord>();
    DataRequest request = new DataRequest()
      ..tableName = list.tableName
      ..type = DataRequestType.NEW
      ..recordList.add(record);

    // Context - windowId
    request.windowNo = list.windowNo.toString();
    // - AD_Window_ID|AD_Tab_ID
    if (_ui.hasExternalKey())
      request.uiExternalKey = _ui.externalKey;
    // - Window Context (general context is on server)
    if (parentContext.isNotEmpty)
      request.contextList.addAll(parentContext);

    execute_data(request, setBusy: false)
    .then((DataResponse resp) {
      ServiceTracker track = new ServiceTracker(resp.response, "new ${list.tableName} #${resp.contextChangeList.length}");
      // copy values
      DataRecord data = new DataRecord(null, value: record);
      for (DKeyValue nv in resp.contextChangeList) {
        String name = nv.key;
        DEntry dataEntry = data.getEntry(null, name, true);
        String value = nv.value;
        dataEntry.value = value;
        dataEntry.valueOriginal = value; // for reset
      }
      completer.complete(record);
      track.send();
    })
    .catchError((error, StackTrace stackTrace) {
      completer.completeError(error, stackTrace); // 2nd
    });
    return completer.future;
  } // newRecord

  /// server callout
  Future<DRecord> callout (Datasource list, DRecord record, DEntry columnChanged, DColumn column) {
    Completer<DRecord> completer = new Completer<DRecord>();
    assert(record != null);
    assert(columnChanged != null);
    //
    String tableName = list.tableName;
    String columnName = columnChanged.columnName;
    String validationCallout = column.validationCallout;

    DataRequest req = new DataRequest()
      ..tableName = list.tableName
      ..type = DataRequestType.CALLOUT
      ..recordList.add(record)
      ..columnChanged = columnChanged
      ..validationCallout = validationCallout;

    // Context - windowId
    req.windowNo = list.windowNo.toString();
    // - AD_Window_ID|AD_Tab_ID
    if (_ui.hasExternalKey())
      req.uiExternalKey = _ui.externalKey;
    // - AD_Field_ID
    req.fieldExternalKey = column.tempExternalKey; // = panelColumn.externalKey;
    if (!column.hasTempExternalKey()) {
      _log.config("recordCallout ${tableName}.${columnName} ${validationCallout} no Field ExtKey");
    }
    // - Window Context (general context is on server)
    if (parentContext.isNotEmpty)
      req.contextList.addAll(parentContext);
    final DataRecord data = new DataRecord(null, value: record);
    req.contextList.addAll(data.asContext(list.windowNo));

    execute_data(req, info:validationCallout, setBusy:false)
    .then((DataResponse resp) {
      ServiceTracker track = new ServiceTracker(resp.response, "callout ${validationCallout} #${resp.contextChangeList.length}");
      completer.complete(record);
      track.send();
    })
    .catchError((error, StackTrace stackTrace) {
      completer.completeError(error, stackTrace); // 2nd
    });
    return completer.future;
  } // callout



  /**
   * Create Request with query info
   */
  DataRequest _createRequest(DataRequestType type,
      {SavedQuery querySaved}) {
    // see WbDatasource
    DataRequest req = new DataRequest()
      ..tableName = tableName
      ..type = type
      ..queryOffset = cacheStart
      ..queryLimit = cacheSize;

    // Saved Query
    if (querySaved != null) {
      req.querySaved = querySaved;
    }

    // Query
    if (queryParentList.isNotEmpty)
      req.queryFilterList.addAll(queryParentList);
    if (queryFilterList.isNotEmpty) // search
      req.queryFilterList.addAll(queryFilterList);
    if (queryFilterLogic != null && queryFilterLogic.isNotEmpty) {
      // add parent?
      req.queryFilterLogic = queryFilterLogic;
    }
    // Find
    if (queryFilterFindList.isNotEmpty)
      req.queryFilterList.addAll(queryFilterFindList);
    // Sort
    if (recordSorting.isNotEmpty) {
      for (RecordSort sort in recordSorting.list) {
        req.querySortList.add(sort.sort);
      }
    }

    // Context - windowId
    req.windowNo = windowNo.toString();
    // - AD_Window_ID|AD_Tab_ID
    if (_ui.hasExternalKey())
      req.uiExternalKey = _ui.externalKey;
    // - AD_Field_ID req.fieldExternalKey = column.column.tempExternalKey;
    // - Window Context (general context is on server)
    if (parentContext.isNotEmpty)
      req.contextList.addAll(parentContext);

    // req.clearIsIncludeStats();
    // req.queryColumnNames;
    return req;
  } // createRequest


  /**
   * Send Data Request to Server
   */
  Future<DataResponse> execute_data(DataRequest request, {String info, bool setBusy: true}) {
    if (info == null) {
      info = "${request.type} ${request.tableName}";
    }
    _log.config("execute_data ${tableName} ${request.type}");
    request.request = createCRequest(dataUri, info);
    Completer<DataResponse> completer = new Completer<DataResponse>();
    //
    sendRequest(dataUri, request.writeToBuffer(), info, setBusy: setBusy)
    .then((HttpRequest httpRequest) {
      List<int> buffer = new Uint8List.view(httpRequest.response);
      DataResponse response = new DataResponse.fromBuffer(buffer);
      handleSuccess(info, response.response, setBusy: setBusy);
      completer.complete(response);
    })
    .catchError((Event error, StackTrace stackTrace) {
      String message = handleError(dataUri, error, stackTrace);
      completer.completeError(message); // 1st
    });
    return completer.future;
  } // execute_data




} // Datasource

