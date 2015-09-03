/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Local Preferences Storage
 * Adapted from http://pub.dartlang.org/packages/lawndart
 *
 * PreferenceStorage pref = PreferenceStorage.getInstance();
 * PreferenceStorage pref = PreferenceStorage.get(storeName: "x");
 *
 * Read:
 *    return pref.open()
 *    .then((_) => pref.dbGetMap())
 *    .then((Map<String,String> map) {}
 *
 * Write:
 *    return pref.open()
 *    .then((_) => pref.dbSaveMap(map));
 *
 */
abstract class PreferenceStorage {

  /**
   * Get current preference instance
   */
  static Future<PreferenceStorage> getInstance() async {
    if (_instance == null) {
      if (IdbFactory.supported) {
        _log.config("getInstance - idb");
        _instance = new PreferenceIDB();
        try {
          await _instance.open();
          return _instance;
        } catch (error) {
          _log.config("getInstance IdbError ${error}");
        }
      }
      if (SqlDatabase.supported) {
        _log.config("getInstance - sql");
        _instance = new PreferenceSQL();
        try {
          await _instance.open();
          return _instance;
        } catch (error) {
          _log.config("getInstance SqlError ${error}");
        }
      }
      _log.config("getInstance - local");
      _instance = new PreferenceLocal();
      await _instance.open();
    }
    return _instance;
  }
  // Preferences instance
  static PreferenceStorage _instance;

  /**
   * Set preference DB instance [indexedDb] null for local
   */
  static PreferenceStorage setInstance(bool indexedDb) {
    if (indexedDb == null && !(_instance is PreferenceLocal)) {
      _log.config("setInstance - local");
      _instance = new PreferenceLocal();
    }
    else if (indexedDb && !(_instance is PreferenceIDB)) {
      _log.config("setInstance - idb");
      _instance = new PreferenceIDB();
    }
    if (!indexedDb && !(_instance is PreferenceSQL)) {
      _log.config("setInstance - sql");
      _instance = new PreferenceSQL();
    }
    _instance.open(); // test
    return _instance;
  }

  /**
   * Get current preference instance
   */
  static PreferenceStorage get({String dbName: "BizFabrik", String storeName: "Preferences"}) {
    if (IdbFactory.supported) {
      _log.config("get - idb");
      return new PreferenceIDB(dbName: dbName, storeName: storeName);
    }
    if (SqlDatabase.supported) {
      _log.config("get - sql");
      return new PreferenceSQL(dbName: dbName, storeName: storeName);
    }
    _log.config("get - local");
    return new PreferenceLocal(dbName: dbName, storeName: storeName);
  } // get


  // Logging
  static final Logger _log = new Logger("PreferenceStorage");

  // DB Name
  final String dbName;
  // Store Name
  final String storeName;

  /// Preferences
  PreferenceStorage(String this.dbName,
      String this.storeName) {
  } //

  /// db is open
  bool get isOpen => _isOpen;
  bool _isOpen = false;

  /// Returns a Future when the store is opened.
  Future<bool> open();

  // throws exception if not open
  void _checkOpen() {
    if (!_isOpen)
      throw new StateError('$runtimeType is not open');
  }

  /// Stores an [value] accessible by [key] - returns [key]
  Future<String> dbSave(String key, String value) {
    _checkOpen();
    return _save(key, value);
  }
  Future _save(String key, String value);

  /// Returns a Future with the value or null for a [key]
  Future<String> dbGet(String key) {
    _checkOpen();
    return _get(key);
  }
  Future<String> _get(String key);

  /// Returns a Future when the [key] and it's value is removed.
  Future dbDelete(String key) {
    _checkOpen();
    return _delete(key);
  }
  Future _delete(String key);

  /// Returns a Future when [keys] and their values are removed
  Future dbDeleteList(Iterable<String> keys) {
    _checkOpen();
    return _deleteList(keys);
  }
  Future _deleteList(Iterable<String> keys);

  /// Returns a Future when all values and keys are removed.
  Future dbClear() {
    _checkOpen();
    return _clear();
  }
  Future _clear();

  /// Returns all the keys as a stream. No order is guaranteed.
  Stream<String> dbKeys() {
    _checkOpen();
    return _keys();
  }
  Stream<String> _keys();

  /// Returns all the values as a stream. No order is guaranteed.
  Stream<String> dbValues() {
    _checkOpen();
    return _values();
  }
  Stream<String> _values();

  /// Stores all objects by their keys.
  Future dbSaveMap(Map<String, String> map) {
    _checkOpen();
    return _saveMap(map);
  }
  Future _saveMap(Map<String, String> map);

  /// Returns a Future with all keys and values.
  Future<Map<String, String>> dbGetMap() {
    _checkOpen();
    return _getMap();
  }
  Future<Map<String, String>> _getMap();

  /// Returns a Future with [keys] and values.
  Future<Map<String, String>> dbGetMapList(Iterable<String> keys) {
    _checkOpen();
    return _getMapList(keys);
  }
  Future<Map<String, String>> _getMapList(Iterable<String> keys);

  /// Close
  void close();

} // PreferenceStorage



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
        Future<Database> fdb = window.indexedDB.open(dbName,
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
    return _doCommand((ObjectStore store) {
      // _log.fine("IDB ${dbName}.${storeName} save ${key}=${value}");
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
    return Future.wait(futures);
  }

  @override
  Future<String> _get(String key) {
    return _doCommand((ObjectStore store) {
      // _log.fine("IDB ${dbName}.${storeName} get ${key}");
      return store.getObject(key);
    }, 'readonly');
  }

  @override
  Future<Map<String, String>> _getMap() {
    var completer = new Completer();
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
    var completer = new Completer();
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



/**********************************************************
 * https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart-dom-web_sql
 * http://sqlite.org/docs.html
 * http://sqlite.org/lang.html
 */
class PreferenceSQL extends PreferenceStorage {

  static final Logger _log = new Logger("PreferenceSQL");

  /// Returns true if WebSQL is supported on this platform.
  static bool get supported => SqlDatabase.supported;

  // WebSql
  PreferenceSQL({String dbName: "BizFabrik", String storeName: "Preferences"})
  : super(dbName, storeName)  {
  }

  String version = "1";
  int estimatedSize = 4 * 1024 * 1024;


  SqlDatabase _db;

  @override
  Future<bool> open() {
    if (!supported) {
      _log.finer("open - not supported");
      return new Future.error(
          new UnsupportedError('WebSQL is not supported'));
    }
    var completer = new Completer();
    _db = window.openDatabase(dbName, version, dbName, estimatedSize);
    _log.finer("open ${dbName}.${storeName}");
    _initDb(completer);
    return completer.future;
  }

  /// create table if not exists
  void _initDb(Completer completer) {
    var sql = 'CREATE TABLE IF NOT EXISTS $storeName (id NVARCHAR(32) UNIQUE PRIMARY KEY, value TEXT)';

    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, resultSet) {
        _isOpen = true;
        completer.complete(true);
      });
    }, (error) => completer.completeError(error));
  } // initDB

  @override
  Future<String> _save(String key, String value) {
    Completer<String> completer = new Completer<String>();
    String upsertSql = 'INSERT OR REPLACE INTO $storeName (id, value) VALUES (?, ?)';

    _db.transaction((txn) {
      txn.executeSql(upsertSql, [key, value], (txn, resultSet) {
        completer.complete(key);
      });
    }, (error) => completer.completeError(error));
    return completer.future;
  } // save

  @override
  Future _saveMap(Map<String, String> map) {
    var completer = new Completer();
    var upsertSql = 'INSERT OR REPLACE INTO $storeName (id, value) VALUES (?, ?)';

    _db.transaction((txn) {
      for (var key in map.keys) {
        String value = map[key];
        txn.executeSql(upsertSql, [key, value]);
      }
    },
        (error) => completer.completeError(error),
        () => completer.complete(true)
    );
    return completer.future;
  }

  @override
  Future<String> _get(String key) {
    Completer<String> completer = new Completer<String>();
    String sql = 'SELECT value FROM $storeName WHERE id = ?';

    _db.readTransaction((txn) {
      txn.executeSql(sql, [key], (txn, resultSet) {
        if (resultSet.rows.isEmpty) {
          completer.complete(null);
        } else {
          var row = resultSet.rows.item(0);
          completer.complete(row['value']);
        }
      });
    }, (error) => completer.completeError(error));
    return completer.future;
  } // get

  @override
  Future<Map<String,String>> _getMap() {
    var completer = new Completer();
    var sql = 'SELECT id,value FROM $storeName';

    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, resultSet) {
        Map<String,String> retValue = new Map<String,String>();
        for (var i = 0; i < resultSet.rows.length; ++i) {
          var row = resultSet.rows.item(i);
          String key = row['id'];
          String value = row['value'];
          retValue[key] = value;
        }
        _log.finer("getMap #${retValue.length}");
        completer.complete(retValue);
      });
    }, (error) => completer.completeError(error));
    return completer.future;
  }

  @override
  Future<Map<String, String>> _getMapList(Iterable<String> keys) {
    var completer = new Completer();
    var sql = 'SELECT id,value FROM $storeName';

    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, resultSet) {
        Map<String,String> retValue = new Map<String,String>();
        for (var i = 0; i < resultSet.rows.length; ++i) {
          var row = resultSet.rows.item(i);
          String key = row['id'];
          if (keys.contains(key)) {
            String value = row['value'];
            retValue[key] = value;
          }
        }
        completer.complete(retValue);
      });
    }, (error) => completer.completeError(error));
    return completer.future;
  }


  @override
  Future _delete(String key) {
    var completer = new Completer();
    var sql = 'DELETE FROM $storeName WHERE id = ?';

    _db.transaction((txn) {
      txn.executeSql(sql, [key], (txn, resultSet) {
        // maybe later, if (resultSet.rowsAffected < 0)
        completer.complete(true);
      });
    }, (error) => completer.completeError(error));

    return completer.future;
  }

  @override
  Future _deleteList(Iterable<String> keys) {
    var completer = new Completer();
    var sql = 'DELETE FROM $storeName WHERE id IN (?)';

    _db.transaction((txn) {
      txn.executeSql(sql, [keys], (txn, resultSet) {
        // maybe later, if (resultSet.rowsAffected < 0)
        completer.complete(true);
      });
    }, (error) => completer.completeError(error));

    return completer.future;
  }


  @override
  Future _clear() {
    var completer = new Completer();

    var sql = 'DELETE FROM $storeName';
    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, resultSet) => completer.complete(true));
    }, (error) => completer.completeError(error));
    return completer.future;
  } // clear

  @override
  Stream<String> _keys() {
    String sql = 'SELECT id FROM $storeName';
    StreamController<String> controller = new StreamController<String>();
    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, resultSet) {
        for (var i = 0; i < resultSet.rows.length; ++i) {
          var row = resultSet.rows.item(i);
          controller.add(row['id']);
        }
      });
    },
        (error) => controller.addError(error),
        () => controller.close());
    return controller.stream;
  } // keys

  @override
  Stream<String> _values() {
    var sql = 'SELECT value FROM $storeName';
    var controller = new StreamController<String>();
    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, resultSet) {
        for (var i = 0; i < resultSet.rows.length; ++i) {
          var row = resultSet.rows.item(i);
          controller.add(row['value']);
        }
      });
    },
        (error) => controller.addError(error),
        () => controller.close());
    return controller.stream;
  }

  @override
  void close() {
    _isOpen = false;
  }

} // PreferenceSQL

