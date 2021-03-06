/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import "package:lightning/lightning.dart";

/**
 * Stand alone Example Form
 */
main() async {

  await LightningDart.init(); // client env
  // The Form
  LForm form = new LForm.stacked("mc-embedded-subscribe-form")
    ..addEditor(new LInput("FNAME", EditorI.TYPE_TEXT)
      ..label = "First Name"
      ..placeholder = "Your First Name")
    ..addEditor(new LInput("LNAME", EditorI.TYPE_TEXT)
      ..label = "Last Name"
      ..placeholder = "Your Last Name")
    ..addEditor(new LInput("EMAIL", EditorI.TYPE_EMAIL)
      ..label = "Email"
      ..placeholder = "Your Email"
      ..required = true)
    ..addEditor(new LCheckbox("cool")
      ..label = "Lightning Dart is Cool!")
    /* html native select
    ..addEditor(new LSelect("interest")
      ..label = "Interest Area"
      ..listText = ["Lightning Dart", "Accorto", "Time+Expense", "Gantt"])
    */
    ..addEditor(new LPicklist("interest")
      ..label = "Interest Area"
      ..listText = ["Lightning Dart", "Accorto", "Time+Expense", "Gantt"])
    ..addEditor(new LTextArea("comments")
      ..label = "Comments")
      ..addResetButton()
      ..addSaveButton(label: "Subscribe", icon: new LIconUtility(LIconUtility.EMAIL));
  form.showTrace(info: "Trace: Enter your email and press Subscribe to test :-)"); // shows detail info
  // The Card
  LCard card = new LCard("exCard")
    ..setHeader(new LIconAction(LIconAction.RECORD), "Sign up for Lightning Dart Updates")
    ..addForm(form);
  // The Page
  PageSimple page = LightningDart.createPageSimple();
  page.add(card);

  // MailChimp
  form.method = "post";
  form.action = "//accorto.us1.list-manage.com/subscribe/post?u=60bc6eb9647e94e9c50548ce7&amp;id=243863cca2";

} // main
