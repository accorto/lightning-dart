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
    extends LProcess {


  static final Logger _log = new Logger("LPath");

  /// Path Nav
  UListElement _nav = new UListElement()
    ..classes.add(LProcess.C_TABS__PATH__NAV)
    ..attributes[Html0.ROLE] = Html0.ROLE_TABLIST;

  /**
   * Path Editor
   */
  LPath(String name, {String idPrefix}) {
    this.name = name;
    _init();
    id = createId(idPrefix, name);
  } // LPath

  /// Path Editor
  LPath.from(DataColumn dataColumn, {String idPrefix}) {
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

  // init
  void _init() {
    input
      ..classes.add(LProcess.C_TABS__PATH)
      ..attributes[Html0.ROLE] = Html0.ROLE_APPLICATION;
    input.append(_nav);
    createBaseLayout(this);
    window.onResize.listen(onWindowResize, cancelOnError: true);
  }

  /// window resize
  void onWindowResize(Event evt) {
  //_log.fine("onWindowResize w=${window.innerWidth} h=${window.innerHeight}");
    fixWidth();
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
      if (parent.parent != null) {
        if (parent.parent.parent is FieldSetElement)
          fieldset = parent.parent.parent; // where to get with from
      }
    }
    if (fieldset == null) { // stand alone (not dataColumn)
      if (parent != null) {
        parent.style.removeProperty("width");
        num clientWidth = parent.clientWidth; // get with w/o path
        parent.style.width = "${clientWidth}px";
      }
    } else {
      parent.style.width = "0"; // to get correct width
      num clientWidth = fieldset.clientWidth; // get with w/o path
      //_log.config("fixWidth client=${clientWidth}");
      if (clientWidth > 0) {
        parent.style.width = "${clientWidth}px";
      } else {
        parent.style.removeProperty("width");
      }
    }
  } // fixWidth


  /// set value
  void set value (String newValue) {
    fixWidth();
    bool found = false;
    for (LProcessItem item in _itemList) {
      if (item is LPathItem) {
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
    }
    //
    if (found) {
      _value = newValue;
    } else {
      _value = null;
      for (LProcessItem item in _itemList) {
        if (item is LPathItem) {
          item.stage = LPathItemStage.INCOMPLETE;
        }
      }
    }
  } // set value

  /// Set Active (black vs. gray/green)
  bool setActive = false;



  /**
   * Rendered Value (different from value)
   */
  String get valueDisplay => renderSync(value, false);
  /// is the rendered [valueDisplay] different from the [value]
  bool get isValueDisplay => true;
  /// render [newValue]
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    completer.complete(renderSync(newValue, setValidity));
    return completer.future;
  } // render
  /// render [newValue]
  String renderSync(String newValue, bool setValidity) {
    if (setValidity) {
      setCustomValidity("");
    }
    if (newValue == null || newValue.isEmpty) {
      return "";
    }
    for (LProcessItem item in _itemList) {
      if (item.value == newValue) {
        return item.label;
      }
    }
    if (setValidity) {
      setCustomValidity("Invalid Value: ${newValue}");
    }
    return "?${newValue}?";
  } // renderSync


  /// clear options
  void clearOptions() {
    super.clearOptions();
    _nav.children.clear();
  }

  /// Add DOption
  void addDOption(DOption option) {
    LPathItem item = new LPathItem(option, onProcessItemChange);
    _itemList.add(item);
    if (item.optionDisplayed) {
      _nav.append(item.element); // don't show inactive
    } // cannot hide as the > will not render correctly
  }

  /// Add Option
  void addSelectOption(SelectOption so) {
    LPathItem item = new LPathItem(so.option, onProcessItemChange, so:so);
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

} // LPath




/**
 * Path Item
 */
class LPathItem
    extends LProcessItem {

  SpanElement _stage = new SpanElement()
    ..classes.add(LProcess.C_TABS__PATH__STAGE);
  SpanElement _stageText = new SpanElement()
    ..classes.add(LText.C_ASSISTIVE_TEXT);
  SpanElement _title = new SpanElement()
    ..classes.add(LProcess.C_TABS__PATH__TITLE);


  /**
   * Path Item
   */
  LPathItem(DOption option, ProcessItemChange processItemChange, {SelectOption so})
    : super(option, processItemChange, so:so) {
    element
      ..classes.add(LProcess.C_TABS__PATH__ITEM);
    _a
      ..classes.add(LProcess.C_TABS__PATH__LINK)
      ..attributes[Html0.ARIA_LIVE] = Html0.ARIA_LIVE_ASSERTIVE
      ..attributes[Html0.ARIA_SELECTED] = Html0.V_FALSE
      ..tabIndex = -1
      ..append(_stage)
      ..append(_title);

    LIcon icon = new LIconUtility(LIconUtility.CHECK, size: LIcon.C_ICON__X_SMALL);
    _stage.append(icon.element);
    _stage.append(_stageText);
    //
    _title.text = option.label;
    title = option.description;
  } // LPathItem;

  void set label (String newValue) {
    _title.text = newValue;
  }

  /// title
  String get title => _stageText.text;
  /// title
  void set title (String newValue) {
    _stageText.text = newValue == null ? "" : newValue;
  }

  /// Get Stage
  LPathItemStage get stage {
    if (element.classes.contains(LProcess.C_IS_COMPLETE))
      return LPathItemStage.COMPLETE;
    if (element.classes.contains(LProcess.C_IS_CURRENT))
      return LPathItemStage.CURRENT;
    return LPathItemStage.INCOMPLETE;
  }
  /// Set Stage
  void set stage (LPathItemStage newValue) {
    element.classes.removeAll([LProcess.C_IS_COMPLETE, LProcess.C_IS_CURRENT, LProcess.C_IS_INCOMPLETE]);
    if (newValue == LPathItemStage.COMPLETE) {
      element.classes.add(LProcess.C_IS_COMPLETE);
      _a.attributes[Html0.ARIA_SELECTED] = Html0.V_FALSE;
      _a.tabIndex = -1;
      option.isSelected = false;
    } else if (newValue == LPathItemStage.CURRENT) {
      element.classes.add(LProcess.C_IS_CURRENT);
      _a.attributes[Html0.ARIA_SELECTED] = Html0.V_TRUE;
      _a.tabIndex = 0;
      option.isSelected = true;
    } else {
      element.classes.add(LProcess.C_IS_INCOMPLETE);
      _a.attributes[Html0.ARIA_SELECTED] = Html0.V_FALSE;
      _a.tabIndex = -1;
      option.clearIsSelected();
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

} // LPathItem

/**
 * Path Item Stage
 */
enum LPathItemStage {

  INCOMPLETE,
  CURRENT,
  COMPLETE

} // LPathItemStage


/**
 * Path Button
 */
class LPathButton extends LButton {

  /// Path Button (blue)
  LPathButton.markComplete(String name, String label, {String idPrefix})
      : super(new ButtonElement(), name, label, idPrefix:idPrefix,
      buttonClasses:[LButton.C_BUTTON__BRAND, LButton.C_BUTTON__SMALL, LButton.C_BUTTON__ICON_BORDER_FILLED,
      "slds-path__mark-complete", LGrid.C_NO_FLEX, LMargin.C_HORIZONTAL__SMALL],
      icon: new LIconUtility(LIconUtility.CHECK)) {
  }

  /// Path Button (black)
  LPathButton.markCurrent(String name, String label, {String idPrefix})
      : super(new ButtonElement(), name, label, idPrefix:idPrefix,
          buttonClasses:[LButton.C_BUTTON__BRAND, LButton.C_BUTTON__SMALL, LButton.C_BUTTON__ICON_BORDER_FILLED,
          "slds-path__mark-complete", LGrid.C_NO_FLEX, LMargin.C_HORIZONTAL__SMALL,
          "slds-path__mark-current"]) {
  }

} // LPathButton
