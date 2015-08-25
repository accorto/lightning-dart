/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Notifications extends DemoFeature {

  Notifications() : super ("notifications", "Notifications", "Click to dismiss");

  LComponent get content {
    CDiv div = new CDiv();
    div.add(new LAlert(label: "Base Alert"));
    div.add(new LAlert.success(label: "Base Success Alert", addDefaultIcon: true));
    div.add(new LAlert.warning(headingElements: [
      new SpanElement()..text = "Base Warning Alert ",
      new AnchorElement(href: "#")..text = "with link"
    ]));
    div.add(new LAlert.error(label: "Base Error Alert"));
    div.add(new LAlert.offline(label: "Base Offline Alert", addDefaultIcon: true));

    div.add(new LToast(label: "Base Toast"));
    div.add(new LToast.success(label: "Base Success Toast", addDefaultIcon: true));
    div.add(new LToast.warning(label: "Base Warning Toast", text: "Some more text"));
    div.add(new LToast.error(addDefaultIcon: true,
      headingElements:[
        new SpanElement()..text = "Base Error Toast ",
        new AnchorElement(href: "#")..text = "with link"],
      contentElements: [
        new ParagraphElement()..text = "Some Detail comes here",
        new ParagraphElement()..text = "with even more Detail"
      ]));
    div.add(new LToast.offline(label: "Base Offline Toast", text: "More info here", addDefaultIcon: true));
    return div;
  }


  String get source {
    return '''
    CDiv div = new CDiv();
    div.add(new LAlert(label: "Base Alert"));
    div.add(new LAlert.success(label: "Base Success Alert", addDefaultIcon: true));
    div.add(new LAlert.warning(headingElements: [
      new SpanElement()..text = "Base Warning Alert ",
      new AnchorElement(href: "#")..text = "with link"
    ]));
    div.add(new LAlert.error(label: "Base Error Alert"));
    div.add(new LAlert.offline(label: "Base Offline Alert", addDefaultIcon: true));

    div.add(new LToast(label: "Base Toast"));
    div.add(new LToast.success(label: "Base Success Toast", addDefaultIcon: true));
    div.add(new LToast.warning(label: "Base Warning Toast", text: "Some more text"));
    div.add(new LToast.error(addDefaultIcon: true,
      headingElements:[
        new SpanElement()..text = "Base Error Toast ",
        new AnchorElement(href: "#")..text = "with link"],
      contentElements: [
        new ParagraphElement()..text = "Some Detail comes here",
        new ParagraphElement()..text = "with even more Detail"
      ]));
    div.add(new LToast.offline(label: "Base Offline Toast", text: "More info here", addDefaultIcon: true));
    ''';
  }

}
