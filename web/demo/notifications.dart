/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Notifications extends DemoFeature {

  final PageSimple wrap;

  Notifications(PageSimple this.wrap) : super ("notifications", "Notifications",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["click x to dismiss"],
  issues: [],
  plans: ["callback that user dismissed"]);

  LComponent get content {
    CDiv div = new CDiv();
    div.add(new LAlert(label: "Base Alert"));

    div.add(new LAlert.notification(label: "Base Notification Alert"));
    div.add(new LAlert.info(label: "Base Info Alert"));
    div.add(new LAlert.success(label: "Base Success Alert"));
    div.add(new LAlert.warning(headingElements: [
      new SpanElement()..text = "Base Warning Alert ",
      new AnchorElement(href: "#")..text = "with link"
    ]));
    div.add(new LAlert.error(label: "Base Error Alert"));
    div.add(new LAlert.offline(label: "Base Offline Alert"));

    div.appendHR();
    div.add(new LToast(label: "Base Toast"));
    div.add(new LToast.notification(label: "Base Notification Toast"));
    div.add(new LToast.info(label: "Base Info Toast"));
    div.add(new LToast.success(label: "Base Success Toast"));
    div.add(new LToast.warning(label: "Base Warning Toast", text: "Some more text"));
    div.add(new LToast.error(addDefaultIcon: true,
      headingElements:[
        new SpanElement()..text = "Base Error Toast ",
        new AnchorElement(href: "#")..text = "with link"],
      contentElements: [
        new ParagraphElement()..text = "Some Detail comes here",
        new ParagraphElement()..text = "with even more Detail"
      ]));
    div.add(new LToast.offline(label: "Base Offline Toast", text: "More info here"));

    div.appendHR();
    LButton btnInfo = new LButton.neutral("nb", "Status Info Toast")
      ..classes.add(LMargin.C_LEFT__SMALL)
      ..onClick.listen((Event evt){
        StatusMessage sm = new StatusMessage.info("Status Info Message", "Info details", "true", "data details");
        wrap.setStatus(sm);
      });
    div.add(btnInfo);
    LButton btnSuccess = new LButton.neutral("nb", "Status Success Toast")
      ..classes.add(LMargin.C_LEFT__SMALL)
      ..onClick.listen((Event evt){
        StatusMessage sm = new StatusMessage.success("Status Success Message", "Success details", "true", "data details");
        wrap.setStatus(sm);
      });
    div.add(btnSuccess);
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
