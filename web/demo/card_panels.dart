/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class CardPanels extends DemoFeature {

  CardPanels() : super("cardPanels", "Card Panels",
      sldsPath: "",
      sldsStatus: "n/a",
      devStatus: DemoFeature.STATUS_PARTIAL,
      hints: [],
      issues: [],
      plans: ["Drag+Drop"]);


  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    CardPanel cpanel = new CardPanel("cpanel");
    cpanel.addGroupOption(new DOption()
      ..value = DemoData.COL_STATUS
      ..label = "Status");
    cpanel.addGroupOption(new DOption()
      ..value = DemoData.COL_TOWN
      ..label = "Town");
    cpanel.setRecords(DemoData.createRecordList(1));

    div.add(cpanel);
    return div;
  }


  String get source {
    return '''
    CardPanel cpanel = new CardPanel("cpanel");
    cpanel.addGroupOption(new DOption()
      ..value = DemoData.COL_STATUS
      ..label = "Status");
    cpanel.addGroupOption(new DOption()
      ..value = DemoData.COL_TOWN
      ..label = "Town");
    cpanel.setRecords(DemoData.createRecordList());
    ''';
  }

}