/**
 * Local Storage
 */
class PreferenceLocal extends PreferenceStorage {

  static final Logger _log = new Logger("PreferenceLocal");

  // the map
  Map<String,String> _map;
  String _prefix;

  // Local
  PreferenceLocal({String dbName: "BizFabrik", String storeName: "Preferences"})
  : super(dbName, storeName)  {
    try {
      _map = window.localStorage;
    } catch (error) {
      _log.info("init ${error}");
    }
    if (_map == null) {
      _map = new Map<String, String>();
    }
    _prefix = "${dbName}${storeName}_";
  } // PreferenceLocal


  /// convert [plainKey] to storageKey
  String _keyTo(String plainKey) {
    return "${_prefix}${plainKey}";
  }
  /// convert [storageKey] to plainKey or null
  String _keyFrom(String storageKey) {
    if (storageKey.startsWith(_prefix))
      return storageKey.substring(_prefix.length);
    return null;
  }

  @override
  Future<bool> open() {
    var completer = new Completer();
    _log.finer("open ${dbName}.${storeName} local=${_map is Storage}");
    _isOpen = true;
    completer.complete(true);
    return completer.future;
  }

  @override
  Future<String> _save(String key, String value) {
    Completer<String> completer = new Completer<String>();
    if (key != null && key.isNotEmpty) {
      if (value == null || value.isEmpty) {
        _map.remove(_keyTo(key));
      } else {
        _map[_keyTo(key)] = value;
      }
    }
    completer.complete(key);
    return completer.future;
  } // save

