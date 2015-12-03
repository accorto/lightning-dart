/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Settings
 */
class Settings {

  /// Initialize
  static void init() {
    _init();
    settingList.add(new SettingItem(NATIVE_HTML5, value: _valueNativeHtml5()));
    settingList.add(new SettingItem(EXPERT_MODE));
  } // init

  static const String NATIVE_HTML5 = "nativeHtml5";
  static const String EXPERT_MODE = "expertMode";

  /// original value - native Html5
  static String _valueNativeHtml5() {
    bool value = true;

    return value.toString();
  }

  /// Not Updatable
  static List<String> _NOT_UPDATABLE = [];
  /// fill name label
  static void _init() {
    if (_nameLabelMap.isEmpty) {
      _nameLabelMap[NATIVE_HTML5] = "Native Html5";
      _nameTypeMap[NATIVE_HTML5] = EditorI.TYPE_CHECKBOX;
      _nameLabelMap[EXPERT_MODE] = "Expert Mode";
      _nameTypeMap[EXPERT_MODE] = EditorI.TYPE_CHECKBOX;
    }
  }
  static Map<String, String> _nameLabelMap = new Map<String, String>();
  static Map<String, String> _nameTypeMap = new Map<String, String>();

  /// Setting List
  static final List<SettingItem> settingList = new List<SettingItem>();

  /// get Setting
  static SettingItem setting(String name) {
    for (SettingItem si in settingList) {
      if (name == si.name)
        return si;
    }
    return null;
  }

  /// get String value or null
  static String get(String name) {
    SettingItem si = setting(name);
    if (si != null)
      return si.value;
    return null;
  }

  /// set setting
  static void set(String name, dynamic value) {
    SettingItem si = setting(name);
    if (si == null) {
      si = new SettingItem(name, value: value);
    } else {
      si.value = value;
    }
  }

  /// get bool value or [defaultValue]
  static bool getAsBool(String name, {bool defaultValue:false}) {
    SettingItem si = setting(name);
    if (si != null && si.isNotEmpty)
      return si.valueAsBool(defaultValue: defaultValue);
    return defaultValue;
  }

  /// get int value or [defaultValue]
  static int getAsInt(String name, {int defaultValue:0}) {
    SettingItem si = setting(name);
    if (si != null && si.isNotEmpty)
      return si.valueAsInt(defaultValue: defaultValue);
    return defaultValue;
  }

  /// get num value or [defaultValue]
  static num getAsNum(String name, {num defaultValue:0.0}) {
    SettingItem si = setting(name);
    if (si != null && si.isNotEmpty)
      return si.valueAsNum(defaultValue: defaultValue);
    return defaultValue;
  }

} // Settings
