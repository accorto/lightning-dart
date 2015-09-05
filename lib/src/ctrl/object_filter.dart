/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

typedef void FilterUpdated(SavedQuery query);

class ObjectFilter {

  static const String _ID = "o-filter";

  /// Modal
  LModal modal = new LModal(_ID);
  /// The Form
  LForm _form = new LForm.stacked("savedQuery", idPrefix:_ID);

  final DTable table;
  final SavedQuery savedQuery;
  final FilterUpdated filterUpdated;


  ObjectFilter(DTable this.table, SavedQuery this.savedQuery, FilterUpdated this.filterUpdated) {
    modal.setHeader(objectFilter());
    modal.add(_form);
    FormUtil fu = new FormUtil(_form, uiSavedQuery());
    fu.build();
  }

  static UI uiSavedQuery() {
    UiUtil uiu = new UiUtil(new UI());
    DTable sqTable = new DTable()
      ..name = "SavedQuery"
      ..label = objectFilter();
    uiu.setTable(sqTable);
    uiu.addPanel(null);

    // Columns
    DColumn col = new DColumn()
      ..name = "name"
      ..label = "Name"
      ..dataType = DataType.STRING
      ..uniqueSeqNo = 2
      ..displaySeqNo = 1
      ..columnSize = 60
      ..isMandatory = true;
    uiu.addColumn(col);

    // Columns
    col = new DColumn()
      ..name = "description"
      ..label = "Description"
      ..dataType = DataType.STRING
      ..columnSize = 255
      ..isMandatory = false;
    uiu.addColumn(col);


    return uiu.ui;
  } // uiSavedQuery


  static String objectFilter() => Intl.message("Filter", name: "objectFilter");


} // ObjectFilter
