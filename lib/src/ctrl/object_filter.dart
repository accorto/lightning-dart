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



  /**
   * Saved Query UI
   */
  static UI uiSavedQuery() {
    UiUtil uiu = new UiUtil(new UI());
    DTable sqTable = new DTable()
      ..name = "SavedQuery"
      ..label = objectFilter();
    uiu.setTable(sqTable);
    uiu.addPanel(null);

    // Columns
    DColumn col = new DColumn()
      ..name = "name"
      ..label = "Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 1
      ..columnSize = 60
      ..isMandatory = true;
    uiu.addColumn(col);

    // Columns
    col = new DColumn()
      ..name = "description"
      ..label = "Description"
      ..dataType = DataType.STRING
      ..columnSize = 255
      ..isMandatory = false;
    uiu.addColumn(col);


    return uiu.ui;
  } // uiSavedQuery


  static String objectFilter() => Intl.message("Filter", name: "objectFilter");


} // ObjectFilter
