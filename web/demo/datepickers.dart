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
  issues: ["first day in week hardcoded", "css: week select with crossing month boundary"],
  plans: ["date ranges"]);

  LComponent get content {
    CDiv div = new CDiv();

    LDatepicker dp = new LDatepicker("date");
    if (optionWeekSelect)
      dp.mode = LDatepicker.MODE_WEEK_FIRST;
    dp.value = null; // today

    div.append(dp.element);
    div.element.style.height = "300px"; // initial test



    return div;
  }
  String get source {
    return '''
    ''';
  }

  bool optionWeekSelect = false;

  DivElement optionWeekCb() {
    LCheckbox cb = new LCheckbox("optionW", idPrefix: id)
      ..label = "Option: Week Select (first day)";
    cb.input.onClick.listen((MouseEvent evt){
      optionWeekSelect = cb.input.checked;
      optionChanged();
    });
    return cb.element;
  }

  List<DivElement> get options {
    List<DivElement> list = new List<DivElement>();
    list.add(optionWeekCb());
    return list;
  }

}
