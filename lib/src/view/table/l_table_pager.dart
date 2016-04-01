/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Pager
 * maintains [startIndex] and [endIndex]
 * call [updatePager] after query
 */
class LTablePager {

  static const _PREV = "tp-prev";
  static const _NEXT = "tp-next";
  static List<int> _PAGESIZES = [5, 10, 25, 50, 100, 250, 500];

  final LTable ltable;
  /// button group
  final LButtonGroup _buttonGroup = new LButtonGroup();
  final Element element = new DivElement()
    ..classes.add(LMargin.C_TOP__X_SMALL);

  final LButton _prev = new LButton.iconBorder(_PREV,
      new LIconUtility(LIconUtility.CHEVRONLEFT),
      lTablePagerPrevious());
  final LButton _next = new LButton.iconBorder(_NEXT,
      new LIconUtility(LIconUtility.CHEVRONRIGHT),
      lTablePagerNext());

  /// List of pager buttons
  final List<LTablePagerButton> _buttons = new List<LTablePagerButton>();
  /// PageSize Dropdown
  LDropdown _pageSizeButton;


  /**
   * Table Pager
   */
  LTablePager(LTable this.ltable) {
    _prev.setIdPrefix(ltable.idPrefix);
    _prev.element.attributes[Html0.DATA_VALUE] = _PREV;
    _prev.onClick.listen((e){

    });
    _next.setIdPrefix(ltable.idPrefix);
    _next.element.attributes[Html0.DATA_VALUE] = _NEXT;
    _next.onClick.listen((e){

    });
    //
    _pageSizeButton = new LDropdown.action(idPrefix: ltable.idPrefix,
        title: lTablePagerSize())
      ..openOnClickOnly = true
      ..dropdown.element.title = lTablePagerSize();
    _PAGESIZES.forEach((int size) {
      DOption option = OptionUtil.option(size.toString(), size.toString());
      LDropdownItem item = new LDropdownItem(option)
        ..selected = size == _pageSize;
      _pageSizeButton.dropdown
          ..addDropdownItem(item)
          ..selectMode = true
          ..editorChange = onPagesizeEditorChange;
    });
    _buttonGroup.element
        ..style.width = "calc(100% - 2.25rem)"
        ..classes.addAll([LFloat.C_FLOAT__LEFT, LScrollable.C_SCROLLABLE__X]);
    _pageSizeButton.element.classes.add(LFloat.C_FLOAT__LEFT);
    element
      ..style.height = "2.25rem"
      ..append(_buttonGroup.element)
      ..append(_pageSizeButton.element);
  } // LTablePager

  /// Set Page Size
  void set pageSize (int newValue) {
    if (newValue != _pageSize) {
      _pageSize = newValue;
      for (LDropdownItem item in _pageSizeButton.dropdown._dropdownItemList) {
        item.selected = item.value == newValue.toString();
      }
      updatePager();
      ltable.display();
    }
  }
  int get pageSize => _pageSize;
  int _pageSize = 25;

  /// Page Size Click
  void onPagesizeEditorChange(String name, String newValue, DEntry entry, var details) {
    if (newValue != null && newValue.isNotEmpty) {
      int size = int.parse(newValue, onError: (e){
        return 0;
      });
      if (size > 0)
        pageSize = size;
    }
  } // onPagesizeEditorChange


  /// start index in table recordList
  int startIndex = 0;
  /// end index in table recordList
  int endIndex = 0;

  /// re-create pager with table recordList and pageSize
  void updatePager() {
    _buttonGroup.clear();
    _buttons.clear();
    //
    int size = ltable.recordList.length;
    int totalRows = ltable.totalRows;
    if (totalRows < size)
      totalRows = size;
    int offset = ltable.offset;

    // previous
    if (offset > 0) {
      _buttonGroup.addButton(_prev);
    }
    for (int index = 0; index < size; index += _pageSize) {
      int indexTo = index + _pageSize - 1;
      if (indexTo >= size)
        indexTo = size-1;
      //
      String labelFrom = null;
      String labelTo = null;
      if (ltable.recordSorting != null
          && ltable.recordSorting.isNotEmpty) {
        RecordSort sort = ltable.recordSorting.list.first;
        String columnName = sort.columnName;
        DRecord record = ltable.recordList[index];
        labelFrom = DataRecord.getColumnValue(record, columnName);
        record = ltable.recordList[indexTo];
        labelTo = DataRecord.getColumnValue(record, columnName);
      }
      LTablePagerButton btn = new LTablePagerButton(this, index, indexTo, labelFrom, labelTo);
      btn.selected = _buttons.isEmpty;
      _buttonGroup.addButton(btn.button);
      _buttons.add(btn);
    }
    // next
    if (offset+size < totalRows) {
      _buttonGroup.addButton(_next);
    }
    //
    startIndex = 0;
    endIndex = startIndex + _pageSize - 1;
    if (endIndex >= size)
      endIndex = size-1;

    // display
    if (offset == 0 && _buttons.length == 1) {
      show = false; // one page only
    } else {
      show = true;
      // dropdown
      bool showIt = true;
      for (int i = 0; i < _PAGESIZES.length; i++) {
        bool over = _PAGESIZES[i] > size;
        if (over) {
          _pageSizeButton.dropdown._dropdownItemList[i].disabled = !showIt;
          showIt = false;
        } else {
          _pageSizeButton.dropdown._dropdownItemList[i].disabled = false;
        }
      }
      // second line
      for (int i = 0; i < _buttons.length; i++) {
        _buttons[i].fixSecondLine(i);
      }
    }
  } // update

