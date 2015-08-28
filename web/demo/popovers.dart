/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Popovers extends DemoFeature {

  Popovers() : super ("popovers", "Popovers",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["shows on hover and stays if trigger clicked"],
  issues: [],
  plans: ["move if it does not fit on screen"]);

  LComponent get content {
    CDiv div = new CDiv();
    LPopover pop = new LPopover()
      ..headText = "Popover Heading"
      ..bodyText = "Popover Content Test lines come here"
      ..nubbinRight = true;
    div.add(pop);

    div.appendHR();
    pop = new LPopover()
      ..headText = "Another Popover";
    pop.body
      ..appendText("Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    LButton button = new LButton.neutral("btnA", "See Above");
    pop.showAbove(button);
    div.add(pop);

    pop = new LPopover()
      ..headText = "A Popbelow"
      ..bodyText = "Some Text, tell me what to show here, so that it is not that boring";
    button = new LButton.neutral("btnB", "See Below");
    pop.showBelow(button);
    div.add(pop);

    pop = new LPopover()
      ..headText = "Right Popover"
      ..bodyText = "Some Text, tell me what to show here, so that it is not that boring";
    button = new LButton.neutral("btnR", "See Right");
    pop.showRight(button);
    div.add(pop);

    pop = new LPopover()
      ..headText = "Left Popover"
      ..bodyText = "Some Text, tell me what to show here, so that it is not that boring";
    button = new LButton.neutral("btnL", "See Left");
    pop.showLeft(button);
    div.add(pop);

    return div;
  }


  String get source {
    return '''
    CDiv div = new CDiv();
    LPopover pop = new LPopover("Popover Heading", "Popover Content Test lines come here")
      ..nubbinRight = true;
    div.add(pop);

    div.appendHR();
    pop = new LPopover("Another Popover", null)
      ..nubbinTop = true;
    pop.body
      ..appendText("Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    div.add(pop);
    ''';
  }
}