  @override
  Future _saveMap(Map<String, String> map) {
    var completer = new Completer();
    map.forEach((String key, String value){
      _map[_keyTo(key)] = value;
    });
    completer.complete();
    return completer.future;
  }

  @override
  Future<String> _get(String key) {
    Completer<String> completer = new Completer<String>();
    if (key == null || key.isEmpty) {
      completer.complete(null);
    } else {
      completer.complete(_map[_keyTo(key)]);
    }
    return completer.future;
  } // get

  @override
  Future<Map<String,String>> _getMap() {
    var completer = new Completer();
    Map<String, String> mm = new Map<String, String>();
    _map.forEach((String key, String value){
      String plainKey = _keyFrom(key);
      if (plainKey != null)
        mm[plainKey] = value;
    });
    completer.complete(mm);
    return completer.future;
  }

  @override
  Future<Map<String, String>> _getMapList(Iterable<String> keys) {
    var completer = new Completer();
    Map<String, String> mm = new Map<String, String>();
    for (String key in keys) {
      mm[key] = _map[_keyTo(key)];
    }
    completer.complete(mm);
    return completer.future;
  }

  @override
  Future _delete(String key) {
    var completer = new Completer();
    if (key != null && key.isNotEmpty) {
      _map.remove(_keyTo(key));
    }
    completer.complete();
    return completer.future;
  }

  @override
  Future _deleteList(Iterable<String> keys) {
    var completer = new Completer();
    for (String key in keys) {
      _map.remove(_keyTo(key));
    }
    completer.complete();
    return completer.future;
  }

  @override
  Future _clear() {
    var completer = new Completer();
    List<String> keys = new List<String>();
    _map.forEach((String key, String value){
      if (key.startsWith(_prefix))
        keys.add(key);
    });
    for (String key in keys) {
      _map.remove(key);
    }
    completer.complete();
    return completer.future;
  } // clear

  @override
  Stream<String> _keys() {
    StreamController<String> controller = new StreamController<String>();
    for (String key in _map.keys) {
      String plainKey = _keyFrom(key);
      if (plainKey != null)
        controller.add(plainKey);
    }
    controller.close();
    return controller.stream;
  } // keys

  @override
  Stream<String> _values() {
    var controller = new StreamController<String>();
    _map.forEach((String key, String value){
      if (key.startsWith(_prefix))
        controller.add(value);
    });
    controller.close();
    return controller.stream;
  }

  @override
  void close() {
    _isOpen = false;
  }

} // PreferenceSQL
