/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Tables extends DemoFeature {

  Tables()
  : super("data-tables", "Data Tables",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["sorting works with Records, not as here when when cells are populated directly", "see workspace demo"],
  issues: [],
  plans: []);

  LComponent get content {

    LTable table = new LTable("t2")
      ..bordered = borderedOption;
    if (responsiveStackedOption)
      table.responsiveStacked = responsiveStackedOption;
    if (responsiveStackedHorizontalOption) // overwrites stacked
      table.responsiveStackedHorizontal = responsiveStackedHorizontalOption;
    if (actionOption) {
      table.addTableAction(new AppsAction("ta", "Table Action", (String value, DRecord record, DEntry entry, var actionVar){
          print("Table Action ${value}");
        })
      );
      table.addRowAction(new AppsAction("ra", "Row Action", (String value, DRecord record, DEntry entry, var actionVar){
          print("Row Action ${value}");
        })
      );
    }


    LTableHeaderRow thead = table.addHeadRow(sortOption);
    thead.addHeaderCell("fn", "First Name");
    thead.addHeaderCell("ln", "Last Name");
    thead.addHeaderCell("city", "City");
    LTableRow tbody = table.addBodyRow();
    tbody.addCellText("Joe");
    tbody.addCellText("Block");
    tbody.addCellText("Small Town");
    tbody = table.addBodyRow();
    tbody.addCellText("Marie");
    tbody.addCellText("Smith");
    tbody.addCellText("Near You");

    if (responsiveOverflowOption) {
      return table.responsiveOverflow();
    }
    return table;
  }

  bool sortOption = false;
  bool borderedOption = false;
  bool responsiveOverflowOption = false;
  bool responsiveStackedOption = false;
  bool responsiveStackedHorizontalOption = false;
  bool actionOption = false;

  EditorI optionBorderedCb() {
    LCheckbox cb = new LCheckbox("bordered", idPrefix: id)
      ..label = "Option: Bordered";
    cb.input.onClick.listen((MouseEvent evt){
      borderedOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionResponsiveOCb() {
    LCheckbox cb = new LCheckbox("responsiveO", idPrefix: id)
      ..label = "Option: Responsive Overflow";
    cb.input.onClick.listen((MouseEvent evt){
      responsiveOverflowOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionResponsiveSCb() {
    LCheckbox cb = new LCheckbox("responsiveS", idPrefix: id)
      ..label = "Option: Responsive Stacked";
    cb.input.onClick.listen((MouseEvent evt){
      responsiveStackedOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionResponsiveSHCb() {
    LCheckbox cb = new LCheckbox("responsiveSH", idPrefix: id)
      ..label = "Option: Responsive Stacked Horizontal";
    cb.input.onClick.listen((MouseEvent evt){
      responsiveStackedHorizontalOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionSortCb() {
    LCheckbox cb = new LCheckbox("sorting", idPrefix: id)
      ..label = "Option: Sorting *";
    cb.input.onClick.listen((MouseEvent evt){
      sortOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }
  EditorI optionActionCb() {
    LCheckbox cb = new LCheckbox("actions", idPrefix: id)
      ..label = "Option: Actions";
    cb.input.onClick.listen((MouseEvent evt){
      actionOption = cb.input.checked;
      optionChanged();
    });
    return cb;
  }


  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionBorderedCb());
    list.add(optionResponsiveOCb());
    list.add(optionResponsiveSCb());
    list.add(optionResponsiveSHCb());
    list.add(optionSortCb());
    list.add(optionActionCb());
    return list;
  }


}
