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
      devStatus: DemoFeature.STATUS_PARTIAL,
      hints: [],
      issues: [],
      plans: []);

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    Datasource datasource = DemoData.createDatasource();

    LTable table = new LTable("tg")
      ..bordered = borderedOption
      ..responsiveOverflow = responsiveOverflowOption;
    if (responsiveStackedOption)
      table.responsiveStacked = responsiveStackedOption;
    if (responsiveStackedHorizontalOption) // overwrites stacked
      table.responsiveStackedHorizontal = responsiveStackedHorizontalOption;
    if (actionOption) {
      table.addTableAction(new AppsAction("ta", "Table Action", (String value, DRecord record, DEntry entry, var actionVar){
        print("Table Action ${value}");
      })
      );
      table.addRowAction(new AppsAction("ra", "Row Action", (String value, DRecord record, DEntry entry, var actionVar){
        print("Row Action ${value}");
      })
      );
    }
    //
    table.setUi(datasource.ui);
    table.setRecords(datasource.recordList);
    div.add(table);
    div.append(new HRElement());

    //
    GraphElement graph = new GraphElement(datasource);
    graph.init();
    div.append(graph.element);

    return div;
  }

  String get source {
    return '''

    ''';
  }

  bool sortOption = false;
  bool borderedOption = false;
  bool responsiveOverflowOption = false;
  bool responsiveStackedOption = false;
  bool responsiveStackedHorizontalOption = false;
  bool actionOption = false;

  EditorI optionBorderedCb() {
    LCheckbox cb = new LCheckbox("bordered", idPrefix: id)
      ..label = "Option: Bordered";
    cb.input.onClick.listen((MouseEvent evt){
      borderedOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionResponsiveOCb() {
    LCheckbox cb = new LCheckbox("responsiveO", idPrefix: id)
      ..label = "Option: Responsive Overflow";
    cb.input.onClick.listen((MouseEvent evt){
      responsiveOverflowOption = cb.input.checked;
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
  EditorI optionSortCb() {
    LCheckbox cb = new LCheckbox("sorting", idPrefix: id)
      ..label = "Option: Sorting *";
    cb.input.onClick.listen((MouseEvent evt){
      sortOption = cb.input.checked;
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
    list.add(optionBorderedCb());
    list.add(optionResponsiveOCb());
    list.add(optionResponsiveSCb());
    list.add(optionResponsiveSHCb());
    list.add(optionSortCb());
    list.add(optionActionCb());
    return list;
  }

}
