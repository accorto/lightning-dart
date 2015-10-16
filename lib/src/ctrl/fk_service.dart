/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * FK Service
 */
class FkService
    extends Service {

  /// The Instance
  static FkService instance;

  static final Logger _log = new Logger("FkService");

  /** Direct URV separator */
  static const String URV_ID = "!"; // other options: ~*. - see DtoUtil


  final List<FkServiceRequest> _activeRequests = new List<FkServiceRequest>();
  List<FkServiceRequest> _pendingRequests = new List<FkServiceRequest>();

  /// The Cache: tableName!id
  final Map<String, DFK> _map = new Map<String, DFK>();
  /// Cache Complete FKs <tableName, List>
  final Map<String, List<DFK>> _tableComplete = new Map<String, List<DFK>>();


  /// Data Request Server Uri
  final String dataUri;
  /// UI Request Server Uri
  final String uiUri;

  /**
   * FK Service
   */
  FkService(String this.dataUri, String this.uiUri) {
  } // FkService


  /**
   * Get complete FK List from Cache direct
   */
  List<DFK> getFkList(fkTableName, String restrictionSql) {
    if (restrictionSql == null || restrictionSql.isEmpty) {
      return _tableComplete[fkTableName]; // map
    }
    return _tableComplete["${fkTableName}_${restrictionSql}"]; // map
  }

  /**
   * Retrieve from server if necessary
   */
  Future<List<DFK>> getFkListFuture(String fkTableName,
      String restrictionSql,
      String parentColumnName, String parentValue) {
    Completer<List<DFK>> completer = new Completer<List<DFK>>();
    FkServiceRequest sr = new FkServiceRequest()
      ..tableName = fkTableName
      ..restrictionSql = restrictionSql
      ..parentColumnName = parentColumnName
      ..parentValue = parentValue
      ..completerList = completer;

    if (_isSimilarRequestActive(sr)) {
      //  _log.fine("getFkFuture - found similar for ${sr}");
      _pendingRequests.add(sr);
    } else {
      _activeRequests.add(sr); // don't wait until submit finished
      _submit(sr);
    }
    return completer.future;
  } // getFkListFuture

  /// is the table complete
  bool isComplete(String tableName) {
    return _tableComplete.containsKey(tableName);
  }

  /**
   * Get FK from Cache direct
   */
  DFK getFk(fkTableName, id) {
    String key = "${fkTableName}${URV_ID}${id}";
    return _map[key];
  }

  /**
   * Retrieve from server if necessary
   */
  Future<DFK> getFkFuture(String fkTableName,
      String id,
      {String parentColumnName, String parentValue}) {
    assert (fkTableName != null && fkTableName.isNotEmpty);
    assert (id != null && id.isNotEmpty);
    //
    Completer<DFK> completer = new Completer<DFK>();
    // try cache (again)
    String key = "${fkTableName}${URV_ID}${id}";
    DFK fk = _map[key];
    if (fk != null) {
      completer.complete(fk);
      return completer.future;
    }
    //
    FkServiceRequest sr = new FkServiceRequest()
      ..tableName = fkTableName
      ..id = id
      ..parentColumnName = parentColumnName
      ..parentValue = parentValue
      ..completer = completer;

    if (_isSimilarRequestActive(sr)) {
      //  _log.fine("getFkFuture - found similar for ${sr}");
      _pendingRequests.add(sr);
    } else {
      _activeRequests.add(sr); // don't wait until submit finished
      _submit(sr);
    }
    return completer.future;
  } // getFkFuture

  /**
   * Add/update to Cache
   */
  DFK addRecord (DRecord record) {
    if (record.recordId.isEmpty)
      return null;
    DFK fk = new DFK()
      ..tableName = record.tableName
      ..id = record.recordId
      ..urv = record.urv
      ..drv = record.drv;
    String key = "${record.tableName}${URV_ID}${record.recordId}";
    _map[key] = fk;
    return fk;
  } // addRecord

  /**
   * Remove from Cache
   */
  DFK removeRecord (DRecord record) {
    if (record.recordId.isEmpty)
      return null;
    _tableComplete.remove(record.tableName);
    // TODO remove tableName_xx
    String key = "${record.tableName}${URV_ID}${record.recordId}";
    return _map.remove(key);
  } // removeRecord


  /**
   * Similar requests active
   * - tableName
   */
  bool _isSimilarRequestActive(FkServiceRequest sr) {
    for (FkServiceRequest req in _activeRequests) {
      if (req == sr) {
        return true;
      }
    }
    return false;
  } // isSimilarRequestActive


  /**
   * Execute FK request
   */
  void _submit(FkServiceRequest sr) {
    DataRequest request = new DataRequest()
      ..tableName = sr.tableName
      ..type = DataRequestType.QUERYFK;
    if (sr.id != null && sr.id.isNotEmpty) {
      request.fkId = sr.id;
    }
    if (sr.restrictionSql != null && sr.restrictionSql.isNotEmpty) {
      request.fkRestrictionSql = sr.restrictionSql;
    }
    if (sr.parentColumnName != null && sr.parentColumnName.isNotEmpty
      && sr.parentValue != null && sr.parentValue.isNotEmpty) {
      request.fkParentColumnName = sr.parentColumnName;
      request.fkParentValue = sr.parentValue;
    }
    String info = "fk_${sr.compareString}";
    request.request = createCRequest(dataUri, info);
    sr.trxNo = request.request.trxNo;

    _log.config("submit ${info}");
    sendRequest(dataUri, request.writeToBuffer(), info, setBusy:false)
    .then((HttpRequest httpRequest) {
      List<int> buffer = new Uint8List.view(httpRequest.response);
      DataResponse response = new DataResponse.fromBuffer(buffer);
      String details = handleSuccess(info, response.response, buffer.length, setBusy:false);
      ServiceTracker track = new ServiceTracker(response.response, info, details);
      if (response.response.isSuccess) {
        _updateCache(sr, response.fksList, response.isFkComplete);
      } else {
        _log.warning("submit ${info} ${response.response.msg}");
        _updateCache(sr, new List<DFK>(), false);
      }
      track.send();
    })
    .catchError((Event error, StackTrace stackTrace) {
      String message = handleError(dataUri, error, stackTrace);
      _log.warning("submit ${info} ${message}");
      _updateCache(sr, new List<DFK>(), false);
    });
  } // _submit

  /**
   * Update Cache - callback from submit
   */
  void _updateCache(FkServiceRequest sr, List<DFK> fkList, bool fkComplete) {
    // update cache
    for (DFK fk in fkList) {
      if (!fk.hasTableName())
        fk.tableName = sr.tableName;
      String key = "${sr.tableName}${URV_ID}${fk.id}";
      _map[key] = fk;
    }
    // FK complete
    if (fkComplete) {
      if (sr.restrictionSql == null || sr.restrictionSql.isEmpty) {
        _tableComplete[sr.tableName] = fkList; // map
      } else {
        _tableComplete["${sr.tableName}_${sr.restrictionSql}"] = fkList; // map
      }
    }

    // complete request
    if (sr.completer != null) {
      DFK fk = getFk(sr.tableName, sr.id);
      if (fk == null) {
        fk = new DFK()
          ..id = sr.id
          ..drv = "NotFound=${sr.tableName}${URV_ID}${sr.id}"
          ..urv = "#";
      }
      sr.completer.complete(fk);
    }
    if (sr.completerList != null) {
      sr.completerList.complete(fkList);
    }
    //
    _activeRequests.remove(sr);
    _checkSimilarRequests(sr, fkList);
  } // updateCache

  /// Check similar requests for completed [sr]
  void _checkSimilarRequests(FkServiceRequest sr, List<DFK> fkList) {
    String srTableName = sr.tableName;
    //String srCompareString = sr.compareString;
    //
    int serviced = 0;
    List<FkServiceRequest> newPendingRequests = new List<FkServiceRequest>();
    List<FkServiceRequest> submitList = new List<FkServiceRequest>();

    for (FkServiceRequest req in _pendingRequests) {
      if (req.tableName == srTableName) {
        if (req.id == null) { // list request
          if (req.completerList != null) {
            req.completerList.complete(fkList);
            serviced++;
          } else {
            newPendingRequests.add(req); // copy
          }
        } else { // id request
          DFK fk = getFk(req.tableName, req.id); // do we have it in cache now
          if (fk == null) {
            if (_checkNoSameRequest(req.tableName, req.id, submitList)) {
              submitList.add(req); // re-issue
            } else {
              newPendingRequests.add(req); // copy
            }
          } else {
            req.completer.complete(fk); // done
            serviced++;
          }
        }
      } else {
        newPendingRequests.add(req); // copy
      }
    }
    // submit pending requests
    _pendingRequests = newPendingRequests;
    for (FkServiceRequest req in submitList) {
      _submit(req);
    }
    _log.fine("checkSimilarRequests ${srTableName} serviced=${serviced} submitted=${submitList.length}"
        " - pending=${_pendingRequests.length} active=${_activeRequests.length}");
  } // checkSimilarRequests

  // return true if no same request exists
  bool _checkNoSameRequest(String tableName, String id, List<FkServiceRequest> submitList) {
    for (FkServiceRequest req in _activeRequests) {
      if (req.tableName == tableName) {
        return false; // might be list request - wait
      }
    }
    for (FkServiceRequest req in submitList) {
      if (req.tableName == tableName && req.id == id) {
        return false; // exact match
      }
    }
    return true;
  } // checkNoSameRequest



  /// FK Status Info
  String get statusInfo => "cache=${_map.length} requests active=${_activeRequests.length} pending=${_pendingRequests.length}";
  int get activeRequestCount => _activeRequests.length;
  List<String> get _activeRequestNames {
    List<String> names = new List<String>();
    for (FkServiceRequest req in _activeRequests) {
      names.add(req.toString());
    }
    return names;
  }
  String get activeRequestInfo => "${_activeRequests.length} ${_activeRequestNames}";
  int get pendingRequestCount => _pendingRequests.length;
  List<String> get _pendingRequestNames {
    List<String> names = new List<String>();
    for (FkServiceRequest req in _pendingRequests) {
      names.add(req.toString());
    }
    return names;
  }
  String get pendingRequestInfo => "${_pendingRequests.length} ${_pendingRequestNames}";

  /// FK Entry Map length
  int get cacheLength => _map.length;
  /// Cached Table Length
  int get cacheTableLength => _tableComplete.length;
  /// Cached Tables count and details
  String get cacheTableInfo {
    return "${_tableComplete.length} ${cacheTableNames}";
  }
  List<String> get cacheTableNames {
    List<String> names = new List<String>();
    _tableComplete.forEach((String name, List<DFK> fks) {
      names.add("${name}(${fks.length})");
    });
    names.sort((String one, String two) {
      return one.compareTo(two);
    });
    return names;
  }

/* Add Tab with Service Info
  static void addServiceFkTab(BsTab tab) {
    DivElement content = tab.addTab("srvFk", "Service FK", iconClass: EditorFk.ICON);
    MiniTable mt = new MiniTable(responsive: true);
    content.append(mt.element);

    mt.addRowHdrDatas("Active Requests", [_activeRequests.length, activeRequestNames]);
    mt.addRowHdrDatas("Pending Requests", [_pendingRequests.length, pendingRequestNames]);
    mt.addRowHdrData("Cache Entities", cacheLength);
    mt.addRowHdrDatas("Cache Tables", [_tableComplete.length, cacheTableNames]);
  } */


} // FkService
