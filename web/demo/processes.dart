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
      hints: ["Components have Select API"],
      issues: [],
      plans: ["Coaching"]);

  LComponent get content {
    CDiv div = new CDiv();

    List<DOption> options = new List<DOption>();
    options.add(OptionUtil.option("contact", "Contacted"));
    options.add(OptionUtil.option("open", "Open"));
    options.add(OptionUtil.option("qualified", "Qualified", isDefault: true));
    options.add(OptionUtil.option("nurturing", "Nurturing"));
    options.add(OptionUtil.option("closed", "Closed"));
    // Quick + easy
    LPath path = new LPath("path")
      ..label = "Sales Path (stand alone)";
    path.dOptionList = options;
    div.append(new DivElement()
      ..classes.add(LMargin.C_HORIZONTAL__SMALL)
      ..style.width = "300px"
      ..append(path.element));

    //
    div.appendHR();
    DColumn column = new DColumn()
      ..name = "path"
      ..label = "Sales Path (in Form)"
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

    div.appendHR();
    column = new DColumn()
      ..name = "path"
      ..label = "Wizard (in Form)"
      ..dataType = DataType.PICK
      ..pickValueList.addAll(options);
    table = new DTable()
      ..name = "test"
      ..columnList.add(column);
    dataColumn = new DataColumn(table,column,null,null);
    LWizard wizEditor = new LWizard.from(dataColumn);
    form = new LForm.stacked("form-wiz")
      ..table = table;
    formSection = new FormSection(1);
    form.setSection(formSection);
    form.addEditor(wizEditor);
    div.add(form);
    return div;
  }

}
