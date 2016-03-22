/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/// Get Value for [key] of table [name]
typedef Future<String> KeyValueValue(String name, String key);

/// Fill Key Value Map
typedef void KeyValueFill(KeyValueMap map);

/**
 * Key Value Map
 */
class KeyValueMap implements Map<String,String> {

  /// not found on server ~ id ~
  static String keyNotFoundOnServer(String key) => "~${key}~";
  /// not found in cache <- id ->
  static String keyNotFoundInCache(String key) => "<-${key}->";
  /// not found < id >
  static String keyNotFound(String key) => "<${key}>";


  /// callback to fill map (FkService)
  static KeyValueFill keyValueFill;
  /// callback for single value (FkService)
  static KeyValueValue keyValueValue;


  /// Get Key-Value Map for Table
  static KeyValueMap getForTable(String tableName) {
    KeyValueMap map = table_map[tableName];
    if (map == null) {
      map = new KeyValueMap(tableName);
      if (keyValueFill != null) {
        keyValueFill(map);
        table_map[tableName] = map;
      }
    }
    return map;
  }
  static Map<String, KeyValueMap> table_map = new Map<String, KeyValueMap>();

  /// Get Key-Value Map for Column or null
  static KeyValueMap getForColumn(DColumn column) {
    if (column.hasFkReference()) {
      return getForTable(column.fkReference);
    } else if (column.pickValueList.isNotEmpty) {
      KeyValueMap map = new KeyValueMap(column.name);
      map.loadOptions(column.pickValueList, true);
      return map;
    }
    return null;
  } // getForColumn


  /// Column or Table Name
  final String name;
  /// Value Map
  final Map<String,String> map = new Map<String, String>();

  /// Key Value Map
  KeyValueMap(String this.name) {
  }

  /// Complete Values
  bool get isComplete => _isComplete;
  bool _isComplete = false;

  /// Load FKs
  void loadFks(List<DFK> fkList, bool isComplete) {
    for (DFK fk in fkList) {
      map[fk.urv] = fk.drv;
    }
    _isComplete = isComplete;
  }

  /// load Options
  void loadOptions(List<DOption> optionList, bool isComplete) {
    for (DOption option in optionList) {
      map[option.value] = option.label;
    }
    _isComplete = isComplete;
  }

  @override
  String operator [](Object key) {
    return getValue(key);
  }

  /// Get Value for [key]
  String getValue(String key) {
    String value = map[key];
    if (_isComplete || value != null) {
      return value;
    }
    return keyNotFoundInCache(key); // <- id ->
  }

  /// get Value for [key]
  Future<String> getValueAsync(String key) {
    String value = map[key];
    if (_isComplete || value != null) {
      Completer<String> completer = new Completer<String>();
      completer.complete(value);
      return completer.future;
    } else if (keyValueValue != null) {
      return keyValueValue(name, key);
    }
    Completer<String> completer = new Completer<String>();
    completer.complete(keyNotFoundInCache(key)); // <- id ->
    return completer.future;
  }

  @override
  void operator []=(String key, String value) {
    map[key] = value;
  }

  @override
  void addAll(Map<String, String> other) {
    map.addAll(other);
  }

  @override
  void clear() {
    map.clear();
  }

  @override
  bool containsKey(Object key) {
    return map.containsKey(key);
  }

  @override
  bool containsValue(Object value) {
    return map.containsValue(value);
  }

  @override
  void forEach(void f(String key, String value)) {
    map.forEach(f);
  }

  @override
  bool get isEmpty => map.isEmpty;

  @override
  bool get isNotEmpty => map.isNotEmpty;

  @override
  Iterable<String> get keys => map.keys;

  @override
  int get length => map.length;

  @override
  String putIfAbsent(String key, String ifAbsent()) {
    return map.putIfAbsent(key, ifAbsent);
  }

  @override
  String remove(Object key) {
    return map.remove(key);
  }

  @override
  Iterable<String> get values => map.values;


  @override
  String toString() {
    return "KeyValueMap[${name} #${map.length}]";
  }

} // KeyValueMap
