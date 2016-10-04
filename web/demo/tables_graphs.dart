/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class TablesGraphs extends DemoFeature {

  TablesGraphs() : super("tableGraphs", "Data Tables(2)",
      sldsPath: "",
      sldsStatus: "n/a",
      devStatus: DemoFeature.STATUS_COMPLETE,
      hints: ["Linked Table and Graph"],
      issues: [],
      plans: ["resizable columns"]);

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    int setCount = 3;
    Datasource datasource = DemoData.createDatasource(setCount);
    LTable table = new LTable("tg")
      ..bordered = true
      ..responsiveOverflow = responsiveOverflowOption
      ..withStatistics = statisticsOption
      ..editMode = editModeOption;
    div.add(table);
    if (responsiveStackedOption)
      table.responsiveStacked = responsiveStackedOption;
    if (responsiveStackedHorizontalOption) // overwrites stacked
      table.responsiveStackedHorizontal = responsiveStackedHorizontalOption;
    if (actionOption) {
      table.addTableAction(new AppsAction("ta", "Table Action", (String value, DataRecord data, DEntry entry, var actionVar){
          print("Table Action ${value}");
        })
      );
      table.addRowAction(new AppsAction("ra", "Row Action", (String value, DataRecord data, DEntry entry, var actionVar){
          print("Row Action ${value}");
        })
      );
    }
    //
    table.setUi(datasource.ui);
    table.setRecords(datasource.recordList);
    div.append(new HRElement());
    if (setCount > 1)
      table.setResponsiveScroll(400);

    //
    GraphPanel graph = new GraphPanel(datasource, table, false);
    div.append(graph.element);


    return div;
  }

  String get source {
    return '''
    Datasource datasource = DemoData.createDatasource();
    LTable table = new LTable("tg")
      ..bordered = true
      ..responsiveOverflow = true
      ..withStatistics = statisticsOption
      ..editMode = LTable.EDIT_RO;
    if (responsiveStackedOption)
      table.responsiveStacked = responsiveStackedOption;
    if (responsiveStackedHorizontalOption) // overwrites stacked
      table.responsiveStackedHorizontal = responsiveStackedHorizontalOption;
    if (actionOption) {
      table.addTableAction(new AppsAction("ta", "Table Action", (String value, DRecord record, DEntry entry, var actionVar){
          print("Table Action \${value}");
        })
      );
      table.addRowAction(new AppsAction("ra", "Row Action", (String value, DRecord record, DEntry entry, var actionVar){
          print("Row Action \${value}");
        })
      );
    }
    //
    table.setUi(datasource.ui);
    table.setRecords(datasource.recordList);
    div.add(table);
    div.append(new HRElement());
    //
    GraphElement graph = new GraphElement(datasource, table, false);
    div.append(graph.element);
    ''';
  }

  bool statisticsOption = true;
  bool responsiveStackedOption = false;
  bool responsiveStackedHorizontalOption = false;
  bool actionOption = false;
  LTableResponsive responsiveOverflowOption = LTableResponsive.OVERFLOW_HEAD_FOOT;
  String editModeOption = LTable.EDIT_RO;

  EditorI optionEditModeSelect() {
    LSelect select = new LSelect("eMode", idPrefix: id)
      ..label = "Edit Mode"
      ..maxWidth = "10rem";
    select.addOption(new OptionElement(data: "Read/Only", value: LTable.EDIT_RO));
    select.addOption(new OptionElement(data: "Edit All", value: LTable.EDIT_ALL));
    select.addOption(new OptionElement(data: "Edit Selected", value: LTable.EDIT_SEL));
    select.addOption(new OptionElement(data: "Edit Field", value: LTable.EDIT_FIELD));
    select.addOption(new OptionElement(data: "R/O Select Multi", value: LTable.EDIT_RO_SELECT_MULTI));
    select.addOption(new OptionElement(data: "R/O Select Single", value: LTable.EDIT_RO_SELECT_SINGLE));
    select.input.onChange.listen((Event evt){
      editModeOption = select.value;
      optionChanged();
    });
    return select;
  }

  EditorI optionStatisticsCb() {
    LCheckbox cb = new LCheckbox("statisticsO", idPrefix: id)
      ..label = "Option: Statistics"
      ..value = "true";
    cb.input.onClick.listen((MouseEvent evt){
      statisticsOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionResponsiveSCb() {
    LCheckbox cb = new LCheckbox("responsiveS", idPrefix: id)
      ..label = "Option: Responsive Stacked";
    cb.input.onClick.listen((MouseEvent evt){
      responsiveStackedOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionResponsiveSHCb() {
    LCheckbox cb = new LCheckbox("responsiveSH", idPrefix: id)
      ..label = "Option: Responsive Stacked Horizontal";
    cb.input.onClick.listen((MouseEvent evt){
      responsiveStackedHorizontalOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionActionCb() {
    LCheckbox cb = new LCheckbox("actions", idPrefix: id)
      ..label = "Option: Actions";
    cb.input.onClick.listen((MouseEvent evt){
      actionOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }


  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionEditModeSelect());
    list.add(optionStatisticsCb());
    list.add(optionResponsiveSCb());
    list.add(optionResponsiveSHCb());
    list.add(optionActionCb());
    return list;
  }

}
