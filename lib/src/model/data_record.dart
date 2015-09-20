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
 * Callback for automatically submitting forms
 */
//typedef void AutoSubmit(String name, String value);

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
   * Get columnName value as String or null if not found
   */
  static String columnValue(DRecord record, String columnName) {
    if (columnName != null && record != null && record.entryList.isNotEmpty) {
      for (DEntry entry in record.entryList) {
        if (columnName == entry.columnName) {
          String value = null;
          if (entry.hasValue()) {
            value = entry.value;
          } else if (entry.hasValueOriginal()) {
            value = entry.valueOriginal;
          }
          if (DataUtil.isEmpty(value)) {
            return ""; // found but empty
          }
          return value;
        }
      }
    }
    return null;
  } // columnValue

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
  /// AutoSubmit
  //AutoSubmit onAutoSubmit;

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
  }
  /// Get current record
  DRecord get record => _record;

  /**
   * Record is read only (static + last calc) | !active
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
    return !isActive || isProcessed;
  } // isReadOnly

  /// Record active (default: true)
  bool get isActive {
    DEntry entry = getEntry(null, C_ISACTIVE, false);
    if (entry != null) {
      if (entry.hasValue())
        return entry.value == "true";
    }
    return true;
  } // isActive

  /// Record active (default: false)
  bool get isProcessed {
    DEntry entry = getEntry(null, C_PROCESSED, false);
    if (entry != null) {
      if (entry.hasValue())
        return entry.value == "true";
    }
    return false;
  } // isProcessed

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
   */
  DRecord newRecord(DTable table, DRecord parentRecord) {
    setRecord(null, -1); // create new
    _record.tableId = table.tableId;
    _record.tableName = table.name;
    //
    if (parentRecord != null)
      _record.parent = parentRecord;
    DataRecord parentData = new DataRecord(null, value: parentRecord);
    // set defaults from table column
    for (DColumn col in table.columnList) {
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
    // set as original (for reset)
    setValueOriginal();
    return _record;
  } // newRecord

  /// copy record
  DRecord copyRecord(DTable table, DRecord currentRecord) {
    setRecord(null, -1);
    DataRecord currentData = new DataRecord(null, value: currentRecord);
    for (DColumn col in table.columnList) {
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
      if (value != NULLVALUE)
        return value;
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
    if (dataEntry.isChanged)
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
    }
  } // resetEntry

  /**
   * Data Record Value Changed - called from EditorI
   */
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    if (entry != null) {
      String valueOriginal = entry.valueOriginal;
      if (NULLVALUE == valueOriginal)
        valueOriginal = "null";
      String oldValue = entry.value;
      if (NULLVALUE == oldValue)
        oldValue = "null";
      _log.fine("onEditorChange ${name} rowNo=${rowNo} value=${newValue} old=${oldValue} (orig=${valueOriginal})");
    } else {
      _log.fine("onEditorChange ${name} rowNo=${rowNo} value=${newValue}");
    }
    // data list - controller
    if (onRecordChange != null) {
      if (entry == null && name != null && name.isNotEmpty) {
        entry = getEntry(null, name, true);
        if (newValue != null)
          entry.value = newValue;
      }
      onRecordChange(_record, entry, rowNo); // data list
    }
    // if (!temporary && onAutoSubmit != null) {
    //  onAutoSubmit(editor.name, newValue);
    //}

  } // onEditorChanged

  /// Table for Record ... or null
  DTable get table {
//    if (_table == null && _record.hasTableName()) {
//      _table = ServiceUi.getTable(_record.tableName);
//    }
    return _table;
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

  /**
   * Evaluate [logic] replacing variables with context value
   */
  String contextEvaluate(final String logic) {
    if (logic == null || logic.isEmpty)
      return logic;
    //
    // bool isBizLogic = logic.contains("record");
    bool isCompiereLogic = logic.contains("@");

    if (isCompiereLogic) {
      //List<String> variables = contextParseVariables2(logic);
      Map<String,String> context = getContext();
      return contextParseReplaceVariables2(logic, context);
    }
    return logic;
  } // contextEvaluate

  /**
   * Parse [logic] for @variable@ returning list of variables
   */
  List<String> contextParseVariables2(String logic) {
    List<String> vars = new List<String>();
    String inString = logic;
    RegExp pattern = new RegExp(r'@');
    int i = inString.indexOf(pattern);
    while (i != -1 && i != inString.lastIndexOf(pattern)) {
      inString = inString.substring(i+1); // remainder
      int j = inString.indexOf(pattern);
      if (j < 0) {
        _log.warning("contextParseVariables2 No second tag logic=${logic}");
        return vars;
      } else {
        String token = inString.substring(0, j);
        int k = token.indexOf("|");
        if (k >= 0) {
          String fallback = token.substring(k+1);
          token = token.substring(0, k);
          _log.warning("contextParseVariables2 fallback=${fallback} token=${token} logic=${logic}");
        }
        vars.add(token);
        inString = inString.substring(j);
        i = inString.indexOf(pattern);
      }
    }
    return vars;
  } // contextParseVariables2

  /**
   * Parse [logic] and replace @variable@ returning updated String
   */
  String contextParseReplaceVariables2(final String logic, final Map<String,String> context) {
    String inString = logic;
    String outString = "";
    RegExp pattern = new RegExp(r'@');
    int i = inString.indexOf(pattern);
    while (i != -1 && i != inString.lastIndexOf(pattern)) {
      outString += inString.substring(0, i); // up to @
      inString = inString.substring(i+1); // remainder
      int j = inString.indexOf(pattern);
      if (j < 0) {
        _log.warning("contextParseReplaceVariables2 No second tag logic=${logic}");
        return logic;
      } else {
        String token = inString.substring(0, j);
        String fallback = null;
        int k = token.indexOf("|");
        if (k >= 0) {
          fallback = token.substring(k+1);
          token = token.substring(0, k);
          _log.warning("contextParseReplaceVariables2 fallback=${fallback} token=${token} logic=${logic}");
        }
        // Value
        String value = context[token];
        if (value == null && fallback != null) {
          value = context[fallback];
        }
        if (value == null) {
          _log.warning("contextParseReplaceVariables2 NotFound ${token} fallback=${fallback}");
        } else {
          // Conversion
          if (value == "true")
            value = "Y";
          else if (value == "false")
            value = "N";
          outString += value;
        }
        inString = inString.substring(j+1);
        i = inString.indexOf(pattern);
      }
    }
    outString += inString; // remainder
    return outString;
  } // contextParseVariables2

  /**
   * Create Context Map
   */
  Map<String, String> getContext() {
    Map<String,String> context = new Map.from(clientContext);
    context.addAll(asMap(_record.parent, true)); // parent context
    context.addAll(asMap(_record, true));
    return context;
  }

  /************************************
   * Evaluate [logic] (not empty) - default false, e.g. record.IsApi
   */
  bool evaluateBool(final String logic) {
    if (_record.entryList.isEmpty)
      return false;
    // indicators
    bool isBizLogic = logic.contains("record");
    bool isCompiereLogic = logic.contains("@");

    if (!isBizLogic
    && (clientContext.containsKey("ScriptType") // == "Compiere")
    || isCompiereLogic)) {
      Map<String,String> context = getContext();
      return evaluateBool2(logic.trim(), context);
    }

    // https://www.dartlang.org/articles/js-dart-interop/
    var biz = new JsObject(context['BizFabrik']);
    if (logic.contains("record"))
      biz.callMethod('set', ['record', getJsRecord()]);
    if (logic.contains("parent") && _record.hasParent())
      biz.callMethod('set', ['parent', getJsParent()]);
    if (logic.contains("context"))
      biz.callMethod('set', ['context', new JsObject.jsify(clientContext)]);
    // var rr = biz['record'];
    try {
      Object retValue = biz.callMethod("evaluate", [logic]);
      bool rr = retValue is bool ? retValue : "true" == retValue;
      _log.finer("evaluateBool urv=${_record.urv} logic=${logic} = ${rr}");
      return rr;
    }
    catch (e) {
      _log.warning("evaluateBool ${e}: urv=${_record.urv} logoc=${logic}");
    }
    return false;
  } // evaluate

  /**
   * Create [theRecord] as Map
   * - with [stringValues] only string values
   * or also boolean, int, double, date.
   * Passwords are not included
   */
  Map<String,dynamic> asMap(DRecord theRecord, bool stringValues) {
    Map<String,Object> map = new Map<String,dynamic>();
    if (theRecord == null) {
      return map;
    }
    for (DEntry entry in theRecord.entryList) {
      DColumn col = DataUtil.findColumn(table, entry.columnId, entry.columnName);
      DataType dt = col == null ? DataType.STRING : col.dataType;
      if (dt == DataType.PASSWORD)
        continue;
      if (!entry.hasValue() || entry.value.isEmpty) {
        map[entry.columnName] = null;
      }
      else if (stringValues) {
        map[entry.columnName] = entry.value;
      }
      else if (dt == DataType.BOOLEAN) {
        map[entry.columnName] = entry.value == "true";
      }
      else if (dt == DataType.INT)
        map[entry.columnName] = int.parse(entry.value,
        onError: (String value) {
          return 0;
        });
      else if (DataTypeUtil.isNumber(dt))
        map[entry.columnName] = double.parse(entry.value,
            (String value) {
          return 0.0;
        });
      else if (DataTypeUtil.isDate(dt)) {
        int time = int.parse(entry.value,
        onError: (String value) {
          return 0;
        });
        map[entry.columnName] = new DateTime.fromMillisecondsSinceEpoch(time, isUtc: dt == DataType.DATE);
      }
      else
        map[entry.columnName] = entry.value;
    }
    return map;
  } // asMap

  // convert record to JS Object
  JsObject getJsRecord() {
    Map map = asMap(_record, false);
    return new JsObject.jsify(map);
  } // getJsRecord

  // convert parent to JS Object
  JsObject getJsParent() {
    Map parent = asMap(_record.parent, false);
    return new JsObject.jsify(parent);
  } // getJsParent

  /**
   * Evaluate [logic] based on "old" &| logic or false if error
   */
  bool evaluateBool2(final String logic, Map<String,String> context) {
    // see Scripting2.java
    StringTokenizer st = new StringTokenizer(logic, "&|", true);
    int it = st.countTokens();
    if (((it / 2) - ((it + 1) / 2)) == 0) { // only uneven arguments
      _log.warning("evaluateBool2 Invalid format => ${logic}");
      return false;
    }
    bool retValue = evaluateBool2Part(st.nextToken(), context);
    while (st.hasMoreTokens()) {
      String nextOp = st.nextToken().trim();
      bool temp = evaluateBool2Part(st.nextToken(), context);
      if (nextOp == "&") {
        retValue = retValue && temp;
      } else if (nextOp == "|") {
        retValue = retValue || temp;
      } else {
        _log.warning("evaluateBool2 Invalid operand=${nextOp} => ${logic}");
        return false;
      }
    } // hasMoreTokens
    return retValue;
  } // evaluateBool2

  /**
   * Evaluate [logic] based on "old" !=^>< comparison
   */
  bool evaluateBool2Part(final String logic, Map<String,String> context) {
    StringTokenizer st = new StringTokenizer(logic.trim(), "!=^><", true);
    // must be boolean expression
    if (st.countTokens() == 1) {
      return evaluateBool2Expression(logic, context);
    }
    if (st.countTokens() != 3) {
      _log.warning("evaluateBool2Part Invalid format => ${logic}");
      return false;
    }
    //  First Part
    String first = st.nextToken().trim(); // get '@tag@'
    String firstEval = first.trim();
    if (first.indexOf('@') != -1) { // variable
      first = first.replaceAll('@', ' ').trim(); // strip 'tag'
      if (context.containsKey(first))
        firstEval = context[first]; // replace with it's value
      else {
        //_log.warning("evaluateBool2Part ${first} not found in (${logic})");
        firstEval = "";
      }
      if (firstEval == null) {
        firstEval = "";
      }
    }
    firstEval = firstEval.replaceAll('\'', ' ').replaceAll('"', ' ').trim(); // strip ' and "
    //  Comparator
    String operand = st.nextToken();
    //  Second Part
    String second = st.nextToken(); // get value
    String secondEval = second.trim();
    if (second.indexOf('@') != -1) { // variable
      second = second.replaceAll('@', ' ').trim(); // strip tag
      if (context.containsKey(second))
        secondEval = context[second]; // replace with it's value
      else {
        //_log.warning("evaluateBool2Part ${second} not found in (${logic})");
        secondEval = "";
      }
      if (secondEval == null) {
        secondEval = "";
      }
    }
    secondEval = secondEval.replaceAll('\'', ' ').replaceAll('"', ' ').trim(); // strip ' and "
    //  Handling of ID compare (null => 0)
    if (first.contains("_ID") && firstEval.isEmpty) {
      firstEval = "0";
    }
    if (second.contains("_ID") && secondEval.isEmpty) {
      secondEval = "0";
    }
    //  Logical Comparison
    return evaluateBool2Tuple(firstEval, operand, secondEval);
  } // evaluateBool2Part

  /**
   * Evaluate [operand] !=^><
   */
  bool evaluateBool2Tuple(final String value1, final String operand, final String value2) {
    if ((value1 == null) || (operand == null) || (value2 == null)) {
      return false;
    }
    double value1bd = double.parse(value1, (String value) {return null;});
    double value2bd = double.parse(value2, (String value) {return null;});
    //
    if (operand == "=") {
      // number
      if (value1bd != null && value2bd != null) {
        return value1bd.compareTo(value2bd) == 0;
      }
      // string
      bool bb = evaluateBool2Values(value1, value2, true);
      if (bb != null)
        return bb;
      return value1.compareTo(value2) == 0;
    } else if (operand == "<") {
      if ((value1bd != null) && (value2bd != null)) {
        return value1bd.compareTo(value2bd) < 0;
      }
      return value1.compareTo(value2) < 0;
    } else if (operand == ">") {
      if ((value1bd != null) && (value2bd != null)) {
        return value1bd.compareTo(value2bd) > 0;
      }
      return value1.compareTo(value2) > 0;
    } else { // interpreted as not
      // number
      if ((value1bd != null) && (value2bd != null)) {
        return value1bd.compareTo(value2bd) != 0;
      }
      // string
      bool bb = evaluateBool2Values(value1, value2, false);
      if (bb != null)
        return bb;
      return value1.compareTo(value2) != 0;
    }
  } // evaluateBool2Tuple

  bool evaluateBool2Expression(final String logic, Map<String,String> context) {
    String value = logic;
    if (logic.contains("@")) {
      String variable = value.replaceAll("@", "");
      if (context.containsKey(variable))
        value = context[variable];
      else {
        _log.warning("evaluateBool2Expression ${variable} not found in (${logic})");
        return false;
      }
    }
    if (value == null || value.isEmpty) {
      _log.warning("evaluateBool2Expression ${logic} evaluated to Null");
      return false;
    }
    value = value.toUpperCase();
    if (value == "TRUE" || value == "T"
    || value == "YES" || value == "Y" || value == "1") {
      return true;
    }
    if (value == "FALSE" || value == "F"
    || value == "NO" || value == "N" || value == "0") {
      return false;
    }
    _log.warning("evaluateBool2Expression ${logic} not boolean");
    return false;
  } // evaluateBool2Expression

  /**
   * Compare Y|true and N|false
   */
  bool evaluateBool2Values(String value1, String value2, bool eq) {
    if (value1 == "Y" || value2 == "true") {
      if (value2 == "Y" || value2 == "true")
        return eq;
      if (value2 == "N" || value2 == "false")
        return !eq;
    } else if (value1 == "N" || value2 == "false") {
      if (value2 == "Y" || value2 == "true")
        return !eq;
      if (value2 == "N" || value2 == "false")
        return eq;
    }
    return null;
  } // evaluateBool2Values


  @override
  String toString() {
    return "DataRecord@${recordId}[urv=${urv}, changed=${changed}]";
  }

} // DataRecord
