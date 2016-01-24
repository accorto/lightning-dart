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
    DColumn column = tableColumn;
    if (column == null) {
      column = DataUtil.findColumn(ui.table, columnId, columnName);
    }
    //
    UIPanelColumn pc = panelColumn;
    if (pc == null) {
      for (UIPanel panel in ui.panelList) {
        for (UIPanelColumn pp in panel.panelColumnList) {
          if (pp.columnName == columnName) {
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
    //
    UIGridColumn gc = gridColumn;
    if (gc == null) {
      for (UIGridColumn pp in ui.gridColumnList) {
        if (pp.columnName == columnName) {
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

  /**
   * Data Column Info with optional [table], [panelColumn] and [uiGridColumn]
   */
  DataColumn(DTable this.table, DColumn this.tableColumn,
      UIPanelColumn this.uiPanelColumn, UIGridColumn this.uiGridColumn) {
    assert (tableColumn != null);
  }

  /// Label
  String get label {
    // String overwrite = labelOverwrite;
    // if (overwrite != null)
    //   return overwrite;
    return tableColumn.label;
  }
  // Label overwrite or null
  String get labelOverwrite {
    if (uiPanelColumn != null && uiPanelColumn.hasLabel() && uiPanelColumn.label.isNotEmpty)
      return uiPanelColumn.label;
    return null;
  }

  /// Column Name
  String get name => tableColumn.name;


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
    if (tableColumn.isReadOnly
        || (uiPanelColumn != null && uiPanelColumn.isReadOnly)) {
      return true;
    }
    if (data != null) {
      data.table = table;
      if (data.isReadOnly) {
        return true; // record level
      }
      if (isReadOnlyDynamic()) {
        bool result = DataContext.evaluateBool(data.record, table, uiPanelColumn.readOnlyLogic);
        _log.warning("isReadOnly ${tableColumn.name} ${result} - ${uiPanelColumn.readOnlyLogic}");
        return result;
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
    if (tableColumn.isMandatory || (uiPanelColumn != null && uiPanelColumn.isMandatory))
      return true;
    if (data != null) {
      if (isMandatoryDynamic()) {
        bool result = DataContext.evaluateBool(data.record, table, uiPanelColumn.mandatoryLogic);
        _log.warning("isMandatory ${tableColumn.name} ${result} - ${uiPanelColumn.mandatoryLogic}");
        return result;
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
    if ((tableColumn.hasIsActive() && !tableColumn.isActive)
    || (uiPanelColumn != null && uiPanelColumn.hasIsActive() && !uiPanelColumn.isActive))
      return false;
    if (data != null) {
      if (isDisplayedDynamic()) {
        bool result = DataContext.evaluateBool(data.record, table, uiPanelColumn.displayLogic);
        // _log.warning("isDisplayed ${tableColumn.name} ${result} - ${uiPanelColumn.displayLogic}");
        return result;
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
