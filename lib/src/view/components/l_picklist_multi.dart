/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


/**
 * Multi Select / Pick List
 * (two lists with add/remove up/down)
 * - attributes: active, seqNo
 */
class LPicklistMulti
      extends LComponent {

  static final Logger _log = new Logger("LPicklistMulti");

  static const SELECTED_INDICATOR_SELECTED = "s";
  static const SELECTED_INDICATOR_ACTIVE = "a";
  static const SELECTED_INDICATOR_BOTH = "b";

  /// element
  final DivElement element = new DivElement()
    ..classes.addAll([LPicklist.C_PICKLIST__DRAGGABLE, LGrid.C_GRID]);

  final DivElement _formLeft = new DivElement()
    ..classes.addAll([LForm.C_FORM_ELEMENT, LGrid.C_SHRINK_NONE]);
  final SpanElement _formLeftLabel = new SpanElement()
    ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
  final DivElement _formLeftPl = new DivElement()
    ..classes.addAll([LPicklist.C_PICKLIST, LPicklist.C_PICKLIST__MULTI]);
  final UListElement _formLeftPlList = new UListElement()
    ..classes.addAll([LPicklist.C_PICKLIST__OPTIONS, LPicklist.C_PICKLIST__OPTIONS__MULTI, "shown"]);

  final DivElement _buttonsLeft = new DivElement()
    ..classes.addAll([LGrid.C_GRID, LGrid.C_GRID__VERTICAL, LGrid.C_SHRINK_NONE]);
  final LButton _buttonRemove = new LButton.iconContainer("remove",
    new LIconUtility(LIconUtility.LEFT),
    lPicklistMultiRemove());
  final LButton _buttonAdd = new LButton.iconContainer("add",
    new LIconUtility(LIconUtility.RIGHT),
    lPicklistMultiAdd());

  final DivElement _formRight = new DivElement()
    ..classes.addAll([LForm.C_FORM_ELEMENT, LGrid.C_SHRINK_NONE]);
  final SpanElement _formRightLabel = new SpanElement()
    ..classes.add(LForm.C_FORM_ELEMENT__LABEL);
  final DivElement _formRightPl = new DivElement()
    ..classes.addAll([LPicklist.C_PICKLIST, LPicklist.C_PICKLIST__MULTI]);
  final UListElement _formRightPlList = new UListElement()
    ..classes.addAll([LPicklist.C_PICKLIST__OPTIONS, LPicklist.C_PICKLIST__OPTIONS__MULTI, "shown"]);

  final DivElement _buttonsRight = new DivElement()
    ..classes.addAll([LGrid.C_GRID, LGrid.C_GRID__VERTICAL, LGrid.C_SHRINK_NONE]);
  final LButton _buttonUp = new LButton.iconContainer("up",
    new LIconUtility(LIconUtility.UP),
    lPicklistMultiUp());
  final LButton _buttonDown = new LButton.iconContainer("down",
    new LIconUtility(LIconUtility.DOWN),
    lPicklistMultiDown());

  /// available
  final List<LPicklistMultiItem> _leftItems = new List<LPicklistMultiItem>();
  /// selected
  final List<LPicklistMultiItem> _rightItems = new List<LPicklistMultiItem>();

  /// Selected indicator in Option
  String selectedIndicator = SELECTED_INDICATOR_BOTH;

  /**
   * Multi Pick List
   */
  LPicklistMulti() {
    // Structure
    element.append(_formLeft);
    _formLeft.append(_formLeftLabel);
    _formLeft.append(_formLeftPl);
    _formLeftPl.append(_formLeftPlList);

    element.append(_buttonsLeft);
    _buttonsLeft.append(_buttonAdd.element);
    _buttonsLeft.append(_buttonRemove.element);

    element.append(_formRight);
    _formRight.append(_formRightLabel);
    _formRight.append(_formRightPl);
    _formRightPl.append(_formRightPlList);

    element.append(_buttonsRight);
    _buttonsRight.append(_buttonUp.element);
    _buttonsRight.append(_buttonDown.element);

    //
    _buttonAdd.onClick.listen(onButtonAdd);
    _buttonRemove.onClick.listen(onButtonRemove);
    _buttonUp.onClick.listen(onButtonUp);
    _buttonDown.onClick.listen(onButtonDown);

    // DnD
    _formLeftPlList.onDragOver.listen(onDragOverList);
    _formRightPlList.onDragOver.listen(onDragOverList);
    _formLeftPlList.onDragLeave.listen(onDragLeaveList);
    _formRightPlList.onDragLeave.listen(onDragLeaveList);
    _formLeftPlList.onDrop.listen(onDropList);
    _formRightPlList.onDrop.listen(onDropList);
  } // LPicklistMulti

  /// Label available - selected
  void set label (String newValue) {
    _formLeftLabel.text = "${lPicklistMultiAvailable()} ${newValue}";
    _formRightLabel.text = "${lPicklistMultiSelected()} ${newValue}";
  }
  void set labelLeft (String newValue) {
    _formLeftLabel.text = newValue;
  }
  void set labelRight (String newValue) {
    _formRightLabel.text = newValue;
  }

  /// Set Options - selected|active - seqNo
  void set options (List<DOption> options) {
    _leftItems.clear();
    _rightItems.clear();
    int seqNo = 1;
    for (DOption option in options) {
      LPicklistMultiItem item = new LPicklistMultiItem(option)
        ..element.onDrop.listen(onDropItem);
      if (isOptionSelected(option)) {
        _rightItems.add(item);
        setOptionSelected(option, true);
        option.seqNo = (seqNo++ * 10);
      } else {
        _leftItems.add(item);
        setOptionSelected(option, false);
        option.seqNo = 0;
      }
    }
    _redisplay();
  } // setOptions

  /// Get Options
  List<DOption> get options {
    List<DOption> options = new List<DOption>();
    for (LPicklistMultiItem item in _leftItems) {
      setOptionSelected(item.option, false);
      item.option.clearSeqNo();
      options.add(item.option);
    }
    int seqNo = 1;
    for (LPicklistMultiItem item in _rightItems) {
      setOptionSelected(item.option, true);
      item.option.seqNo = (seqNo++ * 10);
      options.add(item.option);
    }
    return options;
  } // getOptions


  /// is the option selected based on [selectedIndicator]
  bool isOptionSelected(DOption option) {
    if (option != null) {
      if (option.hasIsActive() && (selectedIndicator == SELECTED_INDICATOR_BOTH || selectedIndicator == SELECTED_INDICATOR_ACTIVE))
        return option.isActive;
      if (option.hasIsSelected() && (selectedIndicator == SELECTED_INDICATOR_BOTH || selectedIndicator == SELECTED_INDICATOR_SELECTED))
        return option.isSelected;
    }
    return false;
  } // isOptionSelected


  /// set the option selected based on [selectedIndicator]
  void setOptionSelected(DOption option, bool selected) {
    if (option != null) {
      if (selectedIndicator == SELECTED_INDICATOR_BOTH || selectedIndicator == SELECTED_INDICATOR_ACTIVE)
        option.isActive = selected;
      if (option.hasIsSelected() && (selectedIndicator == SELECTED_INDICATOR_BOTH || selectedIndicator == SELECTED_INDICATOR_SELECTED))
        option.isSelected = selected;
    }
  } // setOptionSelected


  /// Add to Selected
  void onButtonAdd(MouseEvent evt) {
    List<LPicklistMultiItem> items = new List<LPicklistMultiItem>();
    for (LPicklistMultiItem item in _leftItems) {
      if (item.selected) {
        items.add(item);
        setOptionSelected(item.option, true);
        item.option.seqNo = _rightItems.length * 1000; // end
      }
    }
    for (LPicklistMultiItem item in items) {
      _leftItems.remove(item);
      _rightItems.add(item);
    }
    _redisplay();
  }
  /// Remove from Selected
  void onButtonRemove(MouseEvent evt) {
    List<LPicklistMultiItem> items = new List<LPicklistMultiItem>();
    for (LPicklistMultiItem item in _rightItems) {
      if (item.selected) {
        items.add(item);
        setOptionSelected(item.option, false);
        item.option.seqNo = 0;
        item.selected = false;
      }
    }
    for (LPicklistMultiItem item in items) {
      _rightItems.remove(item);
      _leftItems.add(item);
    }
    _redisplay();
  }
  /// Move selected on Selected up
  void onButtonUp(MouseEvent evt) {
    for (LPicklistMultiItem item in _rightItems) {
      if (item.selected) {
        item.option.seqNo = item.option.seqNo - 15;
      }
    }
    _redisplay();
  }
  /// Move selected in Selected down
  void onButtonDown(MouseEvent evt) {
    for (LPicklistMultiItem item in _rightItems) {
      if (item.selected) {
        item.option.seqNo = item.option.seqNo + 15;
      }
    }
    _redisplay();
  }

  /// Resort and re-display
  void _redisplay() {
    // Available
    _formLeftPlList.children.clear();
    _formLeftPlList.style.removeProperty("background");
    _leftItems.sort((LPicklistMultiItem one, LPicklistMultiItem two){
      return one.option.label.compareTo(two.option.label);
    });
    for (LPicklistMultiItem item in _leftItems) {
      _formLeftPlList.append(item.element);
      item.option.seqNo = 0;
      item.dragOver = false;
    }

    // Selected
    _formRightPlList.children.clear();
    _formRightPlList.style.removeProperty("background");
    _rightItems.sort((LPicklistMultiItem one, LPicklistMultiItem two){
      return one.option.seqNo.compareTo(two.option.seqNo);
    });
    int seqNo = 1;
    for (LPicklistMultiItem item in _rightItems) {
      _formRightPlList.append(item.element);
      item.option.seqNo = (seqNo++ * 10);
      item.dragOver = false;
    }
    element.focus(); // remove focus from items
  } // redisplay


  /// drag over
  void onDragOverList(MouseEvent evt) {
    evt.preventDefault();
    evt.dataTransfer.dropEffect = 'move';
    Element target = evt.target;
    if (target == _formLeftPlList || target == _formRightPlList) {
      target.style.background = "azure";
    }
  }
  void onDragLeaveList(MouseEvent evt) {
    Element target = evt.target;
    target.style.removeProperty("background");
  }
  /// drop it
  void onDropList(MouseEvent evt) {
    evt.stopPropagation();
    Element target = evt.target;
    bool selected = target == _formRightPlList;
    String valueDropped = evt.dataTransfer.getData("text/plain");
    _log.config("onDropList ${valueDropped} selected=${selected}");
    if (valueDropped == null || valueDropped.isEmpty) {
      _redisplay();
      return;
    }
    LPicklistMultiItem item = getItem(valueDropped, removeFromList: true);
    if (item == null) {
      _log.fine("onDropList NotFound ${valueDropped}");
      _redisplay();
      return;
    }
    if (selected) {
      item.option.seqNo = _rightItems.length * 1000; // end
      _rightItems.add(item);
    } else {
      _leftItems.add(item);
    }
    _redisplay();
  } // onDropList

  /// drop it
  void onDropItem(MouseEvent evt) {
    evt.stopPropagation();
    Element target = evt.target;
    String valueTarget = target.attributes[Html0.DATA_VALUE];
    if (valueTarget == null) { // span
      target = target.parent;
      valueTarget = target.attributes[Html0.DATA_VALUE];
      if (valueTarget == null) { // span
        target = target.parent;
        valueTarget = target.attributes[Html0.DATA_VALUE];
      }
    }
    String valueDropped = evt.dataTransfer.getData("text/plain");
    _log.config("onDropItem ${valueDropped} on ${valueTarget}");
    if (valueDropped == null || valueDropped.isEmpty
        || valueTarget == null || valueTarget.isEmpty
        || valueDropped == valueTarget) {
      _redisplay();
      return;
    }
    LPicklistMultiItem item = getItem(valueDropped, removeFromList: true);
    if (item == null) {
      _log.fine("onDropItem NotFound ${valueDropped}");
      _redisplay();
      return;
    }
    for (LPicklistMultiItem ii in _leftItems) {
      if (ii.value == valueTarget) {
        _leftItems.add(item);
        _redisplay();
        return;
      }
    }
    for (LPicklistMultiItem ii in _rightItems) {
      if (ii.value == valueTarget) {
        item.option.seqNo = ii.option.seqNo - 15; // before
        _rightItems.add(item);
        _redisplay();
        return;
      }
    }
    _log.warning("onDropItem NotFound ${valueTarget}");
    _leftItems.add(item);
    _redisplay();
  } // onDropItem

  /// find item
  LPicklistMultiItem getItem(String value, {bool removeFromList:false}) {
    for (LPicklistMultiItem ii in _leftItems) {
      if (ii.value == value) {
        if (removeFromList)
          _leftItems.remove(ii);
        return ii;
      }
    }
    for (LPicklistMultiItem ii in _rightItems) {
      if (ii.value == value) {
        if (removeFromList)
          _rightItems.remove(ii);
        return ii;
      }
    }
    return null;
  } // getDroppedItem


  /// string info
  String toString() {
    return "LPicklistMulti[available=${_leftItems.length} selected=${_rightItems.length}]";
  }


  static String lPicklistMultiAdd() => Intl.message("Add", name: "lPicklistMultiAdd");
  static String lPicklistMultiRemove() => Intl.message("Remove", name: "lPicklistMultiRemove");
  static String lPicklistMultiUp() => Intl.message("Up", name: "lPicklistMultiUp");
  static String lPicklistMultiDown() => Intl.message("Down", name: "lPicklistMultiDown");

  static String lPicklistMultiSelected() => Intl.message("Selected", name: "lPicklistMultiSelected");
  static String lPicklistMultiAvailable() => Intl.message("Available", name: "lPicklistMultiAvailable");

} // LPicklistMulti


