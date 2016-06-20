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


part 'demo/demo_feature.dart';
part 'demo/demo_data.dart';
part 'demo/ui_util_demo.dart';

part 'demo/activity_timeline.dart';
part 'demo/badges.dart';
part 'demo/breadcrumbs.dart';
part 'demo/buttons.dart';
part 'demo/button_groups.dart';
part 'demo/cards.dart';
part 'demo/card_panels.dart';
part 'demo/datepickers.dart';
part 'demo/datetimes.dart';
part 'demo/docked_composers.dart';
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
part 'demo/processes.dart';
part 'demo/popovers.dart';
part 'demo/publishers.dart';
part 'demo/spinners.dart';
part 'demo/tables.dart';
part 'demo/tables_graphs.dart';
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

  /// The Element
  Element element = new DivElement();

  final LCheckbox _onlySelectedCb = new LCheckbox("onlySelected", idPrefix: "demo")
    ..label = "Show only selected components";
  final List<DemoFeature> _featureList = new List<DemoFeature>();

  /// Demo Page
  DemoPage(String id, LIcon icon, String label, PageSimple wrap)
      : super(id, id, icon, label,
        "Lightning Dart Component Demo ${label}") {
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
    //
    _sizes = new LButtonGroup();
    _sizes.addButton(new LButton.iconBorder("small",
        new LIconUtility(LIconUtility.PHONE_PORTRAIT), "Small 480px", idPrefix: "size")
      ..onClick.listen((MouseEvent evt){setSizeIndex(0);}));
    _sizes.addButton(new LButton.iconBorder("medium",
        new LIconUtility(LIconUtility.TABLET_PORTRAIT), "Medium 768px", idPrefix: "size")
      ..onClick.listen((MouseEvent evt){setSizeIndex(1);}));
    _sizes.addButton(new LButton.iconBorder("large",
        new LIconUtility(LIconUtility.TABLET_LANDSCAPE), "Large 1024px", idPrefix: "size")
      ..onClick.listen((MouseEvent evt){setSizeIndex(2);}));
    _sizes.addButton(new LButton.iconBorder("fluid",
        new LIconUtility(LIconUtility.DESKTOP), "Fluid", idPrefix: "size")
      ..onClick.listen((MouseEvent evt){setSizeIndex(3);}));
    //
    _onlySelectedCb.onClick.listen(onClickOnlySelected);
    DivElement dd = new DivElement()
      ..classes.addAll([LGrid.C_GRID, LMargin.C_HORIZONTAL__SMALL])
      ..append(new DivElement()
          ..classes.addAll([LGrid.C_COL])
          ..append(_sizes.element))
      ..append(new DivElement()
          ..classes.addAll([LGrid.C_COL])
          ..append(_onlySelectedCb.element));
    element.append(dd);

    /* Individual parts */
    _addFeature(new ActivityTimeline()..toc(toc, onlySelectedHide));
    _addFeature(new Badges()..toc(toc, onlySelectedHide));
    _addFeature(new Breadcrumbs()..toc(toc, onlySelectedHide));
    _addFeature(new Buttons()..toc(toc, onlySelectedHide));
    _addFeature(new ButtonGroups()..toc(toc, onlySelectedHide));
    _addFeature(new Cards()..toc(toc, onlySelectedHide));
    _addFeature(new CardPanels()..toc(toc, onlySelectedHide));
    _addFeature(new Tables()..toc(toc, onlySelectedHide));
    _addFeature(new TablesGraphs()..toc(toc, onlySelectedHide));
    _addFeature(new Datepickers()..toc(toc, onlySelectedHide));
    _addFeature(new DateTimes()..toc(toc, onlySelectedHide));
    _addFeature(new DockedComposers()..toc(toc, onlySelectedHide));
    _addFeature(new Feeds()..toc(toc, onlySelectedHide));
    _addFeature(new Forms()..toc(toc, onlySelectedHide));
    _addFeature(new Forms2()..toc(toc, onlySelectedHide));
    _addFeature(new FormsEditor()..toc(toc, onlySelectedHide));
    _addFeature(new GridSystem()..toc(toc, onlySelectedHide));
    _addFeature(new Icons()..toc(toc, onlySelectedHide));
    _addFeature(new Images()..toc(toc, onlySelectedHide));
    _addFeature(new Lookups()..toc(toc, onlySelectedHide));
    _addFeature(new Menus()..toc(toc, onlySelectedHide));
    _addFeature(new Modals()..toc(toc, onlySelectedHide));
    _addFeature(new Notifications(wrap)..toc(toc, onlySelectedHide));
    _addFeature(new PageHeaders()..toc(toc, onlySelectedHide));
    _addFeature(new Pills()..toc(toc, onlySelectedHide));
    _addFeature(new Processes()..toc(toc, onlySelectedHide));
    _addFeature(new Popovers()..toc(toc, onlySelectedHide));
    _addFeature(new Publishers()..toc(toc, onlySelectedHide));
    _addFeature(new Spinners()..toc(toc, onlySelectedHide));
    _addFeature(new Tabs()..toc(toc, onlySelectedHide));
    _addFeature(new Tiles()..toc(toc, onlySelectedHide));
    _addFeature(new Trees()..toc(toc, onlySelectedHide));

    _addFeature(new Media()..toc(toc, onlySelectedHide));
    _addFeature(new Themes()..toc(toc, onlySelectedHide));
    //
    setSizeIndex(1); // medium
  } // DemoPage
  LButtonGroup _sizes;

  void _addFeature(DemoFeature feature) {
    _featureList.add(feature);
    add(feature);
  }

  /// Click on Selected Cb
  void onClickOnlySelected(Event evt) {
    onlySelected = _onlySelectedCb.checked;
  }
  /// Show obny Selected
  bool get onlySelected => _onlySelectedCb.checked;
  /// Show only Selected
  void set onlySelected(bool newValue) {
    _onlySelectedCb.checked = newValue;
    for (DemoFeature feature in _featureList) {
      feature.show = !newValue;
    }
  }
  /// hide all if only selected
  void onlySelectedHide() {
    if (onlySelected) {
      for (DemoFeature feature in _featureList) {
        feature.show = false;
      }
    }
  }

  /// Set Size Tab Index
  void setSizeIndex(int sizeIndex) {
    _sizes.selectButton(sizeIndex);
    for (DemoFeature feature in _featureList) {
      feature.tabPos = sizeIndex;
    }
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

  ExampleForm() : super ("form", "form", formIcon, "Form", "Lightning Dart Form Example") {
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
  ObjectCtrl ctrl;

  ExampleWorkspace() : super ("wb", "wb", formIcon, "Workspace", "Lightning Dart Workspace Example") {
    DemoData datasource = new DemoData()
      ..setCount = 1;
    ctrl = new ObjectCtrl(datasource);
    element.append(ctrl.element);
  } // ExampleWorkspace

  void showingNow() {
    ctrl.showingNow();
  }

} // ExampleWorkspace


/**
 * Support Link
 */
class SupportLink extends AppsPage {

  static final LIcon supportIcon = new LIconUtility(LIconUtility.HELP);

  final DivElement element = new DivElement();

  SupportLink() : super("support", "support", supportIcon,
      "Doc + Support", "Lightning Dart Support",
      externalHref: "http://lightning.accorto.com", // support
      target: NewWindow.TARGET_BLANK);

}
