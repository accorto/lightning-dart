/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Meta Data Cache
 */
class MetaCache {

  /// UI List
  static final List<UI> _uiList = new List<UI>();
  /// Table List
  static final List<DTable> _tableList = new List<DTable>();

  /// Get UI By Criteria
  static UI getUi({String uiName, String tableName}) {
    for (UI ui in _uiList) {
      if (tableName != null && ui.tableName == tableName)
        return ui;
      if (uiName != null && ui.name == uiName)
        return ui;
    }
    return null;
  } // get

  /// Get Table with table name
  static DTable getTable(String tableName) {
    if (tableName != null) {
      for (DTable table in _tableList) {
        if (table.name == tableName)
          return table;
      }
    }
    return null;
  } // getTable

  /// update cache
  static void update(DisplayResponse response) {
    for (UI ui in response.uiList) {
      bool found = false;
      for (int i = 0; i < _uiList.length; i++) {
        UI cache = _uiList[i];
        if (ui.hasUiId()) {
          if (ui.uiId == cache.uiId) {
            _uiList[i] = ui;
            found = true;
            break;
          }
        } else {
          if (ui.name == cache.name) {
            _uiList[i] = ui;
            found = true;
            break;
          }
        }
      }
      if (!found) {
        _uiList.add(ui);
      }
      found = false;
      for (int i = 0; i < _tableList.length; i++) {
        DTable cache = _tableList[i];
        if (ui.table.name == cache.name) {
          _tableList[i] = ui.table;
          found = true;
          break;
        }
      }
      if (!found) {
        _tableList.add(ui.table);
      }
    }
    // table list
    for (DTable table in response.tableList) {
      bool found = false;
      for (int i = 0; i < _tableList.length; i++) {
        DTable cache = _tableList[i];
        if (table.name == cache.name) {
          _tableList[i] = table;
          found = true;
          break;
        }
      }
      if (!found) {
        _tableList.add(table);
      }
    }
  } // update

} // MetaCache

