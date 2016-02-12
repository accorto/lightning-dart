/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * FK Search Dialog
 * - independent FK
 * - FK with (external) Parent value
 * TODO dependent/multiple FK's - parent/child/..
 */
class FkDialog {

  static final Logger _log = new Logger("FkDialog");

  /// Get Dialog
  static FkDialog getDialog(String tableName, bool isDependent) {
    FkDialog d = _dialogs[tableName];
    if (d == null) {
      d = new FkDialog(tableName, isDependent);
      _dialogs[tableName] = d;
    }
    return d;
  }
  static final Map<String, FkDialog> _dialogs = new Map<String, FkDialog>();


  LModal _modal;
  LForm _form;
  LInput _editorFind;
  LTable _table;
  /// Status Element
  ParagraphElement _status = new ParagraphElement()
    ..classes.addAll([LMargin.C_VERTICAL__SMALL]);

  FkCtrl lookup;
  /// Fk Table
  final String tableName;
  final bool isDependent;

  // Data Source
  Datasource _datasource;

  String _queryRestriction = "";
  int _totalRows = -1;
  int _queriedRows = -1;
  int _matchedRows = 0;

  /**
   * Fk Search Dialog
   */
  FkDialog(String this.tableName, bool this.isDependent) {
    String idPrefix = "fk_${tableName}";
    _modal = new LModal(idPrefix);
    _modal.setHeader(fkDialogTitle()); // temp
    //
    _form = new LForm.stacked("q", idPrefix:idPrefix);
    _form.formRecordChange = onFormRecordChange;
    _modal.add(_form);
    //
    _editorFind = new LInput("find", EditorI.TYPE_TEXT, idPrefix:idPrefix, withClearValue:true)
      ..label = fkDialogFind();
    _editorFind.input.onKeyUp.listen(onFindInputKeyUp);
    _form.addEditor(_editorFind);
    _modal.add(_form);
    //
    _modal.append(_status);
    //
    _table = new LTable(idPrefix)
      ..responsiveOverflow = true
      ..editMode = LTable.EDIT_SELECT_SINGLE
      ..tableSelectClicked = onTableSelectClicked;
    _modal.add(_table);
    _table.element.style // wrapper
      ..height = "300px" // ~7 records
      ..overflowY = "auto";
    //
    _datasource = new Datasource(tableName, FkService.instance.dataUri, FkService.instance.uiUri);
    _datasource.uiFuture()
    .then(setUi)
    .catchError((error, stackTrace) {
      _log.warning(idPrefix, error, stackTrace);
    });
  } // FkDialog

  /// Set UI
  void setUi(UI ui) {
    _table.setUi(ui, fromQueryColumns:true);
    _log.fine("setUi ${tableName}");
    if (!isDependent) {
      _executeSearch(); // start query
    }
  } // setUI

  // Find Input Change
  void onFindInputKeyUp(KeyboardEvent evt) {
    int kc = evt.keyCode;
    if (kc == KeyCode.ESC) {
      _editorFind.value = "";
      _executeFind();
    } else if (kc == KeyCode.ENTER) {
      _executeSearch();
    } else {
      _executeFind();
    }
  } // onFindInputKeyUp

