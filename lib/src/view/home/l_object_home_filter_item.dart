/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Individual Filter Item [DFilter]
 */
class ObjectHomeFilterItem
    extends LTile {

  /// date operation
  static List<DOP> DATE_OPERATIONS = [DOP.D_DAY, DOP.D_WEEK, DOP.D_MONTH, DOP.D_QUARTER, DOP.D_YEAR];
  /// date operation values
  static List<DOP> DATE_VALUES = [DOP.D_LAST, DOP.D_THIS, DOP.D_NEXT];

  /// Operation from String
  static DOP opFromString(String opString) {
    for (DOP oo in DOP.values) {
      if (oo.name == opString) {
        return oo;
      }
    }
    return null;
  }

  static final Logger _log = new Logger("ObjectHomeFilterItem");

  /// List Element
  final LIElement li = new LIElement()
    ..classes.add(LList.C_LIST__ITEM);

  /// Detail Container
  DivElement _detail;

  final DTable table;
  final DFilter filter;
  final String idPrefix;
  DColumn column;
  DOP op;
  List<DOption> _operationList;

  LLookup _columnNameEditor;
  LPicklist _operationEditor;
  LPicklist _operationDateEditor;
  LEditor _valueEditor;
  LEditor _valueEditorTo;

  /**
   * Filter Item
   */
  ObjectHomeFilterItem(DTable this.table,
      DFilter this.filter,
      String this.idPrefix,
      void onItemDelete(ObjectHomeFilterItem item)) {

    // layout
    li.append(element);
    board = true;
    element.classes.add(LButton.C_HINT_PARENT);

    LButton delete = new LButton.iconContainer("delete",
        new LIconUtility(LIconUtility.DELETE),
        lObjectHomeFilterItemDelete(),
        idPrefix: idPrefix)
      ..classes.add(LFloat.C_FLOAT__RIGHT)
      ..onClick.listen((MouseEvent evt){
        onItemDelete(this);
      });
    Element header = new DivElement()
      ..classes.addAll([LTile.C_TILE__TITLE])
      ..appendText(Html0.SPACE_NB)
      ..append(delete.element);
    element.append(header);

    _detail = createDetail([LTile.C_TILE__DETAIL]);
    element.append(_detail);

    _columnNameEditor = new LLookup("columnName",
        idPrefix: idPrefix, withClearValue: true)
      ..label = lObjectHomeFilterItemColumnName()
      ..placeholder = lObjectHomeFilterItemColumnName()
      ..readOnly = filter.isReadOnly
      ..editorChange = onColumnNameChange
      ..required = false;
    _columnNameEditor.dOptionList = OptionUtil.columnOptions(table);

    _operationEditor = new LPicklist("operation",
        idPrefix: idPrefix, inGrid: true)
      ..title = lObjectHomeFilterItemOperation()
      ..readOnly = filter.isReadOnly
      ..editorChange = onOperationChange
      ..required = true
      ..show = false;

    _operationDateEditor = new LPicklist("operationDate",
        idPrefix: idPrefix, inGrid: true)
      ..readOnly = filter.isReadOnly
      ..required = true
      ..show = false;
    _operationDateEditor.dOptionList = _getOperationDateOptions();
    _operationDateEditor.value = DOP.D_THIS.name;
    //
    _detail.append(_columnNameEditor.element);
    _detail.append(_operationDateEditor.element);
    _detail.append(_operationEditor.element);

    _setFilter(filter);
    _isError = false;
  } // ObjectFilterItem

  /// set Filter Value
  void _setFilter(DFilter filter) {
    // triggers columnName, operation, value
    columnName = filter.columnName;
  }

  /// Detail div - (body) .tile__detail
  DivElement get detail => _detail;
  UListElement get detailList => null;

  /// get updated Filter
  DFilter getFilter() {
    _isError = false;
    // column
    if (column == null) {
      return null;
    }
    filter.columnName = column.name;
    filter.dataType = column.dataType;
    // operation
    if (op == null) {
      op = opFromString(_operationEditor.value);
    }
    if (op == null) {
      return null;
    }
    filter.operation = op;
    filter.clearOperationDate();
    filter.clearFilterValue();
    filter.clearFilterValueTo();
    filter.filterInList.clear();
    if (op == DOP.ISNULL || op == DOP.NOTNULL) {
      return filter;
    }
    // date value
    if (DATE_OPERATIONS.contains(op)) {
      String opValue = _operationDateEditor.value;
      DOP oo = opFromString(opValue);
      if (DATE_VALUES.contains(oo)) {
        filter.operation = oo;
      } else {
        filter.operation = DOP.D_THIS;
        _operationDateEditor.value = DOP.D_THIS.name;
      }
      return filter;
    }
    // value
    if (_valueEditor == null) {
      _isError = true;
      return null;
    }
    String valueString = _valueEditor.value;
    if (valueString == null || valueString.isEmpty) {
      if (column.isMandatory) {
        _valueEditor.doValidate();
        _isError = true;
        return null;
      } else {
        filter.operation = DOP.ISNULL;
        operation = DOP.ISNULL;
        return filter;
      }
    }
    if (!_valueEditor.doValidate()) {
      _isError = false;
      return null;
    }
    filter.filterValue = valueString;
    // value list
    if (_valueEditor is LSelect) {
      LSelect select = _valueEditor as LSelect;
      List<String> list = select.valueList;
      if (list.length > 1) {
        if (op == DOP.EQ) {
          op = DOP.IN;
        } else if (op == DOP.NE) {
          op = DOP.NOTIN;
        }
      }
      if (op == DOP.IN || op == DOP.NOTIN) {
        filter.clearFilterValue();
        filter.filterInList.addAll(list);
      }
    }

    // value to
    if (op == DOP.BETWEEN && _valueEditorTo != null) {
      String valueToString = _valueEditorTo.value;
      if (!_valueEditorTo.doValidate()) {
        _isError = false;
        return null;
      }
      filter.filterValue = valueToString;
    }
    return filter;
  } // getFilter
  bool _isError = false;
  bool get isError => _isError;
  bool get isEmpty => column == null;

  /// column name change
  void onColumnNameChange(String name, String newValue, DEntry entry, var details) {
    _log.config("onColumnNameChange ${newValue}");
    columnName = newValue;
  }

  /**
   * set column name
   */
  void set columnName (String newValue) {
    bool change = filter.columnName != newValue;
    column = DataUtil.findColumn(table, null, newValue);
    if (column == null) {
      _columnNameEditor.value = "";
      filter.clearColumnName();
      filter.clearDataType();
    } else {
      filter.columnName = column.name;
      filter.dataType = column.dataType;
      _columnNameEditor.value = column.name;
      if (change) {
        filter.clearOperation();
        filter.clearOperationDate();
        filter.clearFilterValue();
        filter.clearFilterValueTo();
      }
    }
    _log.fine("columnName=${column == null ? "-" : column.name} (${_columnNameEditor.value})");
    _columnNameSet();
  } // setColumnName
  String get columnName => filter.columnName;

  /// set operations options
  void _columnNameSet() {
    if (column == null) {
      _operationEditor.show = false;
      _operationSet();
      return;
    }
    _operationList = new List<DOption>();
    DataType dt = column.dataType;
    DOP defaultOperation = DOP.EQ;
    _operationList.add(new DOption()
      ..value = DOP.EQ.name
      ..label = "=\u2003 ${filterOpEquals()}");
    if (dt != DataType.BOOLEAN) {
      _operationList.add(new DOption()
        ..value = DOP.NE.name
        ..label = "\u2260\u2003 ${filterOpNotEquals()}");
      if (DataTypeUtil.isStringStrict(dt)) {
        _operationList.add(new DOption()
          ..value = DOP.LIKE.name
          ..label = "\u2248\u2003 ${filterOpLike()}");
        _operationList.add(new DOption()
          ..value = DOP.NOTLIKE.name
          ..label = "\u2249\u2003 ${filterOpNotLike()}");
        defaultOperation = DOP.LIKE;
      }
      if (DataTypeUtil.isPick(dt)) {
        _operationList.add(new DOption()
          ..value = DOP.IN.name
          ..label = "\u2208\u2003 ${filterOpIn()}");
        _operationList.add(new DOption()
          ..value = DOP.NOTIN.name
          ..label = "\u2209\u2003 ${filterOpNotIn()}");
      } else if (!DataTypeUtil.isFk(dt)) {
        _operationList.add(new DOption()
          ..value = DOP.GE.name
          ..label = "\u2265\u2003 ${filterOpGreaterEquals()}");
        _operationList.add(new DOption()
          ..value = DOP.GT.name
          ..label = ">\u2003 ${filterOpGreater()}");
        _operationList.add(new DOption()
          ..value = DOP.LE.name
          ..label = "\u2264\u2003 ${filterOpLessEquals()}");
        _operationList.add(new DOption()
          ..value = DOP.LT.name
          ..label = "<\u2003 ${filterOpLess()}");
        _operationList.add(new DOption()
          ..value = DOP.BETWEEN.name
          ..label = "|..|\u2002 ${filterOpBetween()}");
      }
      if (dt == DataType.DATE || dt == DataType.DATETIME) {
        _operationList.add(new DOption()
          ..value = DOP.D_DAY.name
          ..label = filterOpDateDay());
        _operationList.add(new DOption()
          ..value = DOP.D_WEEK.name
          ..label = filterOpDateWeek());
        _operationList.add(new DOption()
          ..value = DOP.D_MONTH.name
          ..label = filterOpDateMonth());
        _operationList.add(new DOption()
          ..value = DOP.D_QUARTER.name
          ..label = filterOpDateQuarter());
        _operationList.add(new DOption()
          ..value = DOP.D_YEAR.name
          ..label = filterOpDateYear());
        defaultOperation = DOP.D_DAY;
      }
    }
    if (!column.isMandatory) {
      _operationList.add(new DOption()
        ..value = DOP.ISNULL.name
        ..label = "\u2205\u2003 ${filterOpNull()}");
      _operationList.add(new DOption()
        ..value = DOP.NOTNULL.name
        ..label = "\u2203\u2003 ${filterOpNotNull()}");
    }
    _operationEditor.show = true;
    _settingValue = true;
    _operationEditor.dOptionList = _operationList; // sets first op otherwise
    _settingValue = false;

    // set value
    if (filter.hasOperation()) {
      operation = filter.operation;
    } else if (defaultOperation != null) {
      operation = defaultOperation;
    } else {
      operation = DOP.EQ;
    }
  } // columnNameSet


  /// operation change change
  void onOperationChange(String name, String newValue, DEntry entry, var details) {
    if (_settingValue)
      return;
    _log.config("onOperationChange ${newValue}");
    DOP oo = opFromString(newValue);
    if (oo != null) {
      operation = oo;
    }
  }
  bool _settingValue = false;

  /**
   * set operation
   */
  void set operation (DOP newValue) {
    op = newValue;
    if (op == null) {
      filter.clearOperation();
    } else {
      filter.operation = op;
      _operationEditor.value = op.name;
    }
    _log.fine("operation=${op} (${_operationEditor.value})");
    _operationSet();
  }
  DOP get operation => filter.operation;

  /// set value options
  void _operationSet() {
    // remove previous
    if (_valueEditor != null) {
      _valueEditor.element.remove();
    }
    if (_valueEditorTo != null) {
      _valueEditorTo.element.remove();
    }
    _operationDateEditor.show = false;

    // no option or no value
    if (column == null || op == null || op == DOP.ISNULL || op == DOP.NOTNULL) {
      return;
    }
    if (DATE_OPERATIONS.contains(op)) {
      _operationDateEditor.show = true;
      if (filter.hasOperationDate()) {
        _operationDateEditor.value = filter.operationDate.name;
      }
      return;
    }

    // set editor
    DataColumn dataColumn = new DataColumn(table, column, null, null);
    _valueEditor = EditorUtil.createFromColumn("value", dataColumn, true,
        idPrefix: idPrefix, isFilter: true);
    _valueEditor.readOnly = false;
    _valueEditor.defaultValue = "";
    if (_valueEditor is LSelect) {

    }
    _detail.append(_valueEditor.element);
    // set value
    _valueEditor.value = filter.filterValue;
    //
    if (op == DOP.BETWEEN) {
      _valueEditorTo = EditorUtil.createFromColumn("valueTo", dataColumn, true,
          idPrefix: idPrefix, isFilter: true);
      _valueEditorTo.readOnly = false;
      _valueEditorTo.defaultValue = "";
      _detail.append(_valueEditorTo.element);
      _valueEditorTo.value = filter.filterValueTo;
    }

  } // operationSet


  /// Date Op Values
  List<DOption> _getOperationDateOptions() {
    List<DOption> list = new List<DOption>();
    list.add(new DOption()
      ..value = DOP.D_LAST.name
      ..label = filterOpDateLast());
    list.add(new DOption()
      ..value = DOP.D_THIS.name
      ..label = filterOpDateThis());
    list.add(new DOption()
      ..value = DOP.D_NEXT.name
      ..label = filterOpDateNext());
    return list;
  }

  String toString() {
    return "PbjectHomeFilterItem ${table.name}.${filter.columnName} ${filter.operation} ${filter.filterValue}";
  }

  static String lObjectHomeFilterItemDelete() => Intl.message("Delete", name: "lObjectHomeFilterItemDelete");

  static String lObjectHomeFilterItemColumnName() => Intl.message("Column Name", name: "lObjectHomeFilterItemColumnName");
  static String lObjectHomeFilterItemOperation() => Intl.message("Operation", name: "lObjectHomeFilterItemOperation");

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

} //
