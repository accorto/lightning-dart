/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * User Preferences
 * hierarchy:
 * - name     System Level - prefix
 * - name.ui  UI specific  - prefix.key
 */
class Preference {

  static final Logger _log = new Logger("Preferences");

  /**
   * Initialize
   * - called from LightningCtrl.init()
   */
  static Future<bool> init() {
    Completer<bool> completer = new Completer<bool>();
    if (_map == null) {
      _map = new Map<String,String>();
      //_log.config("init");
      if (_pref == null) {
        PreferenceStorage.getInstance()
        .then((PreferenceStorage store){
          _pref = store;
          return _pref.open();
        })
        .then((_) => _pref.dbGetMap())
        .then((Map<String, String> map) {
          _map = map;
          _log.config("init #${_map.length}");
          Settings.loadMap(map);
          completer.complete(true);
        })
        .catchError((error, StackTrace stackTrace) {
          _log.warning("init", error, stackTrace);
          completer.completeError(error, stackTrace);
        });
      } else {
        _pref.open()
        .then((_) => _pref.dbGetMap())
        .then((Map<String, String> map) {
          _map = map;
          _log.config("init(2) #${_map.length}");
          Settings.loadMap(map);
          completer.complete(true);
        })
        .catchError((error, StackTrace stackTrace) {
          _log.warning("init(2)", error, stackTrace);
          completer.completeError(error, stackTrace);
        });
      }
    } else {
      completer.complete(true);
    }
    return completer.future;
  } // init

  /// Preferences
  static PreferenceStorage _pref;
  /// Preferences Map
  static Map<String,String> _map;

  /**
   * Get value with [name] and optional [sub] category - if not found [defaultValue]
   */
  static String get(String name, String sub, String defaultValue) {
    if (_map == null) {
      init(); // ignored
      _log.fine("get ${name} ${sub} - not initialized");
    } else if (name != null && name.isNotEmpty) {
      if (sub != null && sub.isNotEmpty) {
        String key = "${name}.${sub}";
        String retValue = _map[key];
        if (retValue != null) {
          //  _log.finer("get ${key}=${retValue}");
          return retValue;
        }
      }
      // global
      String key = name;
      String retValue = _map[key];
      if (retValue != null) {
        //  _log.finer("get ${key}=${retValue} (g)");
        return retValue;
      }
    }
    // _log.finest("get ${name}.${sub} (d)");
    return defaultValue;
  }
  /// Get value with [name] if not found [defaultValue]
  static bool getBool(String name, String sub, bool defaultValue) {
    String stringValue = get(name, sub, null);
    if (stringValue != null) {
      return stringValue == "true";
    }
    return defaultValue;
  }
  /// Get value with [name] if not found [defaultValue]
  static int getInt(String name, String sub, int defaultValue) {
    String stringValue = get(name, sub, null);
    if (stringValue != null) {
      return int.parse(stringValue, onError: (s) {
        return defaultValue;
      });
    }
    return defaultValue;
  }

  /**
   * Save [name] and optional [sub] category with [value]
   */
  static void set(String name, String sub, String value) {
    if (value == null || value.isEmpty) {
      remove(name, sub);
      return;
    }
    if (_map == null) {
      init();
    }
    if (name != null && name.isNotEmpty) {
      String key = name;
      if (sub != null && sub.isNotEmpty)
        key = "${name}.${sub}";
      //
      _map[key] = value;
      _save();
    }
  } // set
  // Save [name] with [value]
  static void setBool(String name, String sub, bool value) {
    set(name, sub, value.toString());
  }
  // Save [name] with [value]
  static void setInt(String name, String sub, int value) {
    set(name, sub, value.toString());
  }

  /**
   * Remove Value
   */
  static void remove(String name, String sub) {
    if (_map == null) {
      init();
    } else if (name != null && name.isNotEmpty) {
      String key = name;
      if (sub != null && sub.isNotEmpty)
        key = "${name}.${sub}";
      _map.remove(key);
      _pref.dbDelete(key);
    }
  } // remove

  /**
   * Remove all keys starting with name
   */
  static void removeAll(String name) {
    if (_map == null) {
      init();
    }
    if (name != null && name.isNotEmpty) {
      List<String> toDelete = new List<String>();
      for (String key in _map.keys) {
        if (key.startsWith(name))
          toDelete.add(key);
      }
      for (String key in toDelete) {
        _map.remove(key);
      }
      _pref.dbDeleteList(toDelete);
    } else {
      clear();
    }
  } // removeAll

  /**
   * Clear/Remove all values
   */
  static void clear() {
    if (_map == null) {
      init();
    }
    _pref.open()
    .then((_) {
      _pref.dbClear();
      _map.clear();
    });
  } // clear

  /**
   * Save
   */
  static void _save() {
    _pref.open()
    .then((_) => _pref.dbSaveMap(_map));
  }

  /**
   * Save Preferences of [sub] as global preferences
   * returns message (title: preferenceGlobalSave())
   */
  static String saveGlobal(String sub) {
    Map<String, String> globals = new Map<String, String>();
    if (sub != null && sub.isNotEmpty) {
      RegExp re = new RegExp(".${sub}");
      _map.forEach((String key, String value){
        if (key.contains(re)) {
          String baseKey = key.replaceAll(re, "");
          globals[baseKey] = value;
        }
      });
    }
    _map.addAll(globals);
    _save();
    //
    String msg = preferenceNothingToSave();
    if (globals.isNotEmpty) {
      msg = "${sub}: ${preferenceSaved()}: #${globals.length}";
    }
    return msg;
  } // saveGlobal

  /// size of key/value pairs
  static int length(bool global) {
    if (global) {
      int count = 0;
      RegExp re = new RegExp(".");
      for (String key in _map.keys) {
        if (key.contains(re))
          count++;
      }
      return count;
    }
    return _map.length;
  }


  static String preferenceGlobalSave() => Intl.message("Save Preferences as Global", name: "preferenceGlobalSave");
  static String preferenceNothingToSave() => Intl.message("Nothing to save", name: "preferenceNothingToSave");
  static String preferenceSaved() => Intl.message("Preferences saved as Global Preferences", name: "preferenceSaved");

} // Preferences

