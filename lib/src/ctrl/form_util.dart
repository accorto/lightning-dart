/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Form Util - create Fotm from UI
 */
class FormUtil {


  final LForm form;
  final UI ui;

  /**
   * Form Util
   */
  FormUtil(LForm this.form, UI this.ui) {
  }

  void build() {
    for (UIPanel panel in ui.panelList) {
      for (UIPanelColumn pc in panel.panelColumnList) {

        LInput inp = new LInput.from(pc.column, idPrefix:form.id);
        form.addEditor(inp);

      }
    }

  } // build

} // FormUtil
