/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_model;

/**
 * onRecordChanged Callback when [columnChanged] in [record] at [rowNo]
 */
typedef void RecordChange(DRecord record, DEntry columnChanged, int rowNo);

/**
 * Data Record - DRecord functionality
 * Manages the Record value/context
 */
class DataRecord {

  /**
   * Get Filter for Parent Queries from [record]
   */
  static DFilter getParentFilter(DRecord record, {String linkColumnName}) {
    assert (record != null);
    String tableName = record.tableName;
    String query = record.query;

    DFilter filter = new DFilter()
      ..operation = DOP.EQ;

    // (1) link column name
    if (linkColumnName != null && linkColumnName.isNotEmpty) {
      String value = DataRecord.getColumnValue(record, linkColumnName);
      filter
        ..columnName = linkColumnName
        ..filterValue = value
        ..dataType = DataType.FK;
      if (value == null || value.isEmpty) {
        _log.warning("getParentFilter ${tableName} "
            "link ${linkColumnName}=${value}");
      }
    }
    // (2) query
    else if (query.isNotEmpty) {
      List<String> parts = query.split("=");
      if (parts.length == 2) {
        filter
          ..columnName = parts[0]
          ..filterValue = parts[1]
          ..dataType = DataType.FK;
      } else {
        // pass-though ?
        filter
          ..columnName = record.tableName // "sql"
          ..operation = DOP.SQL;
        // filter.filterDirectQuery
        _log.warning("getParentFilter ${tableName} query ${query}");
      }
    }
    // (3) deriving
    else {
      filter
        ..columnName = record.tableName + "_ID"
        ..filterValue = record.recordId
        ..dataType = DataType.FK;
      _log.warning("getParentFilter ${tableName} "
          "NoQuery ${filter.columnName}=${filter.filterValue}");
    }
    filter.filterDirectQuery = query;
    filter.isReadOnly = true;
    return filter;
  } // getParentFilter


  /// create who info multi line
  static String infoWho(DRecord record) {
    if (record == null)
      return "";
    StringBuffer sb = new StringBuffer();
    sb.write(record.who);
    sb.write("\n");
    sb.write(record.query);
    sb.write("\n");
    sb.write(record.urv);
    if (record.urv != record.urvRest) {
      sb.write("\n");
      sb.write(record.urvRest);
    }
    String tenantName = getColumnValue(record, "Tenant");
    if (tenantName != null && tenantName.isNotEmpty) {
      sb.write("\nTenant=");
      sb.write(tenantName);
    }
    return sb.toString();
  } // whoInfo

  /**
   * Get value as String for [columnName] or null if not found
   */
  static String getColumnValue(DRecord record, String columnName) {
    if (columnName != null && record != null && record.entryList.isNotEmpty) {
      for (DEntry entry in record.entryList) {
        if (columnName == entry.columnName) {
          return getEntryValue(entry);
        }
      }
    }
    return null;
  } // columnValue

  /**
   * Set Value as Int or default value (null)
   */
  static int getColumnValueAsInt(DRecord record, String columnName, {int defaultValue}) {
    String ss = getColumnValue(record, columnName);
    if (ss != null && ss.isNotEmpty) {
      return int.parse(ss, onError: (String s){
        return defaultValue;
      });
    }
    return defaultValue;
  } // columnValue

  /**
   * Get value as String for [columnName] or null if not found
   */
  static String getColumnValueFk(DFK fk, String columnName) {
    if (columnName != null && fk != null && fk.entryList.isNotEmpty) {
      for (DEntry entry in fk.entryList) {
        if (columnName == entry.columnName) {
          return getEntryValue(entry);
        }
      }
    }
    return null;
  } // columnValueFk

  /// Create FK from Record
  static DFK createFk(DRecord record, {DTable table}) {
    DFK fk = new DFK()
      ..tableName = record.tableName
      ..id = record.recordId
      ..urv = record.urv
      ..drv = record.drv;
    fk.entryList.addAll(record.entryList);
    /* add drv/urv entries
    if (table != null) {
      for (DColumn col in table.columnList) {
        if ((col.hasUniqueSeqNo() && col.uniqueSeqNo > 0)
            || (col.hasDisplaySeqNo() && col.displaySeqNo > 0)) {
          for (DEntry entry in record.entryList) {
            if (col.name == entry.columnName) {
              fk.entryList.add(entry);
              break;
            }
          }
        }
      }
    } */
    return fk;
  } // createFk

