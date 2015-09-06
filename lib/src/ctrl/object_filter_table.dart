/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

class ObjectFilterTable extends LComponent {

  final DivElement element = new DivElement();

  final List<DFilter> filterList;
  final DTable table;

  ObjectFilterTable(List<DFilter> this.filterList, DTable this.table) {

  }

  void reset() {

  }
}
