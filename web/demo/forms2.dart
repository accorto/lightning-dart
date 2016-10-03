/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Forms2 extends DemoFeature {

  Forms2() : super ("forms2", "Forms(2)",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: [],
  issues: [],
  plans: []);


  int columnCount = 1;

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__SMALL);

    FormCtrl form = new FormCtrl("formA", ui(columnCount));
    form.buildPanels();
    form.showTrace();

    div.add(form);

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();

    FormCtrl form = new FormCtrl("formA", ui(columnCount));
    form.buildPanels();
    div.add(form);

    return div;
    ''';
  }


  /**
   * Saved Query UI
   */
  static UI ui(int columnCount) {
    UiUtil uiu = new UiUtil(new UI());
    DTable sqTable = new DTable()
      ..name = "MyForm2"
      ..label = "My Form 2";
    uiu.setTable(sqTable);
    uiu.addPanel(name:"Collapsible Region", columnCount:columnCount);

    // Column Name
    DColumn col = new DColumn()
      ..name = "Name"
      ..label = "String Column 60"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 1
      ..displaySeqNo = 1
      ..columnSize = 60
      ..isMandatory = true;
    uiu.addColumn(col);

    // Column Description
    col = new DColumn()
      ..name = "Description"
      ..label = "String Column 256"
      ..dataType = DataType.STRING
      ..columnSize = 255;
    uiu.addColumn(col);

    // Column Description
    col = new DColumn()
      ..name = "Integer"
      ..label = "Integer Column"
      ..dataType = DataType.INT;
    uiu.addColumn(col);

    // Column Pick
    col = new DColumn()
      ..name = "PickCol"
      ..label = "Picklist Example"
      ..dataType = DataType.PICK
      ..isMandatory = true;
    col.pickValueList.add(new DOption()..value = "1" ..label = "Option A 1");
    col.pickValueList.add(new DOption()..value = "2" ..label = "Option B 2");
    col.pickValueList.add(new DOption()..value = "3" ..label = "Option A 2");
    col.pickValueList.add(new DOption()..value = "4" ..label = "Option B 1");
    uiu.addColumn(col);

    // Column Date
    col = new DColumn()
      ..name = "DateCol"
      ..label = "Date Column"
      ..dataType = DataType.DATE
      ..description = "Date (only)";
    uiu.addColumn(col);

    // Currency
    col = new DColumn()
      ..name = "Currency"
      ..label = "Currency"
      ..dataType = DataType.PICK
      ..isMandatory = true
      ..defaultValue = "EUR";
    col.pickValueList.add(new DOption()..value = "USD" ..label = "USD");
    col.pickValueList.add(new DOption()..value = "CAD" ..label = "CAD");
    col.pickValueList.add(new DOption()..value = "EUR" ..label = "EUR");
    uiu.table.columnList.add(col);
    /// Amount
    LInputNumber.currencyColumnName = "Currency";
    col = new DColumn()
      ..name = "CurrencyAmt"
      ..label = "Currency Amount"
      ..dataType = DataType.CURRENCY
      ..isMandatory = true
      ..description = "Amount with currency";
    uiu.addColumn(col);

    //
    UIProcess prc = new UIProcess()
      ..name = "ProcessLink"
      ..label = "Process (link)"
      ..webLinkUrl = "https://www.accorto.com";
    uiu.ui.processList.add(prc);

    return uiu.ui;
  } // uiSavedQuery


  EditorI optionCount() {
    LInput count = new LInput("oColumns", EditorI.TYPE_NUMBER, idPrefix: id)
      ..label = "Number of Columns"
      ..min = "0"
      ..max = "8"
      ..value = "1";
    count.input.style.width = "inherit";
    count.input.onChange.listen((Event evt){
      columnCount  = int.parse(count.value, onError: (s){return 1;});
      optionChanged();
    });
    return count;
  }

  List<EditorI> get options {
    List<EditorI> list = new List<EditorI>();
    list.add(optionCount());
    return list;
  }

  } // Forms2
