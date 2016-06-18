/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Popovers extends DemoFeature {

  Popovers() : super ("popovers", "Popovers",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["shows on hover and stays if trigger clicked"],
  issues: [],
  plans: ["auto position", "panels"]);

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    LPopover pop = new LPopover()
      ..headText = "Popover Heading"
      ..bodyText = "Popover Content Test lines come here"
      ..nubbin = LPopover.C_NUBBIN__RIGHT;
    div.add(pop);

    div.appendHR();
    CDiv buttonLine = new CDiv();
    // FIXME  ..classes.add(LButton.C_X_SMALL_BUTTONS__HORIZONTAL);
    div.add(buttonLine);
    pop = new LPopover()
      ..headText = "Another Popover";
    pop.body
      ..appendText("Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    LButton button = new LButton.neutral("btnA", "See Above");
    pop.showAbove(button);
    buttonLine.add(pop);

    pop = new LPopover()
      ..headText = "A Popbelow"
      ..bodyText = "Some Info Text, tell me what to show here, so that it is not that boring"
      ..theme = LTheme.C_THEME__INFO;
    button = new LButton.neutral("btnB", "See Below");
    pop.showBelow(button);
    buttonLine.add(pop);

    pop = new LPopover()
      ..headText = "Right Popover"
      ..bodyText = "Some Warning Text, tell me what to show here, so that it is not that boring"
      ..theme = LTheme.C_THEME__WARNING;
    button = new LButton.neutral("btnR", "See Right");
    pop.showRight(button);
    buttonLine.add(pop);

    pop = new LPopover()
      ..headText = "Left Popover"
      ..bodyText = "Some Text, tell me what to show here, so that it is not that boring";
    button = new LButton.neutral("btnL", "See Left");
    pop.showLeft(button);
    buttonLine.add(pop);


    div.appendHR();
    LTooltip tt = new LTooltip()
      ..bodyText = "Tooltip Content Test lines come here"
      ..nubbin = LPopover.C_NUBBIN__RIGHT;
    div.add(tt);

    div.appendHR();
    buttonLine = new CDiv();
    // FIXME  ..classes.add(LButton.C_X_SMALL_BUTTONS__HORIZONTAL);
    div.add(buttonLine);
    tt = new LTooltip();
    tt.body
      ..appendText("Another Tooltip Some text comes here ")
      ..append(new AnchorElement(href: "#")..text = "Some Link")
      ..appendText(" Additional Text");
    button = new LButton.neutral("btnPA", "See Above");
    tt.showAbove(button);
    buttonLine.add(tt); // tooltip is wrapper for button

    tt = new LTooltip()
      ..bodyText = "Another Below Info Tooltip with some info"
      ..theme = LTheme.C_THEME__INFO;
    button = new LButton.neutral("btnB", "See Below");
    tt.showBelow(button);
    buttonLine.add(tt); // tooltip is wrapper for button

    tt = new LTooltip()
      ..bodyText = "Another Below Warning Tooltip with some info"
      ..theme = LTheme.C_THEME__WARNING;
    button = new LButton.neutral("btnR", "See Right");
    tt.showRight(button); // shows button
    buttonLine.add(tt);

    tt = new LTooltip()
      ..bodyText = "Another Below Tooltip with some info";
    button = new LButton.neutral("btnL", "See Left");
    tt.showLeft(button); // shows button
    buttonLine.add(tt);


    return div;
  }


  String get source {
    return '''
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
    ''';
  }
}
