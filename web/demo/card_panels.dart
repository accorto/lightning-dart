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
      ..value = COL_STATUS
      ..label = "Status");
    cpanel.addGroupOption(new DOption()
      ..value = COL_TOWN
      ..label = "Town");
    cpanel.setRecords(createRecordList());

    div.add(cpanel);
    return div;
  }


  static const COL_NAME = "name";
  static const COL_STATUS = "status";
  static const COL_TOWN = "town";
  static const COL_AGE = "age";

  List<DRecord> createRecordList() {
    List<DRecord> list = new List<DRecord>();
    list.add(createRecord("Joe", "New", "San Francisco", "22"));
    list.add(createRecord("John", "Paid", "San Jose", "23"));
    list.add(createRecord("Jorg", "Paid", "Redwood City", "24"));
    list.add(createRecord("Jorge", "Due", "Santa Clara", "24"));
    list.add(createRecord("George", "Due", "San Mateo", "26"));
    list.add(createRecord("Josh", "New", "San Francisco", "26"));
    list.add(createRecord("Oddie", "", "", "23"));

    return list;
  }

  DRecord createRecord(String name, String status, String town, String age) {
    DRecord r = new DRecord()
      ..recordId = "${_id}"
      ..urv = "${_id}"
      ..drv = name;
    r.entryList.add(new DEntry()
      ..columnName = COL_NAME
      ..valueOriginal = name);
    r.entryList.add(new DEntry()
      ..columnName = COL_STATUS
      ..valueOriginal = status);
    r.entryList.add(new DEntry()
      ..columnName = COL_TOWN
      ..valueOriginal = town);
    r.entryList.add(new DEntry()
      ..columnName = COL_AGE
      ..valueOriginal = age);

    _id++;
    return r;
  }
  int _id = 1;
}
