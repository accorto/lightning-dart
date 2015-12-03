/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Setting Item
 */
class SettingItem {

  /// Setting Name
  final String name;
  /// Updatable
  bool userUpdatable = true;

  /**
   * Setting Item
   */
  SettingItem(String this.name, {dynamic value}) {
    if (value == null)
      _valueOriginal = null;
    else if (value is String)
      _value = value;
    else
      _value = value.toString();
    if (Settings._NOT_UPDATABLE.contains(name))
      userUpdatable = false;
  }

  /// Setting Label
  String get label {
    if (_label == null) {
      _label = Settings._nameLabelMap[name];
    }
    if (_label != null) {
      return _label;
    }
    return name;
  }
  /// set label
  void set label (String newValue) {
    _label = newValue;
  }
  String _label;


  /// Data Type (EditorI) or text
  String get dataType {
    if (_dataType == null) {
      _dataType = Settings._nameTypeMap[name];
    }
    if (_dataType == null) {
      _dataType = EditorI.TYPE_TEXT;
    }
    return _dataType;
  }
  void set dataType(String newValue) {
    _dataType = newValue;
  }
  String _dataType;


  /// Setting value
  String get value {
    if (_value == null)
      return _valueOriginal;
    return _value;
  }
  /// Set Value
  void set value(dynamic newValue) {
    if (_valueOriginal == null) {
      _valueOriginal = _value;
    }
    if (newValue == null)
      _value = null;
    else if (newValue is String)
      _value = newValue;
    else
      _value = newValue.toString();
  }
  String _value;

  /// Setting value
  String get valueOriginal => _valueOriginal;
  String _valueOriginal;

  /// value is null
  bool get isNull {
    return _value == null;
  }
  /// value is null or empty
  bool get isEmpty {
    return _value == null || _value.isEmpty;
  }
  /// value is not empty
  bool get isNotEmpty {
    return _value != null && _value.isNotEmpty;
  }

  bool get isBool {
    return dataType == EditorI.TYPE_CHECKBOX;
  }
  bool get isInt {
    return dataType == EditorI.TYPE_NUMBER;
  }
  bool get isNum {
    return dataType == EditorI.TYPE_NUMBER;
  }

  /// int or 0
  int valueAsInt({int defaultValue:0}) {
    if (_value != null) {
      return int.parse(_value, onError: (String v) {
        return defaultValue;
      });
    }
    return defaultValue;
  }

  /// num or 0.0
  num valueAsNum({num defaultValue:0.0}) {
    if (_value != null) {
      return double.parse(_value, (String v) {
        return defaultValue;
      });
    }
    return defaultValue;
  }

  /// bool or false
  bool valueAsBool({bool defaultValue:false}) {
    if (_value != null)
      return _value == "true";
    return defaultValue;
  }

  /// changed
  bool get changed {
    if (_valueOriginal != null) {
      return _valueOriginal != _value;
    }
    return false;
  }

  /// reset
  void reset() {
    _value = _valueOriginal;
  }


  String toString() {
    if (_valueOriginal != null) {
      return "${name}=${_value} (${_valueOriginal})";
    }
    return "${name}=${_value}";
  }

} // SettingItem