/**
 * Multi Picklist Item
 */
class LPicklistMultiItem {

  /// List Item Element
  final LIElement element = new LIElement()
    ..classes.addAll([LPicklist.C_PICKLIST__ITEM])
    ..draggable = true
    ..attributes[Html0.ROLE] = Html0.ROLE_OPTION
    ..attributes[Html0.ARIA_SELECTED] = Html0.V_FALSE
    ..tabIndex = -1;
  final SpanElement _span = new SpanElement()
    ..classes.add(LText.C_TRUNCATE);
  final SpanElement _label = new SpanElement();

  /// The item option
  final DOption option;

  /**
   * Multi Picklist Item
   */
  LPicklistMultiItem(DOption this.option, {LIcon icon}) {
    element.append(_span);
    if (icon == null && option.hasIconImage()) {
      icon = LIcon.create(option.iconImage);
    }
    if (icon != null) {
      icon.classes.addAll([LIcon.C_ICON__X_SMALL, LIcon.C_ICON_TEXT_DEFAULT, LMargin.C_RIGHT__X_SMALL]);
      _span.append(icon.element);
    }
    _span.append(_label);
    //
    element.onClick.listen((Event evt) {
      selected = !selected; // toggle
    });
    label = option.label;
    // DnD
    element.onDragStart.listen(onDragStart);
    element.onDragOver.listen(onDragOver);
    element.onDragLeave.listen(onDragLeave);
    element.attributes[Html0.DATA_VALUE] = value;
  } // LPicklistMultiItem


  /// selected for action
  bool get selected => element.attributes[Html0.ARIA_SELECTED] == Html0.V_TRUE;
  /// selected for action
  void set selected (bool newValue) {
    element.attributes[Html0.ARIA_SELECTED] = newValue.toString();
  }

  String get label => _label.text;
  void set label (String newValue) {
    _label.text = newValue;
  }

  String get value => option.value;

  /// Drag Start
  void onDragStart(MouseEvent evt) {
    evt.dataTransfer.effectAllowed = 'move'; // none, copy, copyLink, copyMove, link, linkMove, move, all, uninitialized
    evt.dataTransfer.setData('text/plain', value);
  }
  /// drag over
  void onDragOver(MouseEvent evt) {
    evt.preventDefault();
    evt.dataTransfer.dropEffect = 'move';
    dragOver = true;
  }
  void onDragLeave(MouseEvent evt) {
    dragOver = false;
  }

  /// drag over indicator
  void set dragOver (bool newValue) {
    if (newValue)
      element.style.background = "cyan";
    else
      element.style.removeProperty("background");
  }

  /// string info
  String toString() {
    return "LPicklistMultiItem@${value}[selected=${selected}]";
  }

} // LPicklistMultiItem
