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

  // The Cache: String key = "${record.tableName}${URV_ID}${record.recordId}";
  //final Map<String, DFK> _map = new Map<String, DFK>();

  /// Table Cache FKs <tableName, List>
  final Map<String, List<DFK>> _tableFkMap = new Map<String, List<DFK>>();
  /// List of complete tables
  final Set<String> tableComplete = new Set<String>();

  /// Data Request Server Uri
  final String dataUri;
  /// UI Request Server Uri
  final String uiUri;

  /**
   * FK Service
   */
  FkService(String this.dataUri, String this.uiUri) {
    KeyValueMap.keyValueFill = onKeyValueFill;
    KeyValueMap.keyValueValue = onKeyValueValue;
    DataContext.valueOf = getValueOf;
  } // FkService


  /// Get Value for id [key] of [fkTableName]
  Future<String> onKeyValueValue(String fkTableName, String key) {
    Completer<String> completer = new Completer<String>();
    List<DFK> list = _tableFkMap[fkTableName];
    if (list == null) {
      getFkFuture(fkTableName, key)
      .then((DFK fk){
        completer.complete(fk.drv);
      })
      .catchError((){
        completer.complete(KeyValueMap.keyNotFoundOnServer(key));
      });
    } else {
      for (DFK fk in list) {
        if (fk.id == key) {
          completer.complete(fk.drv);
          return completer.future;
        }
      }
      getFkFuture(fkTableName, key)
      .then((DFK fk){
        completer.complete(fk.drv);
      })
      .catchError((error){
        completer.complete(KeyValueMap.keyNotFoundOnServer(key));
      });
    }
    return completer.future;
  }

  /// Fill Key Value Map
  void onKeyValueFill(KeyValueMap keyValueMap) {
    String fkTableName = keyValueMap.name;
    List<DFK> list = _tableFkMap[fkTableName];
    if (list == null) {
      getFkListFuture(fkTableName, null, null, null)
      .then((List<DFK> list) {
        keyValueMap.loadFks(list, isComplete(fkTableName));
        _log.config("onKeyValueFill ${fkTableName} #${list.length}");
      })
      .catchError((error, stackTrace) {
        _log.warning("onKeyValueFill ${fkTableName}", error, stackTrace);
      });
    } else {
      keyValueMap.loadFks(list, tableComplete.contains(fkTableName));
      _log.config("onKeyValueFill ${fkTableName} #${list.length} (cache)");
    }
  } // onKeyValueFill

  /**
   * Get FK List from Cache direct
   */
  List<DFK> getFkList(fkTableName, String restrictionSql) {
    if (restrictionSql != null && restrictionSql.isNotEmpty) {
      _tableFkMap["${fkTableName}_${restrictionSql}"];
    }
    return _tableFkMap[fkTableName];
  }

  /**
   * Retrieve from server if necessary
   */
  Future<List<DFK>> getFkListFuture(String fkTableName,
      String restrictionSql,
      String parentColumnName, String parentValue) {
    Completer<List<DFK>> completer = new Completer<List<DFK>>();
    if (fkTableName == null || fkTableName.isEmpty) {
      completer.completeError(new Exception("NoTable"));
      return completer.future;
    }
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
    return tableComplete.contains(tableName);
  }

  /**
   * Get FK from Cache direct
   */
  DFK getFk(String fkTableName, String id) {
    if (fkTableName == null || id == null)
      return null;
    List<DFK> list = _tableFkMap[fkTableName];
    if (list != null) {
      for (DFK fk in list) {
        if (fk.id == id)
          return fk;
      }
    }
    return null;
  } // getFk

  /**
   * Retrieve from server if necessary
   */
  Future<DFK> getFkFuture(String fkTableName,
      String id,
      {String parentColumnName, String parentValue}) {
    Completer<DFK> completer = new Completer<DFK>();
    // try cache
    DFK fk = getFk(fkTableName, id);
    if (fk != null) {
      completer.complete(fk);
    } else if (fkTableName == null || fkTableName.isEmpty) {
      completer.completeError(new Exception("NoTable"));
    } else if (id == null || id.isEmpty) {
      completer.completeError(new Exception("NoId"));
    }
    else {
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
    }
    return completer.future;
  } // getFkFuture

  /**
   * Add records to Cache
   */
  void addRecords (List<DRecord> records, bool allSameTable) {
    if (allSameTable && records.isNotEmpty) {
      String tableName = records.first.tableName;
      List<DFK> fkList = _tableFkMap[tableName];
      if (fkList == null) {
        fkList = new List<DFK>();
        _tableFkMap[tableName] = fkList;
      }
      if (fkList.isEmpty) {
        for (DRecord record in records) {
          DFK fk = DataRecord.createFk(record);
          fkList.add(fk);
        }
      } else {
        for (DRecord record in records) {
         addRecord(record, fkList: fkList);
        }
      }
    } else {
      for (DRecord record in records) {
        addRecord(record);
      }
    }
  } // addRecords

  /**
   * Add/update to Cache
   */
  DFK addRecord (DRecord record, {List<DFK> fkList}) {
    if (record.recordId.isEmpty)
      return null;
    DFK fk = DataRecord.createFk(record);
    // get list
    if (fkList == null) {
      String tableName = record.tableName;
      fkList = _tableFkMap[tableName];
      if (fkList == null) {
        fkList = new List<DFK>();
        _tableFkMap[tableName] = fkList;
      }
    }
    // remove old
    String id = record.recordId;
    for (int i = 0; i < fkList.length; i++) {
      if (fkList[i].id == id) {
        fkList.removeAt(i);
        break;
      }
    }
    fkList.add(fk);
    return fk;
  } // addRecord

  /**
   * Remove from Cache
   */
  DFK removeRecord (DRecord record) {
    if (record.recordId.isEmpty)
      return null;

    String tableName = record.tableName;
    List<DFK> fkList = _tableFkMap[tableName];
    if (fkList != null) {
      String id = record.recordId;
      for (int i = 0; i < fkList.length; i++) {
        DFK fk = fkList[i];
        if (fk.id == id) {
          fkList.removeAt(i);
          return fk;
        }
      }
    }
    return null;
  } // removeRecord


  /**
   * Get Value of fkTable.columnName
   * - get fkTable => table.fkColumnName
   * - get record from fkColumnValue
   * returns value or empty if found
   * see [DataContext#getJsValueOf]
   */
  String getValueOf(DTable table, String fkColumnName, String fkColumnValue, String columnName) {
    // try shortcut
    List<DFK> fkList = _tableFkMap[fkColumnName];
    // search for table
    String fkTableName = null;
    if (fkList == null) {
      DColumn col = DataUtil.getTableColumn(table, fkColumnName);
      if (col == null) {
        _log.fine("getValueOf column ${fkColumnName} NotFound table=${table}");
        return null;
      }
      if (col.hasFkReference()) {
        fkTableName = col.fkReference;
      } else {
        _log.fine("getValueOf column ${fkColumnName} NoFkReference column=${col}");
        return null;
      }
      fkList = _tableFkMap[fkTableName];
    }
    if (fkList == null) {
      _log.fine("getValueOf table=${fkTableName} for ${fkColumnName} NotFound");
      return null;
    }

    for (DFK fk in fkList) {
      if (fk.urv == fkColumnValue) { // record found
        for (DEntry entry in fk.entryList) {
          if (entry.columnName == columnName) {
            return DataRecord.getEntryValue(entry, returnEmpty: false);
          }
        }
        _log.fine("getValueOf ${fkColumnName}=${fkColumnValue} column ${columnName} NotFound");
        return null;
      }
    }
    _log.fine("getValueOf record ${fkColumnName}=${fkColumnValue} NotFound");
    return null;
  } // getValueOf

  /**
   * Similar requests active
   * - tableName
   */
  bool _isSimilarRequestActive(FkServiceRequest sr) {
    for (FkServiceRequest req in _activeRequests) {
      if (req.tableName == sr.tableName) {
        return true; // general query
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
      String details = handleSuccess(info, response.response, buffer.length);
      ServiceTracker track = new ServiceTracker(response.response, info, details);
      if (response.response.isSuccess) {
        _log.info("received ${details}");
        if (response.hasTable())
          OptionUtil.updateSynonym(response.table);
        _updateCache(sr, response.fksList, response.isFkComplete, null);
      } else {
        _log.warning("received ${details} - ${response.response.msg}");
        _updateCache(sr, new List<DFK>(), false, response.response.msg);
      }
      track.send();
    })
    .catchError((Event error, StackTrace stackTrace) {
      String message = handleError(dataUri, error, stackTrace);
      _log.warning("submit error ${info} ${message}");
      _updateCache(sr, new List<DFK>(), false, message);
    });
  } // _submit

  /**
   * Update Cache - callback from submit
   */
  void _updateCache(FkServiceRequest sr, List<DFK> newFkList,
      bool fkComplete, String errorMessage) {

    // update Cache
    if (errorMessage == null) {
      String tableName = sr.tableName;
      List<DFK> fkList = _tableFkMap[tableName];
      if (fkList == null) {
        _tableFkMap[tableName] = newFkList;
      } else {
        for (DFK fk in newFkList) {
          String id = fk.id;
          for (int i = 0; i < fkList.length; i++) {
            DFK fk = fkList[i];
            if (fk.id == id) {
              fkList.removeAt(i);
              break;
            }
          }
          fkList.add(fk);
        }
      }
      // FK complete
      if (sr.restrictionSql != null && sr.restrictionSql.isNotEmpty) {
        _tableFkMap["${tableName}_${sr.restrictionSql}"] = newFkList;
      } else if (fkComplete) {
        tableComplete.add(sr.tableName);
      }
    } // update cache

    // complete request
    if (sr.completer != null) {
      DFK fk = getFk(sr.tableName, sr.id); // cach updated cache
      if (fk == null) {
        fk = new DFK()
          ..id = sr.id
          ..drv = KeyValueMap.keyNotFoundOnServer("${sr.tableName}${URV_ID}${sr.id}")
          ..urv = sr.id;
      }
      sr.completer.complete(fk);
    }
    if (sr.completerList != null) {
      sr.completerList.complete(newFkList);
    }
    _activeRequests.remove(sr);
    _log.config("updateCache ${sr.compareString} #${newFkList.length} complete=${fkComplete}");
    _checkSimilarRequests(sr, newFkList, errorMessage);
  } // updateCache

  /// Check similar requests for completed [sr]
  void _checkSimilarRequests(FkServiceRequest sr, List<DFK> fkList, String errorMessage) {
    String srTableName = sr.tableName;
    //String srCompareString = sr.compareString;
    //
    int completed = 0;
    List<FkServiceRequest> newPendingRequests = new List<FkServiceRequest>();
    List<FkServiceRequest> submitList = new List<FkServiceRequest>();

    for (FkServiceRequest req in _pendingRequests) {
      if (req.tableName == srTableName) {
        if (req.id == null) { // list request
          if (req.completerList != null) {
            req.completerList.complete(fkList);
            completed++;
          } else {
            newPendingRequests.add(req); // copy
          }
        } else { // id request
          DFK fk = getFk(req.tableName, req.id); // do we have it in cache now
          if (fk == null) {
            if (_checkNoSameRequest(req.tableName, req.id, submitList)) {
              if (errorMessage == null) {
                submitList.add(req); // re-issue
              } else {
                fk = new DFK()
                  ..id = req.id
                  ..drv = KeyValueMap.keyNotFoundOnServer("${req.tableName}${URV_ID}${req.id}")
                  ..urv = req.id;
                req.completer.complete(fk);
              }
            } else {
              newPendingRequests.add(req); // copy
            }
          } else {
            req.completer.complete(fk); // done
            completed++;
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
    _log.fine("checkSimilarRequests ${sr.compareString} completed=${completed} reSubmitted=${submitList.length}"
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
  String get statusInfo => "requests active=${_activeRequests.length} pending=${_pendingRequests.length}";
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

  /// Cached Table Length
  //int get cacheTableLength => _tableComplete.length;
  /// Cached Tables count and details
  //String get cacheTableInfo {
  //  return "${_tableComplete.length} ${cacheTableNames}";
  // }
  /*
  List<String> get cacheTableNames {
    List<String> names = new List<String>();
    _tableFkMap.forEach((String name, List<DFK> fks) {
      names.add("${name}(${fks.length})");
    });
    names.sort((String one, String two) {
      return one.compareTo(two);
    });
    return names;
  } */



} // FkService
