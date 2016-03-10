/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_model;

/**
 * Get Value of fkTable.columnName
 * - get fkTable => table.fkColumnName
 * - get record from fkColumnValue
 */
typedef String ValueOf(DTable table, String fkColumnName, String fkColumnValue, String columnName);


/**
 * Context
 */
class DataContext {


  static Logger _log = new Logger("DataContext");

  /// get value of (set in FkService)
  static ValueOf valueOf;

  /// has the logic a variable - context - record - parent
  static bool hasVariable(String logic, {bool checkContext: true, bool checkRecord: true, bool checkParent: true}) {
    if (DataUtil.isEmpty(logic))
      return false;
    if (checkContext && _CONTEXT.hasMatch(logic))
      return true;
    if (checkRecord && _RECORD.hasMatch(logic))
      return true;
    if (checkParent && _PARENT.hasMatch(logic))
      return true;
    return false;
  }

  /**
   * Evaluate [logic] replacing variables with context value - default strict
   * [columnName] for doc
   */
  static String contextReplace(final DataRecord data, final String logic,
      {bool nullResultOk: false, bool emptyResultOk: false, String columnName: ""}) {
    if (DataUtil.isEmpty(logic))
      return logic;
    //
    String processedLogic = logic;
    for (Match m in _CONTEXT.allMatches(processedLogic)) {
      // _log.info("${m.input} start=${m.start} end=${m.end} groups=${m.groupCount}");
      String varName = m.input.substring(m.start+8, m.end);
      String varValue = ClientEnv.contextValue(varName);
      if (varValue == null) {
        if (nullResultOk)
          _log.config("contextReplace ${columnName} context=${varName} notFound - ${processedLogic}");
        else
          return processedLogic;
      } else if (varValue.isEmpty) {
        if (!emptyResultOk)
          return processedLogic;
      }
      String replaceValue = varValue == null ? "" : varValue;
      processedLogic = processedLogic.replaceAll(_CONTEXT, replaceValue);
      if (varValue != null) {
        _log.config("contextReplace ${columnName} context=${varName} value=${varValue} - ${processedLogic}");
      }
    }
    for (Match m in _RECORD.allMatches(processedLogic)) {
      // _log.info("${m.input} start=${m.start} end=${m.end} groups=${m.groupCount}");
      String varName = m.input.substring(m.start+7, m.end);
      String varValue = DataRecord.getColumnValue(data.record, varName);
      if (varValue == null) {
        if (nullResultOk)
          _log.config("contextReplace ${columnName} record=${varName} notFound - ${processedLogic}");
        else
          return processedLogic;
      } else if (varValue.isEmpty) {
        if (!emptyResultOk)
          return processedLogic;
      }
      String replaceValue = varValue == null ? "" : varValue;
      processedLogic = processedLogic.replaceAll(_RECORD, replaceValue);
      if (varValue == null) {
        _log.config("contextReplace ${columnName} record=${varName} value=${varValue} - ${processedLogic}");
      }
    }
    for (Match m in _PARENT.allMatches(processedLogic)) {
      // _log.info("${m.input} start=${m.start} end=${m.end} groups=${m.groupCount}");
      String varName = m.input.substring(m.start+7, m.end);
      String varValue = DataRecord.getColumnValue(data.record.parent, varName);
      if (varValue == null) {
        if (nullResultOk)
          _log.config("contextReplace ${columnName} parent=${varName} notFound - ${processedLogic}");
        else
          return processedLogic;
      } else if (varValue.isEmpty) {
        if (!emptyResultOk)
          return processedLogic;
      }
      String replaceValue = varValue == null ? "" : varValue;
      processedLogic = processedLogic.replaceAll(_PARENT, replaceValue);
      if (varValue == null) {
        _log.config("contextReplace ${columnName} parent=${varName} value=${varValue} - ${processedLogic}");
      }
    }

    //
    bool isCompiereLogic = processedLogic.contains("@");
    if ((ClientEnv.ctx.containsKey("ScriptType") // == "Compiere")
        && isCompiereLogic)) {
      Map<String,String> context = getContext(data.record);
      return _contextReplace2(processedLogic, context);
    }
    return processedLogic;
  } // contextReplace

