/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;

class Media extends DemoFeature {

  Media() : super("media-objects", "Utility: Media Objects",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["image provided determines the size", "use images or icons"],
  issues: [],
  plans: []);

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);
    LMedia mo = new LMedia()
      ..setImageSrc("avatar1.jpg")
      ..append(new ParagraphElement()..text = "base - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("avatar2.jpg")
      ..center = true
      ..append(new ParagraphElement()..text = "center - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("avatar3.jpg")
      ..reverse = true
      ..append(new ParagraphElement()..text = "reverse - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("avatar1.jpg")
      ..setImageRightSrc("avatar2.jpg")
      ..append(new ParagraphElement()..text = "double - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("LightningDartLogoRotate.svg")
      ..responsive = true
      ..append(new ParagraphElement()..text = "responsive - some lengthy text or content - have to make thing longer, so that it works");
    div.add(mo);

    return div;
  }
  String get source {
    return '''
    CDiv div = new CDiv();
    LMedia mo = new LMedia()
      ..setImageSrc("avatar1.jpg")
      ..append(new ParagraphElement()..text = "base - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("avatar2.jpg")
      ..center = true
      ..append(new ParagraphElement()..text = "center - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("avatar3.jpg")
      ..reverse = true
      ..append(new ParagraphElement()..text = "reverse - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("avatar1.jpg")
      ..setImageRightSrc("avatar2.jpg")
      ..append(new ParagraphElement()..text = "double - some lengthy text or content");
    div.add(mo);
    mo = new LMedia()
      ..setImageSrc("LightningDartLogoRotate.svg")
      ..responsive = true
      ..append(new ParagraphElement()..text = "responsive - some lengthy text or content - have to make thing longer, so that it works");
    div.add(mo);
    ''';
  }

}