  /**
   * Get value (original) of entry - if [returnEmpty] returns "" for null
   */
  static String getEntryValue(DEntry dataEntry, {bool returnEmpty:true}) {
    if (dataEntry != null) {
      String value = null;
      if (dataEntry.hasValue())
        value = dataEntry.value;
      else if (dataEntry.hasValueOriginal()) {
        value = dataEntry.valueOriginal;
      }
      if (DataUtil.isEmpty(value)) {
        if (returnEmpty)
          return ""; // found but empty
        return null;
      }
      return value;
    }
    return null;
  } // getEntryValue

  /**
   * Set Entry [dataEntry] to new string [value].
   * Update changed + original
   * return true if changed
   */
  static bool setEntryValue(DEntry dataEntry, final String newValue, {bool setOriginal:true}) {
    // set original if not set before
    if (setOriginal && !dataEntry.hasValueOriginal()) {
      if (dataEntry.hasValue())
        dataEntry.valueOriginal = dataEntry.value;
      else
        dataEntry.valueOriginal = NULLVALUE;
    }
    // set input
    String deValue = newValue;
    if (deValue == null || deValue.isEmpty)
      deValue = NULLVALUE;
    dataEntry.value = deValue;
    //
    dataEntry.clearValueDisplay();
    dataEntry.isChanged = dataEntry.value != dataEntry.valueOriginal;
    return dataEntry.isChanged;
  } // setEntryValue

  /**
   * Set [columnName] in [record] to [newValue]
   * return true if changed
   */
  static bool setColumnValue(DRecord record, String columnName, String newValue) {
    DEntry dataEntry = null;
    for (DEntry entry in record.entryList) {
      if (columnName == entry.columnName) {
        dataEntry = entry;
        break;
      }
    }
    if (dataEntry == null) {
      dataEntry = new DEntry()
          ..columnName = columnName;
      record.entryList.add(dataEntry);
      record.isChanged = true;
    }
    return setEntryValue(dataEntry, newValue, setOriginal:false);
  } // setColumnValue


  /// id - record map
  static Map<String, DRecord> recordMap(List<DRecord> list) {
    Map<String, DRecord> map = new Map<String, DRecord>();
    int countEmpty = 0;
    for (DRecord record in list) {
      String id = record.recordId;
      if (id.isEmpty) {
        countEmpty++;
      } else {
        map[id] = record;
      }
    }
    if (list.length != map.length) {
      _log.info("recordMap length=${map.length} - list=${list.length} empty=${countEmpty}");
    }
    return map;
  } // recordMap


  /// Null Value indicator (Dto.NULLVALUE)
  static const String NULLVALUE = "::NullValue::";
  /// Column Name IsActive
  static const String C_ISACTIVE = "IsActive";
  /// Column Name IsActive
  static const String C_PROCESSED = "Processed";
  /// Column Name IsActive
  static const String C_SEQNO = "SeqNo";
  /// URV Constant
  static const String URV = "urv";

  // Log
  static final Logger _log = new Logger("DataRecord");

  // table
  DTable table;
  /// callback to data owner
  RecordChange onRecordChange;
  /// The actual Record
  DRecord _record = new DRecord();
  /// row number
  int rowNo = 0;

  /**
   * Data Record with [value] and optional [onRecordChange] callback to data list
   */
  DataRecord(DTable this.table, RecordChange this.onRecordChange,
      {DRecord value, int rowNo: -1}) {
    setRecord(value, rowNo);
  }

  /// Set current record
  void setRecord (DRecord value, int rowNo) {
    this.rowNo = rowNo;
    if (value == null)
      _record = new DRecord();
    else
      _record = value;
    resetCached();
  }
  /// Get current record
  DRecord get record => _record;

  /// reset cached values
  void resetCached() {
    _cacheRO = null;
    _cacheActive = null;
    _cacheProcessed = null;
  }

