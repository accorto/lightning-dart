/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * FK Service request calls back ServiceFk.updateCache
 */
typedef void ServiceFkSubmit (ServiceFkRequest sr);

/**
 * FK Search service
 */
typedef Future<List<DRecord>> ServiceFkSearch (String tableName, String serach, String column);

/**
 * FK Cache Management
 * - requires ServiceFkSubmit to do actual query
 */
class ServiceFkCache {

  /**
   * Callback calls back [updateCache]
   */
  static ServiceFkSubmit submit;
  /// FK Search Service
  static ServiceFkSearch fkSearch;

  /** Direct URV separator */
  static const String URV_ID = "!"; // other options: ~*. - see DtoUtil


  /**
   * Get FK from Cache direct
   */
  static DFK getFk(fkTableName, id) {
    String key = "${fkTableName}${URV_ID}${id}";
    return _map[key];
  }

  /**
   * Get complete FK List from Cache direct
   */
  static List<DFK> getFkList(fkTableName, String restrictionSql) {
    if (restrictionSql == null || restrictionSql.isEmpty) {
      return _tableComplete[fkTableName]; // map
    }
    return _tableComplete["${fkTableName}_${restrictionSql}"]; // map
  }

  /**
   * Retrieve from server if necessary
   */
  static Future<DFK> getFkFuture(String fkTableName,
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
    if (submit == null) {
      completer.completeError("No ServiceFkSubmit");
      return completer.future;
    }
    //
    ServiceFkRequest sr = new ServiceFkRequest()
      ..tableName = fkTableName
      ..id = id
      ..parentColumnName = parentColumnName
      ..parentValue = parentValue
      ..completer = completer;

    if (_isSimilarRequestActive(sr)) {
      //  _log.fine("getFkFuture - found similar for ${sr}");
      _pendingRequests.add(sr);
    } else {
      // submit
      _activeRequests.add(sr); // don't wait until submit finished
      submit(sr); // calls updateCache
      _log.finer("getFkFuture submit=${sr}");
    }
    return completer.future;
  } // getFkFuture

  /**
   * Retrieve from server if necessary
   */
  static Future<List<DFK>> getFkListFuture(String fkTableName,
      String restrictionSql,
      String parentColumnName, String parentValue) {
    Completer<List<DFK>> completer = new Completer<List<DFK>>();
    ServiceFkRequest sr = new ServiceFkRequest()
      ..tableName = fkTableName
      ..restrictionSql = restrictionSql
      ..parentColumnName = parentColumnName
      ..parentValue = parentValue
      ..completerList = completer;

    if (_isSimilarRequestActive(sr)) {
      //  _log.fine("getFkFuture - found similar for ${sr}");
      _pendingRequests.add(sr);
    } else if (submit == null) {
      completer.completeError("Submit not defined");
    } else {
      // submit
      _activeRequests.add(sr); // don't wait until submit finished
      submit(sr); // calls updateCache
      _log.finer("getFkListFuture submit=${sr}");
    }
    return completer.future;
  } // getFkListFuture


  /**
   * Similar requests active
   * - tableName
   */
  static bool _isSimilarRequestActive(ServiceFkRequest sr) {
    for (ServiceFkRequest req in _activeRequests) {
      if (req == sr) {
        return true;
      }
    }
    return false;
  } // isSimilarRequestActive

