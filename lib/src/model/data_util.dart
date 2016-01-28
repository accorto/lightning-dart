/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_model;

/**
 * Data and Model Utilities
 */
class DataUtil {

  static final Logger _log = new Logger("DataUtil");

  static const String UPDATE_FLAG_CREATED = "c";
  static const String UPDATE_FLAG_UPDATED = "u";
  static const String UPDATE_FLAG_DELETED = "d";

  /// 1 day in ms
  static const int ONEDAY_MS = 86400000;

  static const int SEQ_START = 100;
  static const int SEQ_STEP = 100;


  static bool isEmpty(String theValue) {
    return theValue == null || theValue.isEmpty || theValue == DataRecord.NULLVALUE;
  }
  static bool isNotEmpty(String theValue) {
    return theValue != null && theValue.isNotEmpty && theValue != DataRecord.NULLVALUE;
  }

  /**
   * Conversions
   */

  /// double converted or 0
  static double asDouble(String value) {
    if (isNotEmpty(value))
      return double.parse(value, (String value) {
        _log.warning("asDouble ${value}");
        return 0.0;
      });
    return 0.0;
  }

  /// int converted or 0
  static int asInt(String value) {
    if (isNotEmpty(value))
      return int.parse(value, onError: (String value) {
        _log.warning("asInt ${value}");
        return 0;
      });
    return 0;
  }


  /// Date - converted or null - [utc] true for Date - false for Date/Time (i.e. converts to local)
  static DateTime toDate(String valueMs, {String type: EditorI.TYPE_DATETIME, bool isUtc}) {
    if (isUtc == null)
      isUtc = type == EditorI.TYPE_DATE;
    if (isNotEmpty(valueMs)) {
      int ms = int.parse(valueMs, onError: (String value) {
        return parseDateVariable(value, type);
      });
      if (ms != 0)
        return new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    }
    return null;
  }


