/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 *
 */
class RecordInfo {

  static const String _ID = "info";

  /// Modal
  LModal modal = new LModal(_ID);

  /// Base UI
  final UI ui;
  DataRecord data;

  LTextArea _logic = new LTextArea("logic", idPrefix: _ID);
  LBox _result = new LBox()
    ..classes.addAll([LMargin.C_TOP__X_SMALL]);

  TableElement _table = new TableElement()
    ..id = "info-table"
    ..classes.addAll([LTable.C_TABLE]);

  /**
   * Record Info
   */
  RecordInfo(UI this.ui, DataRecord this.data) {
    DRecord record = data.record;
    // Header
    if (record.hasDrv())
      modal.setHeader("${recordInfoLabel()} ${ui.table.label}: ${record.drv}");
    else
      modal.setHeader("${recordInfoLabel()} ${ui.table.label}");
    //

    DListUtil dl = new DListUtil.horizontal();
    modal.append(dl.element);

    if (record.hasDrv())
      dl.add("Display Record Value", record.drv);
    if (record.hasWho())
      dl.add("Who", record.who);
    if (record.hasEtag())
      dl.add("ETag", record.etag);
    if (record.hasRevision())
      dl.add("Revision", record.revision);

    dl.add("Id", "${record.tableName} ${record.tableId}");
    if (record.hasQuery())
      dl.add("Query", record.query);
    if (record.hasUrv())
      dl.add("Unique Record Value", record.urv);
    if (record.hasUrvRest())
      dl.add("URV (Rest)", record.urvRest);

    String flags = record.isReadOnly ? "ReadOnly" : "ReadWrite";
    if (record.hasIsReadOnlyCalc())
      flags += record.isReadOnlyCalc ? " (CalcRO)" : " (NotCalcRO)";
    if (record.hasIsMandatoryCalc())
      flags += record.isMandatoryCalc ? " [MandatoryCalc]" : " [NotMandatoryCalc]";
    dl.add("Access", flags);

    flags = record.isChanged ? "Changed" : "NotChanged";
    if (record.hasIsSelected())
      flags += record.isSelected ? ", Selected" : ", NotSelected";
    if (record.hasIsGroupBy())
      flags += record.isGroupBy ? ", GroupBy" : "NotGroupBy";
    if (record.hasIsMatchFind())
      flags += record.isMatchFind ? ", MatchFind" : ", NotMatchFind";
    dl.add("Flags", flags);

    if (record.hasParent()) {
      dl.add("Parent", record.parent.drv);
      dl.add("Parent Id", "${record.parent.tableName} ${record.parent.recordId}");
    }

    _logic
      ..label = "Test Logic expression (case sensitive)"
      ..help = "e.g. record.Name == 'a'"
      ..rows = 1;
    _logic.element.classes.add(LMargin.C_TOP__MEDIUM);

    LButton btnBool = new LButton.neutral("evalBool", "Evaluate Boolean", idPrefix: _ID);
    btnBool.onClick.listen((Event evt) {
      _result.show = true;
      try {
        Object result = DataContext.evaluateBoolEx(data, _logic.value);
        if (result is bool) {
          _result.text = "Result: ${result}";
        } else {
          _result.text = "Result: ${"true" == result} - ${result}";
        }
      } catch (e) {
        _result.text = "Error: ${e}";
      }
    });

    LButton btnRepl = new LButton.neutral("evalRepl", "Evaluate Replace", idPrefix: _ID);
    btnRepl.onClick.listen((Event evt) {
      _result.show = true;
      Object result = DataContext.contextReplace(data, _logic.value);
      _result.text = "Replace: '${result}'";
    });
    _result.show = false;

    modal.append(_logic.element);
    modal.add(btnBool);
    modal.add(btnRepl);
    modal.add(_result);
    DivElement wrapper = new DivElement()
      ..classes.addAll([LScrollable.C_SCROLLABLE__Y, LMargin.C_TOP__MEDIUM])
      ..style.maxHeight = "200px"
      ..append(_table);
    modal.append(wrapper);

    AppsAction showDetails = new AppsAction("detail", "Show Details", onActionShowDetails);
    modal.addFooterActions([showDetails], addCancel: true, hideOnAction: false);
  } // RecordInfo

  /// show details
  void onActionShowDetails(String value, DataRecord d, DEntry entry, var actionVar) {
    _table.children.clear();

    for (DEntry entry in data.record.entryList) {
      TableRowElement tr = _table.addRow();
      tr.addCell().text = entry.columnName;
      tr.addCell().text = DataRecord.getEntryValue(entry);
      tr.addCell().text = entry.valueDisplay;
    }
  } // onActionShowDetails




  static String recordInfoLabel() => Intl.message("Info", name: "recordInfoLabel");

} // RecordInfo
