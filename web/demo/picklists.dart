/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Picklists extends DemoFeature {

  Picklists() : super("picklists", "Picklists",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["same api as select, lookup and dropdown"],
  issues: [],
  plans: []);


  LComponent get content {
    CDiv div = new CDiv();

    LForm form = new LForm.stacked("tf")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    LPicklist pl1 = new LPicklist("pl1");
    pl1.label = "Picklist 1";
    pl1.listItems = generateListItems(10, iconLeft: true);
    form.addEditor(pl1);
    pl1.value = "item5";

    div.add(form);
    div.appendHR();

    List<DOption> options = new List<DOption>()
      ..add(new DOption()..value = "o1" ..label = "Option 1")
      ..add(new DOption()..value = "o2" ..label = "Option 2" ..isSelected = true )
      ..add(new DOption()..value = "o3" ..label = "Option 3" ..isSelected = true );
    LPicklistMulti multi = new LPicklistMulti()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM)
      ..label = "Choices"
      ..options = options;

    div.add(multi);

    return div;
  }

  String get source {
    return '''
    LForm form = new LForm.stacked("tf");
    LPicklist pl1 = new LPicklist("pl1");
    pl1.label = "Picklist 1";
    pl1.listItems = generateListItems(10, iconLeft: true);
    form.addEditor(pl1);
    pl1.value = "item5";

    List<DOption> options = new List<DOption>()
      ..add(new DOption()..value = "o1" ..label = "Option 1")
      ..add(new DOption()..value = "o2" ..label = "Option 2" ..isSelected = true )
      ..add(new DOption()..value = "o3" ..label = "Option 3" ..isSelected = true );
    LPicklistMulti multi = new LPicklistMulti()
      ..label = "Choices"
      ..options = options;
    ''';
  }

}
