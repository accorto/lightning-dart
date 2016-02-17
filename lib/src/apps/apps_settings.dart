/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Apps Settings Page with tabs
 */
class AppsSettings
    extends AppsPage {

  /// on Setting Save(true) or Reset(false)
  static Stream<bool> get onChange {
    if (_onChange == null) {
      _onChange = new StreamController<bool>.broadcast();
    }
    return _onChange.stream;
  }
  static StreamController<bool> _onChange;


  static const String ID = "setting";

  DivElement get element => _tab.element;

  LTab _tab = new LTab(idPrefix: ID);
  AppsSettingsTab _tabSettings = new AppsSettingsTab();
  AppsSettingsEnvironment _tabEnvironment = new AppsSettingsEnvironment();
  AppsSettingsMessages _tabMessages = new AppsSettingsMessages();
  AppsSettingsCache _tabCache = new AppsSettingsCache();


  /// Settings
  AppsSettings() : super (ID, ID,
      new LIconUtility(LIconUtility.SETUP),
      appsSettingsLabel(), appsSettingsLabel()) {

    _tab.addTabContent(_tabMessages);
    _tab.addTabContent(_tabSettings);
    _tab.addTabContent(_tabEnvironment);
    _tab.addTabContent(_tabCache);
  } // AppsSettings

  /// refresh tabs
  void showingNow() {
    if (_tabSettings.active)
      _tabSettings.showingNow();
    if (_tabMessages.active)
      _tabMessages.showingNow();
    if (_tabEnvironment.active)
      _tabEnvironment.showingNow();
    if (_tabCache.active)
      _tabCache.showingNow();
  }


  /// Translate
  static String appsSettingsLabel() => Intl.message("Settings", name: "appsSettingsLabel");

} // AppsSettings


/**
 * Settings Messages Tab
 */
class AppsSettingsMessages
    extends LTabContent {

  static const String ID = "msg";

  LButton _clearBtn = new LButton.neutral("clear", "-", idPrefix: ID);

  /// Messages
  AppsSettingsMessages() : super(ID, appsSettingsMessagesLabel()) {
    _clearBtn.classes.add(LMargin.C_HORIZONTAL__LARGE);
    _clearBtn.onClick.listen(onClearClick);
  }

  /// recreate - refresh
  void showingNow() {
    element.children.clear();
    LTable table = new LTable(ID);
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);
    // data
    for (StatusMessage sm in PageSimple.statusMessages.reversed) {
      LIcon icon = sm.icon;
      if (icon == null) {
        icon = LNotification.createDefaultIcon(sm.color, setIconColor:true);
      } else {
        icon.classes.add(LIcon.C_ICON_TEXT_DEFAULT);
      }
      icon.classes.add(LIcon.C_ICON__X_SMALL);
      table.addRowDataList([icon.element, sm.message, sm.detail, sm.dataDetail]);
    }
    // clear button
    if (PageSimple.statusMessages.isEmpty) {
      _clearBtn.label = appsSettingsMessagesNone();
    } else {
      _clearBtn.label = "${appsSettingsMessagesClear()} (${PageSimple.statusMessages.length})";
    }
    element.append(_clearBtn.element);
  } // showingNow

  /// on Clear clicked
  void onClearClick(MouseEvent evt) {
    PageSimple.statusMessages.clear();
    showingNow();
  }

  static String appsSettingsMessagesLabel() => Intl.message("Messages", name: "appsSettingsMessagesLabel");
  static String appsSettingsMessagesClear() => Intl.message("Clear Messages", name: "appsSettingsMessagesClear");
  static String appsSettingsMessagesNone() => Intl.message("No Messages", name: "appsSettingsMessagesNone");

} // AppSettingsMessages
