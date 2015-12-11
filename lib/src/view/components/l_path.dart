/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * (Sales) Path - [input] is actual element
 * API as Select Editor
 */
class LPath
    extends LEditor with LFormElement, LSelectI {

  static final Logger _log = new Logger("LPath");


  /// Path Element
  DivElement input = new DivElement()
    ..classes.add(LTab.C_TABS__PATH)
    ..attributes[Html0.ROLE] = Html0.ROLE_TABLIST; // application

  /// Path Nav
  UListElement _nav = new UListElement()
    ..classes.add(LTab.C_TABS__PATH__NAV)
    ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;

  final List<LPathItem> _itemList = new List<LPathItem>();


  String name;

  /**
   * Path Editor
   */
  LPath(String this.name, {String idPrefix}) {
    input.append(_nav);
    //
    createStandard(this);
    id = createId(idPrefix, name);
  }

  /// Path Editor
  LPath.from(DataColumn dataColumn, {String idPrefix}) {
    input.append(_nav);
    //
    createStandard(this);
    DColumn tableColumn = dataColumn.tableColumn;
    name = tableColumn.name;
    id = createId(idPrefix, name);
    // Selection List
    if (tableColumn.pickValueList.isNotEmpty) {
      dOptionList = tableColumn.pickValueList;
    }
    this.dataColumn = dataColumn;
  }

  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  /// Fix/restrict the with - via setValue (or reset)
  void fixWidth() { // assuming that value is set after display
    // fieldset -- has correct width
    // - grid (row)
    // -- col padded (parent)
    // --- form element
    Element parent = element.parent; // where to fix width
    Element fieldset = null;
    if (parent != null) {
      if (parent.parent != null)
        fieldset = parent.parent.parent; // where to get with from
    }
    if (fieldset != null) {
      parent.style.width = "0"; // to get correct width
      num clientWidth = fieldset.clientWidth; // get with w/o path
      //_log.config("fixWidth client=${clientWidth}");
      if (clientWidth > 0) {
        parent.style.width = "${clientWidth}px";
      } else {
        parent.style.removeProperty("width");
      }
    } else if (parent != null) {
      parent.style.removeProperty("width");
    }
  } // fixWidth


  /// get value
  String get value => _value;
  /// set value
  void set value (String newValue) {
    fixWidth();
    bool found = false;
    for (LPathItem item in _itemList) {
      if (item.value == newValue) {
        item.stage = LPathItemStage.CURRENT;
        item.active = false;
        found = true;
        if (!item.optionDisplayed) {
          item.optionDisplayed = true; // override to display
          rebuildPath();
        }
      } else if (found) {
        item.stage = LPathItemStage.INCOMPLETE;
        item.active = setActive;
      } else {
        item.stage = LPathItemStage.COMPLETE;
        item.active = false;
      }
    }
    //
    if (found) {
      _value = newValue;
    } else {
      _value = null;
      for (LPathItem item in _itemList) {
        item.stage = LPathItemStage.INCOMPLETE;
      }
    }
  } // set value
  String _value;

  /// Set Active (black vs. gray/green)
  bool setActive = false;

  String get defaultValue => _defaultValue;
  void set defaultValue (String newValue) {
    _defaultValue = newValue;
  }
  String _defaultValue;


  bool get readOnly => _readOnly;
  void set readOnly (bool newValue) {
    _readOnly = newValue;
  }
  bool _readOnly = false;

  bool get disabled => _readOnly;
  void set disabled (bool newValue) {
    _disabled = newValue;
  }
  bool _disabled = false;


  /**
   * Rendered Value (different from value)
   */
  String get valueDisplay => renderSync(value, false);
  /// is the rendered [valueDisplay] different from the [value]
  bool get valueRendered => true;
  /// render [newValue]
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    completer.complete(renderSync(newValue, setValidity));
    return completer.future;
  } // render
  /// render [newValue]
  String renderSync(String newValue, bool setValidity) {
    if (setValidity) {
      inputValidationMsg = "";
    }
    if (newValue == null || newValue.isEmpty) {
      return "";
    }
    for (LPathItem item in _itemList) {
      if (item.value == newValue) {
        return item.label;
      }
    }
    if (setValidity) {
      inputValidationMsg = "Invalid Value: ${newValue}";
    }
    return "?${newValue}?";
  } // renderSync



  String get type => EditorI.TYPE_SELECT;
  bool get spellcheck => false;
  void set spellcheck (bool ignored) {}
  bool get autofocus => false;
  void set autofocus (bool ignored) {}
  bool get multiple => false;
  bool get required => true;
  void set required (bool ignored) {}
  bool get inGrid => false;

  int get selectedCount => _value == null ? 0 : 1;
  int get length => _itemList.length;

  /// Validation state from Input
  ValidityState get inputValidationState => null;
  /// Validation Message from Input
  String inputValidationMsg = "";


  /// -- options --

  /// Get options
  List<OptionElement> get options {
    List<OptionElement> retValue = new List<OptionElement>();
    for (LPathItem item in _itemList) {
      SelectOption so = item.asSelectOption();
      retValue.add(so.asOptionElement());
    }
    return retValue;
  }
  /// Add Option List
  void set options (List<OptionElement> list) {
    clearOptions();
    defaultValue = null;
    for (OptionElement oe in list) {
      SelectOption so = new SelectOption.fromElement(oe);
      addSelectOption(so);
      if (so.option.isDefault)
        defaultValue = so.value;
    }
    if (defaultValue != null)
      value = defaultValue;
  }
  /// Add Option
  void addOption(OptionElement oe) {
    addSelectOption(new SelectOption.fromElement(oe));
  }

  /// -- select options --

  /// get updated Option list
  List<SelectOption> get selectOptionList {
    List<SelectOption> retValue = new List<SelectOption>();
    for (LPathItem item in _itemList) {
      retValue.add(item.asSelectOption());
    }
    return retValue;
  }
  /// Set Option List
  void set selectOptionList(List<SelectOption> list) {
    clearOptions();
    defaultValue = null;
    for (SelectOption so in list) {
      addSelectOption(so);
      if (so.option.isDefault)
        defaultValue = so.value;
    }
    if (defaultValue != null)
      value = defaultValue;
  } // selectOptionList

  /// Set Option List
  void set dOptionList(List<DOption> options) {
    clearOptions();
    defaultValue = null;
    for (DOption option in options) {
      addDOption(option);
      if (option.isDefault)
        defaultValue = option.value;
    }
    if (defaultValue != null)
      value = defaultValue;
  }

  /// clear options
  void clearOptions() {
    _itemList.clear();
    _nav.children.clear();
  }


  /// Add DOption
  void addDOption(DOption option) {
    LPathItem item = new LPathItem(option, onPathChange);
    _itemList.add(item);
    if (item.optionDisplayed) {
      _nav.append(item.element); // don't show inactive
    } // cannot hide as the > will not render correctly
  }

  /// Add Option
  void addSelectOption(SelectOption so) {
    LPathItem item = new LPathItem(so.option, onPathChange, so:so);
    _itemList.add(item);
    if (item.optionDisplayed) {
      _nav.append(item.element); // don't show inactive
    }
  }

  /// rebuild path ul > li
  void rebuildPath() {
    _nav.children.clear();
    for (LPathItem item in _itemList) {
      if (item.optionDisplayed) {
        _nav.append(item.element);
      }
    }
  } // rebuildPath


  /// Path Selected - callback - onInputChange
  void onPathChange(DOption option) {
    if (_readOnly || _disabled) {
      return;
    }
    value = option == null ? null : option.value;
    String theValue = value;
    _log.config("onPathChange ${name}=${theValue}");
    if (data != null && entry != null) {
      data.updateEntry(entry, theValue);
    }
    if (editorChange != null) {
      editorChange(name, theValue, entry, null);
    }
  }

} // LPath


