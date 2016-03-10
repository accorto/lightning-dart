/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Wizard
 */
class LWizard
    extends LProcess {

  final OListElement _nav = new OListElement()
    ..classes.add(LProcess.C_WIZARD__LIST);
  final SpanElement _progressBar = new SpanElement()
    ..classes.add(LProcess.C_WIZARD__PROGRESS_BAR);

  /**
   * Wizard Editor
   */
  LWizard(String name, {String idPrefix}) {
    this.name = name;
    _init();
    id = createId(idPrefix, name);
  } // LPath

  /// Path Editor
  LWizard.from(DataColumn dataColumn, {String idPrefix}) {
    _init();
    //
    DColumn tableColumn = dataColumn.tableColumn;
    name = tableColumn.name;
    id = createId(idPrefix, name);
    // Selection List
    if (tableColumn.pickValueList.isNotEmpty) {
      dOptionList = tableColumn.pickValueList;
    }
    this.dataColumn = dataColumn;
  } // LPath

  /// initialize
  void _init() {
    input.classes.add(LProcess.C_WIZARD);
    input.append(_nav);
    SpanElement progress = new SpanElement()
      ..classes.add(LProcess.C_WIZARD__PROGRESS)
      ..append(_progressBar);
    input.append(progress);
    _progressBar.style.width = "0%";
    createStandard(this);
  }

  /// set value
  void set value (String newValue) {
    bool found = false;
    for (LProcessItem item in _itemList) {
      item.active = false;
      if (item.value == newValue) {
        item.active = true;
        found = true;
      }
    }
    //
    if (found) {
      _value = newValue;
      int active = 0;
      for (LProcessItem item in _itemList) {
        active++;
        if (item.active) {
          break;
        }
        item.active = true; // previous
      }
      if (active > 1 && _itemList.length > 1) {
        progress = 100 * (active-1) ~/ (_itemList.length - 1);
      } else {
        progress = 0;
      }
    } else {
      _value = null;
      progress = 0;
    }
  } // set value


  /// clear options
  void clearOptions() {
    super.clearOptions();
    _nav.children.clear();
  }

  /// Add DOption
  void addDOption(DOption option) {
    LWizardItem item = new LWizardItem(option, onProcessItemChange);
    _itemList.add(item);
    if (item.optionDisplayed) {
      _nav.append(item.element); // don't show inactive
    } // cannot hide as the > will not render correctly
  }

  /// Add Option
  void addSelectOption(SelectOption so) {
    LWizardItem item = new LWizardItem(so.option, onProcessItemChange, so:so);
    _itemList.add(item);
    if (item.optionDisplayed) {
      _nav.append(item.element); // don't show inactive
    }
  }

  /// rebuild path ul > li
  void rebuildPath() {
    _nav.children.clear();
    for (LProcessItem item in _itemList) {
      if (item.optionDisplayed) {
        _nav.append(item.element);
      }
    }
  } // rebuildPath


  /// progress in percent
  int get progress {
    String width = _progressBar.style.width;
    if (width != null && width.isNotEmpty && width.endsWith("%")) {
      return int.parse(width.substring(0,width.length-1),
          onError: (String s){
        return -1;
      });
    }
    return 0;
  }
  /// progress in percent
  void set progress(int percent) {
    _progressBar.style.width = "${percent}%";
  }

} // LWizard

/**
 * Wizard Item
 */
class LWizardItem
    extends LProcessItem {


  final SpanElement _label = new SpanElement()
    ..classes.addAll([LProcess.C_WIZARD__LABEL, LText.C_TEXT_HEADING__LABEL, LText.C_TRUNCATE]);

  /// Wizard Item
  LWizardItem(DOption option, ProcessItemChange processItemChange, {SelectOption so})
    : super (option, processItemChange, so:so) {
    element
        ..classes.add(LProcess.C_WIZARD__ITEM);
    _a
      ..classes.add(LProcess.C_WIZARD__LINK)
      ..append(new SpanElement()..classes.add(LProcess.C_WIZARD__MARKER))
      ..append(_label);

    _label.text = label; // label value
  } // LWizardItem

  void set label (String newValue) {
    _label.text = newValue;
  }

} // LWizardItem
