/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Datasource - Meta Data and Persistence Interface
 */
abstract class Datasource extends Service {

  static final Logger _log = new Logger("Datasource");
  /// current WindowNo
  static int _s_windowNo = 0;


  /// Table Name
  final String tableName;
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
   * Init Data Source
   */
  Datasource(String this.tableName) {
    recordSorting.sortExecute = sortExecute;
  }

  /// Implement - data
  Future<DataResponse> execute_data(DataRequest request);
  /// Implement - retrieve ui
  Future<UI> execute_ui();


  /// Initialize and get ui
  Future<UI> ui() {
    Completer<UI> completer = new Completer<UI>();
    if (_ui == null) {
      execute_ui()
      .then((UI ui) {
        _ui = ui;
        _table = ui.table;
        completer.complete(_ui);
      })
      .catchError((Object error, StackTrace stackTrace){
        completer.completeError(error, stackTrace);
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

} // Datasource

