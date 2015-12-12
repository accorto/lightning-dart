/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Notification
 */
abstract class LNotification extends LComponent {

  /// slds-notify - Initializes notification | Required
  static const String C_NOTIFY = "slds-notify";
  /// slds-notify-container - Initializes notification container | Required
  static const String C_NOTIFY_CONTAINER = "slds-notify-container";
  /// slds-notify--toast - Initializes toast notification | Required
  static const String C_NOTIFY__TOAST = "slds-notify--toast";
  /// slds-notify--alert - Initializes alert notification | Required
  static const String C_NOTIFY__ALERT = "slds-notify--alert";
  /// slds-notify__close - Positions close icon | Required
  static const String C_NOTIFY__CLOSE = "slds-notify__close";
  /// slds-modal--prompt - Initializes Prompt style notification | Required
  static const String C_MODAL__PROMPT = "slds-modal--prompt";

  /// Marker
  static const String C_NOTIFY__CONTENT = "notify__content";


  /**
   * Create Default Icon for color/theme
   */
  static LIcon createDefaultIcon(String color, {bool setIconColor:false}) {
    if (color == LTheme.C_THEME__ALT_INVERSE) {
      return new LIconUtility(LIconUtility.INFO,
          color: setIconColor ? color : null);
    }
    else if (color == LTheme.C_THEME__SUCCESS) {
      return new LIconUtility(LIconUtility.SUCCESS,
          color: setIconColor ? LIcon.C_ICON_TEXT_SUCCESS : null);
    }
    else if (color == LTheme.C_THEME__WARNING) {
      return new LIconUtility(LIconUtility.WARNING,
          color: setIconColor ? LIcon.C_ICON_TEXT_WARNING : null);
    }
    else if (color == LTheme.C_THEME__ERROR) {
      return new LIconUtility(LIconUtility.ERROR,
          color: setIconColor ? LIcon.C_ICON_TEXT_ERROR : null);
    }
    else if (color == LTheme.C_THEME__OFFLINE) {
      return new LIconUtility(LIconUtility.OFFLINE,
          color: setIconColor ? LIcon.C_ICON_TEXT_DEFAULT : null);
    }
    return new LIconUtility(LIconUtility.NOTIFICATION,
        color: setIconColor ? LIcon.C_ICON_TEXT_DEFAULT : null);
  }


  static String lNotificationClose() => Intl.message("Close", name: "lNotificationClose", args: []);
  static String lNotificationAlert() => Intl.message("Alert (Info)", name: "lNotificationAlert", args: []);

  static String lNotificationWarning() => Intl.message("Warning", name: "lNotificationWarning", args: []);
  static String lNotificationSuccess() => Intl.message("Success", name: "lNotificationSuccess", args: []);
  static String lNotificationError() => Intl.message("Error", name: "lNotificationError", args: []);

  /// Notification Element
  DivElement get element {
    if (container == null)
      return notify;
    return container;
  }
  /// Notify - alert/toast element
  DivElement get notify;
  /// Container Element
  DivElement get container;

  /// Theme
  String _color;
  /// Close button
  LButton close;

  /**
   * Notification
   */
  LNotification(String idPrefix, String color) {
    _color = color;
    if (_color != null && _color.isNotEmpty)
      notify.classes.add(color);

    // close
    close = new LButton(new ButtonElement(), "close", null, idPrefix:idPrefix,
      // button: slds-button slds-notify__close
      buttonClasses:[C_NOTIFY__CLOSE],
      icon: new LIconAction("close", colorOverride: LButton.C_BUTTON__ICON__INVERSE),
        assistiveText: LNotification.lNotificationClose());
    close.iconButton = false;
    close.onClick.listen(onCloseClick);
  } // LNotification

  /// Assistive Text
  String get assistiveText {
    if (_assistiveText == null) {
      if (_color == LTheme.C_THEME__SUCCESS)
        return LNotification.lNotificationSuccess();
      else if (_color == LTheme.C_THEME__WARNING)
        return LNotification.lNotificationWarning();
      else if (_color == LTheme.C_THEME__ERROR)
        return LNotification.lNotificationError();
      else
        return LNotification.lNotificationAlert();
    }
    return _assistiveText;
  }
  void set assistiveText (String newValue) {
    _assistiveText = newValue;
    build();
  }
  String _assistiveText;