  /// Date - 2014-11-16 or ""
  static String asDateString(String valueMs, bool html5, bool isUtc) {
    if (isNotEmpty(valueMs)) {
      int ms = int.parse(valueMs, onError: (String value) {
        return parseDateVariable(value, EditorI.TYPE_DATE);
      });
      if (ms != 0) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
        if (html5) {
          return date.toIso8601String().substring(0, 10);
        }
        return ClientEnv.dateFormat_ymd.format(date);
      }
    }
    return "";
  }
  /// Date - 2014-11-16 or ""
  static DateTime asDate(String valueDisplay, bool html5, bool isUtc, {bool logWarning:true}) {
    if (isEmpty(valueDisplay)) {
      return null;
    }
    try {
      if (html5) {
        DateTime dt = DateTime.parse(valueDisplay); // local
        if (isUtc)
          return dt.add(dt.timeZoneOffset);
        return dt;
      } else {
        DateTime dt = ClientEnv.dateFormat_ymd.parseLoose(valueDisplay, false);
        if (isUtc)
          return dt.add(dt.timeZoneOffset);
        return dt;
      }
    } catch (ex) {
      if (logWarning)
        _log.warning("asDate ${valueDisplay}", ex);
    }
    return null;
  }
  /// Date - 2014-11-16 or ""
  static String asDateMs(String valueDisplay, bool html5, bool isUtc) {
    if (isEmpty(valueDisplay)) {
      return "";
    }
    try {
      if (html5) {
        DateTime dt = DateTime.parse(valueDisplay); // local
        if (isUtc)
          dt = dt.add(dt.timeZoneOffset);
        return dt.millisecondsSinceEpoch.toString();
      } else {
        DateTime dt = ClientEnv.dateFormat_ymd.parseLoose(valueDisplay, false);
        if (isUtc)
          dt = dt.add(dt.timeZoneOffset);
        return dt.millisecondsSinceEpoch.toString();
      }
    } catch (ex) {
      _log.warning("asDateMs ${valueDisplay}", ex);
    }
    return "";
  } // asDateMs


  /// DateTime - 2014-11-16T15:25:33 or ""
  static String asDateTimeString(String valueMs, bool html5, {bool isUtc: false}) {
    if (isNotEmpty(valueMs)) {
      int ms = int.parse(valueMs, onError: (String value) {
        return parseDateVariable(value, EditorI.TYPE_DATETIME);
      });
      if (ms != 0) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
        if (html5) {
          return date.toIso8601String().substring(0, 19);
          // cut off ms
        }
        return ClientEnv.dateFormat_ymd_hm.format(date);
      }
    }
    return "";
  }
  /// DateTime - 2014-11-16T15:25:33 or "" (local)
  static DateTime asDateTime(String valueDisplay, bool html5, {bool logWarning:true}) {
    if (isEmpty(valueDisplay)) {
      return null;
    }
    try {
      if (html5) {
        return DateTime.parse(valueDisplay); // local
      }
      DateTime dt = ClientEnv.dateFormat_ymd_hm.parseLoose(valueDisplay, false);
      return dt;
    } catch (ex) {
      if (logWarning)
        _log.warning("asDateTime ${valueDisplay}", ex);
    }
  }
  /// DateTime - 2014-11-16T15:25:33 or "" (local)
  static String asDateTimeMs(String valueDisplay, bool html5) {
    if (isEmpty(valueDisplay)) {
      return "";
    }
    try {
      if (html5) {
        DateTime dt = DateTime.parse(valueDisplay); // local
        return dt.millisecondsSinceEpoch.toString();
      }
      DateTime dt = ClientEnv.dateFormat_ymd_hm.parseLoose(valueDisplay, false);
      return dt.millisecondsSinceEpoch.toString();
    } catch (ex) {
      _log.warning("asDateTimeMs ${valueDisplay}", ex);
    }
  } // asDateTimeMs


  /// Time - 15:25:33 or "" (local)
  static String asTimeString(String valueMs, DataRecord data, bool html5) {
    if (isNotEmpty(valueMs)) {
      int ms = int.parse(valueMs, onError: (String value) {
        return parseDateVariable(value, EditorI.TYPE_TIME);
      });
      if (ms != 0) {
        DateTime date = new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: false);
        //date = _adjustTimezone(date, data, false);
        if (html5) {
          String s = date.toIso8601String();
          return s.substring(11, 19);
          // time part no ms
        }
        return ClientEnv.dateFormat_hm.format(date);
      }
    }
    return "";
  } // asTimeString
  /// Time - 15:25:33 or "" (local)
  static DateTime asTime(String valueDisplay, DataRecord data, bool html5, {bool logWarning:true}) {
    if (isNotEmpty(valueDisplay)) {
      String parse = valueDisplay;
      DateTime dt = null;
      try {
        if (html5) {
          parse = "1970-01-01 ${valueDisplay}";
          dt = DateTime.parse(parse);
        } else {
          dt = ClientEnv.dateFormat_hm.parseLoose(parse, false); // local
        }
        int ms = dt.millisecondsSinceEpoch;
        while (ms > ONEDAY_MS) {
          dt = dt.subtract(new Duration(milliseconds: ONEDAY_MS));
        }
        // dt = _adjustTimezone(dt, data, true);
        return dt;
      } catch (error, stacktrace) {
        if (logWarning)
          _log.warning("asTime parse=${parse} (${valueDisplay})", error, stacktrace);
      }
    }
    return null;
  } // asTimeMs
  /// Time - 15:25:33 or "" (local)
  static String asTimeMs(String valueDisplay, DataRecord data, bool html5) {
    if (isNotEmpty(valueDisplay)) {
      String parse = valueDisplay;
      DateTime dt = null;
      try {
        if (html5) {
          parse = "1970-01-01 ${valueDisplay}";
          dt = DateTime.parse(parse);
        } else {
          dt = ClientEnv.dateFormat_hm.parseLoose(parse, false); // local
        }
        // dt = _adjustTimezone(dt, data, true);
        int ms = dt.millisecondsSinceEpoch;
        while (ms > ONEDAY_MS)
          ms -= ONEDAY_MS;
        return ms.toString();
      } catch (error, stacktrace) {
        _log.warning("asTimeMs parse=${parse} (${valueDisplay})", error, stacktrace);
      }
    }
    return "";
  } // asTimeMs

  /// adjust date for record timezone
  static DateTime _adjustTimezone(DateTime date, DataRecord data, bool add) {
    if (date != null && data != null) {
      TZ tz = data.getTimezone();
      if (tz != null) {
        Duration tzDelta = tz.delta; // delta to current timezone
        if (tzDelta.inMilliseconds != 0) {
          if (add)
            return date.add(tzDelta);
          else
            return date.subtract(tzDelta);
        }
      }
    }
    return date; // no change
  }

  /// Parse now/time/today/date - or return 0
  static int parseDateVariable(String value, String type) {
    if (isEmpty(value) || value == "0") {
      return 0;
    }
    String lc = value.toLowerCase();
    if (lc.contains("now") || lc.contains("time") || lc.contains("today") || lc.contains("date")) {
      DateTime now = new DateTime.now();
      if (type == EditorI.TYPE_DATE) {
        DateTime date = new DateTime.utc(now.year, now.month, now.day);
        return date.millisecondsSinceEpoch; // utc
      } else if (type == EditorI.TYPE_TIME) {
        DateTime time = new DateTime(1970,1,1, now.hour, now.minute);
        return time.millisecondsSinceEpoch; // local
      } else {
        return now.millisecondsSinceEpoch; // local
      }
    }
    _log.warning("parseDateVariable ${value}");
    return 0;
  } // parseDateVariable


  /// Duration
  static DurationUtil asDuration(String value) {
    if (isNotEmpty(value)) {
      if (value.contains("P")) // xml
        return new DurationUtil.xml(value);
      int seconds = int.parse(value, onError: (String v) {
        _log.warning("asDuration ${value}");
        return 0;
      });
      return new DurationUtil.seconds(seconds);
    }
    return new DurationUtil.seconds(0);
  }

  /// Boolean
  static bool asBool(String value) {
    return value != null && value == "true";
  }

  /**
   * Mon, 03 Jul 2006 21:44:38 GMT
   */
  static String dateGmtString(DateTime dateTime) {
    DateTime dt = dateTime.toUtc();
    // leading 0
    String dd (int no) {
      if (no < 10)
        return "0${no}";
      return no.toString();
    }
    return "${_DAYS[dt.weekday-1]}, ${dd(dt.day)} ${_MONTHS[dt.month-1]} ${dt.year} "
    "${dd(dt.hour)}:${dd(dt.minute)}:${dd(dt.second)} GMT";
  }
  static final List<String> _DAYS = ['Mon', 'Tue', 'Wed', 'Thi', 'Fri', 'Sat', 'Sun'];
  static final List<String> _MONTHS = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  /**
   * Load UI from response, set table and columns
   */
  static void loadUi(List<UI> newUIs, List<DTable> newTables, List<DTable> cachedTables) {
    for (UI ui in newUIs) {
      // find table
      DTable table = null;
      for (DTable tt in newTables) {
        if (ui.tableId == tt.tableId) {
          table = tt;
          ui.table = tt;
          ui.tableName = tt.name;
          break;
        }
      }
      if (table == null) {
        for (DTable tt in cachedTables) {
          if (ui.tableId == tt.tableId) {
            table = tt;
            ui.table = tt;
            ui.tableName = tt.name;
            break;
          }
        }
      }
      if (table == null) {
        _log.warning("load: ui=${ui.name} - tableId=${ui.tableId} not found");
        continue;
      }
      assert (table.name != null);
      assert (table.label != null);

      // GridColumns
      for (UIGridColumn gc in ui.gridColumnList) {
        if (gc.columnId == null || gc.columnId.isEmpty) {
          _log.warning("load: GridColumn has no column info ${gc} - ui=${ui.name}");
          continue;
        }
        bool found = false;
        for (DColumn col in table.columnList) {
          if (gc.columnId == col.columnId) {
            gc.column = col;
            gc.columnName = col.name;
            found = true;
            assert (col.name != null);
            assert (col.label != null);
            break;
          }
        }
        if (!found)
          _log.warning("load: GridColumn - column not found ${gc} - ui=${ui.name}");
      } // gridColumns

      for (UIPanel panel in ui.panelList) {
        for (UIPanelColumn pc in panel.panelColumnList) {
          if (pc.columnId == null || pc.columnId.isEmpty) {
            _log.warning("load: PanelColumn has no column info ${pc} - ui=${ui.name} panel=${panel.name}");
            continue;
          }
          bool found = false;
          for (DColumn col in table.columnList) {
            if (pc.columnId == col.columnId) { // based on id only
              pc.column = col; // link
              pc.columnName = col.name;
              if (pc.hasExternalKey())
                col.tempExternalKey = pc.externalKey; // backlink
              // TODO overwrites
              pc.label = col.label;
              found = true;
              break;
            }
          }
          if (!found)
            _log.warning("load: PanelColumn - column not found ${pc} - ui=${ui.name} panel=${panel.name}");
        }
      } // panels

      for (UIQueryColumn qc in ui.queryColumnList) {
        if (qc.columnId == null || qc.columnId.isEmpty) {
          _log.warning("load: QueryColumn has no column info ${qc} - ui=${ui.name}");
          continue;
        }
        bool found = false;
        for (DColumn col in table.columnList) {
          if (qc.columnId == col.columnId) {
            qc.column = col;
            qc.columnName = col.name;
            found = true;
            break;
          }
        }
        if (!found)
          _log.warning("load: QueryColumn - column not found ${qc} - ui=${ui.name}");
      } // queryColumns

    } // ui
  } // loadUi

  /**
   * Validate UI Data Consistency
   * - table / table column
   * - resequence
   */
  static UI validateUi(UI ui) {
    // UI
    DTable table = ui.table;
    if (table == null) {
      _log.warning("validateUi ${ui.name} - ${ui.tableName} - no table");
    }
    if (table.hasTableId())
      ui.tableId = table.tableId;
    ui.tableName = table.name;

    // Grid (resequence active)
    int seqNo = SEQ_START;
    for (UIGridColumn gc in ui.gridColumnList) {
      if (gc.column == null) {
        gc.column = findColumn(table, gc.columnId, gc.columnName);
      } else {
        if (gc.columnName != gc.column.name)
          _log.warning("validateUi ${ui.name} GridColumn name=${gc.columnName} <> column=${gc.column.name}");
      }
      if (gc.column == null) {
        _log.warning("validateUi ${ui.name} GridColumn name=${gc.columnName} - no column");
      }
      if (gc.isActive) {
        gc.seqNo = seqNo;
        seqNo += SEQ_STEP;
      }
      if (gc.panelColumn == null) {
        gc.panelColumn = findPanelColumn(ui, gc.columnName);
        gc.panelColumn.column = gc.column; // save lookup
      }
    } // gridColumns

    // Panels
    int seqNoPanel = SEQ_START;
    for (UIPanel panel in ui.panelList) {
      if (panel.isActive) {
        panel.seqNo = seqNoPanel;
        seqNoPanel += SEQ_STEP;
      }
      seqNo = SEQ_START;
      for (UIPanelColumn pc in panel.panelColumnList) {
        if (pc.column == null) {
          pc.column = findColumn(table, pc.columnId, pc.columnName);
        } else {
          if (pc.columnName != pc.column.name)
            _log.warning("validateUi ${ui.name} PanelColumn name=${pc.columnName} <> column=${pc.column.name}");
        }
        if (pc.column == null) {
          _log.warning("validateUi ${ui.name} PanelColumn name=${pc.columnName} - no column");
        }
        if (pc.isActive) {
          pc.seqNo = seqNo;
          seqNo += SEQ_STEP;
        }
      } // panelColumn
    } // panel

    // Links
    seqNo = SEQ_START;
    for (UILink link in ui.linkList) {
      if (link.isActive) {
        link.seqNo = seqNo;
        seqNo += SEQ_STEP;
      }
    } // link

    // Processes
    seqNo = SEQ_START;
    for (UIProcess process in ui.processList) {
      if (process.isActive) {
        process.seqNo = seqNo;
        seqNo += SEQ_STEP;
      }
    } // process

    return ui;
  } // validateUi


  /**
   * Standard Column (to be ignored)
   * Created+/Updated+/IsDeleted/Revision
   */
  static bool isStdColumn(DColumn col) {
    String name = col.name;
    return name.startsWith("Created")
        || name.startsWith("Updated")
        || name == "IsDeleted" || name == "Revision";
  }

  /**
   * Find Panel Column in [ui]
   */
  static UIPanelColumn findPanelColumn(UI ui, String columnName) {
    for (UIPanel panel in ui.panelList) {
      for (UIPanelColumn pc in panel.panelColumnList) {
        if (columnName == pc.columnName)
          return pc;
      }
    }
    return null;
  } // findPanelColumn


  /**
   * Find Column in [table]
   */
  static DColumn findColumn(DTable table, String columnId, String columnName) {
    if (columnId != null && columnId.isEmpty)
      columnId = null; // otherwise match with empty value from col
    if (columnName != null && columnName.isEmpty)
      columnName = null;
    if (table != null) {
      for (DColumn col in table.columnList) {
        if (columnId == col.columnId
            || columnName == col.name)
          return col;
      }
    }
    return null;
  } // findColumn

  /**
   * Find Data Type of column with [columnName] in [table]
   */
  static DataType findDataType(DTable table, String columnId, String columnName) {
    DColumn col = findColumn(table, columnId, columnName);
    if (col != null)
      return col.dataType;
    return null;
  }


  // get first parent table name or null
  static String findParentColumnName(DTable table) {
    if (table == null)
      return null;
    for (DColumn col in table.columnList)
      if (col.isParentKey)
        return col.name;
    return null;
  } // findParentColumnName

  // get primary key column name
  static String getPkColumnName(DTable table) {
    if (table == null)
      return null;
    for (DColumn col in table.columnList)
      if (col.isPk)
        return col.name;
    return table.name + "_ID";
  } // getPkColumnName


  /**
   * Get FK Table name from [column] or null
   */
  static String getFkTableName(DColumn column) {
    DataType dt = column.dataType;
    String cn = column.name;
    if (cn.startsWith("Parent"))
      cn = cn.substring(6);
    String fkTableName = null;

    if (column.hasFkReference()) {
      // AD_UI.AD_UI_ID
      String fkReference = column.fkReference;
      if (fkReference.isNotEmpty) {
        fkTableName = fkReference;
        int index = fkTableName.indexOf(".");
        if (index != -1) {
          //String columnName = fkTableName.substring(index + 1);
          fkTableName = fkTableName.substring(0, index);
          // if (columnName != fkTableName + "_ID") // audaxisxcompiere$AD_Client.AD_Client_ID
          //  _log.warning("fkTableName ${column.name} reference=${column.fkReference}");
        }
      }
    }
    if (fkTableName == null) {
      if (dt == DataType.USER || cn == "AD_User_ID")
        fkTableName = "AD_User";
      else if (dt == DataType.TENANT)
        fkTableName = "AD_Tenant";
      else if (dt != DataType.FK) {
        return null; // no FK
      }
    }
    if (fkTableName == null) {
      int index = cn.lastIndexOf("_ID");
      if (index == -1)
        return null;
      fkTableName = cn.substring(0, index);
    }
    return fkTableName;
  } // getFkTableName


  /**
   * Get Column with [columnName] from [table]
   */
  static DColumn getTableColumn(DTable table, String columnName) {
    if (table == null || columnName == null || columnName.isEmpty)
      return null;
    for (DColumn col in table.columnList) {
      if (col.name == columnName)
        return col;
    }
    return null;
  }

  /**
   * Print UI
   */
  static void dumpUi(UI ui) {
    print("UI: ${ui.name} (${ui.label}) table=${ui.tableName}");

    print("Grid: #${ui.gridColumnList.length}");
    for (UIGridColumn gc in ui.gridColumnList) {
      print("  ${gc.columnName} ${gc.hasWidth() ? " (${gc.width})" : ""} ${gc.isActive ? "" : "inactive"} seq=${gc.seqNo}");
    }
    for (UIPanel panel in ui.panelList) {
      print("Panel: ${panel.name} columns=${panel.panelColumnNumber} ${panel.isActive ? "" : "inactive"} seq=${panel.seqNo}");
      for (UIPanelColumn pc in panel.panelColumnList) {
        print("  ${pc.columnName} ${pc.isNewRow ? "newRow" : ""} ${pc.isActive ? "" : "inactive"} seq=${pc.seqNo}");
      }
    }
  } // dumpUi


} // DataUtil
