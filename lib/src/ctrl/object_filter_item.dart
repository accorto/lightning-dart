/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Individual Filter Item [DFilter]
 */
class ObjectFilterItem
    extends LTile {



  final DFilter filter;

  ObjectFilterItem(DFilter this.filter) {
    // layout
    element.classes.add(LTile.C_TILE__BOARD);



    // data
  } // ObjectFilterItem

}
