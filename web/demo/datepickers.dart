/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

/**
 * Date Picker
 */
class Datepickers extends DemoFeature {

  Datepickers()
  : super("datepickers", "Datepickers",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["date constants (e.g. month names) are translated"],
  issues: ["css: week select with crossing month boundary"],
  plans: ["independent date ranges"]);

  LComponent get content {
    LForm form = new LForm.stacked("date-form")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    form.setSection(new FormSection(2));

    LDatepicker dp = new LDatepicker("date-pick")
      ..label = "Date Picker";
    if (optionWeekSelect)
      dp.mode = LDatepicker.MODE_WEEK_FIRST;
    dp.value = null;
    form.addEditor(dp);

    LInputDate id1 = new LInputDate("date-html")
      ..label = "Date Input Html5 (falls back if not supported)"
      ..html5 = true;
    id1.value = null;
    form.addEditor(id1);

    LInputDate id2 = new LInputDate("date-plain")
      ..label = "Date Input (plain)"
      ..html5 = false;
    id2.value = null;
    form.addEditor(id2);

    form.showTrace();
    return form;
  }


  String get source {
    return '''
    LForm form = new LForm.stacked("date-form")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    LDatepicker dp = new LDatepicker("date-pick")
      ..label = "Date Picker";
    if (optionWeekSelect)
      dp.mode = LDatepicker.MODE_WEEK_FIRST;
    dp.value = null;
    form.addEditor(dp);

    LInputDate id1 = new LInputDate("date-html")
      ..label = "Date Input Html5 (falls back if not supported)"
      ..html5 = true;
    id1.value = null;
    form.addEditor(id1);

    LInputDate id2 = new LInputDate("date-plain")
      ..label = "Date Input (plain)"
      ..html5 = false;
    id2.value = null;
    form.addEditor(id2);

    form.showTrace();
    return form;
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
