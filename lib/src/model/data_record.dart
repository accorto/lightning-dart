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
      DataRecord data = new DataRecord(null, value: record);
      String value = data.getValue(name: linkColumnName);
      filter
        ..columnName = linkColumnName
        ..filterValue = value
        ..dataType = DataType.FK;
      if (value == null || value.isEmpty) {
        _log.warning("getParentFilter ${tableName} link ${linkColumnName}=${value}");
      }
    } // (2) query
    else if (query.isNotEmpty) {
      List<String> parts = query.split("=");
      if (parts.length == 2) {
        filter
          ..columnName = parts[0]
          ..filterValue = parts[1]
          ..dataType = DataType.FK;
      } else { // pass-though ?
        filter
          ..columnName = record.tableName
          ..operation = DOP.SQL;
        _log.warning("getParentFilter ${tableName} query ${query}");
      }
    } // (3) deriving
    else {
      filter
        ..columnName = record.tableName + "_ID"
        ..filterValue = record.recordId
        ..dataType = DataType.FK;
      _log.warning("getParentFilter ${tableName} NoQuery ${filter.columnName}=${filter.filterValue}");
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
    DataRecord data = new DataRecord(null, value: record);
    sb.write("\nTenant=");
    sb.write(data.getValue(name: "Tenant"));
    return sb.toString();
  } // whoInfo

  /**
   * Popup with Record Info
   */
