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
        containerHAlign: LGrid.C_CONTAINER__CENTER)
      ..addHeader("Lightning Dart Tutorial (alpha)");

    CDiv main = page.addDiv()
      ..classes.add("main")
      ..role = Html0.ROLE_MAIN;

    DivElement tocDiv = new DivElement();
    main.element.append(tocDiv);
    UListElement toc = new UListElement()
      ..classes.addAll([LMargin.C_TOP__MEDIUM, LList.C_LIST__VERTICAL, LList.C_HAS_BLOCK_LINKS]);
    tocDiv.append(toc);

    /* Individual parts */
    page.add(new ActivityTimeline()..toc(toc));
    page.add(new Badges()..toc(toc));
    page.add(new Breadcrumbs()..toc(toc));
    page.add(new Buttons()..toc(toc));
    page.add(new ButtonGroups()..toc(toc));
    // Card
    // data tables
    // datepickers
    page.add(new Dropdowns()..toc(toc));
    // forms
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

