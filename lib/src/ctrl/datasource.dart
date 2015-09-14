/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Datasource - Meta Data and Persistence Interface
 */
abstract class Datasource {

  static final Logger _log = new Logger("Datasource");


  /// Table Name
  final String tableName;
  /// Record Sort List
  final RecordSorting recordSorting = new RecordSorting();

  /**
   * Data Source
   */
  Datasource(String this.tableName) {
    recordSorting.sortExecute = sortExecute;
  }

  /// Initialize and get ui
  Future<UI> ui() {
    Completer<UI> completer = new Completer<UI>();
    if (_ui == null) {
      meta_ui()
      .then((UI ui) {
        _ui = ui;
        _table = ui.table;
        completer.complete(_ui);
      })
      .catchError((Object error, StackTrace stackTrace){
        completer.completeError(error, stackTrace);
      });
    } else {
      completer.complete(_ui);
    }
    return completer.future;
  }
  /// ui direct - might be null
  UI get uiDirect => _ui;
  UI _ui;

  /// table direct - might be null
  DTable get tableDirect => _table;
  DTable _table;


  /// Execute Sort
  bool sortExecute() {
    bool sortLocal = true;
    _log.info("sortExecute");
    return sortLocal;
  }
  /// Implement - query
  Future<DataResponse> query(DataRequest request);




  /// Implement - retrieve ui
  Future<UI> meta_ui();


} // Datasource