/// Path Selected
typedef void PathChange(DOption option);


/**
 * Path Item
 */
class LPathItem {

  /// Item Element
  LIElement element = new LIElement()
    ..classes.add(LTab.C_TABS__PATH__ITEM)
    ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;

  AnchorElement _a = new AnchorElement(href: "#")
    ..classes.add(LTab.C_TABS__PATH__LINK)
    ..attributes[Html0.ROLE] = Html0.ROLE_TAB
    ..attributes[Html0.ARIA_LIVE] = Html0.ARIA_LIVE_ASSERTIVE;

  SpanElement _stage = new SpanElement()
    ..classes.add(LTab.C_TABS__PATH__STAGE);
  SpanElement _stageText = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT);

  SpanElement _title = new SpanElement()
    ..classes.add(LTab.C_TABS__PATH__TITLE);

  /// Option value
  final DOption option;
  SelectOption so;
  /// Callback
  final PathChange pathChange;

  /**
   * Path Item
   */
  LPathItem(DOption this.option, PathChange this.pathChange, {SelectOption this.so}) {
    element.append(_a);
    LIcon icon = new LIconUtility(LIconUtility.CHECK, size: LIcon.C_ICON__X_SMALL);
    _stage.append(icon.element);
    _stage.append(_stageText);
    _a.append(_stage);
    _a.append(_title);
    //
    _a.onClick.listen(onClick);
    //
    _title.text = option.label;
    title = option.description;
  } // LPathItem;

  /// Return as Select Option
  SelectOption asSelectOption() {
    if (so == null)
      so = new SelectOption(option);
    return so;
  }

  /// value
  String get value => option.value;
  /// label
  String get label => option.label;

  /// title
  String get title => _stageText.text;
  /// title
  void set title (String newValue) {
    _stageText.text = newValue == null ? "" : newValue;
  }

  /// Get Stage
  LPathItemStage get stage {
    if (element.classes.contains(LTab.C_IS_COMPLETE))
      return LPathItemStage.COMPLETE;
    if (element.classes.contains(LTab.C_IS_CURRENT))
      return LPathItemStage.CURRENT;
    return LPathItemStage.INCOMPLETE;
  }
  /// Set Stage
  void set stage (LPathItemStage newValue) {
    element.classes.removeAll([LTab.C_IS_COMPLETE, LTab.C_IS_CURRENT, LTab.C_IS_INCOMPLETE]);
    if (newValue == LPathItemStage.COMPLETE) {
      element.classes.add(LTab.C_IS_COMPLETE);
      _a.attributes[Html0.ARIA_SELECTED] = Html0.V_FALSE;
      _a.tabIndex = -1;
    } else if (newValue == LPathItemStage.CURRENT) {
      element.classes.add(LTab.C_IS_CURRENT);
      _a.attributes[Html0.ARIA_SELECTED] = Html0.V_TRUE;
      _a.tabIndex = 0;
    // option.isSelected = true;
    } else {
      element.classes.add(LTab.C_IS_INCOMPLETE);
      _a.attributes[Html0.ARIA_SELECTED] = Html0.V_FALSE;
      _a.tabIndex = -1;
    }
  }

  /// option is displayed (active or overwrite)
  bool get optionDisplayed {
    if (_optionActive == null)
      return !option.hasIsActive() || option.isActive;
    return _optionActive;
  }
  /// overwrite if displayed
  void set optionDisplayed (bool newValue) {
    _optionActive = newValue;
  }
  bool _optionActive;

  /// Element Active
  bool get active {
    return element.classes.contains(LTab.C_IS_ACTIVE);
  }
  /// Active Item (black, for future items)
  void set active (bool newValue) {
    if (newValue) {
      element.classes.add(LTab.C_IS_ACTIVE);
    } else {
      element.classes.remove(LTab.C_IS_ACTIVE);
    }
  }


  /**
   * On Click
   */
  void onClick(MouseEvent evt) {
    evt.preventDefault();
    evt.stopPropagation();
    //
    if (pathChange != null)
      pathChange(option);
  }

} // LPathItem

/**
 * Path Item Stage
 */
enum LPathItemStage {

  INCOMPLETE,
  CURRENT,
  COMPLETE

} // LPathItemStage
