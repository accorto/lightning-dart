/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Filter Rows
 */
class ObjectFilterFilter extends TableCtrl {

  static final Logger _log = new Logger("ObjectFilterFilter");


  /// Provided Filter List
  final List<DFilter> filterList;
  /// Meta Table
  final DTable objectTable;


  /**
   * Filter
   */
  ObjectFilterFilter(List<DFilter> this.filterList, DTable this.objectTable)
      : super(idPrefix: "off", optionRowSelect:false, optionLayout:false, optionEdit:false, alwaysOneEmptyLine:true) {
    element.classes.add(LMargin.C_TOP__SMALL);

  } // ObjectFilterFilter

  /// Add Table/Row Actions
  void addActions() {
    super.addActions();
    addRowAction(AppsAction.createUp(onAppsActionTableUp));
    addRowAction(AppsAction.createDown(onAppsActionTableDown));
  }

  /// Reset
  void reset() {
    _toRecordList();
    addNewRecord();
    display();
  }

  /// Add New Record at End
  DRecord addNewRecord() {
    DRecord rec = super.addNewRecord();
    rec.drv = recordList.length.toString();
    return rec;
  }

  /// Sorting
  void onAppsActionSequence() {
    resequence();
    int seqNo = 1;
    for (DRecord record in recordList) {
      record.drv = seqNo.toString();
      seqNo++;
    }
  }


  /// Convert to Records
  void _toRecordList() {
    recordList.clear();
    for (DFilter filter in filterList) {
      DRecord record = new DRecord()
        ..tableName = _TABLENAME;
      record.entryList.add(new DEntry()
        ..columnName = _COL_NAME
        ..valueOriginal = filter.columnName
      );
      // op
      record.entryList.add(new DEntry()
        ..columnName = _COL_OP
        ..valueOriginal = filter.operation.name
      );




      recordList.add(record);
    }
  } // toRecordList


  /// Convert to DSort
  List<DFilter> updateFilterList() {
    filterList.clear();
    DataRecord dd = new DataRecord(null);
    for (DRecord record in recordList) {
      dd.setRecord(record, 0);
      String columnName = dd.getValue(name: _COL_NAME);
      if (columnName == null || columnName.isEmpty)
        continue;
      DFilter filter = new DFilter()
        ..columnName = columnName;
      // op
      String opName = dd.getValue(name:_COL_OP);
      if (opName == null || opName.isEmpty)
        continue;
      DOP op = getOperationByName(opName);
      if (op == null) {
        _log.warning("updateFilterList NotFound operation=${opName}");
        continue;
      }
      filter.operation = op;



      filterList.add(filter);
    }
    return filterList;
  }


  static const String _TABLENAME = "DSort";
  static const String _COL_NAME = "columnName";
  static const String _COL_OP = "operation";
  static const String _COL_OP_DATE = "operationDate";
//  static const String _COL_DT = "dataType";
  static const String _COL_VALUE = "filterValue";
  static const String _COL_VALUE_TO = "filterValueTo";
  static const String _COL_IN = "filterIn";
//  static const String _COL_RO = "isReadOnly";
//  static const String _COL_DIRECT = "filterDirectQuery";

