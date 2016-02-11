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

  LPicklist _columnNameEditor;
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

    _columnNameEditor = new LPicklist("columnName",
        idPrefix: idPrefix)
      ..label = lObjectHomeFilterItemColumnName()
      ..readOnly = filter.isReadOnly
      ..editorChange = onColumnNameChange
      ..required = false;
    _columnNameEditor.dOptionList = OptionUtil.columnOptions(table);
    _detail.append(_columnNameEditor.element);

    _operationEditor = new LPicklist("operation",
        idPrefix: idPrefix)
      ..label = lObjectHomeFilterItemOperation()
      ..readOnly = filter.isReadOnly
      ..editorChange = onOperationChange
      ..required = true
      ..show = false;
    _detail.append(_operationEditor.element);

    // data
    columnName = filter.columnName;
    if (filter.hasOperation())
      operation = filter.operation;
    //if (filter.hasFilterValue())


  } // ObjectFilterItem

  /// Detail div - (body) .tile__detail
  DivElement get detail => _detail;
  UListElement get detailList => null;

  /// column name change
  void onColumnNameChange(String name, String newValue, DEntry entry, var details) {
    _log.config("onColumnNameChange ${newValue}");
    columnName = newValue;
  }

  /// set column name
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
    _setOperationOptions();
  } // setColumnName

  /// set operations options
  void _setOperationOptions() {
    if (column == null) {
      _operationEditor.show = false;
      return;
    }

    List<DOption> list = new List<DOption>();
    DataType dt = column.dataType;
    DOP defaultOperation = DOP.EQ;
    list.add(new DOption()
      ..value = DOP.EQ.name
      ..label = "=\u2003 ${filterOpEquals()}");
    if (dt != DataType.BOOLEAN) {
      list.add(new DOption()
        ..value = DOP.NE.name
        ..label = "\u2260\u2003 ${filterOpNotEquals()}");
      if (DataTypeUtil.isStringStrict(dt)) {
        list.add(new DOption()
          ..value = DOP.LIKE.name
          ..label = "\u2248\u2003 ${filterOpLike()}");
        list.add(new DOption()
          ..value = DOP.NOTLIKE.name
          ..label = "\u2249\u2003 ${filterOpNotLike()}");
        defaultOperation = DOP.LIKE;
      }
      if (DataTypeUtil.isPick(dt)) {
        list.add(new DOption()
          ..value = DOP.IN.name
          ..label = "\u2208\u2003 ${filterOpIn()}");
        list.add(new DOption()
          ..value = DOP.NOTIN.name
          ..label = "\u2209\u2003 ${filterOpNotIn()}");
      } else if (!DataTypeUtil.isFk(dt)) {
        list.add(new DOption()
          ..value = DOP.GE.name
          ..label = "\u2265\u2003 ${filterOpGreaterEquals()}");
        list.add(new DOption()
          ..value = DOP.GT.name
          ..label = ">\u2003 ${filterOpGreater()}");
        list.add(new DOption()
          ..value = DOP.LE.name
          ..label = "\u2264\u2003 ${filterOpLessEquals()}");
        list.add(new DOption()
          ..value = DOP.LT.name
          ..label = "<\u2003 ${filterOpLess()}");
        list.add(new DOption()
          ..value = DOP.BETWEEN.name
          ..label = "|..|\u2002 ${filterOpBetween()}");
      }
      if (dt == DataType.DATE || dt == DataType.DATETIME) {
        list.add(new DOption()
          ..value = DOP.D_DAY.name
          ..label = filterOpDateDay());
        list.add(new DOption()
          ..value = DOP.D_WEEK.name
          ..label = filterOpDateWeek());
        list.add(new DOption()
          ..value = DOP.D_MONTH.name
          ..label = filterOpDateMonth());
        list.add(new DOption()
          ..value = DOP.D_QUARTER.name
          ..label = filterOpDateQuarter());
        list.add(new DOption()
          ..value = DOP.D_YEAR.name
          ..label = filterOpDateYear());
        defaultOperation = DOP.D_DAY;
      }
    }
    if (!column.isMandatory) {
      list.add(new DOption()
        ..value = DOP.ISNULL.name
        ..label = "\u2205\u2003 ${filterOpNull()}");
      list.add(new DOption()
        ..value = DOP.NOTNULL.name
        ..label = "\u2203\u2003 ${filterOpNotNull()}");
    }
    _operationEditor.show = true;
    _operationEditor.dOptionList = list;

    // set value
    if (filter.hasOperation()) {
      operation = filter.operation;
    } else if (defaultOperation != null) {
      operation = defaultOperation;
    } else {
      operation = DOP.EQ;
    }
  } // setOperationOptions


  /// column name change
  void onOperationChange(String name, String newValue, DEntry entry, var details) {
    _log.config("onOperationChange ${newValue}");
    for (DOP oo in DOP.values) {
      if (oo.name == newValue) {
        operation = oo;
        return;
      }
    }
  }

  /// set operation
  void set operation (DOP newValue) {
    op = newValue;
    if (op == null) {
      filter.clearOperation();
    } else {
      filter.operation = op;
      _operationEditor.value = op.name;
    }
    _log.fine("operation=${op} (${_operationEditor.value})");
    _setValueOptions();
  }

  /// set value options
  void _setValueOptions() {
    // remove previous
    if (_valueEditor != null) {
      _valueEditor.element.remove();
    }
    if (_valueEditorTo != null) {
      _valueEditorTo.element.remove();
    }

    // no option or no value
    if (column == null || op == null || op == DOP.ISNULL || op == DOP.NOTNULL) {
      return;
    }
    // set editor
    DataColumn dataColumn = new DataColumn(table, column, null, null);
    _valueEditor = EditorUtil.createFromColumn("value", dataColumn, false, idPrefix: idPrefix);
    _detail.append(_valueEditor.element);

    // set value
    if (filter.hasFilterValue()) {
      _valueEditor.value = filter.filterValue;
    }


  } // setValueOptions


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
