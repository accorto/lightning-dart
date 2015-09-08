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

  static const String _ID = "o-filter";
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
    return null;
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
      ..label = "Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 1
      ..columnSize = 60
      ..isMandatory = true;
    uiu.addColumn(col);

    // Column Description
    col = new DColumn()
      ..name = _COL_DESCRIPTION
      ..label = "Description"
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


} // ObjectFilter
