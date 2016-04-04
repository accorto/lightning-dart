/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * Data Column - encapsulates DTable/DColumn and optional UIPanelColumn/UIGridColumn
 */
class DataColumn {

  static final Logger _log = new Logger("DataColumn");

  /// create data column from editor
  static DataColumn fromEditor (EditorI editor, String label, String help) {
    DColumn tableColumn = new DColumn()
      ..name = editor.name
      ..label = label == null ? editor.name : label
      ..isMandatory = editor.required
      ..isReadOnly = editor.readOnly
      ..columnSize = editor.maxlength;
    if (help != null)
      tableColumn.help = help;
    tableColumn.dataType = DataTypeUtil.getDataTypeFromEditorType(editor.type);

    return new DataColumn(null, tableColumn, null, null); // no table, panel/grid column
  } // fromEditor

  /// create data column from ui with optional pre-populated values
  static DataColumn fromUi (UI ui, String columnName, {String columnId,
      DColumn tableColumn, UIPanelColumn panelColumn, UIGridColumn gridColumn}) {
    if (columnName != null && columnName.isEmpty)
      columnName = null; // for compare
    if (columnId != null && columnId.isEmpty)
      columnId = null;
    // Column
    DColumn column = tableColumn;
    if (column == null || !column.hasName()) {
      column = DataUtil.findColumn(ui.table, columnId, columnName);
    }
    // Panel Column
    UIPanelColumn pc = panelColumn;
    if (pc == null) {
      for (UIPanel panel in ui.panelList) {
        for (UIPanelColumn pp in panel.panelColumnList) {
          if (pp.columnId == columnId || pp.columnName == columnName) {
            pc = pp;
            break;
          }
        }
        // panel columns
        if (pc != null)
          break;
      }
    }
    if (pc != null && !pc.hasColumn()) {
      pc.column = column;
    }
    // Grid Column
    UIGridColumn gc = gridColumn;
    if (gc == null) {
      for (UIGridColumn pp in ui.gridColumnList) {
        if (pp.columnId == columnId || pp.columnName == columnName) {
          gc = pp;
          break;
        }
      }
    }
    if (gc != null) {
      if (!gc.hasColumn())
        gc.column = column;
      if (pc != null && !gc.hasPanelColumn())
        gc.panelColumn = pc;
    }
    return new DataColumn(ui.table, column, pc, gc);
  } // fromUi


  /// Table of column
  final DTable table;
  /// The Column
  final DColumn tableColumn;
  /// optional panel column
  final UIPanelColumn uiPanelColumn;
  /// optional grid column
  final UIGridColumn uiGridColumn;
  /// Statistics
  StatCalc statCol;

  /**
   * Data Column Info with optional [table], [uiPanelColumn] and [uiGridColumn]
   */
  DataColumn(DTable this.table, DColumn this.tableColumn,
      UIPanelColumn this.uiPanelColumn, UIGridColumn this.uiGridColumn) {
    assert (tableColumn != null);
  }

  /// Column Name
  String get name => tableColumn.name;

  /// Label - Panel-Column-Name
  String get label {
    if (uiPanelColumn != null && uiPanelColumn.hasLabel())
      return uiPanelColumn.label;
    if (tableColumn.hasLabel()) {
      return tableColumn.label;
    }
    return tableColumn.name; // fallback
  }
  /// Label for Grid
  String get labelGrid {
    if (uiGridColumn != null && uiGridColumn.hasLabel()) {
      return uiGridColumn.label;
    }
    return label;
  }


  /// Title (description - help - label)
  String get title {
    if (tableColumn.hasDescription())
      return tableColumn.description;
    if (tableColumn.hasHelp())
      return tableColumn.help;
    return label;
  }

  /// Active in Grid
  bool get isActiveGrid {
    if (tableColumn.hasIsActive() && !tableColumn.isActive)
      return false;
    if (uiGridColumn != null && uiGridColumn.hasIsActive())
      return uiGridColumn.isActive;
    return true;
  }

  /// Active in Panel
  bool get isActivePanel {
    if (tableColumn.hasIsActive() && !tableColumn.isActive)
      return false;
    if (uiPanelColumn!= null && uiPanelColumn.hasIsActive())
      return uiPanelColumn.isActive;
    return true;
  }

  /**
   * Read Only [data] optional context
   */
  bool isReadOnly(DataRecord data) {
    // new, required and empty - allow entry
    if (data.isNew && isEmpty(data) && isMandatory(data)) {
      return false;
    }
    if (uiPanelColumn != null && uiPanelColumn.hasIsReadOnly()) {
      if (uiPanelColumn.isReadOnly) // ui overwrites
        return true;
    } else if (tableColumn.isReadOnly) { // default false
      return true;
    }
    if (data != null) {
      if (data.isReadOnly) {
        return true; // record level
      }
      if (isReadOnlyDynamic()) {
        if (data.table == null)
          data.table = table;
        DEntry entry = null;
        if (!data.changed) {
          entry = getEntry(data);
          if (entry != null && entry.hasIsReadOnlyCalc()) {
            return entry.isReadOnlyCalc;
          }
        }
        bool result = DataContext.evaluateBool(data, uiPanelColumn.readOnlyLogic, errorValue: null);
        if (entry != null && result != null)
          entry.isReadOnlyCalc = result;
        _log.fine("isReadOnly ${tableColumn.name} ${result} - ${uiPanelColumn.readOnlyLogic}");
        return result == null ? true : result;
      }
    }
    return false;
  } // isReadOnly

