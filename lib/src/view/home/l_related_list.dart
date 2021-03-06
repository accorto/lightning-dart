/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Object Related List
 */
class LRelatedList extends LPageHeader {

  UI ui;
  DataRecord data;

  LRelatedList(UI this.ui) {
    // nav Breadcrumb
    // div Grid
    // - div left
    // - div right
    // p detail
  }

  DRecord get record => data.record;
  void set record (DRecord newValue) {
    data.setRecord(newValue, 0);
    display();
  } // setData

  void display() {
  }

} // LRelatedList