  /// Context indicator
  static final RegExp _CONTEXT = new RegExp(r'context\.[a-zA-Z_0-9]+', multiLine:true);
  /// Record indicator
  static final RegExp _RECORD = new RegExp(r'record\.[a-zA-Z_0-9]+', multiLine:true);
  /// Record indicator
  static final RegExp _PARENT = new RegExp(r'parent\.[a-zA-Z_0-9]+', multiLine:true);
  /// ValueOf RegEx: valueOf.fkColumnName.columnName
  static final RegExp _VALUEOF = new RegExp(r'([\w]+)\.([\w]+)\.([\w]+)', multiLine:true);


  /// Get record / valueOf variable names in [logic]
  static Set<String> contextVariableSet(String logic, bool recordAndValue) {
    Set<String> variables = new Set<String>();
    if (logic == null || logic.isEmpty)
      return variables;
    for (Match match in _RECORD.allMatches(logic)) {
      String var1 = match.input.substring(match.start, match.end);
      variables.add(var1.substring(7)); // remove record. prefix
    }
    if (!recordAndValue)
      return variables;
    for (Match match in _VALUEOF.allMatches(logic)) {
      String ref = match.group(0);
      int i1 = ref.indexOf(".");
      int i2 = ref.lastIndexOf(".");
      String fkColumnName = ref.substring(i1+1, i2);
      variables.add(fkColumnName);
    }
    return variables;
  } // contextVariableList


  /**
   * Parse [logic] for @variable@ returning list of variables
   */
  static List<String> contextVariableList2(String logic) {
    List<String> vars = new List<String>();
    String inString = logic;
    RegExp pattern = new RegExp(r'@');
    int i = inString.indexOf(pattern);
    while (i != -1 && i != inString.lastIndexOf(pattern)) {
      inString = inString.substring(i+1); // remainder
      int j = inString.indexOf(pattern);
      if (j < 0) {
        _log.warning("contextVariableList No second tag logic=${logic}");
        return vars;
      } else {
        String token = inString.substring(0, j);
        int k = token.indexOf("|");
        if (k >= 0) {
          String fallback = token.substring(k+1);
          token = token.substring(0, k);
          _log.warning("contextVariableList fallback=${fallback} token=${token} logic=${logic}");
        }
        vars.add(token);
        inString = inString.substring(j);
        i = inString.indexOf(pattern);
      }
    }
    return vars;
  } // contextVariableList2

