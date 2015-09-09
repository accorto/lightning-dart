/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

typedef void FilterUpdated(SavedQuery query);

/**
 * Filter Dialog
 */
class ObjectFilter {

  static const String _ID = "filter";
  static final Logger _log = new Logger("ObjectFilter");

  /// Modal
  LModal modal = new LModal(_ID);

  /// The Form
  FormCtrl _form;

  final DTable table;
  final SavedQuery savedQuery;
  final FilterUpdated filterUpdated;

  ObjectFilterFilter filterTable;
  ObjectFilterSort sortTable;

  /**
   * Filter Dialog
   */
  ObjectFilter(DTable this.table, SavedQuery this.savedQuery, FilterUpdated this.filterUpdated) {
    // Saved Filter
    _form = new FormCtrl("savedQuery", uiSavedQuery(),
      element: new DivElement(), idPrefix:_ID);
    _form.build();
    modal.large = true;
    modal.addFooterFormButtons(_form);
    _form.addResetButton().onClick.listen(onReset);
    _form.recordSaved = filterRecordSaved;
    _toRecord();

    LIcon icon = new LIconUtility(LIconUtility.FILTER);
    String label = "${objectFilter()}: ${table.label}";
    if (!savedQuery.hasSavedQueryId())
      label += " - ${AppsAction.appsActionNew()}";
    modal.setHeader(label, icon:icon);
    // Form
    modal.add(_form);

    // Filter Rows
    filterTable = new ObjectFilterFilter(savedQuery.filterList, table);
    modal.add(filterTable);
    sortTable = new ObjectFilterSort(savedQuery.sortList, table);
    modal.add(sortTable);
  } // ObjectFilter

  /// Reset dependents
  void onReset(Event evt) {
    filterTable.reset();
    sortTable.reset();
  }

  String filterRecordSaved(DRecord record) {
    _log.info("filterRecordSaved ${record}");
    modal.show = false;
    if (filterUpdated != null)
      filterUpdated(toSavedQuery());
    return null;
  }

  /// Convert to Records
  void _toRecord() {
    DRecord record = new DRecord()
      ..tableName = _TABLENAME;

    if (savedQuery.hasName()) {
      record.entryList.add(new DEntry()
        ..columnName = _COL_NAME
        ..valueOriginal = savedQuery.name);
    }
    if (savedQuery.hasDescription()) {
      record.entryList.add(new DEntry()
        ..columnName = _COL_DESCRIPTION
        ..valueOriginal = savedQuery.description);
    }
    // Sharing
    String sharing = (savedQuery.hasUserId() ? "p" : "s")
      + (savedQuery.isDefault ? "d" : "-");
    record.entryList.add(new DEntry()
      ..columnName = _COL_SHARING
      ..valueOriginal = sharing);

    if (savedQuery.hasSqlWhere()) {
      record.entryList.add(new DEntry()
        ..columnName = _COL_SQLWHERE
        ..valueOriginal = savedQuery.sqlWhere);
    }
    if (savedQuery.hasFilterLogic()) {
      record.entryList.add(new DEntry()
        ..columnName = _COL_FILTERLOGIC
        ..valueOriginal = savedQuery.filterLogic);
    }
    _form.record = record;
  } // toRecord