  /**
   * Record is read only (static + last calc)
   *    | table.readOnlyLogic
   *    | !active | processes
   */
  bool get isReadOnly {
    if (_record != null) {
      if (_record.hasIsGroupBy() && _record.isGroupBy)
        return true;
      if (_record.hasIsReadOnly() && _record.isReadOnly)
        return true;
      if (_record.hasIsReadOnlyCalc() && _record.isReadOnlyCalc)
        return true;
    }
    if (table == null) {
      _log.warning("isReadOnly #${rowNo} - table not set");
    } else if (table.hasReadOnlyLogic()) {
      if (_cacheRO == null || changed)
        _cacheRO = DataContext.evaluateBool(this, table.readOnlyLogic);
      if (_cacheRO)
        return true;
    }
    return !isActive || isProcessed;
  } // isReadOnly
  bool _cacheRO;

  /// Record active (default: true)
  bool get isActive {
    if (_cacheActive == null || changed) {
      DEntry entry = getEntry(null, C_ISACTIVE, false);
      if (entry == null) {
        _cacheActive = true; // default
      } else {
        _cacheActive = getEntryValue(entry) == "true";
      }
    }
    return _cacheActive;
  } // isActive
  bool _cacheActive;

  /// Record active (default: false)
  bool get isProcessed {
    if (_cacheProcessed == null || changed) {
      DEntry entry = getEntry(null, C_PROCESSED, false);
      if (entry == null) {
        _cacheProcessed = false; // default
      } else {
        _cacheProcessed = getEntryValue(entry) == "true";
      }
    }
    return _cacheProcessed;
  } // isProcessed
  bool _cacheProcessed;

  /// Is the Record empty (no entities)
  bool get isEmpty => _record.entryList.isEmpty;

  /// Is the record New (never saved)
  bool get isNew => _record.hasTableName() && !_record.hasRecordId();

  /// Is a group by Record
  bool get isGroupBy => _record.isGroupBy;

  /// Selected
  bool get selected => _record.hasIsSelected() && _record.isSelected;
  /// Selected
  void set selected (bool newValue) {
    _record.isSelected = newValue;
  }

  /// Changed see [checkChanged]
  bool get changed => _record.hasIsChanged() && _record.isChanged;
  /// Check if record is changed
  bool checkChanged() {
    bool changed = false;
    for (DEntry entry in _record.entryList) {
      if (entry.isChanged) {
        changed = true;
        break;
      }
    }
    _record.isChanged = changed;
    return changed;
  } // checkChanged

  /// URV (rest)
  String get urvRest => _record.urvRest;
  /// Record Id
  String get recordId => _record.recordId;


  /**
   * Create new record based on column defaults
   * call DataService.recordNew
   * - table must be set
   */
  DRecord newRecord(DRecord parentRecord, {int rowNo:-1}) {
    setRecord(null, rowNo); // create new
    if (table == null) {
      _log.warning("newRecord #${rowNo} - table not set");
    } else {
      _record.tableId = table.tableId;
      _record.tableName = table.name;
    }
    //
    if (parentRecord != null)
      _record.parent = parentRecord;
    // set defaults from table column
    if (table != null) {
      for (DColumn col in table.columnList) {
        if (col.isParentKey) {
          if (parentRecord == null) {
            if (col.isMandatory)
              _log.warning("newRecord #${rowNo} (${table.name}) - no parent record");
          } else {
            DataRecord parentData = new DataRecord(null, null, value: parentRecord);
            DEntry parentEntry = parentData.getEntry(col.columnId, col.name, false);
            if (parentEntry == null) {
              _log.warning("newRecord #${rowNo} (${table.name}) - no parent record entry ${col.name}");
            } else {
              DEntry entry = getEntry(col.columnId, col.name, true);
              entry.value = parentEntry.value;
              _log.config("newRecord #${rowNo} (${table.name}).${col.name}=${entry.value}");
            }
          }
        }
        else if (col.hasDefaultValue()) {
          if (DataUtil.isStdColumn(col))
            continue;
          DEntry entry = getEntry(col.columnId, col.name, true);
          entry.value = DataContext.contextReplace(this, col.defaultValue,
            nullResultOk: true, emptyResultOk: true, columnName: col.name);
        }
        else if (col.name == C_ISACTIVE) {
          DEntry entry = getEntry(col.columnId, col.name, true);
          entry.value = "true";
        }
      }
    }
    // set as original (for reset)
    setValueOriginal();
    return _record;
  } // newRecord