  /**
   * Saved Query UI
   */
  UI get ui {
    UiUtil uiu = new UiUtil(new UI());
    DTable sqTable = new DTable()
      ..name = _TABLENAME
      ..label = "Filter";
    uiu.setTable(sqTable);
    uiu.addPanel(null);

    // Column Name
    DColumn col = new DColumn()
      ..name = _COL_NAME
      ..label = "Column Name"
      ..dataType = DataType.PICK
      ..uniqueSeqNo = 1
      ..displaySeqNo = 1
      ..columnSize = 60
      ..isMandatory = false;
    List<DKeyValue> neList = new List<DKeyValue>();
    List<DKeyValue> likeList = new List<DKeyValue>();
    List<DKeyValue> pickList = new List<DKeyValue>();
    List<DKeyValue> notFkList = new List<DKeyValue>();
    List<DKeyValue> dateList = new List<DKeyValue>();
    List<DKeyValue> optionalList = new List<DKeyValue>();
    for (DColumn colOption in objectTable.columnList) {
      String name = colOption.name;
      DOption option = new DOption()
        ..value = name
        ..label = colOption.label;
      DataType dt = colOption.dataType;
      if (dt != DataType.BOOLEAN) {
        neList.add(new DKeyValue()..key = _COL_NAME ..value = name);
        if (DataTypeUtil.isString(dt)) {
          likeList.add(new DKeyValue()..key = _COL_NAME ..value = name);
        }
        if (DataTypeUtil.isPick(dt)) {
          pickList.add(new DKeyValue()..key = _COL_NAME ..value = name);
        } else if (!DataTypeUtil.isFk(dt)) {
          notFkList.add(new DKeyValue()..key = _COL_NAME ..value = name);
        }
        if (dt == DataType.DATE || dt == DataType.DATETIME) {
          dateList.add(new DKeyValue()..key = _COL_NAME ..value = name);
        }
      }
      if (!colOption.isMandatory) {
        optionalList.add(new DKeyValue()..key = _COL_NAME ..value = name);
      }
      col.pickValueList.add(option);
    }
    col.pickListSize = col.pickValueList.length;
    uiu.addColumn(col);

    // Operation
    col = new DColumn()
      ..name = _COL_OP
      ..label = "Operation"
      ..dataType = DataType.PICK
      ..isMandatory = true
      ..defaultValue = DOP.LIKE.name;
    getUIOp(col, neList,  likeList, pickList, notFkList, dateList, optionalList);
    uiu.addColumn(col);

    // Operation
    col = new DColumn()
      ..name = _COL_OP_DATE
      ..label = "D"
      ..dataType = DataType.PICK
      ..isMandatory = true
      ..defaultValue = DOP.D_THIS.name;
    col.pickValueList.add(new DOption()..value = DOP.D_LAST.name ..label = filterOpDateLast());
    col.pickValueList.add(new DOption()..value = DOP.D_THIS.name ..label = filterOpDateThis());
    col.pickValueList.add(new DOption()..value = DOP.D_NEXT.name ..label = filterOpDateNext());
    String logicDateOp = "record.${_COL_OP}=='${DOP.D_DAY.name}' || record.${_COL_OP}=='${DOP.D_WEEK.name}' || record.${_COL_OP}=='${DOP.D_MONTH.name}' || record.${_COL_OP}=='${DOP.D_QUARTER.name}' || record.${_COL_OP}=='${DOP.D_YEAR.name}'";
    uiu.addColumn(col, displayLogic: logicDateOp);

    // Value
    col = new DColumn()
      ..name = _COL_VALUE
      ..label = "Value"
      ..dataType = DataType.STRING
      ..isMandatory = true;
    uiu.addColumn(col, displayLogic: "!(record.${_COL_OP}=='${DOP.ISNULL}' || record.${_COL_OP}=='${DOP.NOTNULL}' ||  record.${_COL_OP}=='${DOP.IN.name}' || record.${_COL_OP}=='${DOP.NOTIN.name}' "
      "|| ${logicDateOp})");

    // Value To
    col = new DColumn()
      ..name = _COL_VALUE_TO
      ..label = "To"
      ..dataType = DataType.STRING
      ..isMandatory = false;
    // only if operation is between
    uiu.addColumn(col, displayLogic: "record.${_COL_OP}=='${DOP.BETWEEN.name}'");

    // Value IN
    col = new DColumn()
      ..name = _COL_IN
      ..label = "In"
      ..dataType = DataType.PICKMULTI
      ..isMandatory = false;
    // only if pick list with values from column
    uiu.addColumn(col, displayLogic: "record.${_COL_OP}=='${DOP.IN.name}' || record.${_COL_OP}=='${DOP.NOTIN.name}'");

    //
    return uiu.ui;
  } //getUI

