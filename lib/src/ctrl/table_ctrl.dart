/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Table Controller
 * SubClasses need to implement:
 * - UI get [ui]
 */
abstract class TableCtrl
    extends LTable {

  static final Logger _log = new Logger("TableCtrl");


  final bool optionCreateNew;
  final bool optionLayout;
  final bool optionEdit;
  /// always one empty line
  final bool alwaysOneEmptyLine;
  /// Callback when save
  RecordSaved recordSaved;
  /// Callback when delete
  RecordDeleted recordDeleted;
  /// Callback when delete
  RecordsDeleted recordsDeleted;

  /**
   * Object Table
   * - provide [appsActionNewCallback] to overwrite creating new row (inline)
   */
  TableCtrl({String idPrefix,
      bool this.optionCreateNew:true,
      bool optionRowSelect:true,
      RecordSorting recordSorting,
      bool this.optionLayout:true,
      bool this.optionEdit:true,
      String editMode: LTable.EDIT_ALL,
      bool this.alwaysOneEmptyLine:false})
    : super(idPrefix, optionRowSelect:optionRowSelect, recordSorting:recordSorting) {
    this.editMode = editMode;
    //
    addActions();
    setUi(ui);
    //
    resetContent();
  } // ObjectTable

  /// Add Table/Row Actions
  void addActions() {
    // Table Actions
    if (optionCreateNew)
      addTableAction(AppsAction.createNew(onAppsActionNew));
    if (optionRowSelect)
      addTableAction(AppsAction.createDeleteSelected(onAppsActionDeleteSelected));
    if (optionLayout)
      addTableAction(AppsAction.createLayout(onAppsActionTableLayout));
    //
    if (optionEdit && editMode != LTable.EDIT_RO)
      addRowAction(AppsAction.createEdit(onAppsActionEdit));
    if (editMode != LTable.EDIT_RO)
      addRowAction(AppsAction.createDelete(onAppsActionDelete));
  }

  String get tableName => ui.tableName;

  /// Reset Content
  void resetContent() {
    recordList.clear(); // override
    if (alwaysOneEmptyLine)
      addNewRecord();
    display();
  }

  /// Application Action New
  void onAppsActionNew(String value, DRecord record, DEntry entry, var actionVar) {
    DRecord record = addNewRecord();
    _log.config("onAppsActionNew ${tableName} ${value}  #${recordList.length}");
    if (editMode == LTable.EDIT_ALL || editMode == LTable.EDIT_SEL)
      display();
    else {
      ObjectEdit oe = new ObjectEdit(ui);
      oe.setRecord(record, -1);
      oe.recordSaved = recordSaved;
      oe.modal.showInElement(element);
    }
  }

  /// Add New Record at End
  DRecord addNewRecord() {
    DRecord record = new DataRecord(null).newRecord(ui.table, null);
    recordList.add(record);
    return record;
  }

  /// Application Action Edit
  void onAppsActionEdit(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionEdit ${tableName} ${value} id=${record.recordId}");
     ObjectEdit oe = new ObjectEdit(ui);
     oe.setRecord(record, 0);
     oe.recordSaved = recordSaved;
     oe.modal.showInElement(element);
  }


  /// Application Action Delete
  void onAppsActionDelete(String value, DRecord record, DEntry entry, var actionVar) {
    if (record != null) {
      _log.config("onAppsActionDelete ${tableName} ${value}");
      LIElement li = new LIElement()
        ..text = record.drv;
      UListElement ul = new UListElement()
        ..classes.add(LList.C_LIST__DOTTED)
        ..append(li);
      AppsAction deleteYes = AppsAction.createYes(onAppsActionDeleteConfirmed)
        ..actionVar = record;
      LConfirmation conf = new LConfirmation("tds", label: tableCtrlDelete1Record(),
        text:tableCtrlDelete1RecordText(), contentElements:[ul],
        actions:[deleteYes], addCancel: true);
      conf.showInElement(element);
    }
  } // onAppsActionDelete
  /// Application Action Delete Confirmed
  void onAppsActionDeleteConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (actionVar is DRecord && value == AppsAction.YES) {
      DRecord record = actionVar;
      _log.info("onAppsActionDeleteConfirmed ${tableName} ${value} id=${record.recordId}");
      if (recordDeleted != null) {
        recordDeleted(record)
        .then((SResponse response) {
          recordList.remove(record);
          if (alwaysOneEmptyLine && recordList.isEmpty)
            addNewRecord();
          display();
          _log.config("onAppsActionDeleteConfirmed ${tableName} ${value}  #${recordList.length}");
        });
      }
    }
  } // onAppsActionDeleteConfirmed


  /// Application Action Delete Selected Records
  void onAppsActionDeleteSelected(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionDeleteSelected ${tableName} ${value}");
    List<DRecord> records = selectedRecords;
    if (records == null || records.isEmpty) {
      LToast toast = new LToast(label: "No rows selected");
      toast.showBottomRight(element, autohideSeconds: 15);
    } else {
      UListElement ul = new UListElement()
        ..classes.add(LList.C_LIST__DOTTED);
      for (DRecord record in records) {
        LIElement li = new LIElement()
          ..text = record.drv;
        ul.append(li);
      }
      AppsAction deleteYes = AppsAction.createYes(onAppsActionDeleteSelectedConfirmed)
        ..actionVar = records;
      LConfirmation conf = new LConfirmation("tdm", label: tableCtrlDeleteRecords(),
        text:tableCtrlDeleteRecordsText(), contentElements:[ul],
        actions:[deleteYes], addCancel: true);
      conf.showInElement(element);
    }
  }
  /// Application Action Delete Selected Record Confirmed
  void onAppsActionDeleteSelectedConfirmed(String value, DRecord record, DEntry entry, var actionVar) {
    if (actionVar is List<DRecord> && value == AppsAction.YES) {
      List<DRecord> records = actionVar;
      _log.info("onAppsActionDeleteSelectedConfirmed ${tableName} ${value} #${records.length}");
      if (recordsDeleted != null) {
        recordsDeleted(records)
        .then((SResponse response) {
          for (DRecord sel in records) {
            recordList.remove(sel);
          }
          if (alwaysOneEmptyLine && recordList.isEmpty)
            addNewRecord();
          _log.config("onAppsActionDeleteSelectedConfirmed ${tableName} ${value} deleted=${records.length}  #${recordList.length}");
          display();
        });
      }
    }
  } // onAppsActionDeleteSelectedConfirmed




  /// Get UI
  UI get ui;

  /// Application Action Table Layout
  void onAppsActionTableLayout(String value, DRecord record, DEntry entry, var actionVar) {
    _log.config("onAppsActionTableLayout ${ui.tableName} ${value}");
    TableLayout layout = new TableLayout(ui, onAppsActionTableLayoutUpdated);
    layout.modal.showInComponent(this);
  }
  void onAppsActionTableLayoutUpdated() {
    _log.config("onAppsActionTableLayoutUpdated ${ui.tableName}");
    resetStructure();
    setUi(ui);
    // TODO save ui
    display();
  }

  /// move record up
  void onAppsActionTableUp(String value, DRecord record, DEntry entry, var actionVar) {
    int index = recordList.indexOf(record);
    if (index > 0) {
      DRecord thisRecord = recordList[index];
      DRecord previousRecord = recordList[index-1];
      recordList[index-1] = thisRecord;
      recordList[index] = previousRecord;
      //
      onAppsActionSequence();
      display();
    }
  }
  /// move record down
  void onAppsActionTableDown(String value, DRecord record, DEntry entry, var actionVar) {
    int index = recordList.indexOf(record);
    if (index >= 0 && index < recordList.length-1) {
      DRecord thisRecord = recordList[index];
      DRecord nextRecord = recordList[index + 1];
      recordList[index + 1] = thisRecord;
      recordList[index] = nextRecord;
      //
      onAppsActionSequence();
      display();
    }
  }
  /// notify subclass - could call resequence
  void onAppsActionSequence() {}

  /// re-sequence records based on [recordList] appearance
  void resequence({String columnName:"seqNo", int start:10, int increment:10}) {
    int seqNo = start;
    for (DRecord record in recordList) {
      DEntry entry = null;
      for (DEntry e in record.entryList) {
        if (e.columnName == columnName) {
          entry = e;
          break;
        }
      }
      if (entry == null) {
        entry = new DEntry()
          ..columnName = columnName
          ..value = seqNo.toString()
          ..isChanged = true;
        record.entryList.add(entry);
        record.isChanged = true;
      } else {
        String newValue = seqNo.toString();
        if (entry.hasValue()) {
          if (entry.value != newValue) {
            if (!entry.hasValueOriginal())
              entry.valueOriginal = entry.value;
            entry.value = newValue;
            entry.isChanged = true;
            record.isChanged = true;
          }
        } else if (entry.hasValueOriginal()) {
          if (entry.valueOriginal != newValue) {
            entry.value = newValue;
            entry.isChanged = true;
            record.isChanged = true;
          }
        } else {
          entry.valueOriginal = DataRecord.NULLVALUE;
          entry.value = newValue;
          entry.isChanged = true;
          record.isChanged = true;
        }
      }
      seqNo += increment;
    }
  } // resequence

  /// not correctly translated
  static String tableCtrlRecords(int count) => Intl.plural(count, zero: "no records", one: "${count} record", other: "${count} records", args:["count"], name: "tableCtrlRecords");

  // delete confirmation
  static String tableCtrlDelete1Record() => Intl.message("Delete current record", name: "tableCtrlDelete1Record");
  static String tableCtrlDeleteRecords() => Intl.message("Delete selected Records?", name: "tableCtrlDeleteRecords");
  static String tableCtrlDelete1RecordText() => Intl.message("Do you want to delete the current record?", name: "tableCtrlDelete1RecordText");
  static String tableCtrlDeleteRecordsText() => Intl.message("Do you want to delete the selected records?", name: "tableCtrlDeleteRecordsText");

} // TableCtrl



/**
 * Table Controller with fixed UI
 */
class TableCtrlUi extends TableCtrl {

  /// ui
  final UI ui;

  /**
   * Table Controller
   */
  TableCtrlUi(UI this.ui, {String idPrefix,
      bool optionCreateNew:true,
      bool optionRowSelect:true,
      RecordSorting recordSorting,
      bool optionLayout:true,
      bool optionEdit:true,
      String editMode: LTable.EDIT_FIELD,
      bool alwaysOneEmptyLine:false})
    : super(idPrefix:idPrefix,
        optionCreateNew:optionCreateNew, optionRowSelect:optionRowSelect, recordSorting:recordSorting,
        optionLayout:optionLayout, optionEdit:optionEdit,
        editMode:editMode, alwaysOneEmptyLine:alwaysOneEmptyLine);

} // TableCtrlUi