  /// Button Click - call LTable
  void buttonClicked(LTablePagerButton button) {
    for (LTablePagerButton btn in _buttons) {
      btn.selected = btn.indexFrom == button.indexFrom;
    }
    startIndex = button.indexFrom;
    endIndex = button.indexTo;
    ltable.display();
  } // buttonClicked

  /// show if more than one button
  void set show (bool newValue) {
    element.classes.toggle(LVisibility.C_HIDE, !newValue);
  }

  void set disabled (bool newValue) {

  }

  static String lTablePagerPrevious() => Intl.message("Previous", name: "lTablePagerPrevious");
  static String lTablePagerNext() => Intl.message("Next", name: "lTablePagerNext");

  static String lTablePagerSize() => Intl.message("Page Size", name: "lTablePagerSize");

} // LTablePager

/**
 * Table Pager Button
 */
class LTablePagerButton {

  final LTablePager pager;
  final int indexFrom;
  final int indexTo;
  String labelFrom;
  String labelTo;
  //
  LButton button;
  SpanElement _secondLine;

  /**
   * Table Pager button
   */
  LTablePagerButton(LTablePager this.pager, int this.indexFrom, int this.indexTo,
      String this.labelFrom, String this.labelTo) {
    button = new LButton.neutral("tp-${indexFrom}",
        "${indexFrom+1} - ${indexTo+1}", idPrefix: pager.ltable.idPrefix);
    //  ..small = true;
    button.element.attributes[Html0.DATA_VALUE] = indexFrom.toString();
    if (labelFrom != null) {
      String text = "${labelFrom} - ${labelTo}";
      button.title = text;
      _secondLine = new SpanElement()
        ..classes.add(LText.C_TEXT_BODY__SMALL)
        ..text = text;
      button.element
          ..append(new BRElement())
          ..append(_secondLine)
          ..style.lineHeight = "1"
          ..style.height = "2.25rem";
    }
    button.onClick.listen(onButtonClick);
  }

  void onButtonClick(Event evt) {
    pager.buttonClicked(this);
  }

  bool get selected => button.selected;
  void set selected (bool selected) {
    button.selected = selected;
  }

  /// fix description
  void fixSecondLine(int myIndex) {
    if (_secondLine == null)
      return;
    String from = labelFrom;
    String to = labelTo;
    if (myIndex == 0) { // first
      if (from.isNotEmpty)
        from = from[0];
    } else {
      String otherTo = pager._buttons[myIndex-1].labelTo; // previous To
      from = _copyDiff(from, otherTo);
    }
    if (myIndex == pager._buttons.length-1) { // last
      to = _copyDiff(to, labelFrom);
    } else {
      String otherFrom = pager._buttons[myIndex+1].labelFrom; // next from
      to = _copyDiff(to, otherFrom);
    }
    if (from.length > _CUTOFF)
      from = from.substring(0,_CUTOFF-1) + LUtil.ELLIPSIS;
    if (to.length > _CUTOFF)
      to = to.substring(0,_CUTOFF-1) + LUtil.ELLIPSIS;
    _secondLine.text = "${from} - ${to}";
  }
  static const int _CUTOFF = 10;

  String _copyDiff (String str, String other) {
    if (str.isEmpty)
      return "";
    String retValue = "";
    for (int i = 0; i < str.length && i < other.length; i++) {
      retValue += str[i];
      if (str[i] != other[i])
        return retValue;
    }
    return retValue;
  }

} // LTablePagerButton
