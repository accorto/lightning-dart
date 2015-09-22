/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart.demo;


class Images extends DemoFeature {

  Images() : super("images", "Images",
  sldsStatus: DemoFeature.SLDS_DEV_READY,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: [],
  issues: [],
  plans: []);

  LComponent get content {
    CDiv div = new CDiv()
      ..classes.add(LMargin.C_HORIZONTAL__MEDIUM);

    div.add(new LImage.srcXSmall("avatar1.jpg", "x-small"));
    div.add(new LImage.srcSmall("avatar1.jpg", "small"));
    div.add(new LImage.srcMedium("avatar1.jpg", "medium"));
    div.add(new LImage.srcLarge("avatar1.jpg", "large"));

    div.add(new LImage.srcXSmall("avatar2.jpg", "x-small", circle:false));
    div.add(new LImage.srcSmall("avatar2.jpg", "small", circle:false));
    div.add(new LImage.srcMedium("avatar2.jpg", "medium", circle:false));
    div.add(new LImage.srcLarge("avatar2.jpg", "large", circle:false));

    ImageElement img = new ImageElement(src: LImage.assetsSrc("avatar3.jpg"));
    div.add(new LImage.imgLarge(img));

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();

    div.add(new LImage.srcXSmall("avatar1.jpg", "x-small"));
    div.add(new LImage.srcSmall("avatar1.jpg", "small"));
    div.add(new LImage.srcMedium("avatar1.jpg", "medium"));
    div.add(new LImage.srcLarge("avatar1.jpg", "large"));

    div.add(new LImage.srcXSmall("avatar2.jpg", "x-small", circle:false));
    div.add(new LImage.srcSmall("avatar2.jpg", "small", circle:false));
    div.add(new LImage.srcMedium("avatar2.jpg", "medium", circle:false));
    div.add(new LImage.srcLarge("avatar2.jpg", "large", circle:false));

    ImageElement img = new ImageElement(src: LImage.assetsSrc("avatar3.jpg"));
    div.add(new LImage.imgLarge(img));
    ''';
  }

}
