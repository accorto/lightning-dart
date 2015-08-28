/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Picklists extends DemoFeature {

  Picklists() : super("picklists", "Picklists",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_INITIAL,
  hints: ["same api as select, lookup and dropdown"],
  issues: ["instable"],
  plans: []);


  LComponent get content {
    LForm form = new LForm.stacked("tf");

    LPicklist pl1 = new LPicklist("pl1");
    pl1.label = "Picklist 1"; // TODO
    pl1.listItems = generateListItems(10, iconLeft: true);
    pl1.value = "item5";
    form.addEditor(pl1);


    return form;
  }

  String get source {
    return '''
    LForm form = new LForm.stacked("tf");

    LPicklist pl1 = new LPicklist("pl1");
    pl1.label = "Picklist 1"; // TODO
    pl1.listItems = generateListItems(10, iconLeft: true);
    pl1.value = "item5";
    form.addEditor(pl1);
    ''';
  }

}
