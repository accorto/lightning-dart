/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class FormsEditor extends DemoFeature {

  FormsEditor() : super ("formsEditor", "Form Editors", sldsPath:"forms",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["if the input has an icon, by default it is displayed on the right",
    "any input can have a clear value icon, then the icon is on the left",
    "date editors in date picker"],
  issues: [],
  plans: ["address, geo, file, timezone, number/currency"]);


  LComponent get content {

    LForm form = new LForm.stacked("tfe")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    LInputSearch searchInput1 = new LInputSearch("search1")
      ..label = "Search Input 1"
      ..placeholder = "Search Placeholder";
    form.addEditor(searchInput1);

    LInputSearch searchInput2 = new LInputSearch("search2", withClearValue: true)
      ..label = "Search Input with Clear"
      ..placeholder = "Search Placeholder";
    form.addEditor(searchInput2);

    LInputDuration durationInput = new LInputDuration("duration")
      ..label = "Duration Input"
      ..placeholder = "Duration Placeholder";
    form.addEditor(durationInput);

    LInputRange rangeInput = new LInputRange("range")
      ..label = "Range Input 7 - 7 - 182"
      ..setMinStepMax(7, 7, 182);
    form.addEditor(rangeInput);
    rangeInput.valueAsInt = 35;

    return form;
  }

  String get source {
    return '''
    LForm form = new LForm.stacked("tfe");

    LInputSearch searchInput1 = new LInputSearch("search1")
      ..label = "Search Input 1"
      ..placeholder = "Search Placeholder";
    form.addEditor(searchInput1);

    LInputSearch searchInput2 = new LInputSearch("search2", withClearValue: true)
      ..label = "Search Input with Clear"
      ..placeholder = "Search Placeholder";
    form.addEditor(searchInput2);

    ''';
  }
}
