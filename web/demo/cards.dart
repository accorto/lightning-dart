/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Cards extends DemoFeature {

  Cards() : super("cards", "Cards",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: [],
  issues: [],
  plans: ["empty"]);


  LComponent get content {
    CDiv div = new CDiv();

    LCard card = new LCard("c1");
    LButtonGroup bg = new LButtonGroup();
    bg.add(new LButton.neutral("btn", "Button"));
    bg.add(new LButton.neutral("add", "Action"));
    bg.layout(1);
    card.setHeader(new LIconStandard(LIconStandard.CONTACT), "Card Header", action:bg);

    LTable table = new LTable("t1");
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
    card.addTable(table);
    card.appendFooter(new AnchorElement(href:"#")..text = "Some Link");

    div.add(card);
    div.appendHR();

    LCardCompact cc = new LCardCompact("c2");
    LButtonGroup bg2 = new LButtonGroup();
    bg2.add(new LButton.neutral("btn", "Button"));
    bg2.add(new LButton.neutral("add", "Action"));
    bg2.layout(1);
    cc.setHeader(new LIconStandard(LIconStandard.CONTACT), "Compact Card Header", action:bg2);

    LCardCompactEntry entry = new LCardCompactEntry("Adam");
    entry.addActions([AppsAction.createEdit(null)]);
    entry.addEntry("Title", "VP");
    entry.addEntry("Email", "mail@mail.com");
    cc.addEntry(entry);

    div.add(cc);
    return div;
  }

  String get source {
    return '''
    LCard card = new LCard("c1");
    LButtonGroup bg = new LButtonGroup();
    bg.add(new LButton.neutral("btn", "Button"));
    bg.add(new LButton.neutral("add", "Action"));
    bg.layout(1);
    card.setHeader(new LIconStandard(LIconStandard.CONTACT), "Card Header", action:bg);

    LTable table = new LTable("t1");
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
    card.addTable(table);
    card.appendFooter(new AnchorElement(href:"#")..text = "Some Link");


    LCardCompact cc = new LCardCompact("c2");
    LButtonGroup bg2 = new LButtonGroup();
    bg2.add(new LButton.neutral("btn", "Button"));
    bg2.add(new LButton.neutral("add", "Action"));
    bg2.layout(1);
    cc.setHeader(new LIconStandard(LIconStandard.CONTACT), "Compact Card Header", action:bg2);

    LCardCompactEntry entry = new LCardCompactEntry("Adam");
    entry.addActions([AppsAction.createEdit(null)]);
    entry.addEntry("Title", "VP");
    entry.addEntry("Email", "mail@mail.com");
    cc.addEntry(entry);
    ''';
  }

}
