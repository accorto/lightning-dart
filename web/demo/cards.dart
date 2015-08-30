/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Cards extends DemoFeature {

  Cards() : super("cards", "Cards",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_PARTIAL,
  hints: [],
  issues: [],
  plans: ["compact, empty"]);



  LComponent get content {

    LCard card = new LCard("c1");
    LButtonGroup bg = new LButtonGroup();
    bg.add(new LButton.neutral("btn", "Button"));
    bg.add(new LButton.neutral("add", "Action"));
    bg.layout(1);
    card.setHeader(new LIconStandard(LIconStandard.CONTACT), "Card Header", group:bg);

    LTable table = new LTable("t1", true);
    LTableHeaderRow thead = table.addHeadRow(false);
    thead.addHeaderCell("c1", "First Column");
    thead.addHeaderCell("c2", "Second Column");
    thead.addHeaderCell("c3", "Third Column");
    LTableRow tbody = table.addBodyRow();
    tbody.addCellText("First Col #1");
    tbody.addCellText("Second Col #1");
    tbody.addCellText("Third Col #1");
    tbody = table.addBodyRow();
    tbody.addCellText("First Col #2");
    tbody.addCellText("Second Col #2");
    tbody.addCellText("Third Col #2");
    card.setBody(table);

    card.appendFooter(new AnchorElement(href:"#")..text = "Some Link");
    return card;
  }

  String get source {
    return '''
    LCard card = new LCard("c1");
    LButtonGroup bg = new LButtonGroup();
    bg.add(new LButton.neutral("btn", "Button"));
    bg.add(new LButton.neutral("add", "Action"));
    bg.layout(1);
    card.setHeader(new LIconStandard(LIconStandard.CONTACT), "Card Header", group:bg);

    LTable table = new LTable("t1", true);
    LTableHeaderRow thead = table.addHeadRow();
    thead.addHeaderCell("First Column", "c1");
    thead.addHeaderCell("Second Column", "c2");
    thead.addHeaderCell("Third Column", "c3");
    LTableRow tbody = table.addBodyRow();
    tbody.addCellText("First Col #1");
    tbody.addCellText("Second Col #1");
    tbody.addCellText("Third Col #1");
    tbody = table.addBodyRow();
    tbody.addCellText("First Col #2");
    tbody.addCellText("Second Col #2");
    tbody.addCellText("Third Col #2");
    card.setBody(table);

    card.appendFooter(new AnchorElement(href:"#")..text = "Some Link");
    return card;
    ''';
  }

}
