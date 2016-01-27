/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Datasource for table/object
 * - Meta Data and Persistence Interface
 */
class Datasource
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
  final RecordSortList recordSorting = new RecordSortList();

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
  /// ui direct - might be null
  UI ui;


  /**
   * Init Data Source for [tableName]
   * to server uri [serverUrl][dataUri] or [uiUri]
   */
  Datasource(String this.tableName, String this.dataUri, String this.uiUri) {
    recordSorting.sortExecuteRemote = sortExecuteRemote;
  }

  /// Data Source Initialized
  bool get initialized => ui != null;

  /// Initialize and get/set ui
  Future<UI> uiFuture() {
    Completer<UI> completer = new Completer<UI>();
    if (ui == null) {
      if (UiService.instance == null) {
        UiService.instance = new UiService(dataUri, uiUri);
      }
      UiService.instance.getUiFuture(tableName:tableName)
      .then((UI ui){
        this.ui = ui;
        completer.complete(ui);
      })
      .catchError((error, stackTrace) {
        completer.completeError(error, stackTrace);
      });
    } else {
      completer.complete(ui);
    }
    return completer.future;
  }

  /// table direct - might be null
  DTable get tableDirect => _table;
  DTable _table;

  /// Execute Sort locally if possible
  bool sortExecuteRemote() {
    return totalRows != recordList.length;
  }


  /// query
  Future<DataResponse> query({bool setBusy:true}) {
    Completer<DataResponse> completer = new Completer<DataResponse>();
    //
    DataRequest req = _createRequest(DataRequestType.QUERY);
    //
    execute_data(req, setBusy:setBusy)
    .then((DataResponse response) {
      totalRows = response.totalRows;
      recordList = response.recordList;
      statisticList = response.statisticList;
      completer.complete(response);
    })
    .catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
    });
    return completer.future;
  } // query

  /// query count
  Future<int> queryCount () {
    Completer<int> completer = new Completer<int>();
    DataRequest req = _createRequest(DataRequestType.QUERYCOUNT);
    //
    execute_data(req, setBusy:false)
    .then((DataResponse response){
      completer.complete(response.totalRows);
    })
    .catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
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
    })
    .catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
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
    })
    .catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
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
    })
    .catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
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
    })
    .catchError((error, stackTrace) {
      completer.completeError(error, stackTrace);
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
    if (ui.hasExternalKey())
      request.uiExternalKey = ui.externalKey;
    // - Window Context (general context is on server)
    if (parentContext.isNotEmpty)
      request.contextList.addAll(parentContext);

    execute_data(request, setBusy: false)
    .then((DataResponse resp) {
      ServiceTracker track = new ServiceTracker(resp.response, "new_${list.tableName}", "#${resp.contextChangeList.length}");
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
    if (ui.hasExternalKey())
      req.uiExternalKey = ui.externalKey;
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
      ServiceTracker track = new ServiceTracker(resp.response, "callout_${validationCallout}", "#${resp.contextChangeList.length}");
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
        if (sort.columnName == DataRecord.URV)
          continue;
        req.querySortList.add(sort.sort);
      }
    }

    // Context - windowId
    req.windowNo = windowNo.toString();
    // - AD_Window_ID|AD_Tab_ID
    if (ui != null && ui.hasExternalKey())
      req.uiExternalKey = ui.externalKey;
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
  Future<DataResponse> execute_data(DataRequest request, {String info, bool setBusy:true}) {
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
      String details = handleSuccess(info, response.response, buffer.length, setBusy: setBusy);
      ServiceTracker track = new ServiceTracker(response.response, info, details);
      completer.complete(response);
      _log.info("received ${details}");
      track.send();
    })
    .catchError((Event error, StackTrace stackTrace) {
      String message = handleError(dataUri, error, stackTrace);
      _log.warning("execute_data ${tableName} ${message}");
      completer.completeError(message); // 1st
    });
    return completer.future;
  } // execute_data

} // Datasource
