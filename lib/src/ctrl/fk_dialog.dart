/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * FK Search Dialog
 */
class FkDialog {

  static final Logger _log = new Logger("FkDialog");

  LModal _modal;
  LForm _form;
  LInput _editorName;
  LTable _table;

  /// Fk Table
  final String tableName;
  List<String> parents;

  Datasource _datasource;

  /**
   * Fk Search Dialog
   */
  FkDialog(String this.tableName, String label, bool createNew) {
    String id = "fk_${tableName}";
    _modal = new LModal(id);
    _modal.setHeader("${fkDialogTitle()} ${label}",icon: new LIconUtility(LIconUtility.SEARCH));
    //
    _form = new LForm.stacked("q", idPrefix:id);
    _modal.add(_form);
    //
    _editorName = new LInput("name", EditorI.TYPE_TEXT, idPrefix:id, withClearValue:true)
      ..label = "Name";
    _editorName.input.onKeyUp.listen(onNameInputKeyUp);
    _form.addEditor(_editorName);
    //
    _table = new LTable(id);
    _modal.add(_form);
    //
    _datasource = new Datasource(tableName, FkService.instance.dataUri, FkService.instance.uiUri);
    _datasource.uiFuture()
    .then(setUi);
  } // FkDialog

  /// Set UI
  void setUi(UI ui) {
    _executeSearch();



  } // setUI

  // Name Input Change
  void onNameInputKeyUp(KeyboardEvent evt) {
    int kc = evt.keyCode;
    if (kc == KeyCode.ESC) {
      _editorName.value = "";
      _executeFind();
    } else if (kc == KeyCode.ENTER) {
      _executeSearch();
    } else {
      _executeFind();
    }
  } // onNameInputKeyPress


  void _executeFind() {
    String restriction = _editorName.value;
    _log.config("executeFind ${tableName} ${restriction}");
  }

  void _executeSearch() {
    _datasource.queryFilterList.clear();

    String name = _editorName.value;
    if (name != null && name.isNotEmpty) {
      DFilter filter = new DFilter()
        ..columnName = "Name"
        ..operation = DOP.LIKE
        ..filterValue = name;
      _datasource.queryFilterList.add(filter);
    }
    _log.config("executeSearch start ${tableName} ${name}");

    _datasource.query()
    .then((DataResponse response){
      _log.config("executeSearch end ${tableName} ${name}");

    });
  } // executeSearch


  /// Show
  void show() {
    _modal.showInElement(AppsMain.modals);
  }


  static String fkDialogTitle() => Intl.message("Search", name: "fkDialogTitle");


} // FkDialog