  List<Element> _headingElements;
  String _headingText = "";
  LIcon _icon;


  /**
   * span .assistiveText
   * button
   * - svg close
   * - .assistiveText
   */
  void build() {
    notify.children.clear();
    String at = assistiveText;
    if (at != null && at.isNotEmpty) {
      SpanElement span = new SpanElement()
        ..classes.add(LVisibility.C_ASSISTIVE_TEXT)
        ..text = at;
      notify.append(span);
    }
    notify.append(close.element);
  }

  /// Close clicked - Remove Alert
  void onCloseClick(MouseEvent evt) {
    element.remove();
  }

  /// show
  void show (Element parent, {int autohideSeconds}) {
    parent.append(element);
    if (autohideSeconds != null && autohideSeconds > 0) {
      new Timer(new Duration(seconds: autohideSeconds), (){
        element.remove();
      });
    }
  } // show

  /// show
  void showCenter (Element parent, {int autohideSeconds}) {
    Rectangle rectParent = parent.getBoundingClientRect();
    parent.append(element); // to calc position
    Rectangle rectElement = element.getBoundingClientRect();
    double top = (rectParent.height/2) - (rectElement.height/2);
    double left = (rectParent.width/2) - (rectElement.width/2);
    element.style
      ..position = "absolute"
      ..top = "${top}px"
      ..left = "${left}px"
      ..removeProperty("right")
      ..removeProperty("bottom");
    show(parent, autohideSeconds:autohideSeconds);
  } // show

  /**
   * Show Bottom Right in parent or window
   */
  void showBottomRight (Element parent, {int autohideSeconds, bool onWindow:true}) {
    element.style
      ..position = "absolute"
      ..bottom = "0"
      ..right = "0"
      ..removeProperty("top")
      ..removeProperty("left");
    show(parent, autohideSeconds:autohideSeconds);

    Rectangle thisRect = element.getBoundingClientRect();
    if (onWindow) {
      int winH = window.innerHeight;
      int winScrollY = window.scrollY;
      int top = winH - thisRect.height + winScrollY - 10; // margin
      element.style
        ..top = "${top}px"
        ..removeProperty("bottom");
    }
    // fit onto screen
    int winW = window.innerWidth;
    if (thisRect.width > winW) {
      // print("element=${element.getBoundingClientRect().width} - window=${window.innerWidth}");
      element.style.left = "0";
    }
  } // show

  /// Hide Notification
  void hide() {
    element.remove();
  }

} // LNotification



/**
 * Alert
 */
class LAlert extends LNotification {

  /// Container Element
  DivElement container;

  /// Alert Element
  final DivElement notify = new DivElement()
    ..classes.addAll([LNotification.C_NOTIFY, LNotification.C_NOTIFY__ALERT,
        LTheme.C_THEME__INVERSE_TEXT, LTheme.C_THEME__ALERT_TEXTURE])
    ..attributes[Html0.ROLE] = Html0.ROLE_ALERT;


