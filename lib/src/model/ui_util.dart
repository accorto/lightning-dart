/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Ui Construction Utility
 */
class UiUtil {

  /// The UI
  final UI ui;
  /// The Table
  DTable get table => ui.table;

  /// current panel
  UIPanel _panel;


  /**
   * UI Construction Utility
   */
  UiUtil(UI this.ui) {
  }

  /// Set Table
  void setTable(DTable newTable) {
    ui.table = newTable;
    if (newTable.hasTableId())
      ui.tableId = newTable.tableId;
    ui.tableName = newTable.name;
    ui.label = newTable.label;
  }

  /// Add/Set Panel
  UIPanel addPanel(String name, {int columnCount:0}) {
    _panel = new UIPanel()
      ..name = name == null ? "Default" : name
      ..panelColumnNumber = columnCount;
    ui.panelList.add(_panel);
    return _panel;
  }

  /// add column
  void addColumn(DColumn col, {String displayLogic}) {
    ui.table.columnList.add(col);
    if (_panel == null)
      addPanel(null);

    // panel
    UIPanelColumn pc = new UIPanelColumn()
      ..column = col
      ..columnName = col.name;
    if (col.hasColumnId())
      pc.columnId = col.columnId;
    if (displayLogic != null && displayLogic.isNotEmpty)
      pc.displayLogic = displayLogic;
    pc.seqNo = (_panel.panelColumnList.length + 1);
    _panel.panelColumnList.add(pc);

    // grid
    UIGridColumn gc = new UIGridColumn()
      ..column = col
      ..columnName = col.name
      ..panelColumn = pc;
    if (col.hasColumnId())
      gc.columnId = col.columnId;
    gc.seqNo = (ui.gridColumnList.length + 1);
    ui.gridColumnList.add(gc);

  } // addColumn


} // UiUtil


/**
 * Demo UiUtil
 */
class UiUtilDemo extends UiUtil {

  final List<DRecord> exampleList;

  /**
   * UI Demo Construction Utility
   */
  UiUtilDemo(UI ui, {List<DRecord> this.exampleList}) : super(ui) {
  }


  /// add column
  void addColumn(DColumn col, {List<String> examples, String displayLogic}) {
    super.addColumn(col, displayLogic:displayLogic);

    // -- data
    if (exampleList != null && examples != null) {
      for (int i = 0; i < examples.length; i++) {
        String value = examples[i];
        DEntry entry = new DEntry()
          ..columnId = col.columnId
          ..columnName = col.name
          ..valueOriginal = value;
        DRecord record = _getExample(i);
        record.entryList.add(entry);
      }
    }
  } // addColumn


  /// get example record
  DRecord _getExample(int i) {
    while (exampleList.length <= i) {
      DRecord r = new DRecord()
        ..recordId = "99" + i.toString()
        ..tableId = ui.tableId
        ..tableName = ui.tableName;
      exampleList.add(r);
    }
    return exampleList[i];
  }

  /// update example records
  void updateExamples() {
    // update DRecord Header
    for (DRecord record in exampleList) {
      updateHeader(record);
    }
  }

  /// update exmpple header
  void updateHeader(DRecord record) {
    // "save"
    if (!record.hasRecordId()) {
      record.recordId = nextId();
    }
    for (DEntry entry in record.entryList) {
      if (entry.hasValue()) {
        entry.valueOriginal = entry.value;
        entry.clearValue();
        entry.clearValueDisplay();
        entry.clearIsChanged();
      }
    }

    record.drv = "";
    record.urv = "";
    // unique
    ui.table.columnList.sort((DColumn one, DColumn two){
      return one.uniqueSeqNo.compareTo(two.uniqueSeqNo);
    });
    for (DColumn col in ui.table.columnList) {
      if (col.hasUniqueSeqNo()) {
        String value = "";
        for (DEntry entry in record.entryList) {
          if (entry.columnName == col.name) {
            value = entry.valueOriginal;
            break;
          }
        }
        if (record.urv.isEmpty)
          record.urv = value;
        else
          record.urv += value;
      }
    }
    // display
    ui.table.columnList.sort((DColumn one, DColumn two){
      return one.displaySeqNo.compareTo(two.displaySeqNo);
    });
    for (DColumn col in ui.table.columnList) {
      if (col.hasDisplaySeqNo()) {
        String value = "";
        for (DEntry entry in record.entryList) {
          if (entry.columnName == col.name) {
            value = entry.valueOriginal;
            break;
          }
        }
        if (record.drv.isEmpty)
          record.drv = value;
        else
          record.drv += " " + value;
      }
    }
  } // updateHeader

  /// next id
  String nextId() {
    return "${_nid++}";
  }
  int _nid = 1;

}
