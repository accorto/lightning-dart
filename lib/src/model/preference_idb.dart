/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Indexed DB
 * http://docs.webplatform.org/wiki/apis/indexeddb
 * https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart-dom-indexed_db
 * https://www.dartlang.org/docs/tutorials/indexeddb/
 */
class PreferenceIDB
    extends PreferenceStorage {

  static final Logger _log = new Logger("PreferenceIDB");

  /// Returns true if IndexedDB is supported on this platform.
  static bool get supported => IdbFactory.supported;
  // Indexed DB
  Database _db;

  // Indexed DB
  PreferenceIDB ({String dbName: "BizFabrik", String storeName: "Preferences"})
      : super(dbName, storeName)  {
  }

  @override
  Future<bool> open() {
    if (!supported) {
      _log.finer("open - not supported");
      return new Future.error(
          new UnsupportedError('IndexedDB is not supported'));
    }
    if (_db != null) {
      _db.close();
    }
    return window.indexedDB.open(dbName)
        .then((Database db) {
      // _log.finest("open ${dbName} version=${db.version} stores=${db.objectStoreNames}");
      if (!db.objectStoreNames.contains(storeName)) {
        db.close();
        // All instances must be closed - otherwise blocked!
        _log.finest("open ${dbName}.${storeName} upgrade version=${db.version}");
        int version = db.version;
        Future<Database> fdb = window.indexedDB.open(dbName, // strong-mode issue
            version: version + 1,
            onUpgradeNeeded: (VersionChangeEvent e) {
              _log.finest("open ${dbName}.${storeName} upgarding to ${version+1}");
              Database db2 = (e.target as Request).result;
              db2.createObjectStore(storeName);
            },
            onBlocked: (Event e) {
              _log.finest("open ${dbName}.${storeName} blocked");
            }
        )
            .catchError((error, stackTrace){
          _log.warning("open", error, stackTrace);
        });
        return fdb;
      } else {
        return db;
      }
    })
        .then((db){
      _db = db;
      _isOpen = true;
      // _log.finer("open ${dbName}.${storeName}");
      return true;
    });
  } // open


  @override
  Future<String> _save(String key, String value) {
    return _doCommand((ObjectStore store) { // strong-mode issue
      //_log.finest("IDB ${dbName}.${storeName} save ${key}=${value}");
      return store.put(value, key);
    });
  }

  @override
  Future _saveMap(Map<String, String> map) {
    var futures = <Future>[];
    for (var key in map.keys) {
      var value = map[key];
      futures.add(_save(key, value));
    }
    _log.finest("${dbName}.${storeName} saveMap #${map.length}");
    return Future.wait(futures);
  }

  @override
  Future<String> _get(String key) {
    return _doCommand((ObjectStore store) { // strong-mode issue
      // _log.fine("IDB ${dbName}.${storeName} get ${key}");
      return store.getObject(key);
    }, 'readonly');
  }

  @override
  Future<Map<String, String>> _getMap() {
    var completer = new Completer<Map<String, String>>();
    var trans = _db.transaction(storeName, 'readonly');
    var store = trans.objectStore(storeName);
    // Get everything in the store.
    Map<String,String> retValue = new Map<String,String>();
    store.openCursor(autoAdvance: true).listen(
        (CursorWithValue cursor) {
      retValue[cursor.key] = cursor.value;
    },
        onDone: () {
          completer.complete(retValue);
          //  _log.finer("getMap #${retValue.length}");
        },
        onError: (e) => completer.completeError(e));
    return completer.future;
  }

  @override
  Future<Map<String, String>> _getMapList(Iterable<String> keys) {
    var completer = new Completer<Map<String, String>>();
    var trans = _db.transaction(storeName, 'readonly');
    var store = trans.objectStore(storeName);
    // Get everything in the store.
    Map<String,String> retValue = new Map<String,String>();
    store.openCursor(autoAdvance: true).listen(
        (CursorWithValue cursor) {
      String key = cursor.key;
      if (keys.contains(key))
        retValue[key] = cursor.value;
    },
        onDone: () => completer.complete(retValue),
        onError: (e) => completer.completeError(e));
    return completer.future;
  }


  @override
  Future _delete(String  key) {
    return _doCommand((ObjectStore store)
    => store.delete(key));
  }

  @override
  Future _deleteList(Iterable<String> keys) {
    var trans = _db.transaction(storeName, 'readwrite');
    var store = trans.objectStore(storeName);
    for (String key in keys) {
      store.delete(key);
    }
    return trans.completed;
  }

  @override
  Future _clear() {
    _log.config("${dbName}.${storeName} clear");
    return _doCommand((ObjectStore store) => store.clear());
  }

  @override
  Stream<String> _keys() {
    return _doGetAll((CursorWithValue cursor) => cursor.key);
  }

  @override
  Stream<String> _values() {
    return _doGetAll((CursorWithValue cursor) => cursor.value);
  }

  // Get All
  Stream<String> _doGetAll(dynamic onCursor(CursorWithValue cursor)) {
    var controller = new StreamController<String>();
    var trans = _db.transaction(storeName, 'readonly');
    var store = trans.objectStore(storeName);
    // Get everything in the store.
    store.openCursor(autoAdvance: true).listen(
        (cursor) => controller.add(onCursor(cursor)),
        onDone: () => controller.close(),
        onError: (e) => controller.addError(e));
    return controller.stream;
  }

  // execute
  Future _doCommand(Future requestCommand(ObjectStore store),
      [String txnMode = 'readwrite']) {
    Transaction trans = _db.transaction(storeName, txnMode);
    ObjectStore store = trans.objectStore(storeName);
    Future future = requestCommand(store);
    return trans.completed.then((_) => future);
  } // doCommand

  @override
  void close() {
    if (_db != null) {
      _db.close();
    }
    _db = null;
    _isOpen = false;
  }

} // PreferenceIDB

