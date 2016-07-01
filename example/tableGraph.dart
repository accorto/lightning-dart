/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import 'dart:html';


import 'package:lightning/lightning_ctrl.dart';
import "package:lightning/lightning_demo.dart";

void main() {

  LightningCtrl.init("TableGraph", "TableGraph", LightningDart.VERSION, uaCode: "UA-32129178-8") // server env
  .then((_) {
    PageSimple page = LightningDart.createPageSimple();
    page.add(new TableGraphPage());

  });


}

class TableGraphPage extends AppsPage {

  /// The Element
  Element element = new DivElement()
    ..classes.add(LMargin.C_AROUND__MEDIUM);

  LTableResponsive responsiveOverflowOption = LTableResponsive.OVERFLOW_HEAD_FOOT;
  String editModeOption = LTable.EDIT_RO;
  bool statisticsOption = true;
  bool actionOption = false;
  bool responsiveStackedOption = false;
  bool responsiveStackedHorizontalOption = false;

  TableGraphPage()
      : super("table-graph", "tg", new LIconUtility(LIconUtility.BUCKET),
          "Table Graph", "Table Graph") {

    int setCount = 3;
    Datasource datasource = DemoData.createDatasource(setCount);
    LTable table = new LTable("tg")
      ..bordered = true
      ..responsiveOverflow = responsiveOverflowOption
      ..withStatistics = statisticsOption
      ..editMode = editModeOption;
    element.append(table.element);
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
    element.append(new HRElement());
    if (setCount > 1)
      table.setResponsiveScroll(400);

    //
    GraphPanel graph = new GraphPanel(datasource, table, false);
    element.append(graph.element);
  }

} // TableGraphPage