  /// copy record - make sure that Table is set
  DRecord copyRecord(DRecord currentRecord) {
    setRecord(null, -1);
    DataRecord currentData = new DataRecord(table, null, value: currentRecord);
    if (table == null) {
      _log.warning("copyRecord #${rowNo} - table not set");
    } else {
      for (DColumn col in table.columnList) {
        if (!col.isCopied || DataUtil.isStdColumn(col))
          continue;
        String value = currentData.getValueOf(id: col.columnId, name: col.name);
        if ((value == null || value.isEmpty) && col.hasDefaultValue())
          value = col.defaultValue;
        if (value != null && value.isNotEmpty) {
          DEntry entry = getEntry(col.columnId, col.name, true);
          entry.value = col.defaultValue;
        }
      }
    }
    return _record;
  } // copyRecord


  /**
   * Get value by [id] or column [name] (key)
   */
  String getValueOf({String id, String name}) {
    return getEntryValue(getEntry(id, name, false));
  }
  /// get value of [name]
  String getValue(String name) {
    return getEntryValue(getEntry(null, name, false));
  }
  /**
   * Get value as int by [id] or column [name] (key)
   * Returns 0 if invalid or null
   */
  int getValueAsInt(String name) {
    String value = getEntryValue(getEntry(null, name, false));
    return DataUtil.asInt(value);
  }
  /**
   * Get value as int by [id] or column [name] (key)
   * Returns false if invalid or null
   */
  bool getValueAsBool(String name) {
    String value = getEntryValue(getEntry(null, name, false));
    return DataUtil.asBool(value);
  }

  /**
   * Get Display Info for [col] column
   */
  String getDisplay(DColumn col) {
    DEntry entry = null;
    for (DEntry ee in _record.entryList) {
      if (col.name == ee.columnName) {
        entry = ee;
        break;
      }
    }
    if (entry == null)
      return "";
    if (entry.valueDisplay.isNotEmpty)
      return entry.valueDisplay;
    return entry.value;
  }

  /**
   * Get Column Entry by [id] columnId or column [name] (key) - [create] if not exists
   */
  DEntry getEntry (String id, String name, bool create, {String createDefault}) {
    if (id != null && id.isEmpty)
      id = null;
    if (name != null && name.isEmpty)
      name = null;
    for (DEntry entry in _record.entryList) {
      if (entry.columnId == id || entry.columnName == name)
        return entry;
    }
    if (create) {
      DEntry dataEntry = new DEntry()
        ..isChanged = false;
      if (id != null)
        dataEntry.columnId = id;
      if (name != null)
        dataEntry.columnName = name;
      if (createDefault != null && createDefault.isNotEmpty)
        dataEntry.value = createDefault;
      _record.entryList.add(dataEntry);
      return dataEntry;
    }
    return null;
  } // getEntry

  /// Get Timezone
  TZ getTimezone() {
    for (DEntry entry in _record.entryList) {
      if (entry.columnName == TZ.TZ_COLUMN_NAME) {
        if (entry.value == NULLVALUE)
          return null;
        String tzName = entry.value;
        String alias = TzRef.alias(tzName);
        TZ tz = TZ.findTimeZone(alias);
        if (tz == null) {
          if (alias != tzName)
            tz = TZ.findTimeZone(tzName);
        }
        return tz;
      }
    }
    return null;
  } // getTimezone

  /**
   * Get Column Statistics by [id] columnId or column [name] (key)
   */
  DStatistics getStatistics(String id, String name) {
    for (DStatistics stats in _record.statList) {
      if ((id != null && id.isNotEmpty && stats.columnId == id)
          || (name != null && name.isNotEmpty && stats.columnName == name))
        return stats;
    }
    return null;
  }



