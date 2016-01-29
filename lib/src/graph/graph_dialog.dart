/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Dialog
 */
class GraphDialog {

  static final Logger _log = new Logger("GraphDialog");

  static const String _NAME_BY = "by";
  static const String _NAME_WHAT = "what";
  static const String _NAME_PERIOD = "period";

  LModal _modal;
  GraphPanel _graphPanel;

  final Element parent;
  final Datasource datasource;
  DTable get table => datasource.ui.table;
  List<DRecord> get records => datasource.recordList;

  LPicklist _whatPickList;
  LPicklist _byPickList;
  LPicklist _byPeriodPickList;
  List<String> _dateColumns = new List<String>();

  /**
   * Graph Dialog for [table]
   */
  GraphDialog(Element this.parent, Datasource this.datasource) {
  } // GraphDialog

  void _init() {
    String id = LComponent.createId("gd", table.name);
    _modal = new LModal(id);
    _modal.setHeader("${graphDialogTitle()}: ${table.label}",
        icon: new LIconUtility(LIconUtility.CHART));

    LForm form = new LForm.inline("f", idPrefix: id);
    form.formRecordChange = onFormRecordChange;
    _modal.add(form);

    _whatPickList = new LPicklist(_NAME_WHAT, idPrefix: id)
      ..label = graphDialogWhat()
      ..small = true;
    form.addEditor(_whatPickList);
    _whatPickList.addDOption(new DOption()
      ..value = GraphCalc.COLUMN_COUNT
      ..label = graphDialogCount());
    _whatPickList.value = GraphCalc.COLUMN_COUNT;

    _byPickList = new LPicklist(_NAME_BY, idPrefix: id)
      ..label = graphDialogBy()
      ..small = true;
    form.addEditor(_byPickList);

    _byPeriodPickList = new LPicklist(_NAME_PERIOD, idPrefix: id)
      ..title = graphDialogByPeriod()
      ..small = true;
    form.addEditor(_byPeriodPickList);
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Day.toString()
      ..label = LightningGraph.graphByDay());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Week.toString()
      ..label = LightningGraph.graphByWeek());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Month.toString()
      ..label = LightningGraph.graphByMonth());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Quarter.toString()
      ..label = LightningGraph.graphByQuarter());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Year.toString()
      ..label = LightningGraph.graphByYear());
    _byPeriodPickList.value = ByPeriod.Week.toString();
    _byPeriodPickList.show = false;

    // fill options
    for (DColumn col in table.columnList) {
      DOption colOption = new DOption()
        ..value = col.name
        ..label = col.label;

      DataType dt = col.dataType;
      if (DataTypeUtil.isNumber(dt)) {
        _whatPickList.addDOption(colOption);
      } else if (DataTypeUtil.isPick(dt) || DataTypeUtil.isFk(dt)) {
        _byPickList.addDOption(colOption);
      } else if (DataTypeUtil.isDate(dt)) {
        _byPickList.addDOption(colOption);
        _dateColumns.add(col.name);
      }
    }

    _graphPanel = new GraphPanel(id, table.name, table.label);
    _modal.add(_graphPanel);
  } // init

  /// Init and show dialog
  void onGraphClick(MouseEvent evt) {
    _log.config("onGraphClick");
    if (_modal == null) {
      _init();
    }
    _modal.showInElement(parent);
  }

  /// Selection
  void onFormRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    String what = _whatPickList.value;
    String by = _byPickList.value;
    String period = _byPeriodPickList.value;
    _byPeriodPickList.show = _dateColumns.contains(by);
    _log.config("onFormRecordChange what=${what} by=${by} ${period}");

    // by
    DColumn byColumn = DataUtil.findColumn(table, null, by);
    if (byColumn == null) {
      _log.info("onFormRecordChange NotFound column=${by}");
      return;
    }
    Map<String,String> keyLabelMap = new Map<String,String>();
    for (DOption option in byColumn.pickValueList) {
      keyLabelMap[option.value] = option.label;
    }
    _graphPanel.by(byColumn.name, byColumn.label, keyLabelMap);
    String dateColumnName = null;
    if (_dateColumns.contains(by)) {
      dateColumnName = by;
      _graphPanel.byPeriod(LightningGraph.findPeriod(period));
    }

    // what
    if (what == GraphCalc.COLUMN_COUNT) {
      _graphPanel.calc(what, graphDialogWhat(), dateColumnName);
    } else {
      DColumn whatColumn = DataUtil.findColumn(table, null, what);
      if (whatColumn == null) {
        _log.info("onFormRecordChange NotFound column=${what}");
        return;
      }
      _graphPanel.calc(whatColumn.name, whatColumn.label, dateColumnName);
    }
    //
    _graphPanel.calculate(records);
    _graphPanel.display();
  } // onFormRecordChange



  static String graphDialogTitle() => Intl.message("Graph", name: "graphDialogTitle");
  static String graphDialogWhat() => Intl.message("Display", name: "graphDialogWhat");
  static String graphDialogBy() => Intl.message("Group by", name: "graphDialogBy");
  static String graphDialogByPeriod() => Intl.message("Group by Period", name: "graphDialogByPeriod");
  static String graphDialogCount() => Intl.message("Count", name: "graphDialogCount");

} // GraphDialog
