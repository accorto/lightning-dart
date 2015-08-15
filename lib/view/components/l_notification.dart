/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Notification
 */
abstract class LNotification {


  static const String C_NOTIFY = "slds-notify";
  static const String C_NOTIFY__ALERT = "slds-notify--alert";
  static const String C_NOTIFY__CLOSE = "slds-notify__close";
  static const String C_NOTIFY_CONTAINER = "slds-notify-container";
  static const String C_NOTIFY__CONTENT = "notify__content";
  static const String C_NOTIFY__TOAST = "slds-notify--toast";

  static const String C_NOTIFY__SUCCESS = "slds-notify--success";
  static const String C_NOTIFY__WARNING = "slds-notify--warning";
  static const String C_NOTIFY__ERROR = "slds-notify--error";
  static const String C_NOTIFY__OFFLINE = "slds-notify--offline";


  static String lNotificationClose() => Intl.message("Close", name: "lNotificationClose", args: []);
  static String lNotificationAlert() => Intl.message("Alert (Info)", name: "lNotificationAlert", args: []);

  static String lNotificationWarning() => Intl.message("Warning", name: "lNotificationWarning", args: []);
  static String lNotificationSuccess() => Intl.message("Success", name: "lNotificationSuccess", args: []);
  static String lNotificationError() => Intl.message("Error", name: "lNotificationError", args: []);

  /// Notification Element
  DivElement get element;
  /// Notify - might be point to element
  DivElement get notify;

  /// Close button
  LButton close;
  ///content
  final DivElement content = new DivElement()
    ..classes.add(C_NOTIFY__CONTENT);
  /// Heading Element
  final HeadingElement h2 = new HeadingElement.h2();

  /**
   * Notification
   */
  LNotification(String label, LIcon icon, String idPrefix, String color, String assistiveText) {
    if (color != null && color.isNotEmpty)
      notify.classes.add(color);

    // assistive
    if (assistiveText == null) {
      if (color == LNotification.C_NOTIFY__SUCCESS)
        assistiveText = LNotification.lNotificationSuccess();
      else if (color == LNotification.C_NOTIFY__WARNING)
        assistiveText = LNotification.lNotificationWarning();
      else if (color == LNotification.C_NOTIFY__ERROR)
        assistiveText = LNotification.lNotificationError();
      else
        assistiveText = LNotification.lNotificationAlert();
    }
    if (assistiveText != null) {
      SpanElement span = new SpanElement()
        ..classes.add(LVisibility.C_ASSISTIVE_TEXT)
        ..text = assistiveText;
      notify.append(span);
    }

    // close
    close = new LButton("close", null, idPrefix:idPrefix,
      // button: slds-button slds-notify__close
      buttonClasses:[LButton.C_CLOSE, LButton.C_BUTTON__ICON__SMALL],
      icon: new LIconAction("close", size: LIcon.C_ICON__SMALL,
        // icon: slds-button__icon slds-button__icon--inverse "icon-text-email"
        addlCss: [LMargin.C_RIGHT__X_SMALL]),
        assistiveText: LNotification.lNotificationClose());
    close.onClick.listen((MouseEvent evt) {
      remove();
    });
    notify.append(close.element);
    // Heading
    if (icon != null) { // slds-icon icon-text-email slds-icon--small slds-m-right--x-small
      icon.classes.addAll([LIcon.C_ICON, LIcon.C_ICON__SMALL, LMargin.C_RIGHT__X_SMALL]);
    }
    notify.append(content);
    if (label != null)
      h2.appendText(label);
    content.append(h2); // in design: Alerts element.append(h2)
  } // LNotification


  /// Append Notification
  void add(Element e) {
    content.append(e);
  }


  void hide() {

  }

  /// Remove Alert
  void remove() {
    element.remove();
  }

} // LNotification



/**
 * Alert
 */
class LAlert extends LNotification {

  final DivElement element = new DivElement()
    ..classes.addAll([LNotification.C_NOTIFY, LNotification.C_NOTIFY__ALERT,
      LTheme.C_THEME__INVERSE_TEXT, LTheme.C_THEME__ALERT_TEXTURE])
    ..attributes[Html0.ROLE] = Html0.ROLE_ALERT;
  DivElement get notify => element;


  /// blue background
  LAlert.base(String label, {LIcon icon, String idPrefix, String assistiveText})
      : super(label, icon, idPrefix, null, assistiveText);
  /// green background
  LAlert.success(String label, {LIcon icon, String idPrefix, String assistiveText})
      : super(label, icon, idPrefix, LNotification.C_NOTIFY__SUCCESS, assistiveText);
  /// yellow background
  LAlert.warning(String label, {LIcon icon, String idPrefix, String assistiveText})
      : super(label, icon, idPrefix, LNotification.C_NOTIFY__WARNING, assistiveText);
  /// red background
  LAlert.error(String label, {LIcon icon, String idPrefix, String assistiveText})
      : super(label, icon, idPrefix, LNotification.C_NOTIFY__ERROR, assistiveText);
  /// grayblack background
  LAlert.offline(String label, {LIcon icon, String idPrefix, String assistiveText})
      : super(label, icon, idPrefix, LNotification.C_NOTIFY__OFFLINE, assistiveText);


} // LAlert


/**
 * Toast
 */
class LToast extends LNotification {

  /// Toast Element
  final DivElement element = new DivElement()
    ..classes.add(LNotification.C_NOTIFY_CONTAINER);

  final DivElement notify = new DivElement()
    ..classes.addAll([LNotification.C_NOTIFY, LNotification.C_NOTIFY__TOAST, LTheme.C_THEME__INVERSE_TEXT])
    ..attributes[Html0.ROLE] = Html0.ROLE_ALERT;


  /// blue background
  LToast.base(String label, {LIcon icon, String idPrefix, String assistiveText})
    : super(label, icon, idPrefix, null, assistiveText) {
    element.append(notify);
  }


} // LToast
