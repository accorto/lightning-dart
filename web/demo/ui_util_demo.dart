/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

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
  UIPanelColumn addColumn(DColumn col, {List<String> examples, String displayLogic,
      bool mandatory, bool readOnly, String label, String labelGrid,
      bool isAlternativeDisplay, int width, bool addColToTable:true}) {
    UIPanelColumn pc = super.addColumn(col, displayLogic:displayLogic, mandatory:mandatory,
        isAlternativeDisplay:isAlternativeDisplay, width:width, addColToTable:addColToTable);

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
    return pc;
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

  /// update example header
  void updateHeader(DRecord record) {
    // "save"
    if (!record.hasRecordId()) {
      record.recordId = nextId();
    }
    for (DEntry entry in record.entryList) {
      if (entry.hasValue()) {
        entry.valueOriginal = entry.value;
        entry.clearValue();
        //  entry.clearValueDisplay();
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
    record.clearIsChanged();
  } // updateHeader

  /// next id
  String nextId() {
    return "${_nid++}";
  }
  int _nid = 1;

} // UiUtilDemo
