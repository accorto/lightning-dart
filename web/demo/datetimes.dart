/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

/**
 * Date/Time Pickers
 */
class DateTimes extends DemoFeature {

  DateTimes()
      : super("datetimes", "DateTime",
      sldsPath: "",
      sldsStatus: DemoFeature.SLDS_NA,
      devStatus: DemoFeature.STATUS_PARTIAL,
      hints: ["Date is internally maintained in UTC",
        "DateTime and Time in local time"]);


  LComponent get content {
    LForm form = new LForm.stacked("dateTime-form")
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    form.setSection(new FormSection(2));

    LInputDate id1 = new LInputDate("dateTime-html", type: EditorI.TYPE_DATETIME)
      ..label = "Date Time Html5 (falls back if not supported)"
      ..html5 = true;
    id1.value = null;
    form.addEditor(id1);

    LInputDate id1t = new LInputDate("time-html", type: EditorI.TYPE_TIME)
      ..label = "Time Html5 (falls back if not supported)"
      ..html5 = true;
    id1.value = null;
    form.addEditor(id1t);

    LInputDate id2 = new LInputDate("dateTime-plain", type: EditorI.TYPE_DATETIME)
      ..label = "Date Time Input (plain)"
      ..html5 = false;
    id2.value = null;
    form.addEditor(id2);

    LInputDate id2t = new LInputDate("time-plain", type: EditorI.TYPE_TIME)
      ..label = "Time Input (plain)"
      ..html5 = false;
    id2.value = null;
    form.addEditor(id2t);

    //LLookup tz = new LLookupTimezone(TZ.TZ_COLUMN_NAME)
    //  ..label = TZ.TZ_COLUMN_NAME;
    //form.addEditor(tz);

    form.addResetButton()
      ..classes.add(LMargin.C_TOP__MEDIUM);

    form.showTrace();
    return form;
  }


}
