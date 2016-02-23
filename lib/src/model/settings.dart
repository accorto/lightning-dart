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

  static const String NATIVE_HTML5 = "nativeHtml5";
  static const String MOBILE_UI = "mobileUI";
  static const String EXPERT_MODE = "expertMode";
  static const String ICON_IMAGE = "iconImg";
  static const String GEO_ENABLED = "geoEnabled";
  static const String TEST_MODE = "testMode";

  static const String VALUE_TRUE = "true";
  static const String VALUE_FALSE = "false";

  static const String _PREFERENCE_PREFIX = "setting";
  static const String _LAST_MOD = "lastMod";

  static final Logger _log = new Logger("Settings");

  /**
   * Initialize
   * - called from [ClientEnv.init()] .. LightningDart.init()
   */
  static void init() {
    if (settingList.isEmpty) {
      add(MOBILE_UI, ClientEnv.isMobileUserAgent.toString(),
          label:"Mobile UI",
          description: "Mobile (phone, tablet) environment",
          dataType: EditorI.TYPE_CHECKBOX)
        ..optional = true;
      add(NATIVE_HTML5, ClientEnv.isMobileUserAgent.toString(),
          label:"Native Html5",
          description: "Use native HTML5 elements, e.g. date, number",
          dataType: EditorI.TYPE_CHECKBOX)
        ..optional = true;
      add(ICON_IMAGE, VALUE_FALSE,
          label:"Icon Image",
          description: "Icons use path rather than symbol",
          dataType: EditorI.TYPE_CHECKBOX)
        ..optional = true;
      add(GEO_ENABLED, VALUE_FALSE,
          label:"Geo Location",
          description: "Request browser Geo Location",
          dataType: EditorI.TYPE_CHECKBOX);
      add(EXPERT_MODE, VALUE_FALSE,
          label:"Expert Mode",
          description: "Show detailed information",
          dataType: EditorI.TYPE_CHECKBOX);
      add(TEST_MODE, VALUE_FALSE,
          label:"Test Mode",
          description: "Show debug information",
          dataType: EditorI.TYPE_CHECKBOX);
    }
  } // init

  /**
   * Add Setting
   */
  static SettingItem add(String name, String value,
      {String label,
      String dataType: EditorI.TYPE_TEXT,
      String description,
      bool userUpdatable: true}) {
    SettingItem item = new SettingItem(name, value: value)
      ..dataType = dataType
      ..userUpdatable = userUpdatable
      ..description = description;
    if (label != null)
      item.label = label;
    settingList.add(item);
    return item;
  } // add

  /**
   * Add Setting - get Value from Preference
   */
  static SettingItem addFromPreference(String name, String defaultValue,
      {String label,
      String dataType: EditorI.TYPE_TEXT,
      bool userUpdatable: true}) {
    String value = Preference.get(_PREFERENCE_PREFIX, name, defaultValue);
    return add(name, value, label:label, dataType:dataType, userUpdatable:userUpdatable);
  }

  /**
   * Load from Preferences to original value
   * (from [Preference.init()])
   */
  static void loadMap(Map<String, String> map) {
    int count = 0;
    String lastMod = map["${_PREFERENCE_PREFIX}.${_LAST_MOD}"];
    for (SettingItem item in settingList) {
      String key = "${_PREFERENCE_PREFIX}.${item.name}";
      String value = map[key];
      //
      if (value != null || item.optional) {
        item.valueOriginal = value;
        count++;
      }
    }
    _log.fine("loadMap #${count} of ${settingList.length} in ${map.length}  ${lastMod == null ? "" : lastMod}");
  } // load

  /// reset and load
  static void reset() {
    Preference.removeAll(_PREFERENCE_PREFIX);
    for (SettingItem item in settingList) {
      item.valueOriginal = null;
    }
  }


  /**
   * Store all setting values to Preferences
   */
  static void save() {
    for (SettingItem item in settingList) {
      String value = item.value;
      Preference.set(_PREFERENCE_PREFIX, item.name, value);
      item.valueOriginal = value;
    }
    Preference.set(_PREFERENCE_PREFIX, _LAST_MOD, new DateTime.now().toIso8601String());
    _log.config("save #${settingList.length}");
  } // save

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