  /**
   * Set Entry [value] by column [id] or column [name] (key)
   * Update changed + original
   */
  DEntry setValue (String id, String name, String value) {
    DEntry dataEntry = getEntry(id, name, true);
    updateEntry(dataEntry, value);
    return dataEntry;
  } // setValue

  /**
   * Set Entry [value] converted from (bool, int, String)
   * by column [name]. Update changed + original
   */
  DEntry setValueName (String name, dynamic value) {
    DEntry dataEntry = getEntry(null, name, true);
    String stringValue = null;
    if (value != null) {
      if (value is String)
        stringValue = value;
      else if (value is bool)
        stringValue = value ? "true" : "false";
      else if (value is int)
        stringValue = value.toString();
      else
        stringValue = value.toString();
    }
    updateEntry(dataEntry, stringValue);
    return dataEntry;
  } // setValueName

  /**
   * Set Entry [dataEntry] to new string [value].
   * Update changed + original
   * return true if changed
   */
  bool updateEntry (DEntry dataEntry, final String newValue) {
    if (setEntryValue(dataEntry, newValue))
      _record.isChanged = true;
    return dataEntry.isChanged;
  } // updateEntry

  /**
   * Set all Values as Original
   */
  void setValueOriginal() {
    for (DEntry entry in _record.entryList) {
      if (entry.hasValue())
        entry.valueOriginal = entry.value;
      else
        entry.clearValueOriginal();
      entry.isChanged = false;
    }
    _record.isChanged = false;
  } // setValueOriginal

  /**
   * Reset Record (all entries)
   */
  void resetRecord() {
    for (DEntry entry in _record.entryList) {
      resetEntry(entry);
    }
    _record.clearIsChanged();
    //_record.clearIsSelected();
  } // resetRecord

  /**
   * Reset to Original for Entry with [id] or column [name] (key)
   */
  String resetValue (String id, String name) {
    DEntry dataEntry = getEntry(id, name, false);
    resetEntry(dataEntry);
    return getEntryValue(dataEntry);
  } // reset

  /**
   * Reset to Original
   */
  void resetEntry (DEntry dataEntry) {
    if (dataEntry != null) {
      if (dataEntry.hasValueOriginal()) {
        dataEntry.value = dataEntry.valueOriginal;
        dataEntry.clearValueOriginal();
        if (dataEntry.value == NULLVALUE)
          dataEntry.clearValue();
      } else {
        dataEntry.clearValue();
      }
      dataEntry.clearValueDisplay();
      dataEntry.clearIsChanged();
      resetCached();
    }
  } // resetEntry

  /**
   * Data Record Value Changed - called from EditorI
   */
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    if (entry != null) {
      String valueOriginalD = entry.valueOriginal;
      if (NULLVALUE == valueOriginalD)
        valueOriginalD = "null";
      String oldValueD = entry.value;
      if (NULLVALUE == oldValueD)
        oldValueD = "null";
      _log.fine("onEditorChange #${rowNo} ${name} rowNo=${rowNo} value=${newValue} old=${oldValueD} (orig=${valueOriginalD})");
    } else {
      _log.fine("onEditorChange #${rowNo} ${name} rowNo=${rowNo} value=${newValue}");
    }
    // data list - controller
    if (onRecordChange != null) {
      if (entry == null && name != null && name.isNotEmpty) {
        entry = getEntry(null, name, true);
        updateEntry(entry, newValue);
      }
      onRecordChange(_record, entry, rowNo); // data list
    }
  } // onEditorChanged


  /**
   * Get Record as context with [windowNo] window prefix
   */
  List<DKeyValue> asContext(int windowNo) {
    List<DKeyValue> context = new List<DKeyValue>();
    for (DEntry ee in _record.entryList) {
      String value = getEntryValue(ee);
      if (value != null && value.isNotEmpty) {
        context.add(new DKeyValue()
          ..key = "${windowNo}|${ee.columnName}"
          ..value = value);
      }
    }
    return context;
  } // asContext

  @override
  String toString() {
    if (record.hasUrvRest()) {
      return "DataRecord@${recordId}[urv=${urvRest}, changed=${changed}]";
    }
    return "DataRecord@${recordId}[changed=${changed}]";
  }

} // DataRecord
