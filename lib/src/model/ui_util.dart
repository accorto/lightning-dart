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

  static final Logger _log = new Logger("UiUtil");

  /**
   * Validate UI structure
   */
  static void validate(final UI ui) {
    // grid columns in need of panel column
    Map<String, UIGridColumn> gcMap = new Map<String, UIGridColumn>();

    // Grid Columns
    for (UIGridColumn gc in ui.gridColumnList) {
      if (!gc.hasColumn()) {
        DColumn column = DataUtil.findColumn(ui.table, gc.columnId, gc.columnName);
        if (column != null) {
          gc.column = column;
          if (!gc.hasColumnId())
            gc.columnId = column.columnId;
          if (!gc.hasColumnName())
            gc.columnName = column.name;
        }
      }
      if (!gc.hasPanelColumn()) {
        gcMap[gc.columnName] = gc;
      }
    } // gc

    // Query Columns
    for (UIQueryColumn qc in ui.queryColumnList) {
      if (!qc.hasColumn()) {
        DColumn column = DataUtil.findColumn(ui.table, qc.columnId, qc.columnName);
        if (column != null) {
          qc.column = column;
          if (!qc.hasColumnId())
            qc.columnId = column.columnId;
          if (!qc.hasColumnName())
            qc.columnName = column.name;
        }
      }
    } // qc

    // Panel
    for (UIPanel panel in ui.panelList) {
      for (UIPanelColumn pc in panel.panelColumnList) {
        if (!pc.hasColumn()) {
          DColumn column = DataUtil.findColumn(ui.table, pc.columnId, pc.columnName);
          if (column != null) {
            pc.column = column;
            if (!pc.hasColumnId())
              pc.columnId = column.columnId;
            if (!pc.hasColumnName())
              pc.columnName = column.name;
          }
        }
        UIGridColumn gc = gcMap[pc.columnName];
        if (gc != null)
          gc.panelColumn = pc;
      } // pc
    } // panel
  } // validate


  /**
   * Copy UI (table the same)
   */
  static UiUtil clone(UI original, {String label, String name}) {
    UI ui = original.clone();
    //
    if (label != null && label.isNotEmpty)
      ui.label = label;
    if (name != null && name.isNotEmpty)
      ui.name = name;
    //
    return new UiUtil(ui);
  } // copy


  /// Find Grid Column in UI
  static UIGridColumn findGridColumn(UI ui, String columnName) {
    for (UIGridColumn gc in ui.gridColumnList) {
      if (gc.columnName == columnName) {
        return gc;
      }
    }
    return null;
  }
  /// Find Panel Column in UI
  static UIPanelColumn findPanelColumn(UI ui, String columnName, UIGridColumn gc) {
    if (gc != null && gc.panelColumn != null) {
      return gc.panelColumn;
    }
    for (UIPanel panel in ui.panelList) {
      for (UIPanelColumn pc in panel.panelColumnList) {
        if (pc.columnName == columnName) {
          return pc;
        }
      }
    }
    return null;
  } // findPanelColumn


  /// The UI
  final UI ui;
  /// The Table
  DTable get table => ui.table;

  /// current panel
  UIPanel _panel;
  /// original Panels
  List<UIPanelColumn> _origPanelColumns;

  /**
   * UI Construction Utility
   */
  UiUtil(UI this.ui) {
  }

  /**
   * Reset panels + grid columns and save to original
   */
  void resetUi() {
    _origPanelColumns = new List<UIPanelColumn>();
    for (UIPanel panel in ui.panelList) {
      for (UIPanelColumn pc in panel.panelColumnList) {
        _origPanelColumns.add(pc);
      }
    }
    ui.panelList.clear();
    ui.gridColumnList.clear();
    ui.queryColumnList.clear();
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
  UIPanel addPanel({String name:"Default", int columnCount:0}) {
    _panel = new UIPanel()
      ..name = name
      ..panelColumnNumber = columnCount;
    ui.panelList.add(_panel);
    return _panel;
  }

  /// Add (default) Panel if missing
  void addPanelIfMissing({String name:"Default", int columnCount:0}) {
    if (_panel != null) {
      return;
    }
    if (ui.panelList.isNotEmpty) {
      _panel = ui.panelList[0];
      return;
    }
    addPanel(name:name, columnCount:columnCount);
  }

  /**
   * Add Data Column to Table
   */
  DColumn addDColumn(String name, String label, DataType dataType) {
    DColumn col = new DColumn()
      ..name = name
      ..label = label
      ..dataType = dataType;
    table.columnList.add(col);
    return col;
  }

  /// add existing column to UI
  void addColumn(DColumn col,
      {String displayLogic,
      bool mandatory,
      bool readOnly,
      bool isAlternativeDisplay,
      int width,
      bool addColToTable:true}) {
    if (addColToTable)
      ui.table.columnList.add(col);
    if (_panel == null)
      addPanel();

    // panel column
    UIPanelColumn pc = _createPanelColumn(col);
    if (displayLogic != null && displayLogic.isNotEmpty)
      pc.displayLogic = displayLogic;
    if (readOnly != null)
      pc.isReadOnly = readOnly;
    if (mandatory != null)
      pc.isMandatory = mandatory;
    if (isAlternativeDisplay != null)
      pc.isAlternativeDisplay = isAlternativeDisplay;
    if (width != null)
      pc.width = width;
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

  /// create/clone panel column
  UIPanelColumn _createPanelColumn(DColumn col) {
    UIPanelColumn pc = null;
    String colName = col.name;
    if (_origPanelColumns != null) {
      for (UIPanelColumn pp in _origPanelColumns) {
        if (pp.columnName == colName) {
          pc = pp.clone();
          break;
        }
      }
    }

    if (pc == null)
      pc = new UIPanelColumn();
    pc.column = col;
    pc.columnName = colName;
    if (col.hasColumnId())
      pc.columnId = col.columnId;
    return pc;
  } // getPanelColumn


  /// add grid/panel column if missing
  void addIfMissing(String columnName,
      {bool mandatory,
      bool readOnly,
      bool isAlternativeDisplay,
      int width}) {

    // exists in grid with pc/gc
    UIGridColumn gc = findGridColumn(ui, columnName);
    UIPanelColumn pc = findPanelColumn(ui, columnName, gc);
    if (pc != null) {
      if (mandatory != null)
        pc.isMandatory = mandatory;
      if (isAlternativeDisplay != null)
        pc.isAlternativeDisplay = isAlternativeDisplay;
      if (width != null)
        pc.width = width;
      if (readOnly != null)
        pc.isReadOnly = readOnly;
      return; // found it
    }

    // find column + create
    for (DColumn col in ui.table.columnList) {
      if (col.name == columnName) {
        addColumn(col,
            mandatory: mandatory,
            isAlternativeDisplay: isAlternativeDisplay,
            width: width,
            readOnly: readOnly,
            addColToTable: false);
        return;
      }
    }
    _log.warning("${ui.name} addIfMissing NotFound ${columnName}");
  } // addIfMissing

  /// Add Query Column
  void addQueryColumn(String columnName) {
    DColumn column = null;
    for (DColumn col in ui.table.columnList) {
      if (col.name == columnName) {
        column = col;
        break;
      }
    }
    if (column != null) {
      UIQueryColumn qc = new UIQueryColumn()
        ..column = column
        ..columnName = columnName
        ..columnLabel = column.label;
      if (column.hasColumnId())
        qc.columnId = column.columnId;
      ui.queryColumnList.add(qc);
    }
  } // addQueryColumn

  /// get Column or null
  DColumn getColumn(String columnName) {
    if (table != null) {
      for (DColumn col in table.columnList) {
        if (col.name == columnName)
          return col;
      }
    }
    return null;
  }

} // UiUtil