  /// blue background
  LAlert({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String assistiveText, bool addDefaultIcon: false, bool inContainer: false, String color})
    : super(idPrefix, color) {
    if (inContainer) {
      container = new DivElement();
      container.append(notify);
    }
    close.icon.classes.add(LIcon.C_ICON__X_SMALL);

    _assistiveText = assistiveText;
    _headingText = label;
    _headingElements = headingElements;

    // Icon
    _icon = icon;
    if (_icon == null && addDefaultIcon) {
      _icon = LNotification.createDefaultIcon(color);
    }
    if (_icon != null) {
      _icon.classes.addAll([LIcon.C_ICON, LIcon.C_ICON__SMALL, LMargin.C_RIGHT__X_SMALL]);
    }
    build();
  }
  /// green background
  LAlert.success({String label, List<Element> headingElements, String idPrefix,
        LIcon icon,  String assistiveText, bool addDefaultIcon: true})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
        assistiveText:assistiveText, addDefaultIcon:addDefaultIcon, color:LTheme.C_THEME__SUCCESS);
  /// blue background
  LAlert.info({String label, List<Element> headingElements, String idPrefix,
        LIcon icon,  String assistiveText, bool addDefaultIcon: true})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
        assistiveText:assistiveText, addDefaultIcon:addDefaultIcon, color:LTheme.C_THEME__ALT_INVERSE);
  /// blue background
  LAlert.notification({String label, List<Element> headingElements, String idPrefix,
        LIcon icon,  String assistiveText, bool addDefaultIcon: true})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
        assistiveText:assistiveText, addDefaultIcon:addDefaultIcon);
  /// yellow background
  LAlert.warning({String label, List<Element> headingElements, String idPrefix,
        LIcon icon,  String assistiveText, bool addDefaultIcon: true})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
        assistiveText:assistiveText, addDefaultIcon:addDefaultIcon, color:LTheme.C_THEME__WARNING);
  /// red background
  LAlert.error({String label, List<Element> headingElements, String idPrefix,
        LIcon icon,  String assistiveText, bool addDefaultIcon: true})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
        assistiveText:assistiveText, addDefaultIcon:addDefaultIcon, color:LTheme.C_THEME__ERROR);
  /// grayblack background
  LAlert.offline({String label, List<Element> headingElements, String idPrefix,
      LIcon icon,  String assistiveText, bool addDefaultIcon: true})
  : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
      assistiveText:assistiveText, addDefaultIcon:addDefaultIcon, color:LTheme.C_THEME__OFFLINE);

  /// build
  void build() {
    super.build();
    // Simple text heading content
    HeadingElement h2 = new HeadingElement.h2();
    if (_icon != null) {
      h2.append(_icon.element);
    }
    if (_headingElements != null && _headingElements.isNotEmpty) {
      for (Element ele in _headingElements)
        h2.append(ele);
    } else if (_headingText != null){
      h2.appendText(_headingText);
    }
    notify.append(h2);
  } // build


} // LAlert



/**
 * Toast
 */
class LToast extends LNotification {

  /// Container Element
  DivElement container;

  /// Toast Element
  final DivElement notify = new DivElement()
    ..classes.addAll([LNotification.C_NOTIFY, LNotification.C_NOTIFY__TOAST, LTheme.C_THEME__INVERSE_TEXT])
    ..attributes[Html0.ROLE] = Html0.ROLE_ALERT;

  final DivElement _content = new DivElement()
    ..classes.add(LNotification.C_NOTIFY__CONTENT);

  /// blue background
  LToast({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String text, List<Element> contentElements,
      String assistiveText, bool addDefaultIcon: false,
      bool inContainer: false, String color})
    : super(idPrefix, color) {
    if (inContainer) {
      container = new DivElement()
        ..classes.add(LNotification.C_NOTIFY_CONTAINER);
      container.append(notify);
    }
    _assistiveText = assistiveText;
    _headingText = label;
    _headingElements = headingElements;
    _contentText = text;
    _contentElements = contentElements;
    // Icon
    _icon = icon;
    if (_icon == null && addDefaultIcon) {
      _icon = LNotification.createDefaultIcon(color);
    }
    if (_icon != null) {
      _icon.classes.addAll([LIcon.C_ICON, LIcon.C_ICON__SMALL, LMargin.C_RIGHT__X_SMALL, LGrid.C_GROW_NONE]);
    }
    build();
  } // LToast



