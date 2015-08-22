/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

library lightning_dart.demo;

import 'dart:html';

import "package:lightning_dart/lightning_dart.dart";
import "package:logging/logging.dart";

part 'demo/demo_feature.dart';
part 'demo/activity_timeline.dart';
part 'demo/badges.dart';
part 'demo/breadcrumbs.dart';
part 'demo/buttons.dart';
part 'demo/button_groups.dart';

part 'demo/dropdowns.dart';
part 'demo/forms.dart';
part 'demo/icons.dart';
part 'demo/images.dart';
part 'demo/lookups.dart';

part 'demo/picklists.dart';
part 'demo/pills.dart';

part 'demo/tabs.dart';

/**
 * Lightning Demo Example Page
 */
void main() {

  LightningDart.init() // client env
  .then((_){
    //
    LContainer page = LContainer.create(id: "demo",
        containerSize: LGrid.C_CONTAINER__LARGE,
        containerHAlign: LGrid.C_CONTAINER__CENTER);
    LHeader hdr = page.addHeader("Lightning Dart Demo (alpha)");
    ParagraphElement p = new ParagraphElement()
      ..text = "Please check out the different component implementations of the Salesforce Lightning Design System ";
    p.append(new AnchorElement(href: "https://www.lightningdesignsystem.com")
      ..text = "(SLDS)"
      ..target = "_blank");
    hdr.append(p);
    //
    p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL)
      ..text = "The current status is Alpha, so there might be a few things not working as expected. "
      "If you identified a bug, please report it via ";
    p.append(new AnchorElement(href: "https://github.com/accorto/lightning-dart/issues")
      ..text = "Github Isssues for Lightning Dart"
      ..target = "_blank");
    p.appendText(" and provide the following info:");
    hdr.append(p);
    UListElement ul = new UListElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL);
    hdr.append(ul);
    ul.append(new LIElement()..text = "* Browser+Platform (e.g. Sarari on iPod)");
    ul.append(new LIElement()..text = "* Type: Rendering off | Html elements/attributes wrong | Functianality bug");
    p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL)
      ..text = "We appreciate also suggestions and questions :-)";
    hdr.append(p);
    p = new ParagraphElement()
      ..text = "Thanks.";
    hdr.append(p);


    CDiv main = page.addDiv()
      ..classes.add("main")
      ..role = Html0.ROLE_MAIN;

    DivElement tocDiv = new DivElement();
    main.element.append(tocDiv);
    UListElement toc = new UListElement()
      ..classes.addAll([LMargin.C_TOP__MEDIUM, LList.C_LIST__VERTICAL, LList.C_HAS_BLOCK_LINKS]);
    tocDiv.append(toc);

    /* Individual parts */
    //page.add(new ActivityTimeline()..toc(toc));
    page.add(new Badges()..toc(toc));
    page.add(new Breadcrumbs()..toc(toc));
    page.add(new Buttons()..toc(toc));
    page.add(new ButtonGroups()..toc(toc));
    // Card
    // data tables
    // datepickers
    page.add(new Dropdowns()..toc(toc));
    page.add(new Forms()..toc(toc));
    page.add(new Icons()..toc(toc));
    page.add(new Images()..toc(toc));
    page.add(new Lookups()..toc(toc));
    // media
    // modal
    // notification
    // page headers
    page.add(new Picklists()..toc(toc));
    page.add(new Pills()..toc(toc));
    // popover
    // spinner
    page.add(new Tabs()..toc(toc));
    // tiles
    // tooltips
    // trees

    page.addFooter("Lightning Dart");
  });


  /**
  CDiv main = page.appendDiv()
    ..classes.add("main")
    ..role = Html0.ROLE_MAIN;
  CSection section = main.appendSection()
    ..addHeading2("Components/Anchor", headingClasses:[LText.C_TEXT_HEADING__LARGE,
        LPadding.C_TOP__MEDIUM, LPadding.C_BOTTOM__MEDIUM]);

  LButtonGroup buttonGroup = new LButtonGroup()
    ..add(new LButton("a1","Action 1"))
    ..add(new LButton("a2", "Action 2"));
  LRecordTitle recordTitle = new LRecordTitle(new LIconStandard(LIconStandard.STD_USER),
    recordType: "Record Type", recordTitle: "Record Title", buttonGroup: buttonGroup);
  section.append(recordTitle);


  LFooter footer = page.addFooter("Core/Grid")
    ..addFooterClasses([LPadding.C_TOP__X_LARGE, LPadding.C_BOTTOM__X_LARGE])
    ..addHeadingClasses([LText.C_TEXT_HEADING__LARGE, LPadding.C_TOP__X_LARGE, LPadding.C_BOTTOM__X_LARGE]);

  LGrid footerGrid = new LGrid.div()
    ..addGridClass(LGrid.C_GRID__ALIGN_SPREAD)
    ..appendParagraph("Footer Col 1: Salesforce Design System tutorial")
    ..appendParagraph("Footer Col 2: Salesforce Design System tutorial");
  footer.append(footerGrid);
  */

} // main

