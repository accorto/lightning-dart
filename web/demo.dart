/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

library lightning_dart.demo;

import 'dart:html';
import 'dart:async';

import "package:lightning/lightning_ctrl.dart";
export "package:lightning/lightning_ctrl.dart";

import 'exampleWorkspace.dart';


part 'demo/demo_feature.dart';
part 'demo/activity_timeline.dart';
part 'demo/badges.dart';
part 'demo/breadcrumbs.dart';
part 'demo/buttons.dart';
part 'demo/button_groups.dart';
part 'demo/cards.dart';
part 'demo/datepickers.dart';
part 'demo/feeds.dart';
part 'demo/forms.dart';
part 'demo/forms2.dart';
part 'demo/forms_editor.dart';
part 'demo/gridsystem.dart';
part 'demo/icons.dart';
part 'demo/images.dart';
part 'demo/lookups.dart';
part 'demo/media.dart';
part 'demo/menus.dart';
part 'demo/modals.dart';
part 'demo/notifications.dart';
part 'demo/pageheaders.dart';
part 'demo/pills.dart';
part 'demo/popovers.dart';
part 'demo/publishers.dart';
part 'demo/spinners.dart';
part 'demo/tables.dart';
part 'demo/tabs.dart';
part 'demo/tiles.dart';
part 'demo/trees.dart';

part 'demo/themes.dart';


/**
 * Intro Page (copy part of index)
 */
class IntroPage extends AppsPage {

  static const String NAME = "home";

  Element element = new DivElement();

  /// Into Page
  IntroPage()
      : super(NAME, NAME, new LIconUtility(LIconUtility.HOME),
          "Home", "Lightning Dart Home",
          defaultRoute:true) {
    /// add index part
    Element ld = querySelector("#ld");
    if (ld != null)
      element.append(ld);
  }
} // IntroPage


/**
 * Demo Page
 */
class DemoPage extends AppsPage {

  Element element = new DivElement();

  DemoPage(String id, LIcon icon, String label, PageSimple wrap)
      : super(id, id, icon, label, "Lightning Dart Component Demo ${label}") {
    DivElement hdr = new DivElement()
      ..classes.addAll([LTheme.C_BOX, LTheme.C_THEME__SHADE]);
    element.append(hdr);
    HeadingElement h2 = new HeadingElement.h2()
      ..classes.add(LText.C_TEXT_HEADING__LARGE)
      ..text = "Component Demo";
    hdr.append(h2);
    ParagraphElement p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__REGULAR)
      ..text = "Check out the individual UI Components with their SLDS (Salesforce Lightning Design System) status and the Lightning Dart implementation status";
    hdr.append(p);
    p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__REGULAR)
      ..text = "The components are displayed without any horizontal/verical spacing, which is provided by the container.";
    hdr.append(p);
    p = new ParagraphElement()
      ..classes.add(LText.C_TEXT_BODY__SMALL)
      ..text = "Version: ${LightningDart.VERSION} - ${LightningDart.devTimestamp}";
    hdr.append(p);

    Element toc = new Element.nav()
      ..classes.addAll([LGrid.C_GRID, LGrid.C_WRAP]);
    element.append(toc);

    /* Individual parts */
    add(new ActivityTimeline()..toc(toc));
    add(new Badges()..toc(toc));
    add(new Breadcrumbs()..toc(toc));
    add(new Buttons()..toc(toc));
    add(new ButtonGroups()..toc(toc));
    add(new Cards()..toc(toc));
    add(new Tables()..toc(toc));
    add(new Datepickers()..toc(toc));
    add(new Feeds()..toc(toc));
    add(new Forms()..toc(toc));
    add(new Forms2()..toc(toc));
    add(new FormsEditor()..toc(toc));
    add(new GridSystem()..toc(toc));
    add(new Icons()..toc(toc));
    add(new Images()..toc(toc));
    add(new Lookups()..toc(toc));
    add(new Media()..toc(toc));
    add(new Menus()..toc(toc));
    add(new Modals()..toc(toc));
    add(new Notifications(wrap)..toc(toc));
    add(new PageHeaders()..toc(toc));
    add(new Pills()..toc(toc));
    add(new Popovers()..toc(toc));
    add(new Publishers()..toc(toc));
    add(new Spinners()..toc(toc));
    add(new Tabs()..toc(toc));
    add(new Tiles()..toc(toc));
    add(new Trees()..toc(toc));

    add(new Themes()..toc(toc));
  }
} // Demo Page


/**
 * Demo Frame ... includes demo page
 */
class DemoFrame extends AppsPage {

  final IFrameElement element = new IFrameElement();

  DemoFrame(String id, LIcon icon, String label, int width)
      : super(id, id, icon, label, "Lightning Dart ${label}") {
    element
      ..src = "demo.html"
      ..width = "${width}px"
      ..height = "1000px";
  }

} // DemoFrame


/**
 * Example Signup Form Frame
 */
class ExampleForm extends AppsPage {

  static final LIcon formIcon = new LIconAction(LIconAction.RECORD);

  final IFrameElement element = new IFrameElement();

  ExampleForm() : super ("form", "form", formIcon, "Form", "Lightning Dart Form Exmaple") {
    element
      ..src = "exampleForm.html"
      ..width = "100%"
      ..height = "1000px";
  }

} // ExampleForm


/**
 * Example Workbench Form Frame
 */
class ExampleWorkspace extends AppsPage {

  static final LIcon formIcon = new LIconAction(LIconAction.FLOW);

  Element element = new DivElement();

  ExampleWorkspace() : super ("wb", "wb", formIcon, "Workspace", "Lightning Dart Workspace Exmaple") {
    WorbenchData wbData = new WorbenchData();
    ObjectCtrl ctrl = new ObjectCtrl(wbData);
    element.append(ctrl.element);
  } // ExampleWorkspace

} // ExampleWorkspace


/**
 * Support Link
 */
class SupportLink extends AppsPage {

  static final LIcon supportIcon = new LIconAction(LIconAction.NEW_CUSTOM86);

  final DivElement element = new DivElement();

  SupportLink() : super("support", "support", supportIcon, "Doc + Support", "Lightning Dart Support",
    externalHref: "http://lightning.accorto.com", target: "_blank");

}
