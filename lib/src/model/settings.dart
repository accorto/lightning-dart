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

  static const String PREFERENCE_PREFIX = "settings";
  static const String VALUE_TRUE = "true";
  static const String VALUE_FALSE = "false";

  /**
   * Initialize
   * - called from [ClientEnv.init()] .. LightningDart.init()
   */
  static void init() {
    if (settingList.isEmpty) {
      add(NATIVE_HTML5, _valueNativeHtml5(),
              label:"Native Html5", dataType: EditorI.TYPE_CHECKBOX);
      add(EXPERT_MODE, VALUE_FALSE,
              label:"Expert Mode", dataType: EditorI.TYPE_CHECKBOX);
      add(GEO_ENABLED, VALUE_FALSE,
              label:"Geo Location", dataType: EditorI.TYPE_CHECKBOX);
    }
  } // init

  /**
   * Add Setting
   */
  static SettingItem add(String name, String value,
                  {String label,
                  String dataType: EditorI.TYPE_TEXT,
                  bool userUpdatable: true}) {
    SettingItem item = new SettingItem(name, value: value)
      ..dataType = dataType
      ..userUpdatable = userUpdatable;
    if (label != null)
      item.label = label;
    Settings.settingList.add(item);
    return item;
  } // add

  /**
   * Add Setting - get Value from Preference
   */
  static SettingItem addFromPreference(String name, String defaultValue,
                         {String label,
                         String dataType: EditorI.TYPE_TEXT,
                         bool userUpdatable: true}) {
    String value = Preference.get(PREFERENCE_PREFIX, name, defaultValue);
    return add(name, value, label:label, dataType:dataType, userUpdatable:userUpdatable);
  }

    /**
   * Load from Preferences to original value
   * (initially loaded from [Preference.init()])
   */
  static void load() {
    for (SettingItem item in settingList) {
      String value = Preference.get(PREFERENCE_PREFIX, item.name, null);
      if (value != null) {
        item.valueOriginal = value;
      }
    }
  } // load

  /**
   * Store values to Preferences
   */
  static void save() {
    for (SettingItem item in settingList) {
      String value = item.value;
      Preference.set(PREFERENCE_PREFIX, item.name, value);
      item.valueOriginal = value;
    }
  } // save


  static const String NATIVE_HTML5 = "nativeHtml5";
  static const String EXPERT_MODE = "expertMode";
  static const String GEO_ENABLED = "geoEnabled";
  /// original value - native Html5
  static String _valueNativeHtml5() {
    bool value = true;

    return value.toString();
  }

  /// Setting List
  static final List<SettingItem> settingList = new List<SettingItem>();

  /// get Setting with [name] or null
  static SettingItem setting(String name) {
    for (SettingItem si in settingList) {
      if (name == si.name)
        return si;
    }
    return null;
  }

  /// get setting with [name] and return String value or null
  static String get(String name) {
    SettingItem si = setting(name);
    if (si != null)
      return si.value;
    return null;
  }

  /// set setting with [name] and set [value]
  static void set(String name, dynamic value, {bool saveToPreferences:false}) {
    SettingItem si = setting(name);
    if (si == null) {
      si = new SettingItem(name, value: value);
      settingList.add(si);
    } else {
      si.value = value;
    }
    if (saveToPreferences) {
      si.save();
    }
  } // set

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
