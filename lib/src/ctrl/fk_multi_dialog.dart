/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Multi FK Lookup Dialog
 */
class FkMultiDialog {

  static final Logger _log = new Logger("FkMultiDialog");

  LModal _modal;
  DivElement _selectDiv = new DivElement()
    ..classes.add(LMargin.C_TOP__MEDIUM)
    ..style.minHeight = "200px";

  final List<DColumn> columnList;
  final List<LLookup> _lookupList = new List<LLookup>();

  /// Parent
  FkMulti multi;

  String _level0columnName = null;
  String _level1columnName = null;

  /// Fk Multi Dialog
  FkMultiDialog(String name, List<DColumn> this.columnList) {
    String idPrefix = "fkmd_${name}";
    _modal = new LModal(idPrefix);
    _modal.setHeader(FkDialog.fkDialogTitle()); // temp
    //
    LForm form = new LForm.stacked("f", idPrefix: idPrefix);
    for (int i = 0; i < columnList.length; i++) {
      DColumn column = columnList[i];
      LLookup ll = new LLookup(column.name, idPrefix: idPrefix, withClearValue: true)
        ..label = column.label;
      ll.getIconRight().element.onClick.listen(onIconClick);
      _lookupList.add(ll);
      form.addEditor(ll);
      //
      if (i == 0) {
        _level0columnName = column.name;
      } else {
        ll.required = false; // optional
        if (i == 1)
          _level1columnName = column.name;
      }
    }
    form.formRecordChange = onRecordChange;
    form.addSaveButton(label: "Select", buttonSaveChangeOnly:false)
      ..onClick.listen(onSaveClick);
    _modal.addForm(form);
    _modal.append(_selectDiv);
  } // FkMultiDialog


  /// Show after setting parent values
  void show(FkMulti multi) { // assumes modal dialog
    this.multi = multi;
    _modal.setHeader("${FkDialog.fkDialogTitle()} ${multi.label}",icon: new LIconUtility(LIconUtility.OVERFLOW));
    _modal.showModal();
    //
    // fill lookups
    for (int i = 0; i < _lookupList.length; i++) {
      String lvalue = multi.getValueAtLevel(i);
      fillLookup(i, lvalue);
    }
  } // show

  /// fill lookup and set lookup value [lvalue]
  void fillLookup(int level, String lvalue) {
    String level0columnValue = null;
    String level1columnValue = null;
    if (level > 0) {
      level0columnValue = _lookupList[0].value;
      if (level > 1) {
        level1columnValue = _lookupList[1].value;
      }
    }
    LLookup lookup = _lookupList[level];
    String fkTableName = multi.getFkTableName(level);

    _log.config("fillLookup #${level} table=${fkTableName} value=${lvalue} level0=${level0columnValue} level1=${level1columnValue}");
    if (level > 0 && (level0columnValue == null || level0columnValue.isEmpty)) {
      lookup.clearOptions();
      return;
    }

    List<DFK> fkList = FkService.instance.getFkList(fkTableName, null);
    if (fkList != null) {
      _fillLookupDetails(level, lvalue, lookup, fkList, level0columnValue, level1columnValue);
      return;
    }

    lookup.clearOptions();
    FkService.instance.getFkListFuture(fkTableName, null, null, null)
    .then((List<DFK> fkList){
      _fillLookupDetails(level, lvalue, lookup, fkList, level0columnValue, level1columnValue);
    });
  } // fillLookup

  /// fill lookup and set value [lvalue]
  void _fillLookupDetails(int level, String lvalue,
      LLookup lookup, List<DFK> fkList,
      String level0columnValue, String level1columnValue) {
    List<DOption> options = new List<DOption>();
    for (DFK fk in fkList) {
      if (level > 0
          && !FkRecord.matchExactColumnValue(fk, _level0columnName, level0columnValue)) {
        continue;
      }
      if (level > 1
          && !FkRecord.matchNullColumnValue(fk, _level1columnName, level1columnValue)) {
        continue;
      }
      options.add(OptionUtil.optionFromFk(fk, lookup.fkTableName));
    }

    lookup.dOptionList = options;
    if (level > 0)
      lookup.required = false;
    lookup.value = lvalue;
    _log.fine("fillLookupDetails #${level} value=${lvalue} fks=${fkList.length} options=${options.length}");
  } // fillLookup


  /// editor changed
  void onRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    String name = columnChanged.columnName;
    LLookup lookup = null;
    int level = 0;
    for (int i = 0; i < _lookupList.length; i++) {
      LLookup ll = _lookupList[i];
      if (name == ll.name) {
        level = i;
        lookup = ll;
        break;
      }
    }
    if (lookup != null) {
      _log.config("onEditorChange ${name} #${level} ${DataRecord.getEntryValue(columnChanged)}");
      for (int i = level+1; i < _lookupList.length; i++) {
        fillLookup(i, null);
      }
    }
  } // onEditorChange

  /// search icon clicked
  void onIconClick(MouseEvent evt) {


  } // onIconClick

  /// Check+Save
  void onSaveClick(MouseEvent evt) {
    List<String> valueList = new List<String>();
    for (LLookup lookup in _lookupList) {
      valueList.add(lookup.value);
    }
    _log.config("onSaveClick ${valueList}");
    multi.setValues(valueList);
    // close
    _modal.show = false;;
  }


} // FkMultiDialog
