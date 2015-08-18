/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

library lightning_dart.demo;

import 'dart:html';

import "package:lightning_dart/lightning_dart.dart";

part 'demo/demo_feature.dart';
part 'demo/activity_timeline.dart';
part 'demo/badges.dart';
part 'demo/breadcrumbs.dart';
part 'demo/buttons.dart';
part 'demo/button_groups.dart';

part 'demo/dropdowns.dart';

part 'demo/icons.dart';

part 'demo/tabs.dart';

/**
 * Lightning Demo Example Page
 */
void main() {

  LContainer page = LContainer.init(id: "demo", containerSize: LContainer.C_CONTAINER__LARGE)
    ..addHeader("Lightning Dart Tutorial");

  CDiv main = page.addDiv()
    ..classes.add("main")
    ..role = Html0.ROLE_MAIN;

  DivElement tocDiv = new DivElement();
  main.element.append(tocDiv);
  UListElement toc = new UListElement();
  tocDiv.append(toc);


  /*
  page.add(new ActivityTimeline()..toc(toc));
  page.add(new Badges()..toc(toc));
  page.add(new Breadcrumbs()..toc(toc));      */
  page.add(new Buttons()..toc(toc));
  page.add(new ButtonGroups()..toc(toc));

  page.add(new Dropdowns()..toc(toc));

  page.add(new Icons()..toc(toc));


  page.add(new Tabs()..toc(toc));





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

