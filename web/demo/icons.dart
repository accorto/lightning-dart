/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart.demo;

class Icons extends DemoFeature {

  Icons() : super("icons", "Icons",
  sldsStatus: DemoFeature.SLDS_PROTOTYPE,
  devStatus: DemoFeature.STATUS_COMPLETE,
  hints: ["different sizes of utility/action and standard (assume border)"],
  issues: [],
  plans: []);


  LComponent get content {
    CDiv div = new CDiv();

    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__X_SMALL));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__SMALL));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1));
    div.add(new LIconSpan.doctype(LIconDoctype.XML));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1));
    div.add(new LIconSpan.doctype(LIconDoctype.XML));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__LARGE));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__SMALL, circle:true));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, circle:true));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, circle:true));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, circle:true));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, circle:true));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, circle:true));

    return div;
  }

  String get source {
    return '''
    CDiv div = new CDiv();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__X_SMALL));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__X_SMALL));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__SMALL));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__SMALL));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1));
    div.add(new LIconSpan.doctype(LIconDoctype.XML));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1));
    div.add(new LIconSpan.doctype(LIconDoctype.XML));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__LARGE));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__LARGE));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, size:LIcon.C_ICON__SMALL, circle:true));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, size:LIcon.C_ICON__SMALL, circle:true));

    div.appendHrSmall();
    div.add(new LIconSpan.utility(LIconUtility.ANNOUNCEMENT, circle:true));
    div.add(new LIconSpan.action(LIconAction.DESCRIPTION, circle:true));
    div.add(new LIconSpan.standard(LIconStandard.ACCOUNT, circle:true));
    div.add(new LIconSpan.custom(LIconCustom.CUSTOM_1, circle:true));
    div.add(new LIconSpan.doctype(LIconDoctype.XML, circle:true));
    ''';
  }
}
