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


    PageSimple page = PageSimple.create();
    page.add(ctrl);

    /// Record
    page.append(new HRElement());
    LRecordHome recordHome = new LRecordHome.ui(wbData.ui)
      ..record = wbData.exampleList.first;

    page.add(recordHome);

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
    DTable table = new DTable()
      ..tableId = "99"
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

    // Columns
    DColumn col = new DColumn()
      ..name = "FName"
      ..label = "First Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 2
      ..displaySeqNo = 1
      ..isMandatory = true;
    addColumn(col, ["Joe", "Peter", "Marie"]);

    col = new DColumn()
      ..name = "LName"
      ..label = "Last Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 2
      ..isMandatory = true;
    addColumn(col, ["Black", "Smith", "Johnson"]);

    // update DRecord Header
    for (DRecord record in exampleList) {
      updateHeader(record);
    }
  } // WorkbenchData

  /// add column
  void addColumn(DColumn col, List<String> exampleData) {
    ui.table.columnList.add(col);

    // Data
    for (int i = 0; i < exampleData.length; i++) {
      String value = exampleData[i];
      DEntry entry = new DEntry()
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
        ..recordId = "9" + i.toString()
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

} // WorkbenchData
