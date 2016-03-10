/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Local Storage
 */
class PreferenceLocal
    extends PreferenceStorage {

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
    var completer = new Completer<bool>();
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
    _log.fine("saveMap #${map.length} - #${_map.length}");
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
    var completer = new Completer<Map<String, String>>();
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
    var completer = new Completer<Map<String, String>>();
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
    _log.config("clear");
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

} // PreferenceLocal

