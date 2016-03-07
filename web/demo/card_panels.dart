/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class CardPanels extends DemoFeature {

  CardPanels() : super("cardPanels", "Card Panels",
      sldsPath: "",
      sldsStatus: DemoFeature.SLDS_NA,
      devStatus: DemoFeature.STATUS_COMPLETE,
      hints: [],
      issues: [],
      plans: ["Drag+Drop to change status"]);


  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    CardPanel cpanel = new CardPanel("cpanel");
    cpanel.addGroupByOption(new DOption()
      ..value = DemoData.COL_STATUS
      ..label = "Status");
    cpanel.addGroupByOption(new DOption()
      ..value = DemoData.COL_TOWN
      ..label = "Town");
    cpanel.setRecords(DemoData.createRecordList(1));
    cpanel.groupBy = DemoData.COL_STATUS;

    div.add(cpanel);
    return div;
  }


  String get source {
    return '''
    CardPanel cpanel = new CardPanel("cpanel");
    cpanel.addGroupByOption(new DOption()
      ..value = DemoData.COL_STATUS
      ..label = "Status");
    cpanel.addGroupByOption(new DOption()
      ..value = DemoData.COL_TOWN
      ..label = "Town");
    cpanel.setRecords(DemoData.createRecordList(1));
    cpanel.groupBy = DemoData.COL_STATUS;
    ''';
  }

}
