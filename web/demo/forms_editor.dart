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
  plans: ["address, geo, currency"]);


  LComponent get content {

    LForm form = new LForm.stacked("tfe")
      ..classes.add(LMargin.C_HORIZONTAL__SMALL);
    form.setSection(new FormSection(2));
    String marginClass = LMargin.C_TOP__X_SMALL;

    LInputSearch searchInput1 = new LInputSearch("search1")
      ..label = "Search Input 1"
      ..placeholder = "Search Placeholder";
    form.addEditor(searchInput1, marginClass:marginClass);

    LInputSearch searchInput2 = new LInputSearch("search2", withClearValue: true)
      ..label = "Search Input with Clear"
      ..placeholder = "Search Placeholder";
    form.addEditor(searchInput2, marginClass:marginClass);

    LInputDuration durationInput = new LInputDuration("duration")
      ..label = "Duration Input"
      ..placeholder = "Duration Placeholder";
    form.addEditor(durationInput, marginClass:marginClass);

    LInputDuration durationInput2 = new LInputDuration("duration2", type:EditorI.TYPE_DURATIONHOUR)
      ..label = "Duration Hour Input (Browser mode)"
      ..placeholder = "Duration Hour Placeholder"
      ..mobileUi = false; // overwrite default/preferences
    form.addEditor(durationInput2, marginClass:marginClass);

    LInputDuration durationInput3 = new LInputDuration("duration3", type:EditorI.TYPE_DURATIONHOUR)
      ..label = "Duration Hour Input (Mobile mode)"
      ..placeholder = "Duration Hour Placeholder"
      ..mobileUi = true; // overwrite default/preferences
    form.addEditor(durationInput3, marginClass:marginClass);

    LInputNumber number1h = new LInputNumber("n1h")
      ..label = "Html5 Integer"
      ..placeholder = "Number Placeholder"
      ..decimalDigits = 0
      ..html5 = true;
    form.addEditor(number1h, marginClass:marginClass);

    LInputNumber number1 = new LInputNumber("n1")
      ..label = "Standard Integer"
      ..placeholder = "Number Placeholder"
      ..html5 = false
      ..decimalDigits = 0;
    form.addEditor(number1, marginClass:marginClass);

    LInputNumber number2h = new LInputNumber("n2h")
      ..label = "Html5 Number(2)"
      ..placeholder = "Number Placeholder"
      ..html5 = true
      ..decimalDigits = 2;
    form.addEditor(number2h, marginClass:marginClass);

    LInputNumber number2 = new LInputNumber("n2")
      ..label = "Standard Number(2)"
      ..placeholder = "Number Placeholder"
      ..html5 = false
      ..decimalDigits = 2;
    form.addEditor(number2, marginClass:marginClass);

    LInputRange rangeInput = new LInputRange("range")
      ..label = "Range Input 7 - 7 - 182"
      ..setMinStepMax(7, 7, 182);
    form.addEditor(rangeInput, marginClass:marginClass);
    rangeInput.valueAsInt = 35;

    LInputColor colorInput = new LInputColor("color")
      ..label = "Color";
    form.addEditor(colorInput, marginClass:marginClass);

    LInputImage imageInput = new LInputImage("image")
      ..label = "Image";
    form.addEditor(imageInput, marginClass:marginClass);

    LInputFile fileInput = new LInputFile("file")
      ..label = "File";
    form.addEditor(fileInput, marginClass:marginClass);

    LInputImage imageInput2 = new LInputImage("image2")
      ..label = "Image 2"
      ..value = "standard|client";
    form.addEditor(imageInput2, marginClass:marginClass);

    return form;
  }

  String get source {
    return '''
    LForm form = new LForm.stacked("tfe")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    form.setSection(new FormSection(2));

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

    LInputDuration durationInput2 = new LInputDuration("duration", type:EditorI.TYPE_DURATIONHOUR)
      ..label = "Duration Hour Input"
      ..placeholder = "Duration Hour Placeholder";
    form.addEditor(durationInput2);

    LInputNumber number1h = new LInputNumber("n1h")
      ..label = "Html5 Integer"
      ..placeholder = "Number Placeholder"
      ..decimalDigits = 0;
    form.addEditor(number1h);

    LInputNumber number1 = new LInputNumber("n1")
      ..label = "Standard Integer"
      ..placeholder = "Number Placeholder"
      ..decimalDigits = 0
      ..html5 = false;
    form.addEditor(number1);

    LInputNumber number2h = new LInputNumber("n2h")
      ..label = "Html5 Number(2)"
      ..placeholder = "Number Placeholder"
      ..decimalDigits = 2;
    form.addEditor(number2h);

    LInputNumber number2 = new LInputNumber("n2")
      ..label = "Standard Number(2)"
      ..placeholder = "Number Placeholder"
      ..decimalDigits = 2
      ..html5 = false;
    form.addEditor(number2);

    LInputRange rangeInput = new LInputRange("range")
      ..label = "Range Input 7 - 7 - 182"
      ..setMinStepMax(7, 7, 182);
    form.addEditor(rangeInput);
    rangeInput.valueAsInt = 35;

    return form;
    ''';
  }
}