  /// green background
  LToast.success({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String text, List<Element> contentElements, String assistiveText, bool addDefaultIcon: true,
      bool inContainer: false})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
      text:text, contentElements:contentElements, assistiveText:assistiveText, addDefaultIcon:addDefaultIcon,
      inContainer:inContainer, color:LTheme.C_THEME__SUCCESS);

  /// yellow background
  LToast.warning({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String text, List<Element> contentElements, String assistiveText, bool addDefaultIcon: true,
      bool inContainer: false})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
      text:text, contentElements:contentElements, assistiveText:assistiveText, addDefaultIcon:addDefaultIcon,
      inContainer:inContainer, color:LTheme.C_THEME__WARNING);

  /// red background
  LToast.error({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String text, List<Element> contentElements, String assistiveText, bool addDefaultIcon: true,
      bool inContainer: false})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
      text:text, contentElements:contentElements, assistiveText:assistiveText, addDefaultIcon:addDefaultIcon,
      inContainer:inContainer, color:LTheme.C_THEME__ERROR);

  /// brown background
  LToast.offline({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String text, List<Element> contentElements, String assistiveText, bool addDefaultIcon: true,
      bool inContainer: false})
    : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
      text:text, contentElements:contentElements, assistiveText:assistiveText, addDefaultIcon:addDefaultIcon,
      inContainer:inContainer, color:LTheme.C_THEME__OFFLINE);

  /// dark blue background
  LToast.info({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String text, List<Element> contentElements, String assistiveText, bool addDefaultIcon: true,
      bool inContainer: false})
  : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
      text:text, contentElements:contentElements, assistiveText:assistiveText, addDefaultIcon:addDefaultIcon,
      inContainer:inContainer, color:LTheme.C_THEME__ALT_INVERSE);

  /// pale blue background
  LToast.notification({String label, List<Element> headingElements, String idPrefix, LIcon icon,
      String text, List<Element> contentElements, String assistiveText, bool addDefaultIcon: true,
      bool inContainer: false})
  : this(label:label, headingElements:headingElements, idPrefix:idPrefix, icon:icon,
      text:text, contentElements:contentElements, assistiveText:assistiveText, addDefaultIcon:addDefaultIcon,
      inContainer:inContainer);


  List<Element> _contentElements;
  String _contentText;

  /// Build Toast
  void build() {
    super.build();
    notify.append(_content);
    if (_icon == null
        && (_contentElements == null || _contentElements.isEmpty)
        && (_contentText == null || _contentText.isEmpty)) {
      HeadingElement h2 = new HeadingElement.h2()
        ..classes.add(LText.C_TEXT_HEADING__SMALL);
      if (_headingElements != null && _headingElements.isNotEmpty) {
        for (Element ele in _headingElements)
          h2.append(ele);
      } else if (_headingText != null){
        h2.appendText(_headingText);
      }
      _content.append(h2);
    } else {
      _content.classes.add(LGrid.C_GRID);
      if (_icon != null) {
        _icon.classes.addAll([LIcon.C_ICON, LIcon.C_ICON__SMALL, LMargin.C_RIGHT__SMALL, LGrid.C_COL]);
        _content.append(_icon.element);
      }
      DivElement rightSide = new DivElement()
        ..classes.addAll([LGrid.C_COL, LGrid.C_ALIGN_MIDDLE]);
      _content.append(rightSide);
      //
      HeadingElement h2 = new HeadingElement.h2()
        ..classes.add(LText.C_TEXT_HEADING__SMALL);
      if (_headingElements != null && _headingElements.isNotEmpty) {
        for (Element ele in _headingElements)
          h2.append(ele);
      } else if (_headingText != null){
        h2.appendText(_headingText);
      }
      rightSide.append(h2);
      // Content
      if (_contentText != null && _contentText.isNotEmpty) {
        ParagraphElement p = new ParagraphElement()
          ..text = _contentText;
        rightSide.append(p);
      }
      if (_contentElements != null) {
        for (Element ele in _contentElements) {
          rightSide.append(ele);
        }
      }
    }
  }

  /// Append Toast
  void add(LComponent component) {
    if (_contentElements == null)
      _contentElements = new List<Element>();
    _contentElements.add(component.element);
    build();
  }
  /// Append Toast
  void append(Element e) {
    if (_contentElements == null)
      _contentElements = new List<Element>();
    _contentElements.add(e);
    build();
  }

} // LToast
