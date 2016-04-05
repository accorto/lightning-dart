/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;


/**
 * Table Controller
 */
class TableCtrl
    extends LTable {

  static final Logger _log = new Logger("TableCtrl");


  final bool optionCreateNew;
  final bool optionLayout;
  final bool optionEdit;
  /// always one empty line
  final int alwaysEmptyLines;
  /// Callback when save e.g. [ObjectCtrl#onRecordSave]
  RecordSave recordSave;
  /// Callback when delete e.g. [ObjectCtrl#onRecordDelete]
  RecordDelete recordDelete;
  /// Callback when delete e.g. [ObjectCtrl#onRecordsDelete]
  RecordsDelete recordsDelete;

  /**
   * Object Table
   * - provide [appsActionNewCallback] to overwrite creating new row (inline)
   */
  TableCtrl(String idPrefix,
      {bool rowSelect:true,
      RecordSortList recordSorting,
      AppsActionTriggered recordAction, // record urv click
      UI tableUi,
      bool this.optionCreateNew:true,
      bool this.optionLayout:true,
      bool this.optionEdit:true,
      String editMode: LTable.EDIT_RO,
      int this.alwaysEmptyLines:0
      })
      : super(idPrefix,
          rowSelect:rowSelect,
          recordSorting:recordSorting,
          recordAction:recordAction) {
    this.editMode = editMode;
    //
    addActions();
    if (tableUi != null) {
      setUi(tableUi);
    } else {
      setUi(ui);
    }
    //
    infoText = "";
    infoSize = false;
    resetContent();
  } // ObjectTable

  /// Add Table/Row Actions
  void addActions() {
    // Table Actions
    if (optionCreateNew)
      addTableAction(AppsAction.createNew(onActionNew));
    if (rowSelect)
      addTableAction(AppsAction.createDeleteSelected(onActionDeleteSelected));
    if (optionLayout)
      addTableAction(AppsAction.createLayout(onActionTableLayout));

    // Row Actions
    addRowAction(AppsAction.createExclude(onActionRowExclude));
    if (optionEdit && editMode != LTable.EDIT_RO) {
      addRowAction(AppsAction.createEdit(onActionRowEdit));
      addRowAction(AppsAction.createReset(onActionRowReset));
    }
    if (editMode != LTable.EDIT_RO) {
      addRowAction(AppsAction.createDelete(onActionRowDelete));
    }
    addRowAction(AppsAction.createInfo(onActionRowInfo));
  } // addActions

  String get tableName => ui.tableName;

  /// Reset Content
  void resetContent() {
    recordList.clear();
    displayList.clear();
    display(true, true);
  }

  /// display after creating new records
  void display(bool calcStatistics, bool updatePager) {
    if (alwaysEmptyLines > 0) {
      int emptyLines = 0;
      for (DRecord record in displayList.reversed) {
        if (isRecordEmpty(record)) {
          emptyLines++;
          if (emptyLines == alwaysEmptyLines)
            break;
        }
      }
      for (int i = emptyLines; i < alwaysEmptyLines; i++) {
        DRecord record = createNewRecord();
        recordList.add(record);
        if (recordList != displayList)
          displayList.add(record);
      }
    }
    super.display(calcStatistics, updatePager);
  } // display

  /// is the record empty - see [createNewRecord]
  bool isRecordEmpty(DRecord record) {
    return record.entryList.isEmpty;
  }

    /// Application Action New
  void onActionNew(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionNew ${tableName} ${value}  #${recordList.length}");
    DRecord record = createNewRecord();
    recordList.add(record);
    if (recordList != displayList)
      displayList.add(record);
    if (editMode == LTable.EDIT_ALL || editMode == LTable.EDIT_SEL)
      addBodyRow(record: record);
    else { // display Form
      ObjectEdit oe = new ObjectEdit(ui);
      oe.setRecord(record, -1);
      oe.recordSave = recordSave;
      oe.modal.showInElement(element);
    }
  }

  /// create new Record - see [isRecordEmpty]
  DRecord createNewRecord() {
    DataRecord data = new DataRecord(ui.table, null);
    DRecord parentRecord = null;
    DRecord record = data.newRecord(parentRecord);
    return record;
  }

  /// Row Action Edit
  void onActionRowEdit(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionEdit ${tableName} ${value} ${data}");
     ObjectEdit oe = new ObjectEdit(ui);
     oe.setRecord(data.record, 0);
     oe.recordSave = recordSave;
     oe.modal.showInElement(element);
  }

  /// Row Action Info
  void onActionRowInfo(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionRowInfo ${tableName} ${value} ${data}");
    RecordInfo info = new RecordInfo(ui, data);
    info.modal.showInElement(element);
  }

  /// Row Action Delete
  void onActionRowDelete(String value, DataRecord data, DEntry entry, var actionVar) {
    if (data != null) {
      _log.config("onActionRowDelete ${tableName} ${value}");
      LIElement li = new LIElement()
        ..text = data.record.drv;
      if (!data.record.hasDrv() && !data.record.hasRecordId())
        li.text = tableCtrlNewRecord();
      UListElement ul = new UListElement()
        ..classes.add(LList.C_LIST__DOTTED)
        ..append(li);
      AppsAction deleteYes = AppsAction.createYes(onActionRowDeleteConfirmed)
        ..actionVar = data.record;
      LConfirmation conf = new LConfirmation("tds",
          title: tableCtrlDelete1Record(),
          text: tableCtrlDelete1RecordText(),
          contentElements:[ul],
          actions:[deleteYes],
          addCancel: true);
      conf.showInElement(element);
    }
  } // onAppsActionDelete
  /// Application Action Delete Confirmed
  void onActionRowDeleteConfirmed(String value, DataRecord data, DEntry entry, var actionVar) {
    if (actionVar is DRecord && value == AppsAction.YES) {
      DRecord record = actionVar;
      int index = recordList.indexOf(record);
      _log.info("onActionDeleteConfirmed ${tableName} ${value} id=${record.recordId} index=${index}");
      if (!record.hasRecordId()) {
        removeRecord(record); // displays
      } else if (recordDelete != null) {
        recordDelete(record)
        .then((SResponse response) {
          if (response.isSuccess) {
            removeRecord(record); // displays
            _log.config("onActionDeleteConfirmed ${tableName} #${recordList.length}");
          } else {
            _log.config("onActionDeleteConfirmed ${tableName} Error ${response.msg}");
          }
        });
      }
    }
  } // onAppsActionDeleteConfirmed


  /// Application Action Delete Selected Records
  void onActionDeleteSelected(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionDeleteSelected ${tableName} ${value}");
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
      AppsAction deleteYes = AppsAction.createYes(onActionDeleteSelectedConfirmed)
        ..actionVar = records;
      LConfirmation conf = new LConfirmation("tdm",
          title: tableCtrlDeleteRecords(),
          text: tableCtrlDeleteRecordsText(),
          contentElements:[ul],
          actions:[deleteYes],
          addCancel: true);
      conf.showInElement(element);
    }
  }
  /// Application Action Delete Selected Record Confirmed
  void onActionDeleteSelectedConfirmed(String value, DataRecord data, DEntry entry, var actionVar) {
    if (actionVar is List<DRecord> && value == AppsAction.YES) {
      List<DRecord> records = actionVar;
      _log.info("onActionDeleteSelectedConfirmed ${tableName} ${value} #${records.length}");
      if (recordsDelete != null) {
        recordsDelete(records)
        .then((SResponse response) {
          if (response.isSuccess) {
            removeRecords(records); // displays
            _log.config("onActionDeleteSelectedConfirmed ${tableName} deleted=${records.length}  #${recordList.length}");
            display(true, true); // Stat+Pager
          } else {
            // delete error
            _log.warning("onActionDeleteSelectedConfirmed ${tableName} NotFound ${response.msg}");
          }
        });
      }
    }
  } // onActionDeleteSelectedConfirmed



  /// Application Action Table Layout
  void onActionTableLayout(String value, DataRecord data, DEntry entry, var actionVar) {
    _log.config("onActionTableLayout ${ui.tableName} ${value}");
    TableLayout layout = new TableLayout(ui, onActionTableLayoutUpdated);
    layout.modal.showInComponent(this);
  }
  void onActionTableLayoutUpdated() {
    _log.config("onActionTableLayoutUpdated ${ui.tableName}");
    resetStructure();
    setUi(ui);
    // TODO save ui
    display(true, true); // Stat+Pager
  }

  /// move record up
  void onActionRowUp(String value, DataRecord data, DEntry entry, var actionVar) {
    int index = recordList.indexOf(data.record);
    if (index > 0) {
      DRecord thisRecord = recordList[index];
      DRecord previousRecord = recordList[index-1];
      recordList[index-1] = thisRecord;
      recordList[index] = previousRecord;
      //
      onActionSequence();
      display(false, true); // noStat, Pager
    }
  }
  /// move record down
  void onActionRowDown(String value, DataRecord data, DEntry entry, var actionVar) {
    int index = recordList.indexOf(data.record);
    if (index >= 0 && index < recordList.length-1) {
      DRecord thisRecord = recordList[index];
      DRecord nextRecord = recordList[index + 1];
      recordList[index + 1] = thisRecord;
      recordList[index] = nextRecord;
      //
      onActionSequence();
      display(false, true); // noStat, Pager
    }
  }
  /// notify subclass - could call resequence
  void onActionSequence() {}

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

  String toString() {
    return "TableCtrl@${tableName}[records=${recordList.length} display=${displayList == null ? "-" : displayList.length}]";
  }


  /// not correctly translated
  static String tableCtrlRecords(int count) => Intl.plural(count, zero: "no records", one: "${count} record", other: "${count} records", args:["count"], name: "tableCtrlRecords");

  static String tableCtrlNewRecord() => Intl.message("new", name: "tableCtrlNewRecord");

  // delete confirmation
  static String tableCtrlDelete1Record() => Intl.message("Delete current record", name: "tableCtrlDelete1Record");
  static String tableCtrlDeleteRecords() => Intl.message("Delete selected Records?", name: "tableCtrlDeleteRecords");
  static String tableCtrlDelete1RecordText() => Intl.message("Do you want to delete the current record?", name: "tableCtrlDelete1RecordText");
  static String tableCtrlDeleteRecordsText() => Intl.message("Do you want to delete the selected records?", name: "tableCtrlDeleteRecordsText");

} // TableCtrl
