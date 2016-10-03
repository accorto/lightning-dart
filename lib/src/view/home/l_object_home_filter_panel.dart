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

  static const NAME_TEMP = "temp";

  /// element
  Element element = new Element.aside()
    ..classes.add(LObjectHome.C_HOME_POPIN);

  /// name editor
  LInput _nameEditor;
  LButton _buttonSave;

  /// Filter List
  UListElement _filters = new UListElement()
    ..classes.addAll([LList.U_HAS_DIVIDERS__AROUND_SPACE]);
  /// filter item list
  final List<ObjectHomeFilterItem> _filterItemList = new List<ObjectHomeFilterItem>();

  /// sync Table
  LTable syncTable;
  LButtonStatefulIcon _syncTableButton;

  /// Saved Query
  SavedQuery _savedQuery;

  final String idPrefix;
  int _optionSeq = 0;

  /// button on object Home
  LButton homeFilterButton;
  /// Callback
  EditorChange editorChange;

  /// Pop-In Panel
  ObjectHomeFilterPanel(String this.idPrefix) {
    String id = LComponent.createId("f-e", idPrefix); // table.name);
    element.id = id;

    // header
    _syncTableButton = new LButtonStatefulIcon("syncTable",
        objectHomeFilterPanelSyncTable(),
        new LIconUtility(LIconUtility.TABLE),
        idPrefix: id,
        onButtonClick: onSyncButtonClick)
      //..small = true
      ..selected = false
      ..element.style.verticalAlign = "top";

    DivElement text = new DivElement()
      ..classes.addAll([LText.C_TEXT_HEADING__SMALL, LMargin.C_TOP__XX_SMALL, LMargin.C_LEFT__MEDIUM])
      ..style.display = "inline-block"
      ..text = objectHomeFilterPanel();

    LButton close = new LButton.iconBare("close",
        new LIconUtility(LIconUtility.RIGHT),
        LModal.lModalClose(),
        idPrefix: id)
      ..classes.add(LFloat.C_FLOAT__RIGHT);
    close.onClick.listen(onCancelClick);

    LButton buttonAdd = new LButton.neutralIcon("addFilter",
        objectHomeFilterPanelAddFilter(),
        new LIconUtility(LIconUtility.NEW),
        idPrefix: id)
      ..onClick.listen(onAddClick);
    LButton buttonExecute = LModal.createExecuteButton(label: objectHomeFilterPanelExecute(), idPrefix: id)
      ..classes.add(LFloat.C_FLOAT__RIGHT)
      ..onClick.listen(onExecuteClick);
    DivElement header1 = new DivElement()
      ..classes.add(LMargin.C_TOP__SMALL)
      ..append(buttonAdd.element)
      ..append(buttonExecute.element);
    Element header = new Element.header()
      ..classes.add(LMargin.C_BOTTOM__X_SMALL)
      ..append(_syncTableButton.element)
      ..append(close.element)
      ..append(text)
      ..append(header1);
    element.append(header);

    element.append(_filters);

    // footer
    LButton buttonCancel = LModal.createCancelButton(idPrefix: id)
      ..onClick.listen(onCancelClick)
      ..classes.add(LFloat.C_FLOAT__LEFT);
    _nameEditor = new LInput("filterName", EditorI.TYPE_TEXT, idPrefix: id, inGrid: true)
      ..placeholder = objectHomeFilterPanelSaveName()
      ..title = objectHomeFilterPanelSaveName()
      ..element.classes.addAll([LFloat.C_FLOAT__RIGHT, LMargin.C_RIGHT__X_SMALL])
      ..maxWidth = "10rem";
    _nameEditor.editorChange = onNameEditorChange;
    _buttonSave = LModal.createSaveButton(label: objectHomeFilterPanelSave(), idPrefix: id)
      ..classes.add(LFloat.C_FLOAT__RIGHT)
      ..onClick.listen(onSaveClick);
    Element footer = new Element.footer()
      ..classes.add(LMargin.C_VERTICAL__MEDIUM)
      ..append(buttonCancel.element)
      ..append(_buttonSave.element)
      ..append(_nameEditor.element);
    element.append(footer);
  } // ObjectFilterElement

  /// set UI
  void setUi(UI ui) {
    _table = ui.table;
  }
  DTable _table;

  /// Display [savedQuery]
  void set savedQuery (SavedQuery savedQuery) {
    _savedQuery = savedQuery;
    _optionSeq = 0;
    _filterItemList.clear();
    _filters.children.clear(); // ul
    _nameEditor.value = "";
    _buttonSave.disabled = true;

    if (_savedQuery != null) {
      if (_savedQuery.name.isNotEmpty && _savedQuery.name != NAME_TEMP) {
        _nameEditor.value = _savedQuery.name;
        _buttonSave.disabled = false;
      }
      for (DFilter filter in _savedQuery.filterList) {
        _addFilter(filter);
      }
    }
    if (_filterItemList.isEmpty) {
      _addFilter(new DFilter());
    }
  } // saved query

  /// get updated saved query
  SavedQuery get savedQuery {
    List<DFilter> filters = getFilters();
    if (filters == null) {
      return null;
    }

    if (_savedQuery == null) {
      _savedQuery = new SavedQuery();
    } else {
      _savedQuery.clearIsUpsert();
      _savedQuery.filterList.clear();
      _savedQuery.clearFilterLogic();
      _savedQuery.sortList.clear();
      _savedQuery.clearSqlWhere();
    }
    String name = _nameEditor.value;
    if (name == null || name.isEmpty)
      name = NAME_TEMP;
    _savedQuery.name = name;
    _savedQuery.tableName = _table.name;
    //
    _savedQuery.filterList.addAll(filters);

    return _savedQuery;
  } // savedQuery

  /// Add Filter to list and display
  void _addFilter(DFilter filter) {
    _optionSeq++;
    String prefix = "${idPrefix}-o-${_optionSeq}";
    ObjectHomeFilterItem item = new ObjectHomeFilterItem(_table, filter, prefix, onItemDelete);
    _filterItemList.add(item);
    _filters.append(item.li); // wrapper
  }

  /// Name changed - enable save
  void onNameEditorChange(String name, String newValue, DEntry entry, var details) {
    String theValue = _nameEditor.value;
    _buttonSave.disabled = theValue.isEmpty;
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
  void onAddClick(MouseEvent evt) {
    _addFilter(new DFilter());
  }

  /// cancel (close)
  void onCancelClick(MouseEvent evt) {
    show = false;
  }

  /// save click
  void onSaveClick(MouseEvent evt) {
    SavedQuery sq = savedQuery;
    if (editorChange != null && sq != null) {
      sq.isUpsert = true;
      editorChange("panel", sq.name, null, sq); // LObjectHomeFilter.onSavedQueryChange
    }
  }
  /// execute click
  void onExecuteClick(MouseEvent evt) {
    SavedQuery sq = savedQuery;
    if (editorChange != null && sq != null) {
      editorChange("panel", sq.name, null, sq); // LObjectHomeFilter.onSavedQueryChange
    }
  }

  /// get filters or null if error
  List<DFilter> getFilters() {
    List<DFilter> list = new List<DFilter>();
    for (ObjectHomeFilterItem item in _filterItemList) {
      DFilter filter = item.getFilter();
      if (filter == null && item.isError) {
        list = null;
      }
      if (list != null && filter != null) {
        list.add(filter);
      }
    }
    return list;
  } // getFilters


  /// Sync Table Button clicked
  void onSyncButtonClick(MouseEvent evt) {
    doSyncTable(null);
  }

  /// sync table
  bool get isSyncTable {
    return syncTable != null && _syncTableButton != null && _syncTableButton.selected;
  }

  /// Sync Table
  void doSyncTable(String by) {
    if (syncTable != null) {
      if (by != null && by.isEmpty) {
        by = null;
      }
      if (isSyncTable) {
      } else {
        by = null;
        syncTable.graphSelect(null);
      }
      if (by != syncTable.groupByColumnName) {
        syncTable.groupByColumnName = by;
      }
    }
  } // doSyncTable


  static String objectHomeFilterPanel() => Intl.message("Filter", name: "objectHomeFilterPanel");
  static String objectHomeFilterPanelSyncTable() => Intl.message("Sync with Table", name: "objectHomeFilterPanelSyncTable");

  static String objectHomeFilterPanelAddFilter() => Intl.message("Add Filter", name: "objectHomeFilterPanelAddFilter");

  static String objectHomeFilterPanelExecute() => Intl.message("Execute", name: "objectHomeFilterPanelExecute");
  static String objectHomeFilterPanelSaveName() => Intl.message("Filter Name", name: "objectHomeFilterPanelSaveName");
  static String objectHomeFilterPanelSave() => Intl.message("Save+Execute", name: "objectHomeFilterPanelSave");

} // ObjectHomeFilterElement