  /// Operation Options
  void getUIOp(DColumn col, List<DKeyValue> neList,  List<DKeyValue> likeList,  List<DKeyValue> pickList,
      List<DKeyValue> notFkList, List<DKeyValue> dateList, List<DKeyValue> optionalList) {
    col.pickValueList.add(getUIOpOption(DOP.EQ.name, "=\u2003 ${filterOpEquals()}", null));

    col.pickValueList.add(getUIOpOption(DOP.NE.name, "\u2260\u2003 ${filterOpNotEquals()}", neList));
    // LIKE ..
    col.pickValueList.add(getUIOpOption(DOP.LIKE.name, "\u2248\u2003 ${filterOpLike()}", likeList));
    col.pickValueList.add(getUIOpOption(DOP.NOTLIKE.name, "\u2249\u2003 ${filterOpNotLike()}", likeList));
    // PICK
    col.pickValueList.add(getUIOpOption(DOP.IN.name, "\u2208\u2003 ${filterOpIn()}", pickList));
    col.pickValueList.add(getUIOpOption(DOP.NOTIN.name, "\u2209\u2003 ${filterOpNotIn()}", pickList));
    // not FK
    col.pickValueList.add(getUIOpOption(DOP.GE.name, "\u2265\u2003 ${filterOpGreaterEquals()}", notFkList));
    col.pickValueList.add(getUIOpOption(DOP.GT.name, ">\u2003 ${filterOpGreater()}", notFkList));
    col.pickValueList.add(getUIOpOption(DOP.LE.name, "\u2264\u2003 ${filterOpLessEquals()}", notFkList));
    col.pickValueList.add(getUIOpOption(DOP.LT.name, "<\u2003 ${filterOpLess()}", notFkList));
    col.pickValueList.add(getUIOpOption(DOP.BETWEEN.name, "|..|\u2002 ${filterOpBetween()}", notFkList));
    // Date
    col.pickValueList.add(getUIOpOption(DOP.D_DAY.name, filterOpDateDay(), dateList));
    col.pickValueList.add(getUIOpOption(DOP.D_WEEK.name, filterOpDateWeek(), dateList));
    col.pickValueList.add(getUIOpOption(DOP.D_MONTH.name, filterOpDateMonth(), dateList));
    col.pickValueList.add(getUIOpOption(DOP.D_QUARTER.name, filterOpDateQuarter(), dateList));
    col.pickValueList.add(getUIOpOption(DOP.D_YEAR.name, filterOpDateYear(), dateList));
    // Optional
    col.pickValueList.add(getUIOpOption(DOP.ISNULL.name, "\u2205\u2003 ${filterOpNull()}", optionalList));
    col.pickValueList.add(getUIOpOption(DOP.NOTNULL.name, "\u2203\u2003 ${filterOpNotNull()}", optionalList));
  } // getUIOp

  DOption getUIOpOption(String value, String label, List<DKeyValue> list) {
    DOption option = new DOption()
      ..value = value
      ..label = label;
    if (list != null) {
      if (list.isEmpty) { // to show the option either no restrictions or one valid
        option.validationList.add(new DKeyValue()..key = _COL_NAME ..value = "invalid");
      } else {
        option.validationList.addAll(list);
      }
    }
    return option;
  }

  /// Get Operation by name
  static DOP getOperationByName(String name) {
    for (DOP op in DOP.values) {
      if (op.name == name)
        return op;
    }
    return null;
  }

  static String filterOpEquals() => Intl.message("equals", name: "filterOpEquals", args: []);
  static String filterOpNotEquals() => Intl.message("not equals", name: "filterOpNotEquals", args: []);
  static String filterOpIn() => Intl.message("in", name: "filterOpIn", args: []);
  static String filterOpNotIn() => Intl.message("not in", name: "filterOpNotIn", args: []);
  static String filterOpNull() => Intl.message("null", name: "filterOpNull", args: []);
  static String filterOpNotNull() => Intl.message("not null", name: "filterOpNotNull", args: []);
  static String filterOpGreater() => Intl.message("greater", name: "filterOpGreater", args: []);
  static String filterOpGreaterEquals() => Intl.message("greater or equals", name: "filterOpGreaterEquals", args: []);
  static String filterOpLess() => Intl.message("less", name: "filterOpLess", args: []);
  static String filterOpLessEquals() => Intl.message("less or equals", name: "filterOpLessEquals", args: []);
  static String filterOpBetween() => Intl.message("between", name: "filterOpBetween", args: []);
  static String filterOpLike() => Intl.message("like", name: "filterOpLike", args: []);
  static String filterOpNotLike() => Intl.message("not like", name: "filterOpNotLike", args: []);

  static String filterOpDateDay() => Intl.message("day", name: "filterOpDateDay", args: []);
  static String filterOpDateWeek() => Intl.message("week", name: "filterOpDateWeek", args: []);
  static String filterOpDateMonth() => Intl.message("month", name: "filterOpDateMonth", args: []);
  static String filterOpDateQuarter() => Intl.message("quarter", name: "filterOpDateQuarter", args: []);
  static String filterOpDateYear() => Intl.message("year", name: "filterOpDateYear", args: []);

  static String filterOpDateThis() => Intl.message("this", name: "filterOpDateThis", args: []);
  static String filterOpDateLast() => Intl.message("last", name: "filterOpDateLast", args: []);
  static String filterOpDateNext() => Intl.message("next", name: "filterOpDateNext", args: []);

} // ObjectFilterFilter

