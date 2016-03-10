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
  Future<String> _save(String key, String value);

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
