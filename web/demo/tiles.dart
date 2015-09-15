/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Tiles extends DemoFeature {

  Tiles() : super ("tiles", "Tiles",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["tiles can have multiple lines of text", "or single line with items", "or multiple entries (label/value)"],
  issues: [],
  plans: ["task tile", "list tiles", "Board"]);

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    LTileBase t1 = new LTileBase("Base Tile")
      ..addText("26 members");
    div.add(t1);

    div.appendHrSmall();

    LTileIcon t2 = new LTileIcon("Base Tile without Icon")
      ..addText("26 members");
    div.add(t2);
    LTileIcon t3 = new LTileIcon("Base Tile with Icon", icon: new LIconStandard(LIconStandard.GROUPS))
      ..addText("26 members");
    div.add(t3);
    LTileIcon t4 = new LTileIcon("Base Tile with Image", imgSrc: "avatar2.jpg")
      ..addText("26 members");
    div.add(t4);
    LTileIcon t5 = new LTileIcon("Base Tile with Icon + list", icon: new LIconStandard(LIconStandard.GROUPS))
      ..addItem("26 members")
      ..addItem("all happy");
    div.add(t5);

    div.appendHrSmall();

    LTileGeneric tg = new LTileGeneric("Generic Tile", icon: new LIconStandard(LIconStandard.GROUPS))
      ..addActions([AppsAction.createEdit(null)])
      ..addEntry("Name", "Joe Block")
      ..addEntry("Title", "VP")
      ..addEntry("see also", "compact card entry");
    div.add(tg);

    return div;
  }

  String get source {
    return '''
    LTileBase t1 = new LTileBase("Base Tile")
      ..addText("26 members");
    div.add(t1);

    LTileIcon t2 = new LTileIcon("Base Tile without Icon")
      ..addText("26 members");
    div.add(t2);
    LTileIcon t3 = new LTileIcon("Base Tile with Icon", icon: new LIconStandard(LIconStandard.GROUPS))
      ..addText("26 members");
    div.add(t3);
    LTileIcon t4 = new LTileIcon("Base Tile with Image", imgSrc: "avatar2.jpg")
      ..addText("26 members");
    div.add(t4);
    LTileIcon t5 = new LTileIcon("Base Tile with Icon + list", icon: new LIconStandard(LIconStandard.GROUPS))
      ..addItem("26 members")
      ..addItem("all happy");
    div.add(t5);

    LTileGeneric tg = new LTileGeneric("Generic Tile", icon: new LIconStandard(LIconStandard.GROUPS))
      ..addActions([AppsAction.createEdit(null)])
      ..addEntry("Name", "Joe Block")
      ..addEntry("Title", "VP")
      ..addEntry("see also", "compact card entry");
    div.add(tg);
    ''';
  }
}
