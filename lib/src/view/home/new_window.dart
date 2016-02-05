/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * New Window Button
 */
class NewWindow {

  /// URL Parameters
  static final Map<String,String> urlParameters = new Map<String,String>();
  /// URL with Parameters
  static Uri get winUri {
    return ClientEnv.uriBase.replace(queryParameters: urlParameters);
  }


  /// new window
  static const String NAME_BLANK = "_blank";
  /// top frameset
  static const String NAME_TOP = "_top";


  LButton button;
  Element get element => button.element;

  /**
   * New Window
   */
  NewWindow({String idPrefix}) {
    button = new LButton.iconContainer("newWindow",
        new LIconUtility(LIconUtility.NEW_WINDOW),
        newWindowText(), idPrefix:idPrefix);
    button.onClick.listen(onClick);
  } // NewButton

  /// open window
  void onClick(MouseEvent evt) {
    if (evt != null) {
      evt.preventDefault();
      evt.stopImmediatePropagation();
    }
    String url = winUri.toString();
    String options = winOptions;
    // _winBase =
    window.open(url, winName, options);
  }
  // WindowBase _winBase;


  String get winName => _winName;
  void set winName(String newValue) {
    _winName = newValue;
  }
  String _winName = NAME_BLANK;

  /// window options
  String get winOptions {
    _options = null;
    if (winWidth != null && winWidth > 0)
      _addOption("width=${winWidth}");
    if (winHeight != null && winHeight > 100)
      _addOption("height=${winHeight}");
    if (winTop != null && winTop >= 0)
      _addOption("top=${winTop}");
    if (winLeft != null && winLeft >= 0)
      _addOption("left=${winLeft}");
    // yes=1 no=0
    if (winMenubar != null)
      _addOption("menubar=${winMenubar ? "yes" : "no"}");
    if (winToolbar != null)
      _addOption("toolbar=${winToolbar ? "yes" : "no"}");
    if (winLocation != null)
      _addOption("location=${winLocation ? "yes" : "no"}");
    if (winStatus != null)
      _addOption("status=${winStatus ? "yes" : "no"}");
    if (winResizable != null)
      _addOption("resizable=${winResizable ? "yes" : "no"}");

    return _options;
  } // winOptions

  /// add window option
  void _addOption(String option) {
    if (_options == null) {
      _options = option;
    } else {
      _options += ", ${option}";
    }
  }
  String _options = null;

  int winWidth;
  int winHeight;
  int winTop;
  int winLeft;
  bool winMenubar = true;
  bool winToolbar = true;
  bool winLocation = true;
  bool winResizable = true;
  bool winStatus = true;


  static String newWindowText() => Intl.message("open in New Window", name: "newWindowText");


} // NewWindow