  /**
   * Update Cache - callback from submit
   */
  static void updateCache(ServiceFkRequest sr, List<DFK> fkList, bool fkComplete) {
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
  static void _checkSimilarRequests(ServiceFkRequest sr, List<DFK> fkList) {
    String srTableName = sr.tableName;
    //String srCompareString = sr.compareString;
    //
    int serviced = 0;
    List<ServiceFkRequest> newPendingRequests = new List<ServiceFkRequest>();
    List<ServiceFkRequest> submitList = new List<ServiceFkRequest>();

    for (ServiceFkRequest req in _pendingRequests) {
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
    for (ServiceFkRequest req in submitList) {
      submit(req);
    }
    _log.fine("checkSimilarRequests ${srTableName} serviced=${serviced} submitted=${submitList.length}"
    " - pending=${_pendingRequests.length} active=${_activeRequests.length}");
  } // checkSimilarRequests
  // return true if no same request exists
  static bool _checkNoSameRequest(String tableName, String id, List<ServiceFkRequest> submitList) {
    for (ServiceFkRequest req in _activeRequests) {
      if (req.tableName == tableName) {
        return false; // might be list request - wait
      }
    }
    for (ServiceFkRequest req in submitList) {
      if (req.tableName == tableName && req.id == id) {
        return false; // exact match
      }
    }
    return true;
  } // checkNoSameRequest


  /**
   * Add/update to Cache
   */
  static DFK addRecord (DRecord record) {
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
  static DFK removeRecord (DRecord record) {
    if (record.recordId.isEmpty)
      return null;
    _tableComplete.remove(record.tableName);
    // TODO remove tableName_xx
    String key = "${record.tableName}${URV_ID}${record.recordId}";
    return _map.remove(key);
  } // removeRecord



  /// FK Status Info
  static String get statusInfo => "cache=${_map.length} requests active=${_activeRequests.length} pending=${_pendingRequests.length}";
  static int get activeRequestCount => _activeRequests.length;
  static List<String> get activeRequestNames {
    List<String> names = new List<String>();
    for (ServiceFkRequest req in _activeRequests) {
      names.add(req.toString());
    }
    return names;
  }
  static String get activeRequestInfo => "${_activeRequests.length} ${activeRequestNames}";
  static int get pendingRequestCount => _pendingRequests.length;
  static List<String> get pendingRequestNames {
    List<String> names = new List<String>();
    for (ServiceFkRequest req in _pendingRequests) {
      names.add(req.toString());
    }
    return names;
  }
  static String get pendingRequestInfo => "${_pendingRequests.length} ${pendingRequestNames}";

  /// FK Entry Map length
  static int get cacheLength => _map.length;
  /// Cached Table Length
  static int get cacheTableLength => _tableComplete.length;
  /// Cached Tables count and details
  static String get cacheTableInfo {
    return "${_tableComplete.length} ${cacheTableNames}";
  }
  static List<String> get cacheTableNames {
    List<String> names = new List<String>();
    _tableComplete.forEach((String name, List<DFK> fks) {
      names.add("${name}(${fks.length})");
    });
    names.sort((String one, String two) {
      return one.compareTo(two);
    });
    return names;
  }


  static Logger _log = new Logger("ServiceFkCache");

  /// The Cache: tableName!id
  static final Map<String, DFK> _map = new Map<String, DFK>();
  static List<ServiceFkRequest> _activeRequests = new List<ServiceFkRequest>();
  static List<ServiceFkRequest> _pendingRequests = new List<ServiceFkRequest>();

  /// Cache Complete FKs <tableName, List>
  static Map<String, List<DFK>> _tableComplete = new Map<String, List<DFK>>();


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

} // ServiceFk



/**
 * Fk Request Info
 */
class ServiceFkRequest {

  String tableName;
  String id;
  //
  String restrictionSql;
  String parentColumnName;
  String parentValue;
  //
  Completer<DFK> completer;
  Completer<List<DFK>> completerList;
  // active trx
  int trxNo;

  /// equals
  bool operator ==(o) =>  o is ServiceFkRequest && compareString == o.compareString;
  /// hash code
  int get hashCode => compareString.hashCode;

  /// Compare String
  String get compareString {
    if (_compare == null) {
      _compare = tableName;
      if (id != null && id.isNotEmpty)
        _compare += "_i=${id}";
      if (restrictionSql != null && restrictionSql.isNotEmpty)
        _compare += "_s=${restrictionSql}";
      if (parentValue != null && parentColumnName.isNotEmpty)
        _compare += "_${parentColumnName}=${parentValue}";
    }
    return _compare;
  }
  String _compare;

  @override
  String toString() {
    String msg = compareString;
    if (trxNo != null)
      return msg;
    return "trx=${trxNo}_${msg}";
  }
} // ServiceFkRequest
