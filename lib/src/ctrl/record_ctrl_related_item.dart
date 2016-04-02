/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Related List Item
 */
class RecordCtrlRelatedItem {

  static final Logger _log = new Logger("RecordCtrlRelatedItem");


  Element get element {
    if (relatedList == null)
      return _element;
    return relatedList.element;
  }
  Element _element = new DivElement(); // temp
  /// Related List
  LRelatedList relatedList;

  /**
   * Related List Item
   */
  RecordCtrlRelatedItem(UILink link) {
    // get UI
    if (UiService.instance != null) {
      UiService.instance.getUiFuture(uiName:link.uiRelatedName, tableName:link.tableName)
      .then((UI ui) {
        relatedList = new LRelatedList(ui);
        _element.replaceWith(relatedList.element); // switch
      })
      .catchError((error, stackTrace) {
        _log.warning(link.toString(), error, stackTrace);
      });
    }

  } // RecordCtrlRelatedItem

  /// Init Display
  void setParent(DRecord parent) {
    if (relatedList != null) {
    //  relatedList.loading = true;
      // query+display
    }
  } // display

} // RecordCtrlRelatedItem
