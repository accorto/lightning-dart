/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Detail View
 */
class RecordCtrlDetails extends FormCtrl {


  /// Detail View
  RecordCtrlDetails(UI ui)
      : super(ui.tableName, ui, idPrefix:"rc") {
    buttonDiv = new DivElement()
//    ..classes.add(LMargin.C_VERTICAL__MEDIUM)
      ..classes.add(LModal.C_MODAL__FOOTER);
    buildPanels();
    append(buttonDiv);
    element.classes.add(LMargin.C_HORIZONTAL__LARGE);
  } // RecordCtrlDetails


} // RecordCtrlDetails
