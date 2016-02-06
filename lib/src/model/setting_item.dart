/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Setting Item.
 * You can listen to changes via [onChange]
 */
class SettingItem {

  /// Setting Name
  final String name;
  /// Updatable
  bool userUpdatable = true;

  /**
   * Setting Item with [name] and original [value]
   */
  SettingItem(String this.name, {dynamic value}) {
    if (value == null)
      _valueOriginal = null;
    else if (value is String)
      _valueOriginal = value;
    else
      _valueOriginal = value.toString();
  }

  /// Setting Label
  String get label {
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

  String get description => _description;
  void set description (String newValue) {
    _description = newValue;
  }
  String _description;

  /// Data Type (EditorI) or text
  String get dataType {
    if (_dataType == null) {
      _dataType = EditorI.TYPE_TEXT;
    }
    return _dataType;
  }
  void set dataType(String newValue) {
    _dataType = newValue;
  }
  String _dataType;

  /// Optional
  bool optional = false;

  /// Setting value
  String get value {
    if (_value == null)
      return _valueOriginal;
    if (_value == DataRecord.NULLVALUE)
      return null;
    return _value;
  }
  /// Set Value
  void set value(dynamic newValue) {
    if (newValue == null) {
      _value = DataRecord.NULLVALUE;
    } else if (newValue is String) {
      _value = newValue;
    } else {
      _value = newValue.toString();
    }
    // inform always (even if same value)
    if (_onChange != null) {
      _onChange.add(value);
    }
  } // set value
  String _value;


  /// Setting value
  String get valueOriginal => _valueOriginal;
  /// Set Value original + set value to null
  void set valueOriginal (String newValue) {
    _valueOriginal = newValue;
    _value = null;
  }
  String _valueOriginal;


  /// value is null
  bool get isNull {
    return _value == null && _valueOriginal == null;
  }
  /// value is null or empty
  bool get isEmpty {
    String vv = value;
    return vv == null || vv.isEmpty;
  }
  /// value is not empty
  bool get isNotEmpty {
    String vv = value;
    return vv != null && vv.isNotEmpty;
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
  bool get isPick {
    return dataType == EditorI.TYPE_SELECT
        && optionList != null && optionList.isNotEmpty;
  }

  /// int or 0
  int valueAsInt({int defaultValue:0}) {
    String vv = value;
    if (vv != null) {
      return int.parse(vv, onError: (String v) {
        return defaultValue;
      });
    }
    return defaultValue;
  }

  /// num or 0.0
  num valueAsNum({num defaultValue:0.0}) {
    String vv = value;
    if (vv != null) {
      return double.parse(vv, (String v) {
        return defaultValue;
      });
    }
    return defaultValue;
  }

  /// bool or false
  bool valueAsBool({bool defaultValue:false}) {
    String vv = value;
    if (vv != null)
      return vv == Settings.VALUE_TRUE;
    return defaultValue;
  }

  /// changed
  bool get changed {
    if (_value != null) {
      return _value != _valueOriginal;
    }
    return false;
  }

  /// Reset to original value
  void reset() {
    if (_value != null) {
      _value = null;
      if (_onChange != null) {
        _onChange.add(_valueOriginal);
      }
    }
  }

  /// Save individually in Preference (does not update LastMod)
  void save() {
    String vv = value;
    Preference.set(Settings._PREFERENCE_PREFIX, name, vv);
    _valueOriginal = vv;
    _value = null;

  }

  /// on Value Change
  Stream<String> get onChange {
    if (_onChange == null) {
      _onChange = new StreamController<String>.broadcast();
    }
    return _onChange.stream;
  }
  StreamController<String> _onChange;


  /// Add Option Value/Label
  void addOptionValue(final String value, final String label, {String description}) {
    DOption option = new DOption()
      ..value = value
      ..label = label;
    if (description != null && description.isNotEmpty)
      option.description = description;
    addOption(option);
  }

  /// Add Option
  void addOption(final DOption option) {
    if (optionList == null) {
      optionList = new List<DOption>();
    }
    optionList.add(option);
  }
  List<DOption> optionList;


  /// info
  String toString() {
    if (_value == null) {
      return "${name}=${_valueOriginal}";
    } else if (_valueOriginal == null) {
      return "${name}=${_value}";
    }
    return "${name}=${_value} (${_valueOriginal})";
  }

} // SettingItem