//  static void infoDisplay(DRecord record) {
//    if (record == null)
//      return;
//    MiniTable table = new MiniTable();
//    table.element.style.fontSize = "smaller";
//
//    table.addRowHdrDatas("Urv", [record.urv, record.urv != record.urvRest ? record.urvRest : "", ""]);
//    table.addRowHdrData("Who", record.who, colSpan: 3);
//    table.addRowHdrDatas("Query", [record.query, record.tableName, record.recordId]);
//
//    table.addRowData([
//      "Revision=${record.revision}",
//      record.isSelected ? "selected" : "",
//      record.isChanged ? "changed" : "",
//      ""]);
//    table.addRowData([
//      record.isReadOnly ? "r/o" : "r/w",
//      record.isReadOnlyCalc ? "r/o calc" : "",
//      record.isMandatoryCalc ? "mandatory calc" : "",
//      ""]);
//
//    if (record.hasParent()) {
//      table.addRowHdrDatas("Parent", [record.parent.drv, record.parent.urv, record.parent.query]);
//    }
//    table.addRowData(["stat=#${record.statList.length}",
//      record.isGroupBy ? "groupBy" : "",
//      record.isMatchFind ? "match" : "",
//      ""]);
//
//    table.addRowHeadings(["Column", "Value", "Original", "Display"]);
//    for (DEntry entry in record.entryList) {
//      table.addRowData([entry.columnName, entry.value, entry.isChanged ? entry.clearValueOriginal() : "", entry.clearValueDisplay()]);
//    }
//
//    new BizConfirm(type: BizConfirm.TYPE_INFO,
//        title: record.drv,
//        messageElement: table.element)
//    .show();
//  } // infoDisplay

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


  /**
   * Get value (original) of entry
   */
  static String getEntryValue(DEntry dataEntry) {
    if (dataEntry != null) {
      String value = null;
      if (dataEntry.hasValue())
        value = dataEntry.value;
      else if (dataEntry.hasValueOriginal()) {
        value = dataEntry.valueOriginal;
      }
      if (DataUtil.isEmpty(value)) {
        return ""; // found but empty
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
  static bool setEntryValue (DEntry dataEntry, final String newValue) {
    // set original if not set before
    if (!dataEntry.hasValueOriginal()) {
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
    dataEntry.isChanged = dataEntry.value != dataEntry.valueOriginal;
    return dataEntry.isChanged;
  } // setEntryValue



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

  /// The actual Record
  DRecord _record = new DRecord();
  /// row number
  int rowNo = 0;
  /// callback to data owner
  RecordChange onRecordChange;

  /**
   * Data Record with [value] and optional [onRecordChange] callback to data list
   */
  DataRecord(RecordChange this.onRecordChange, {DRecord value}) {
    setRecord(value, 0);
  }

  void reset() {
    setRecord(null, -1);
    onRecordChange = null;
  }

  void set(DataRecord other) {
    if (other == null) {
      reset();
    } else {
      setRecord(other.record, other.rowNo);
      onRecordChange = other.onRecordChange;
    }
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
   *
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
    if (_table == null) {
      _log.warning("isReadOnly - table not set");
    } else if (_table.hasReadOnlyLogic()) {
      if (_cacheRO == null || changed)
        _cacheRO = DataContext.evaluateBool(_record, _table, _table.readOnlyLogic);
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
  bool get isEmpty => _record.entryList.isEmpty
      && !_record.hasTableName(); // not a new record

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

  /// Changed
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
  String get urv => _record.urvRest;
  /// Record Id
  String get recordId => _record.recordId;


  /**
   * Create new record based on column defaults
   * call DataService.recordNew
   * - table must be set
   */
  DRecord newRecord(DRecord parentRecord) {
    setRecord(null, -1); // create new
    if (_table == null) {
      _log.warning("newRecord - table not set");
    } else {
      _record.tableId = table.tableId;
      _record.tableName = table.name;
    }
    //
    if (parentRecord != null)
      _record.parent = parentRecord;
    DataRecord parentData = new DataRecord(null, value: parentRecord);
    // set defaults from table column
    if(_table != null) {
      for (DColumn col in _table.columnList) {
        if (col.isParentKey) {
          if (parentRecord == null) {
            if (col.isMandatory)
              _log.warning("newRecord(${table.name}) - no parent record");
          } else {
            DEntry parentEntry = parentData.getEntry(col.columnId, col.name, false);
            if (parentEntry == null) {
              _log.warning("newRecord(${table.name}) - no parent record entry ${col.name}");
            } else {
              DEntry entry = getEntry(col.columnId, col.name, true);
              entry.value = parentEntry.value;
              _log.config("newRecord(${table.name}).${col.name}=${entry.value}");
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
    DataRecord currentData = new DataRecord(null, value: currentRecord);
    if (_table == null) {
      _log.warning("copyRecord - table not set");
    } else {
      for (DColumn col in _table.columnList) {
        if (!col.isCopied || DataUtil.isStdColumn(col))
          continue;
        String value = currentData.getValue(id: col.columnId, name: col.name);
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
  String getValue({String id, String name}) {
    return getEntryValue(getEntry(id, name, false));
  }
  /**
   * Get value as int by [id] or column [name] (key)
   * Returns 0 if invalid or null
   */
  int getValueAsInt({String id, String name}) {
    String value = getEntryValue(getEntry(id, name, false));
    return DataUtil.asInt(value);
  }
  /**
   * Get value as int by [id] or column [name] (key)
   * Returns false if invalid or null
   */
  bool getValueAsBool({String id, String name}) {
    String value = getEntryValue(getEntry(id, name, false));
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
    for (DEntry entry in _record.entryList) {
      if ((id != null && id.isNotEmpty && entry.columnId == id)
          || (name != null && name.isNotEmpty && entry.columnName == name))
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
      if (entry.columnName == "Timezone") {
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
    _record.isChanged = false;
    for (DEntry entry in _record.entryList) {
      resetEntry(entry);
    }
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
      }
      dataEntry.isChanged = false;
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
      _log.fine("onEditorChange ${name} rowNo=${rowNo} value=${newValue} old=${oldValueD} (orig=${valueOriginalD})");
    } else {
      _log.fine("onEditorChange ${name} rowNo=${rowNo} value=${newValue}");
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

  /// Table for Record ... or null
  DTable get table {
//    if (_table == null && _record.hasTableName()) {
//      _table = ServiceUi.getTable(_record.tableName);
//    }
    return _table;
  }
  void set table (DTable newValue) {
    _table = newValue;
  }
  DTable _table;

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
    return "DataRecord@${recordId}[urv=${urv}, changed=${changed}]";
  }

} // DataRecord
