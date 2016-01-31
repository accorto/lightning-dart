/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Element
 * with Form and Panel
 */
class GraphElement {

  static const String _NAME_BY = "by";
  static const String _NAME_WHAT = "what";
  static const String _NAME_PERIOD = "period";

  static final Logger _log = new Logger("GraphElement");

  Element element = new Element.section();

  final Datasource datasource;
  DTable get table => datasource.ui.table;
  List<DRecord> get records => datasource.recordList;

  LPicklist _whatPickList;
  LPicklist _byPickList;
  LPicklist _byPeriodPickList;
  List<String> _dateColumns = new List<String>();
  GraphPanel _graphPanel;

  /**
   * Graph Element - call [init] explicitly
   */
  GraphElement(Datasource this.datasource) {
  } // GraphElement

  /// Initialize Element
  void init() {
    element
      ..id = LComponent.createId("ge", table.name)
      ..style.minHeight = "300px";

    LForm form = _initForm(element.id);
    element.append(form.element);

    _graphPanel = new GraphPanel(element.id, table.name);
    element.append(_graphPanel.element);
  }

  /**
   * Initialize Form
   */
  LForm _initForm(String id) {
    LForm form = new LForm.inline("f", idPrefix: id);
    form.formRecordChange = onFormRecordChange;

    _whatPickList = new LPicklist(_NAME_WHAT, idPrefix: id)
      ..label = graphElementWhat()
      ..small = true;
    form.addEditor(_whatPickList);
    _whatPickList.addDOption(new DOption()
      ..value = StatCalc.COLUMN_COUNT
      ..label = graphElementCount());
    _whatPickList.value = StatCalc.COLUMN_COUNT;

    _byPickList = new LPicklist(_NAME_BY, idPrefix: id)
      ..label = graphElementBy()
      ..small = true;
    form.addEditor(_byPickList);

    _byPeriodPickList = new LPicklist(_NAME_PERIOD, idPrefix: id)
      ..title = graphElementByPeriod()
      ..small = true;
    form.addEditor(_byPeriodPickList);
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Day.toString()
      ..label = StatPoint.statByPeriodDay());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Week.toString()
      ..label = StatPoint.statByPeriodWeek());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Month.toString()
      ..label = StatPoint.statByPeriodMonth());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Quarter.toString()
      ..label = StatPoint.statByPeriodQuarter());
    _byPeriodPickList.addDOption(new DOption()
      ..value = ByPeriod.Year.toString()
      ..label = StatPoint.statByPeriodYear());
    _byPeriodPickList.value = ByPeriod.Week.toString();
    _byPeriodPickList.show = false;

    // fill options
    List<DOption> whatList = new List<DOption>();
    List<DOption> byList = new List<DOption>();
    for (DColumn col in table.columnList) {
      DOption colOption = new DOption()
        ..value = col.name
        ..label = col.label;
      DataType dt = col.dataType;
      if (DataTypeUtil.isNumber(dt)) {
        whatList.add(colOption);
      } else if (DataTypeUtil.isPick(dt) || DataTypeUtil.isFk(dt)) {
        byList.add(colOption);
      } else if (DataTypeUtil.isDate(dt)) {
        byList.add(colOption);
        _dateColumns.add(col.name);
      }
    }
    whatList.sort(OptionUtil.compareLabel);
    for (DOption colOption in whatList)
      _whatPickList.addDOption(colOption);
    byList.sort(OptionUtil.compareLabel);
    for (DOption colOption in byList)
      _byPickList.addDOption(colOption);

    return form;
  } // init

  /// Selection
  void onFormRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    String what = _whatPickList.value;
    String by = _byPickList.value;
    String period = _byPeriodPickList.value;
    _byPeriodPickList.show = _dateColumns.contains(by);
    _log.config("onFormRecordChange what=${what} by=${by} ${period}");
    _graphPanel.reset();

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
    // TODO
    DColumn dateColumn = null;
    if (_dateColumns.contains(by)) {
      dateColumn = byColumn;
    }

    // what
    if (what == StatCalc.COLUMN_COUNT) {
    // TODO  _graphPanel.calc(what, graphElementWhat(), dateColumnName);
    } else {
      DColumn whatColumn = DataUtil.findColumn(table, null, what);
      if (whatColumn == null) {
        _log.info("onFormRecordChange NotFound column=${what}");
        return;
      }
      _graphPanel.calc(whatColumn);
    }
    //
    _graphPanel.calculate(records, dateColumn, StatPoint.findPeriod(period));
    _graphPanel.display();
  } // onFormRecordChange


  static String graphElementWhat() => Intl.message("Display", name: "graphElementWhat");
  static String graphElementBy() => Intl.message("Group by", name: "graphElementBy");
  static String graphElementByPeriod() => Intl.message("Group by Period", name: "graphElementByPeriod");
  static String graphElementCount() => Intl.message("Count", name: "graphElementCount");

} // GraphElement
