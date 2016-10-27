/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * https://api.dartlang.org/apidocs/channels/stable/dartdoc-viewer/dart-dom-web_sql
 * http://sqlite.org/docs.html
 * http://sqlite.org/lang.html
 */
class PreferenceSQL
    extends PreferenceStorage {

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
    var completer = new Completer<bool>();
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
      _log.fine("saveMap #${map.length}");
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
      txn.executeSql(sql, [key], (txn, SqlResultSet resultSet) {
        if (resultSet.rows.isEmpty) {
          completer.complete(null);
        } else {
          Map row = resultSet.rows.item(0);
          completer.complete(row['value']);
        }
      });
    }, (error) => completer.completeError(error));
    return completer.future;
  } // get

  @override
  Future<Map<String,String>> _getMap() {
    var completer = new Completer<Map<String, String>>();
    var sql = 'SELECT id,value FROM $storeName';

    _db.transaction((txn) {
      txn.executeSql(sql, [], (var txn, SqlResultSet resultSet) {
        Map<String,String> retValue = new Map<String,String>();
        for (var i = 0; i < resultSet.rows.length; ++i) {
          Map row = resultSet.rows.item(i);
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
    var completer = new Completer<Map<String, String>>();
    var sql = 'SELECT id,value FROM $storeName';

    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, SqlResultSet resultSet) {
        Map<String,String> retValue = new Map<String,String>();
        for (var i = 0; i < resultSet.rows.length; ++i) {
          Map row = resultSet.rows.item(i);
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
    _log.config("clear");
    return completer.future;
  } // clear

  @override
  Stream<String> _keys() {
    String sql = 'SELECT id FROM $storeName';
    StreamController<String> controller = new StreamController<String>();
    _db.transaction((txn) {
      txn.executeSql(sql, [], (txn, SqlResultSet resultSet) {
        for (var i = 0; i < resultSet.rows.length; ++i) {
          Map row = resultSet.rows.item(i);
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
      txn.executeSql(sql, [], (txn, SqlResultSet resultSet) {
        for (var i = 0; i < resultSet.rows.length; ++i) {
          Map row = resultSet.rows.item(i);
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

