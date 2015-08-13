/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Modal Dialog
 */
class LModal extends LComponent {

  static const String C_MODAL = "slds-modal";
  static const String C_MODAL__LARGE = "slds-modal--large";
  static const String C_FADE_IN_OPEN = "slds-fade-in-open";

  static const String C_MODAL__CONTAINER = "slds-modal__container";
  static const String C_MODAL__HEADER = "slds-modal__header";
  static const String C_MODAL__CLOSE = "slds-modal__close";
  static const String C_MODAL__CONTENT = "slds-modal__content";
  static const String C_MODAL__FOOTER = "slds-modal__footer";
  static const String C_MODAL__FOOTER__DIRECTIONAL = "slds-modal__footer--directional";

  static const String C_MODAL_BACKDROP = "slds-modal-backdrop";
  static const String C_MODAL_BACKDROP__OPEN = "slds-modal-backdrop--open";

  /// Outer Element
  final DivElement element = new DivElement();

  final DivElement dialog = new DivElement()
    ..classes.add(C_MODAL)
    ..attributes[Html0.ROLE] = Html0.ROLE_DIALOG;

  final DivElement container = new DivElement()
    ..classes.add(C_MODAL__CONTAINER);
  final DivElement header = new DivElement()
    ..classes.add(C_MODAL__CONTAINER);
  final DivElement content = new DivElement()
    ..classes.add(C_MODAL__CONTAINER);
  final DivElement footer = new DivElement()
    ..classes.add(C_MODAL__CONTAINER);
  LButton buttonSave;
  LButton buttonCancel;


  final DivElement backdrop = new DivElement()
    ..classes.add(C_MODAL_BACKDROP);

  /**
   * Modal Dialog
   */
  LModal(String idPrefix) {
    element.id = idPrefix;
    element.append(dialog);
    dialog.append(container);
    container.append(header);
    container.append(content);
    container.append(footer);
    element.append(backdrop);
  } // LModal


  /// Large Modal
  bool get large => dialog.classes.contains(C_MODAL__LARGE);
  /// Large Modal
  void set large (bool newValue) {
    if (newValue)
      dialog.classes.add(C_MODAL__LARGE);
    else
      dialog.classes.remove(C_MODAL__LARGE);
  }

  /**
   * Set Header (and close)
   */
  void setHeaderComponents(HeadingElement h2, Element tagLine) {
    header.children.clear();
    h2.classes.add(LText.C_TEXT_HEADING__MEDIUM);
    header.append(h2);
    if (tagLine != null)
      header.append(tagLine);
    // Close
    LButton buttonClose = new LButton("close", null, idPrefix: id,
        buttonClasses: [C_MODAL__CLOSE],
        icon: new LIcon.action("close", className: LButton.C_BUTTON__ICON,
          colorOverride: LButton.C_BUTTON__ICON__INVERSE, size: LButton.C_BUTTON__ICON__LARGE),
        assistiveText: lModalClose());
    buttonClose.onClick.listen(onClickHide);
    header.append(buttonClose.element);
  }
  /// Set header
  void setHeader(String title, {String tagLine}) {
    HeadingElement h2 = new HeadingElement.h2()
      ..text = title;
    ParagraphElement p;
    if (tagLine != null)
      p = new ParagraphElement()
        ..text = tagLine;
    setHeaderComponents(h2, p);
  } // setHeader

  /**
   * Add to Content
   */
  void addContent(Element contentElement) {
    content.append(contentElement);
  }

  /// Append Div
  CDiv appendDiv() {
    CDiv div = new CDiv();
    content.append(div.element);
    return div;
  }

  /// Append Section
  CSection appendSection() {
    CSection div = new CSection();
    content.append(div.element);
    return div;
  }

  /**
   * Set Footer
   */
  void setFooter(List<Element> footerElements, bool directional) {
    footer.children.clear();
    if (directional)
      footer.classes.add(C_MODAL__FOOTER__DIRECTIONAL);
    else
      footer.classes.remove(C_MODAL__FOOTER__DIRECTIONAL);
    ///
    if (footerElements != null) {
      for (Element fe in footerElements) {
        if (fe != null)
          footer.append(fe);
      }
    }
  } // setFooter

  /**
   * Set Footer Buttons - returns save button
   * [buttonCancel] hides the dialog
   */
  LButton setFooterButtons({String saveNameOverride, bool hideOnSave: true,
      bool addCancel: true}) {
    String saveLabel = saveNameOverride;
    if (saveLabel == null || saveLabel.isEmpty)
      saveLabel = lModalSave();
    buttonSave = new LButton("save", saveLabel, idPrefix: id,
      buttonClasses: [LButton.C_BUTTON__NEUTRAL, LButton.C_BUTTON__BRAND]);
    if (hideOnSave)
      buttonSave.onClick.listen(onClickHide);

    if (addCancel) {
      buttonCancel = new LButton("cancel", lModalCancel(), idPrefix: id,
        buttonClasses: [LButton.C_BUTTON__NEUTRAL]);
      buttonCancel.onClick.listen(onClickHide);
      setFooter([buttonSave, buttonCancel], false);
    } else {
      setFooter([buttonSave], false);
    }
    return buttonSave;
  } // setFooterButtons


  /// Showing Modal
  bool get show => backdrop.classes.contains(C_MODAL_BACKDROP__OPEN);
  /// Show/Hide Modal
  void set show (bool newValue) {
    dialog.attributes[Html0.ARIA_HIDDEN] = newValue ? "false" : "true";
    if (newValue) {
      dialog.classes.add(C_FADE_IN_OPEN);
      backdrop.classes.add(C_MODAL_BACKDROP__OPEN);
    } else {
      dialog.classes.remove(C_FADE_IN_OPEN);
      backdrop.classes.remove(C_MODAL_BACKDROP__OPEN);
    }
  }

  /// Hide Modal
  void onClickHide(MouseEvent evt) {
    show = false;
  }

  /// Hide and Remove Modal
  void onClickHideAndRemove(MouseEvent evt) {
    show = false;
    element.remove();
  }


  // Trl
  static String lModalClose() => Intl.message("Close", name: "lModalClose", args: []);
  static String lModalCancel() => Intl.message("Cancel", name: "lModalCancel", args: []);
  static String lModalSave() => Intl.message("Save", name: "lModalSave", args: []);

} // LModal
