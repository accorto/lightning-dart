/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Settings Tab
 */
class AppSettingsTab
    extends LTabContent {

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

      TableRowElement tr = table.addRowDataList([item.label, line.editor]);
      if (item.description != null)
        tr.title = item.description;
      _lines.add(line);
    }
    element.append(_buttonDiv);
  } // showingNow

  /// reload from local preferences
  void onResetClick(MouseEvent evt) {
    Settings.reset(); // updates value
    for (AppSettingsTabLine line in _lines) {
      line.setting.value = Settings.get(line.setting.name);
      line.setEditorValue();
    }
    if (AppsSettings._onChange != null) {
      AppsSettings._onChange.add(false);
    }
  }

  /// save to local preferences
  void onSaveClick(MouseEvent evt) {
    for (AppSettingsTabLine line in _lines) {
      line.save();
    }
    Settings.save();
    if (AppsSettings._onChange != null) {
      AppsSettings._onChange.add(true);
    }
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
  Element get editor {
    if (_input != null)
      return _input;
    if (_select != null)
      return _select;
    //
    if (setting.isPick) {
      _select = new SelectElement()
          ..name = setting.name;
      for (DOption option in setting.optionList) {
        _select.append(new OptionElement(data: option.label, value: option.value));
      }
    } else if (setting.optional && setting.isBool) {
      _select = new SelectElement()
        ..name = setting.name;
      for (DOption option in OptionUtil.optionsYesNo(true)) {
        _select.append(new OptionElement(data: option.label, value: option.value));
      }
    } else {
      _input = new InputElement(type: setting.dataType)
          ..name = setting.name;
    }
    //
    setEditorValue();
    if (!setting.userUpdatable) {
      _input.disabled = true;
    }
    if (_select == null)
      return _input;
    return _select;
  }
  InputElement _input;
  SelectElement _select;

  /// set editor value
  void setEditorValue() {
    if (setting.isBool) {
      if (_input != null) {
        _input.checked = setting.valueAsBool();
      } else {
        _select.value = setting.value;
      }
    } else if (setting.isInt)
      _input.valueAsNumber = setting.valueAsInt();
    else if (setting.isNum)
      _input.valueAsNumber = setting.valueAsNum();
    else if (setting.isPick)
      _select.value = setting.value;
    else
      _input.value = setting.value;
  }

  /// save value to setting (need to save to preference)
  void save() {
    if (setting.userUpdatable) {
      if (setting.isBool) {
        if (_input != null) {
          setting.value = _input.checked;
        } else {
          String vv = _select.value;
          if (vv == null || vv.isEmpty)
            setting.value = null;
          else
            setting.value = vv == Html0.V_TRUE;
        }
      } else if (setting.isInt)
        setting.value = _input.valueAsNumber;
      else if (setting.isNum)
        setting.value = _input.valueAsNumber;
      else if (setting.isPick)
        setting.value = _select.value;
      else
        setting.value = _input.value;
    } else {
      setEditorValue(); // ignore input
    }
  } // save

} // AppSettingsTabLine
