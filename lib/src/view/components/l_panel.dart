/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Panel (article)
 */
class LPanel {

  /// slds-panel: Container for slide out panels
  static const String C_PANEL = "slds-panel";
  /// slds-panel__section: Contains sub sections of a panel
  static const String C_PANEL__SECTION = "slds-panel__section";
  /// slds-panel__actions: Contains form actions at the bottom of a panel
  static const String C_PANEL__ACTIONS = "slds-panel__actions";

  /// panel element
  Element element = new Element.article()
    ..classes.addAll([C_PANEL, LGrid.C_GRID, LGrid.C_GRID__VERTICAL, LGrid.C_NOWRAP]);

  DivElement _form = new DivElement()
    ..classes.addAll([LForm.C_FORM__STACKED, LGrid.C_GROW, LScrollable.C_SCROLLABLE__Y]);

  Element _footer;
  DivElement _footerContent;

  LPanel() {
    element.append(_form);
  }

  /**
   * Create/Add Form Section
   */
  DivElement addSection() {
    DivElement sec = new DivElement()
        ..classes.addAll([C_PANEL__SECTION]);
    _form.append(sec);
    return sec;
  }

  /**
   * Add to Footer Actions (create footer if not exists)
   */
  void addFooter(Element footerElement) {
    if (_footer == null) {
      _footerContent = new DivElement()
        ..classes.addAll([LGrid.C_GRID, LGrid.C_GRID__ALIGN_CENTER]); // x-small-buttons--horizontal ?
      _footer = new Element.footer()
          ..classes.addAll([C_PANEL__ACTIONS, LList.C_HAS_DIVIDER__TOP])
          ..append(_footerContent);
      element.append(_footer);
    }
    _footerContent.append(footerElement);
  }

} // LPanel
