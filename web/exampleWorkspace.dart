/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

library lightning.example;

import "dart:html";

//import "package:lightning/lightning.dart";
import "package:lightning/lightning_ctrl.dart";

/**
 * Workbench Example
 * - Object Home with records
 */
void main() {

  LightningDart.init() // client env
  .then((_) {
    WorbenchData wbData = new WorbenchData();

    ObjectCtrl ctrl = new ObjectCtrl(wbData.ui);
    ctrl.display(wbData.exampleList);


    PageSimple page = PageSimple.create();
    page.add(ctrl);

    /// Record
    page.append(new HRElement());
    RecordCtrl recordCtrl = new RecordCtrl(wbData.ui)
      ..record = wbData.exampleList.first;

    page.add(recordCtrl);

  });

} // main


/**
 * Data Structure for Workbench
 */
class WorbenchData {

  final UI ui = new UI();
  final List<DRecord> recordList = new List<DRecord>();
  final List<DRecord> exampleList = new List<DRecord>();


  WorbenchData() {
    ui.uiId = _nextId();
    DTable table = new DTable()
      ..tableId = _nextId()
      ..name = "MyContact"
      ..label = "My Contact"
      ..description = "My brief Object description"
      ..help = "This is an example object to demonstrate the workbench"
      ..tutorialUrl = "http://lightning,accorto.com"
      ..iconImage = "slds-icon-standard-contact";

    // Set Table
    ui.table = table;
    ui.tableId = table.tableId;
    ui.tableName = table.name;
    ui.label = table.label;

    UIPanel panel = new UIPanel()
      ..uiPanelId = _nextId()
      ..name = "Panel";
    ui.panelList.add(panel);


    // Columns
    DColumn col = new DColumn()
      ..columnId = _nextId()
      ..name = "FName"
      ..label = "First Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 2
      ..displaySeqNo = 1
      ..isMandatory = true;
    addColumn(col, panel, ["Joe", "Peter", "Marie"]);

    col = new DColumn()
      ..columnId = _nextId()
      ..name = "LName"
      ..label = "Last Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 2
      ..isMandatory = true;
    addColumn(col, panel, ["Black", "Smith", "Johnson"]);

    // update DRecord Header
    for (DRecord record in exampleList) {
      updateHeader(record);
    }
  } // WorkbenchData

  /// add column
  void addColumn(DColumn col, UIPanel panel, List<String> exampleData) {
    ui.table.columnList.add(col);

    UIPanelColumn pc = new UIPanelColumn()
      ..uiPanelColumnId = _nextId()
      ..column = col
      ..columnId = col.columnId
      ..columnName = col.name;
    panel.panelColumnList.add(pc);

    UIGridColumn gc = new UIGridColumn()
      ..uiGridColumnId = _nextId()
      ..column = col
      ..columnId = col.columnId
      ..columnName = col.name
      ..panelColumn = pc;
    ui.gridColumnList.add(gc);

    // Data
    for (int i = 0; i < exampleData.length; i++) {
      String value = exampleData[i];
      DEntry entry = new DEntry()
        ..columnId = col.columnId
        ..columnName = col.name
        ..valueOriginal = value;
      DRecord record = getExample(i);
      record.entryList.add(entry);
    }
  }

  /// get example record
  DRecord getExample(int i) {
    while (exampleList.length <= i) {
      DRecord r = new DRecord()
        ..recordId = "99" + i.toString()
        ..tableId = ui.tableId
        ..tableName = ui.tableName;
      exampleList.add(r);
    }
    return exampleList[i];
  }

  /// update header
  void updateHeader(DRecord record) {
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
  String _nextId() {
    return "${_nid++}";
  }
  int _nid = 1;

} // WorkbenchData
