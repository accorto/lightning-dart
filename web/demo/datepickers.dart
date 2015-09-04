/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Datepickers extends DemoFeature {

  Datepickers()
  : super("datepickers", "Datepickers",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_PARTIAL,
  hints: ["date constants (e.g. month names) translated"],
  issues: ["css: week select with crossing month boundary"],
  plans: ["date ranges"]);

  LComponent get content {
    LForm form = new LForm.stacked("datePick");

    LDatepicker dp = new LDatepicker("date")
      ..label = "Date Picker";
    if (optionWeekSelect)
      dp.mode = LDatepicker.MODE_WEEK_FIRST;
    dp.value = null;
    form.addEditor(dp);

    LInputDate id1 = new LInputDate("id1", EditorI.TYPE_DATE)
      ..label = "Date Input Html5 (falls back if not supported)";
    id1.value = null;
    form.addEditor(id1);

    LInputDate id2 = new LInputDate("id2", EditorI.TYPE_DATE)
      ..label = "Date Input"
      ..html5 = false;
    id2.value = null;
    form.addEditor(id2);

    form.element.style.height = "300px"; // initial test
    return form;
  }


  String get source {
    return '''
    LForm form = new LForm.stacked("datePick");

    LDatepicker dp = new LDatepicker("date")
      ..label = "Date Picker";
    if (optionWeekSelect)
      dp.mode = LDatepicker.MODE_WEEK_FIRST;
    dp.value = null;
    form.addEditor(dp);

    LInputDate id1 = new LInputDate("id1", EditorI.TYPE_DATE)
      ..label = "Date Input Html5 (falls back if not supported)";
    id1.value = null;
    form.addEditor(id1);

    LInputDate id2 = new LInputDate("id2", EditorI.TYPE_DATE)
      ..label = "Date Input"
      ..html5 = false;
    id2.value = null;
    form.addEditor(id2);
    ''';
  }

  bool optionWeekSelect = false;

  EditorI optionWeekCb() {
    LCheckbox cb = new LCheckbox("optionW", idPrefix: id)
      ..label = "Option: Week Select (first day)";
    cb.input.onClick.listen((MouseEvent evt){
      optionWeekSelect = cb.input.checked;
      optionChanged();
    });
    return cb;
  }

  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionWeekCb());
    return list;
  }

}
