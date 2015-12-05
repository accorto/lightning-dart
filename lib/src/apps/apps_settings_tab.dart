/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Settings Tab
 */
class AppSettingsTab extends LTabContent {

  static const String ID = "set";

  final List<AppSettingsTabLine> _lines = new List<AppSettingsTabLine>();

  DivElement _buttonDiv = new DivElement()
    ..classes.add(LMargin.C_AROUND__LARGE);
  LButton _buttonReset = new LButton.neutralIcon("reset", LForm.lFormReset(),
      new LIconUtility(LIconUtility.UNDO), iconLeft:true, idPrefix:ID)
    ..typeReset = false;
  LButton _buttonSave = new LButton.brandIcon("save", LForm.lFormSave(),
      new LIconUtility(LIconUtility.CHECK), iconLeft:true, idPrefix:ID)
    ..typeSubmit = false;


  /// Settings Tab
  AppSettingsTab() : super(ID, appsSettingsTabLabel()) {
    _buttonReset.onClick.listen(onResetClick);
    _buttonSave.onClick.listen(onSaveClick);
    _buttonDiv.append(_buttonReset.element);
    _buttonDiv.append(_buttonSave.element);
  }

  /// Show
  void showingNow() {
    element.children.clear();
    _lines.clear();
    LTable table = new LTable(ID);
    element.classes.add(LScrollable.C_SCROLLABLE__X);
    element.append(table.element);

    for (SettingItem item in Settings.settingList) {
      AppSettingsTabLine line = new AppSettingsTabLine(item);

      table.addRowDataList([item.label, line.editor]);
      _lines.add(line);
    }
    element.append(_buttonDiv);
  } // showingNow

  /// reload from local preferences
  void onResetClick(MouseEvent evt) {
    Settings.load(); // updates value
    for (AppSettingsTabLine line in _lines) {
      line.setEditorValue();
    }
  }

  /// save to local preferences
  void onSaveClick(MouseEvent evt) {
    for (AppSettingsTabLine line in _lines) {
      line.save();
    }
    Settings.save();
  }


  static String appsSettingsTabLabel() => Intl.message("Settings", name: "appsSettingsTabLabel");

} // AppSettingsTab


/**
 * Settings Tab Line (editor)
 */
class AppSettingsTabLine {

  final SettingItem setting;

  /// Setting Tab Line
  AppSettingsTabLine(SettingItem this.setting) {
  } // AppSettingsTabLine

  /// get/create Editor + set value
  InputElement get editor {
    _input = new InputElement(type:setting.dataType);
    setEditorValue();
    if (!setting.userUpdatable) {
      _input.disabled = true;
    }
    return _input;
  }
  InputElement _input;

  /// set editor value
  void setEditorValue() {
    if (setting.isBool)
      _input.checked = setting.valueAsBool();
    else if (setting.isInt)
      _input.valueAsNumber = setting.valueAsInt();
    else if (setting.isNum)
      _input.valueAsNumber = setting.valueAsNum();
    else
      _input.value = setting.value;
  }

  /// reset
  void reset() {
    setting.reset();
    setEditorValue();
  }

  /// save value to setting (need to save to preference)
  void save() {
    if (setting.userUpdatable) {
      if (setting.isBool)
        setting.value = _input.checked;
      else if (setting.isInt)
        setting.value = _input.valueAsNumber;
      else if (setting.isNum)
        setting.value = _input.valueAsNumber;
      else
        setting.value = _input.value;
    } else {
      setEditorValue(); // ignore input
    }
  } // save

} // AppSettingsTabLine