  /// update Saved Qyery
  SavedQuery toSavedQuery() {
    savedQuery.name = _form.data.getValue(name: _COL_NAME);
    String desc = _form.data.getValue(name: _COL_DESCRIPTION);
    if (desc == null || desc.isEmpty)
      savedQuery.clearDescription();
    else
      savedQuery.description = desc;
    // Sharing
    String sharing = _form.data.getValue(name: _COL_SHARING);
    if (sharing == null || sharing.isEmpty) {
      savedQuery.clearUserId();
      savedQuery.clearIsDefault();
    } else {
      if (sharing.contains("p")) {
        // set user
      } else {
        savedQuery.clearUserId();
      }
      savedQuery.isDefault = sharing.contains("d");
    }
    // FilterLogic
    String logic = _form.data.getValue(name: _COL_FILTERLOGIC);
    if (logic == null || logic.isEmpty)
      savedQuery.clearFilterLogic();
    else
      savedQuery.filterLogic = logic;

    // Direct Sql
    if (_manualEntry) {
      String sql = _form.data.getValue(name: _COL_SQLWHERE);
      if (sql == null || sql.isEmpty)
        savedQuery.clearSqlWhere();
      else
        savedQuery.sqlWhere = sql;
    } else {
      savedQuery.clearSqlWhere();
    }

    // get child values
    savedQuery.filterList.clear();
    savedQuery.filterList.addAll(filterTable.updateFilterList());

    savedQuery.sortList.clear();
    savedQuery.sortList.addAll(sortTable.updateSortList());

    return savedQuery;
  }

  // TODO notice change in filter/sort
  //
  bool _manualEntry = false;

  bool checkFilterLogic() {
    String logic = _form.data.getValue(name: _COL_FILTERLOGIC);
    if (logic == null || logic.isEmpty)
      return true;

    List<DFilter> filters = filterTable.updateFilterList();
    if (filters.isEmpty)
      return true;
    // TODO check correctness of filter logic
    return true;
  }

  static const String _TABLENAME = "SavedQuery";
  static const String _COL_NAME = "name";
  static const String _COL_DESCRIPTION = "description";
  static const String _COL_SHARING = "sharing";
//  ..a(5, 'userId', GeneratedMessage.OS)
//  ..a(6, 'isDefault', GeneratedMessage.OB)
  static const String _COL_SQLWHERE = "sqlWhere";
  static const String _COL_FILTERLOGIC = "filterLogic";


  /**
   * Saved Query UI
   */
  static UI uiSavedQuery() {
    UiUtil uiu = new UiUtil(new UI());
    DTable sqTable = new DTable()
      ..name = _TABLENAME
      ..label = objectFilter();
    uiu.setTable(sqTable);
    uiu.addPanel(null);

    // Column Name
    DColumn col = new DColumn()
      ..name = _COL_NAME
      ..label = objectFilterName()
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 1
      ..columnSize = 60
      ..isMandatory = true;
    uiu.addColumn(col);

    // Column Description
    col = new DColumn()
      ..name = _COL_DESCRIPTION
      ..label = objectFilterDescription()
      ..dataType = DataType.STRING
      ..columnSize = 255;
    uiu.addColumn(col);

    // Column Sharing
    col = new DColumn()
      ..name = _COL_SHARING
      ..label = "Sharing"
      ..dataType = DataType.PICK
      ..isMandatory = true;
    col.pickValueList.add(new DOption()..value = "s-" ..label = "Shared Filter");
    col.pickValueList.add(new DOption()..value = "sd" ..label = "Shared Filter (Default)");
    col.pickValueList.add(new DOption()..value = "p-" ..label = "Private Filter");
    col.pickValueList.add(new DOption()..value = "pd" ..label = "Private Filter (Default)");
    uiu.addColumn(col);

    // Column Where
    col = new DColumn()
      ..name = _COL_SQLWHERE
      ..label = "Direct SQL Where clause"
      ..dataType = DataType.STRING
      ..columnSize = 255;
    uiu.addColumn(col);

    // Column Filter Logic
    col = new DColumn()
      ..name = _COL_FILTERLOGIC
      ..label = "Filter Logic"
      ..help = "hint: all filter have AND conditions, unless specified, e.g. (1 OR 2) AND 3"
      ..dataType = DataType.STRING
      ..columnSize = 255;
    uiu.addColumn(col);

    return uiu.ui;
  } // uiSavedQuery


  static String objectFilter() => Intl.message("Filter", name: "objectFilter");
  static String objectFilterName() => Intl.message("Name", name: "objectFilterName");
  static String objectFilterDescription() => Intl.message("Description", name: "objectFilterDescription");


} // ObjectFilter