  /// is ReadOnly dynamic ?
  bool isReadOnlyDynamic() {
    return uiPanelColumn != null && uiPanelColumn.hasReadOnlyLogic() && uiPanelColumn.readOnlyLogic.isNotEmpty;
  }

  /// is the value empty
  bool isEmpty(DataRecord data) {
    DEntry entry = getEntry(data);
    String value = DataRecord.getEntryValue(entry);
    return value == null || value.isEmpty;
  }

  /**
   * Mandatory [data] optional context
   */
  bool isMandatory(DataRecord data) {
    if (uiPanelColumn != null && uiPanelColumn.hasIsMandatory()) {
      if (uiPanelColumn.isMandatory) // ui overwrites
        return true;
    } else if (tableColumn.isMandatory) { // default false
      return true;
    }
    if (data != null) {
      if (isMandatoryDynamic()) {
        if (data.table == null)
          data.table = table;
        DEntry entry = null;
        if (!data.changed) {
          entry = getEntry(data);
          if (entry != null && entry.hasIsMandatoryCalc()) {
            return entry.isMandatoryCalc;
          }
        }
        bool result = DataContext.evaluateBool(data, uiPanelColumn.mandatoryLogic, errorValue: null);
        if (entry != null && result != null)
          entry.isMandatoryCalc = result;
        _log.warning("isMandatory ${tableColumn.name} ${result} - ${uiPanelColumn.mandatoryLogic}");
        return result == null ? true : result; // mandatory when error
      }
    }
    return false;
  } // isMandatory

  /// is Mandatory dynamic ?
  bool isMandatoryDynamic() {
    return uiPanelColumn != null && uiPanelColumn.hasMandatoryLogic() && uiPanelColumn.mandatoryLogic.isNotEmpty;
  }

  /**
   * Displayed [data] optional context
   */
  bool isDisplayed(DataRecord data) {
    // inactive
    if (uiPanelColumn != null && uiPanelColumn.hasIsActive()) {
      if (!uiPanelColumn.isActive) // ui overwrites - default true
        return false;
    } else if (tableColumn.hasIsActive() && !tableColumn.isActive) { // default true
      return false;
    }

    if (data != null) {
      if (isDisplayedDynamic()) {
        if (data.table == null)
          data.table = table;
        DEntry entry = null;
        if (!data.changed) {
          entry = getEntry(data);
          if (entry != null && entry.hasIsDisplayCalc()) {
            return entry.isDisplayCalc;
          }
        }
        bool result = DataContext.evaluateBool(data, uiPanelColumn.displayLogic, errorValue: null);
        if (entry != null && result != null)
          entry.isDisplayCalc = result;
        // _log.warning("isDisplayed ${tableColumn.name} ${result} - ${uiPanelColumn.displayLogic}");
        return result == null ? true : result; // display when error
      }
    }
    return true;
  } // isDisplayed


  /// is Display dynamic ?
  bool isDisplayedDynamic() {
    return uiPanelColumn != null && uiPanelColumn.hasDisplayLogic() && uiPanelColumn.displayLogic.isNotEmpty;
  }

  /// get table column for anothe column
  DColumn getTableColumn(String columnName) {
    for (DColumn col in table.columnList) {
      if (col.name == columnName)
        return col;
    }
    return null;
  }

  /// rendered in an Element
  bool get isValueRenderElement {
    DataType dataType = tableColumn.dataType;
    return dataType == DataType.BOOLEAN
        || dataType == DataType.IMAGE
        || dataType == DataType.COLOR;
  }

  /// rendered in an Element
  bool get isValueRender {
    DataType dataType = tableColumn.dataType;
    return DataTypeUtil.isDisplayRendered(dataType);
  }

  /// tableName.columnName
  String toString() {
    if (tableColumn == null)
      return "DataColumn[-]";
    if (table == null)
      return "DataColumn[${tableColumn.name}]";
    return "DataColumn[${table.name}.${tableColumn.name}]";
  }

  /// Get Data Entry for this Column if exists
  DEntry getEntry(DataRecord data) => data.getEntry(tableColumn.columnId, tableColumn.name, false);
  /// Get Data Entry Statistics for this Column if exists
  DStatistics getStatistics(DataRecord data) => data.getStatistics(tableColumn.columnId, tableColumn.name);


} // DataColumn