  /**
   * Parse [logic] and replace @variable@ returning updated String
   */
  static String _contextReplace2(final String logic, final Map<String,String> context) {
    String inString = logic;
    String outString = "";
    RegExp pattern = new RegExp(r'@');
    int i = inString.indexOf(pattern);
    while (i != -1 && i != inString.lastIndexOf(pattern)) {
      outString += inString.substring(0, i); // up to @
      inString = inString.substring(i+1); // remainder
      int j = inString.indexOf(pattern);
      if (j < 0) {
        _log.warning("contextReplace2 No second tag logic=${logic}");
        return logic;
      } else {
        String token = inString.substring(0, j);
        String fallback = null;
        int k = token.indexOf("|");
        if (k >= 0) {
          fallback = token.substring(k+1);
          token = token.substring(0, k);
          _log.warning("contextReplace2 fallback=${fallback} token=${token} logic=${logic}");
        }
        // Value
        String value = context[token];
        if (value == null && fallback != null) {
          value = context[fallback];
        }
        if (value == null) {
          _log.warning("contextReplace2 NotFound ${token} fallback=${fallback}");
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
  } // contextReplace2

  /**
   * Create Context Map
   */
  static Map<String, String> getContext(DRecord record) {
    Map<String,String> context = new Map.from(ClientEnv.ctx);
    context.addAll(asStringMap(record.parent)); // parent context
    context.addAll(asStringMap(record));
    return context;
  }

  /**
   * Get [record] as context with [windowNo] window prefix
   */
  static List<DKeyValue> asContext(DRecord record, int windowNo) {
    List<DKeyValue> context = new List<DKeyValue>();
    for (DEntry ee in record.entryList) {
      String value = DataRecord.getEntryValue(ee);
      if (value != null && value.isNotEmpty) {
        context.add(new DKeyValue()
            ..key = "${windowNo}|${ee.columnName}"
            ..value = value);
      }
    }
    return context;
  } // asContext


  /************************************
   * Evaluate [logic] (not empty) - thows Exception
   * - default false, e.g. record.IsApi
   */
  static bool evaluateBool(final DataRecord data, final String logic) {
    try {
      Object retValue = evaluateBoolEx(data, logic);
      bool rr = retValue is bool ? retValue : "true" == retValue;
      _log.finer("evaluateBool urv=${data.record.urv} logic=${logic} = ${rr}");
      return rr;
    } catch (e) {
      _log.warning("evaluateBool ${e}: urv=${data.record.urv} logoc=${logic}");
    }
    return false;
  }
  /// execute evaluation
  static Object evaluateBoolEx(final DataRecord data, final String logic) {
    if (data.isEmpty)
      return false;
    // indicators
    bool isBizLogic = logic.contains("record");
    bool isCompiereLogic = logic.contains("@");

    if (!isBizLogic
        && (ClientEnv.ctx.containsKey("ScriptType") // == "Compiere")
          || isCompiereLogic)) {
      Map<String,String> context = getContext(data.record);
      return _evaluateBool2(logic.trim(), context);
    }

    // https://www.dartlang.org/articles/js-dart-interop/
    // Exception: constructor not a function
    //    <script src="packages/lightning/assets/ldart.js"></script>
    var biz = new JsObject(context['LDART']);
    if (logic.contains(_RECORD)) {
      biz.callMethod('set', ['record', _getJsRecord(data, logic)]);
    }
    if (logic.contains(_VALUEOF)) {
      biz.callMethod('set', ['valueOf', _getJsValueOf(data, logic)]);
    }
    if (data.record.hasParent() && logic.contains(_PARENT)) {
      biz.callMethod('set', ['parent', _getJsParent(data, logic)]);
    }
    if (logic.contains(_CONTEXT)) {
      biz.callMethod('set', ['context', new JsObject.jsify(ClientEnv.ctx)]);
    }
    // var rr = biz['record'];
    return biz.callMethod("evaluate", [logic]);
  } // evaluate

  /**
   * Create [theRecord] as String Map
   */
  static Map<String,String> asStringMap(DRecord record) {
    Map<String,String> map = new Map<String,String>();
    if (record == null || record.entryList.isEmpty) {
      return map;
    }
    for (DEntry entry in record.entryList) {
      if (!entry.hasValue() || entry.value.isEmpty) {
        map[entry.columnName] = null;
      }
      else {
        map[entry.columnName] = entry.value;
      }
    }
    return map;
  } // asStringMap


  // convert record to JS Object
  static JsObject _getJsRecord(final DataRecord data, final String logic) {
    Map map = _asJsMap(data, logic);
    return new JsObject.jsify(map);
  } // getJsRecord

  // convert parent to JS Object
  static JsObject _getJsParent(final DataRecord data, final String logic) {
    DRecord record = data.record.parent;
    DTable table = null; // TODO get table for parent
    DataRecord dataParent = new DataRecord(table, null, value:record);
    Map parent = _asJsMap(dataParent, logic);
    return new JsObject.jsify(parent);
  } // getJsParent

  /**
   * Create [theRecord] as Javascript Map
   * - with [stringValues] only string values
   * or also boolean, int, double, date.
   * Passwords are not included
   */
  static Map<String,dynamic> _asJsMap(final DataRecord data, final String logic,
      {bool asStringValues:false}) {
    Map<String,Object> map = new Map<String,dynamic>();
    DRecord record = data.record;
    if (record == null || record.entryList.isEmpty) {
      return map;
    }
    Set<String> termSet = contextVariableSet(logic, false);
    DTable table = data.table;
    for (DEntry entry in record.entryList) {
      String columnName = entry.columnName;
      if (!termSet.contains(columnName)) {
        continue;
      }
      DColumn col = DataUtil.findColumn(table, entry.columnId, columnName);
      DataType dt = col == null ? DataType.STRING : col.dataType;
      if (dt == DataType.PASSWORD)
        continue;
      String value = DataRecord.getEntryValue(entry);
      if (value == null || value.isEmpty) {
        map[columnName] = null;
      }
      else if (asStringValues) {
        map[columnName] = value;
      }
      else if (dt == DataType.BOOLEAN) {
        map[columnName] = value == "true";
      }
      else if (dt == DataType.INT)
        map[columnName] = int.parse(value,
            onError: (String value) {
               return 0;
            });
      else if (DataTypeUtil.isNumber(dt))
        map[columnName] = double.parse(value,
            (String value) {
              return 0.0;
            });
      else if (DataTypeUtil.isDate(dt)) {
        int time = int.parse(value,
            onError: (String value) {
              return 0;
            });
        map[columnName] = new DateTime.fromMillisecondsSinceEpoch(time, isUtc: dt == DataType.DATE);
      }
      else {
        map[columnName] = value;
      }
    }
    //_log.finest("asJsMap terms=${termSet} map=${map}");
    return map;
  } // asJsMap


  /**
   * Evaluate [logic] based on "old" &| logic or false if error
   */
  static bool _evaluateBool2(final String logic, Map<String,String> context) {
    // see Scripting2.java
    StringTokenizer st = new StringTokenizer(logic, "&|", true);
    int it = st.countTokens();
    if (((it / 2) - ((it + 1) / 2)) == 0) { // only uneven arguments
      _log.warning("evaluateBool2 Invalid format => ${logic}");
      return false;
    }
    bool retValue = _evaluateBool2Part(st.nextToken(), context);
    while (st.hasMoreTokens()) {
      String nextOp = st.nextToken().trim();
      bool temp = _evaluateBool2Part(st.nextToken(), context);
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
  static bool _evaluateBool2Part(final String logic, Map<String,String> context) {
    StringTokenizer st = new StringTokenizer(logic.trim(), "!=^><", true);
    // must be boolean expression
    if (st.countTokens() == 1) {
      return _evaluateBool2Expression(logic, context);
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
        _log.warning("evaluateBool2Part ${first} not found in (${logic})");
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
        _log.warning("evaluateBool2Part ${second} not found in (${logic})");
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
    return _evaluateBool2Tuple(firstEval, operand, secondEval);
  } // evaluateBool2Part

  /**
   * Evaluate [operand] !=^><
   */
  static bool _evaluateBool2Tuple(final String value1, final String operand, final String value2) {
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
      bool bb = _evaluateBool2Values(value1, value2, true);
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
      bool bb = _evaluateBool2Values(value1, value2, false);
      if (bb != null)
        return bb;
      return value1.compareTo(value2) != 0;
    }
  } // evaluateBool2Tuple

  static bool _evaluateBool2Expression(final String logic, Map<String,String> context) {
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
  static bool _evaluateBool2Values(String value1, String value2, bool eq) {
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

  /**
   * Create Map for valueOf.fkColumnName.columnName
   */
  static JsObject _getJsValueOf(final DataRecord data, final String logic,
      {bool asStringValues:false}) {
    Map<String,dynamic> map = new Map<String,dynamic>();
    DRecord record = data.record;
    if (record == null || record.entryList.isEmpty) {
      return new JsObject.jsify(map);
    }
    for (Match match in _VALUEOF.allMatches(logic)) {
      String ref = match.group(0);
      int i1 = ref.indexOf(".");
      int i2 = ref.lastIndexOf(".");
      String fkColumnName = ref.substring(i1+1, i2);
      String columnName = ref.substring(i2+1);

      // valueOf.fkColumnName
      Map<String, dynamic> colMap = map[fkColumnName];
      if (colMap == null) {
        colMap = new Map<String, dynamic>();
        map[fkColumnName] = colMap;
      }

      String fkColumnNameValue = data.getValue(fkColumnName);
      String columnNameValue = null;
      if (fkColumnNameValue != null && fkColumnNameValue.isNotEmpty && valueOf != null)
        columnNameValue = valueOf(data.table, fkColumnName, fkColumnNameValue, columnName);
      // valueOf.fkColumnName.columnName
      colMap[columnName] = columnNameValue;
      _log.finest("getJsValueOf ${fkColumnName}=${fkColumnNameValue} ${columnName}=${columnNameValue}");
    }
    //_log.finest("getJsValueOf map=${map}");
    return new JsObject.jsify(map);
  } // getJsValueOf


} // DataContext
