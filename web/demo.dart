/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

library lightning_dart.demo;

import 'dart:html';

import "package:lightning/lightning.dart";
export "package:lightning/lightning.dart";

part 'demo/demo_feature.dart';
part 'demo/activity_timeline.dart';
part 'demo/badges.dart';
part 'demo/breadcrumbs.dart';
part 'demo/buttons.dart';
part 'demo/button_groups.dart';
part 'demo/cards.dart';

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
 * Intro Page (copy part of index)
 */
class IntroPage extends PageEntry {

  Element element = new DivElement();

  IntroPage() : super("intro", new LIconUtility(LIconUtility.HOME), "Home") {
    DivElement ld = querySelector("#ld");
    if (ld != null)
      element.append(ld);
  }

} // IntroPage


/**
 * Demo Page
 */
class DemoPage extends PageEntry {

  Element element = new DivElement();

  DemoPage(String id, LIcon icon, String label) : super(id, icon, label) {
    DivElement hdr = new DivElement()
      ..classes.addAll([LTheme.C_BOX, LTheme.C_THEME__SHADE]);
    element.append(hdr);
    HeadingElement h2 = new HeadingElement.h2()
      ..classes.add(LText.C_TEXT_HEADING__MEDIUM)
      ..text = "Component Demo";
    hdr.append(h2);

    Element toc = new Element.nav()
      ..classes.addAll([LGrid.C_GRID, LGrid.C_WRAP]);
    element.append(toc);

    /* Individual parts */
    //page.add(new ActivityTimeline()..toc(toc));
    add(new Badges()..toc(toc));
    add(new Breadcrumbs()..toc(toc));
    add(new Buttons()..toc(toc));
    add(new ButtonGroups()..toc(toc));
    add(new Cards()..toc(toc));
    // data tables
    // datepickers
    add(new Dropdowns()..toc(toc));
    add(new Forms()..toc(toc));
    add(new Icons()..toc(toc));
    add(new Images()..toc(toc));
    add(new Lookups()..toc(toc));
    // media
    // modal
    add(new Notifications()..toc(toc));
    // page headers
    add(new Picklists()..toc(toc));
    add(new Pills()..toc(toc));
    add(new Popovers()..toc(toc));
    // spinner
    add(new Tabs()..toc(toc));
    // tiles
    add(new Tooltips()..toc(toc));
    // trees

    add(new Themes()..toc(toc));

  }

} // Demo Page


class DemoFrame extends PageEntry {

  final IFrameElement element = new IFrameElement();

  DemoFrame(String id, LIcon icon, String label, int width) : super(id, icon, label) {
    element
      ..name = id
      ..src = "demo.html"
      ..width = "${width}px"
      ..height = "1000px";

  }

} // DemoFrame


