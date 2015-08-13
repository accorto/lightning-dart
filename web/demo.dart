/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

library lightning_dart.demo;

import "package:lightning_dart/lightning_dart.dart";

/**
 * Lightning Demo Example Page
 */
void main() {

  LContainer page = LContainer.init(id: "demo", containerSize: LContainer.C_CONTAINER__LARGE)
    ..addHeader("Salesforce Design System Tutorial");

  CDiv main = page.appendDiv()
    ..classes.add("main")
    ..role = Html0.ROLE_MAIN;
  CSection section = main.appendSection()
    ..addHeading2("Components/Anchor", headingClasses:[LText.C_TEXT_HEADING__LARGE,
        LPadding.C_TOP__MEDIUM, LPadding.C_BOTTOM__MEDIUM]);

  LButtonGroup buttonGroup = new LButtonGroup()
    ..add(new LButton("a1","Action 1"))
    ..add(new LButton("a2", "Action 2"));
  LRecordTitle recordTitle = new LRecordTitle(new LIcon.standard(LIcon.STD_USER),
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


} // main

