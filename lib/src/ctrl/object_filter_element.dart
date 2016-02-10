/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Filter Pop-In
 * edits [SavedQuery]
 * or [DFilter] list
 */
class ObjectFilterElement {

  Element element = new Element.aside();

  final Datasource datasource;
  DTable get table => datasource.ui.table;

  SavedQuery _savedQuery;

  /// filter item list
  final List<ObjectFilterItem> _filterItemList = new List<ObjectFilterItem>();
  /// Filter List
  UListElement _filters = new UListElement()
    ..classes.addAll([LList.C_LIST__VERTICAL, LList.C_HAS_CARDS__SPACE]);

  ObjectFilterElement(Datasource this.datasource) {
    String id = LComponent.createId("f-e", table.name);
    element.id = id;

    // header
    SpanElement text = new SpanElement()
      ..classes.addAll([LText.C_TEXT_HEADING__SMALL, LMargin.C_TOP__SMALL, LMargin.C_LEFT__MEDIUM])
      ..text = "Filter";

    LButton buttonClose = new LButton(new ButtonElement(), "close", null, idPrefix: id,
        buttonClasses: [LModal.C_MODAL__CLOSE],
        icon: new LIconAction("close", className: LButton.C_BUTTON__ICON,
            colorOverride: LButton.C_BUTTON__ICON_INVERSE, size: LButton.C_BUTTON__ICON__LARGE),
        assistiveText: LModal.lModalClose());
    buttonClose.onClick.listen((MouseEvent evt){
      show = false;
    });

    Element header = new Element.header()
      ..append(buttonClose.element)
      ..append(text);
    element.append(header);

    element.append(_filters);

    // footer
    LButton buttonAdd = new LButton.neutralIcon("addFilter", "Add Filter",
      new LIconUtility(LIconUtility.NEW));
    LButton buttonCancel = new LButton(new ButtonElement(), "cancel",
        LModal.lModalCancel(), idPrefix: id,
        buttonClasses: [LButton.C_BUTTON__NEUTRAL]);
    LButton buttonSave = new LButton(new ButtonElement(), "save",
        LModal.lModalSave(), idPrefix: id,
        buttonClasses: [LButton.C_BUTTON__NEUTRAL, LButton.C_BUTTON__BRAND]);

    Element footer = new Element.footer()
      ..append(buttonCancel.element)
      ..append(buttonAdd.element)
      ..append(buttonSave.element);

    element.append(footer);
  } // ObjectFilterElement


  /// Display [filterList]
  void display(List<DFilter> filterList) {
    _filterItemList.clear();
    _filters.children.clear(); // ul
    for (DFilter filter in filterList) {
      ObjectFilterItem item = new ObjectFilterItem(filter);
      _filterItemList.add(item);
      LIElement li = new LIElement()
        ..classes.add(LList.C_LIST__ITEM)
        ..append(item.element);
      _filters.append(li);
    }
  }
  void displaySavedQuery(SavedQuery savedQuery) {
    _savedQuery = savedQuery;
    display(_savedQuery.filterList);
  }


  /// Showing
  bool get show => !element.classes.contains(LVisibility.C_HIDE);
  /// Show
  void set show (bool newValue) {
    element.classes.toggle(LVisibility.C_HIDE, !newValue);
  }

}