  void onFormRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    // clear value pressed
    _executeFind();
  } // onFormRecordChange

  /// Find in table
  void _executeFind() {
    String restriction = _editorFind.value;
    _log.config("executeFind ${tableName} ${restriction}");
    _matchedRows = _table.findInTable(restriction);
    _setStatus();
  } // executeFind

  /// Go back to server
  void _executeSearch() {
    _datasource.queryFilterList.clear();
    // parent restriction
    if (lookup.parentValues != null && lookup.parentValues.isNotEmpty) {
      _datasource.queryParentList.clear();
      for (int i = 0; i < lookup.parents.length; i++) {
        String columnName = lookup.parents[i];
        String columnValue = lookup.parentValues[i];
        if (columnValue == null)
          continue;
        DFilter filter = new DFilter()
          ..columnName = columnName
          ..operation = DOP.EQ
          ..filterValue = columnValue
          ..dataType = DataType.FK;
        _datasource.queryParentList.add(filter);
      }
    } // parent restriction

    // name restriction
    _queryRestriction = _editorFind.value;
    if (_queryRestriction != null && _queryRestriction.isNotEmpty) {
      DFilter filter = new DFilter()
        ..columnName = "Name"
        ..operation = DOP.LIKE
        ..filterValue = _queryRestriction;
      _datasource.queryFilterList.add(filter);
    }
    _log.config("executeSearch start ${tableName} ${_queryRestriction}");

    _table.loading = true;
    _datasource.query(null, setBusy:false)
    .then((DataResponse response){
      _log.config("executeSearch end ${tableName} ${_queryRestriction}");
      _table.loading = false;
      _table.setRecords(response.recordList);
      _totalRows = response.totalRows;
      _queriedRows = response.recordList.length;
      _matchedRows = _queriedRows;
      _setStatus();
    });
  } // executeSearch


  /// Show after setting parent values
  void show(FkCtrl lookup) {
    this.lookup = lookup;
    _modal.setHeader("${fkDialogTitle()} ${lookup.label}",icon: new LIconUtility(LIconUtility.SEARCH));
    _modal.showInElement(AppsMain.modals);
    _table.selectAll(false); // previous selection
    //
    if (lookup.parentValues != null && lookup.parentValues.isNotEmpty) {
      _executeSearch();
    }
  } // show

  /// Select + close
  void onTableSelectClicked(DataRecord data) {
    _log.config("onTableSelectClicked ${tableName} ${data.selected} ${data.recordId}");
    if (lookup != null && data.selected && data.recordId.isNotEmpty) {
      lookup.value = data.recordId;
      lookup.onInputChange(null);
      _modal.onClickRemove(null); // fini
    }
  } // onTableSelectClicked

  /// update status
  void _setStatus() {
    String restriction = _editorFind.value;
    if (_queryRestriction.isNotEmpty && restriction == _queryRestriction) {
      restriction = ""; // additional
    }
    _log.fine("total=${_totalRows} queried==${_queriedRows} matched=${_matchedRows} search=${_queryRestriction} restriction=${restriction}");

    if (_totalRows == 0) {
      _status.text = "No records found";
    } else if (_totalRows == _queriedRows) {
      // all available records
      if (_matchedRows == _totalRows) {
        _status.text = "${_totalRows} records";
      } else {
        _status.text = "matched ${_matchedRows} of ${_totalRows} records";
      }
    } else if (_datasource.queryParentList.isNotEmpty) {
      // total rows not applicable
      if (_queriedRows == 0) {
        _status.text = "No records of parent with '${_queryRestriction}' found";
      } else if (_matchedRows == 0) {
        _status.text = "None of queried ${_queriedRows} records with '${_queryRestriction}' matched restriction entered";
      } else {
        _status.text = "matched ${_matchedRows} records of queried ${_queriedRows} records with '${_queryRestriction}'";
      }
    } else {
      // query restriction
      if (_queriedRows == 0) {
        _status.text = "None of total ${_totalRows} records with '${_queryRestriction}' found";
      } else if (_matchedRows == 0) {
        _status.text = "None of queried ${_queriedRows} records with '${_queryRestriction}' of total ${_totalRows} records matched restriction entered";
      } else {
        _status.text = "matched ${_matchedRows} records of queried ${_queriedRows} records with '${_queryRestriction}' of total ${_totalRows} records";
      }
    }
  } // setStatus

  static String fkDialogTitle() => Intl.message("Search", name: "fkDialogTitle");

  static String fkDialogFind() => Intl.message("Find in records -or- Search with name (enter)", name: "fkDialogFind");

} // FkDialog
