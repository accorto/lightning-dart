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
part 'demo/notifications.dart';

part 'demo/picklists.dart';
part 'demo/pills.dart';
part 'demo/popovers.dart';

part 'demo/tabs.dart';
part 'demo/tooltips.dart';

part 'demo/themes.dart';

/**
 * Lightning Demo Example Page
 */
void main() {

  LightningDart.init() // client env
  .then((_){
    //
    LPage page = LPage.create();
    page.header
      ..classes.add(LGrid.C_CONTAINER__MEDIUM);
    page.header.h1
      ..text = "Lightning Dart Demo (alpha)"
      ..classes.add(LText.C_TEXT_HEADING__LARGE);
    ParagraphElement p = new ParagraphElement()
      ..classes.add(LMargin.C_VERTICAL__MEDIUM)
      ..text = "Please check out the different component implementations of the Salesforce Lightning Design System ";
    p.append(new AnchorElement(href: "https://www.lightningdesignsystem.com")
      ..text = "(SLDS)"
      ..target = "_blank");
    page.header.append(p);
    //
    p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL)
      ..text = "The current status is Alpha, so there might be a few things not working as expected. "
      "If you identified a bug, please help and report it via ";
    p.append(new AnchorElement(href: "https://github.com/accorto/lightning-dart/issues")
      ..text = "Github Isssues"
      ..target = "_blank");
    p.appendText(" with the following info:");
    page.header.append(p);
    UListElement ul = new UListElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL);
    page.header.append(ul);
    ul.append(new LIElement()..text = "* Browser+Platform (e.g. Sarari on iPod)");
    ul.append(new LIElement()..text = "* Type: Rendering off | Html elements/attributes wrong | Functianality bug");
    p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL)
      ..text = "We appreciate also suggestions and questions :-)";
    page.header.append(p);
    p = new ParagraphElement()
      ..classes.add(LMargin.C_TOP__MEDIUM)
      ..text = "Thanks.";
    page.header.append(p);
    //
    page.footer
      ..classes.add(LGrid.C_CONTAINER__MEDIUM);
    page.footer.h2
      ..text = "Lightning Dart version ${LightningDart.VERSION}";


    Element tocDiv = new Element.nav();
    page.append(tocDiv);
    tocDiv.append(new HeadingElement.h2()
      ..classes.add(LText.C_TEXT_HEADING__SMALL)
      ..text = "Components:");
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
    page.add(new Notifications()..toc(toc));
    // page headers
    page.add(new Picklists()..toc(toc));
    page.add(new Pills()..toc(toc));
    page.add(new Popovers()..toc(toc));
    // spinner
    page.add(new Tabs()..toc(toc));
    // tiles
    page.add(new Tooltips()..toc(toc));
    // trees

    page.add(new Themes()..toc(toc));

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

