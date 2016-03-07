/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Processes extends DemoFeature {

  Processes() : super ("process", "Process",
      sldsStatus: DemoFeature.SLDS_PROTOTYPE,
      devStatus: DemoFeature.STATUS_PARTIAL,
      hints: [],
      issues: [],
      plans: ["Coaching, Wizard"]);

  LComponent get content {
    CDiv div = new CDiv();

    List<DOption> options = new List<DOption>();
    options.add(OptionUtil.option("contact", "Contacted"));
    options.add(OptionUtil.option("open", "Open"));
    options.add(OptionUtil.option("unqualified", "Unqualified", isDefault: true));
    options.add(OptionUtil.option("nurturing", "Nurturing"));
    options.add(OptionUtil.option("closed", "Closed"));
    // Quick + easy
    LPath path = new LPath("path")
      ..label = "Sales Path";
    path.dOptionList = options;
    //path.element.classes.add(LMargin.C_HORIZONTAL__LARGE);
    //div.append(path.element);
    div.append(new DivElement()
      ..classes.add(LMargin.C_HORIZONTAL__LARGE)
      ..style.width = "300px"
      ..append(path.element));

    //
    div.appendHR();
    DColumn column = new DColumn()
      ..name = "path"
      ..label = "Sales Path"
      ..dataType = DataType.PICK
      ..pickValueList.addAll(options);
    DTable table = new DTable()
      ..name = "test"
      ..columnList.add(column);
    DataColumn dataColumn = new DataColumn(table,column,null,null);
    LEditor pathEditor = EditorUtil.createFromColumn("path", dataColumn, false, isAlternativeDisplay: true);
    LForm form = new LForm.stacked("form-path")
      ..table = table;
    FormSection formSection = new FormSection(1);
    form.setSection(formSection);
    form.addEditor(pathEditor);
    div.add(form);

    return div;
  }

}
