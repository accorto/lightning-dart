/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Filter Pop-In Panel
 * edits [SavedQuery]
 * or [DFilter] list
 */
class ObjectHomeFilterPanel {

  static final Logger _log = new Logger("ObjectHomeFilterPanel");

  /// element
  Element element = new Element.aside()
    ..classes.add(LObjectHome.C_HOME_POPIN);

  /// button on object Home
  LButton homeFilterButton;

  /// Filter List
  UListElement _filters = new UListElement()
    ..classes.addAll([LList.C_LIST__VERTICAL, LList.C_HAS_CARDS__SPACE, LMargin.C_VERTICAL__MEDIUM]);
  /// filter item list
  final List<ObjectHomeFilterItem> _filterItemList = new List<ObjectHomeFilterItem>();

  SavedQuery _savedQuery;

  final String idPrefix;
  int _optionSeq = 0;

  /// Pop-In Panel
  ObjectHomeFilterPanel(String this.idPrefix) {
    String id = LComponent.createId("f-e", idPrefix); // table.name);
    element.id = id;

    // header
    SpanElement text = new SpanElement()
      ..classes.addAll([LText.C_TEXT_HEADING__SMALL, LMargin.C_TOP__SMALL, LMargin.C_LEFT__MEDIUM])
      ..text = "Filter";

    LButton close = new LButton.iconBare("close",
        new LIconUtility(LIconUtility.RIGHT),
        LModal.lModalClose(),
        idPrefix: id)
      ..classes.add(LFloat.C_FLOAT__RIGHT);
    close.onClick.listen(onClickCancel);

    LButton buttonAdd = new LButton.neutralIcon("addFilter",
        objectHomeFilterPanelAddFilter(),
        new LIconUtility(LIconUtility.NEW),
        idPrefix: id)
      ..onClick.listen(onClickAdd);
    LButton buttonExecute = LModal.createExecuteButton(label: objectHomeFilterPanelExecute(), idPrefix: id)
      ..classes.add(LFloat.C_FLOAT__RIGHT)
      ..onClick.listen(onClickExecute);
    DivElement header1 = new DivElement()
      ..classes.add(LMargin.C_TOP__SMALL)
      ..append(buttonAdd.element)
      ..append(buttonExecute.element);
    Element header = new Element.header()
      ..append(close.element)
      ..append(text)
      ..append(header1);
    element.append(header);

    element.append(_filters);

    // footer
    LButton buttonCancel = LModal.createCancelButton(idPrefix: id)
      ..onClick.listen(onClickCancel)
      ..classes.add(LFloat.C_FLOAT__LEFT);
    LInput name = new LInput("filterName", EditorI.TYPE_TEXT, idPrefix: id, inGrid: true)
      ..placeholder = objectHomeFilterPanelSaveName()
      ..title = objectHomeFilterPanelSaveName()
      ..element.classes.addAll([LFloat.C_FLOAT__RIGHT, LMargin.C_RIGHT__X_SMALL])
      ..maxWidth = "10rem";
    LButton buttonSave = LModal.createSaveButton(label: objectHomeFilterPanelSave(), idPrefix: id)
      ..classes.add(LFloat.C_FLOAT__RIGHT)
      ..onClick.listen(onClickSave);
    Element footer = new Element.footer()
      ..classes.add(LMargin.C_VERTICAL__MEDIUM)
      ..append(buttonCancel.element)
      ..append(buttonSave.element)
      ..append(name.element);
    element.append(footer);
  } // ObjectFilterElement

  /// set UI
  void setUi(UI ui) {
    _table = ui.table;
  }
  DTable _table;


  /// Display [savedQuery]
  void displaySavedQuery(SavedQuery savedQuery) {
    _savedQuery = savedQuery;
    display(_savedQuery.filterList);
  }
  /// Display [filterList]
  void display(List<DFilter> filterList) {
    _optionSeq = 0;
    _filterItemList.clear();
    _filters.children.clear(); // ul
    for (DFilter filter in filterList) {
      addFilter(filter);
    }
  }

  /// Add Filter to list and display
  void addFilter(DFilter filter) {
    _optionSeq++;
    String prefix = "${idPrefix}-o-${_optionSeq}";
    ObjectHomeFilterItem item = new ObjectHomeFilterItem(_table, filter, prefix, onItemDelete);
    _filterItemList.add(item);
    _filters.append(item.li); // wrapper
  }


  /// Showing
  bool get show => element.parent != null // attached
      && !element.classes.contains(LVisibility.C_HIDE);
  /// Show
  void set show (bool newValue) {
    element.classes.toggle(LVisibility.C_HIDE, !newValue);
    if (homeFilterButton != null) {
      homeFilterButton.selected = newValue;
    }
  }

  /// Item Delete
  void onItemDelete(ObjectHomeFilterItem item) {
    item.li.remove(); // _filters
    _filterItemList.remove(item);
    _log.config("onItemDelete filters=#${_filterItemList.length}");
  }

  /// add new filter
  void onClickAdd(MouseEvent evt) {
    addFilter(new DFilter());
  }

  /// cancel (close)
  void onClickCancel(MouseEvent evt) {
    show = false;
  }

  void onClickSave(MouseEvent evt) {

  }
  void onClickExecute(MouseEvent evt) {
  }

  static String objectHomeFilterPanelAddFilter() => Intl.message("Add Filter", name: "objectHomeFilterPanelAddFilter");

  static String objectHomeFilterPanelExecute() => Intl.message("Execute", name: "objectHomeFilterPanelExecute");
  static String objectHomeFilterPanelSaveName() => Intl.message("Filter Name", name: "objectHomeFilterPanelSaveName");
  static String objectHomeFilterPanelSave() => Intl.message("Save+Execute", name: "objectHomeFilterPanelSave");

} // ObjectHomeFilterElement
