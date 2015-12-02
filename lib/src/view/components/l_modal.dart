/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Modal Dialog
 * - width: 50%, min: 20rem, max: 40rem
 * - small: width: 90%, max: 580px
 * - large: width: 90%, min: 40rem (if > 48em)
 */
class LModal extends LComponent {

  /// slds-modal - Positions the modal to stretch to page edges | Required
  static const String C_MODAL = "slds-modal";
  /// slds-fade-in-open - Allows the modal to be visible. | Required
  static const String C_FADE_IN_OPEN = "slds-fade-in-open";
  /// slds-modal--large - Widens the modal to take more horizontal space
  static const String C_MODAL__LARGE = "slds-modal--large";
  /// slds-modal__container - Centers and sizes the modal horizontally and confines modal within viewport height | Required
  static const String C_MODAL__CONTAINER = "slds-modal__container";
  /// slds-modal__header - Creates the Modal Header container. | Required
  static const String C_MODAL__HEADER = "slds-modal__header";
  /// slds-modal__close - Positions the close button to the top right outside of the modal. | Required
  static const String C_MODAL__CLOSE = "slds-modal__close";
  /// slds-modal__content - Creates the scrollable content area for the modal. | Required
  static const String C_MODAL__CONTENT = "slds-modal__content";
  /// slds-modal__menu - Creates the shaded menu area for the modal. | Required
  static const String C_MODAL__MENU = "slds-modal__menu";
  /// slds-modal__footer - Creates the Modal Footer container. | Required
  static const String C_MODAL__FOOTER = "slds-modal__footer";
  /// slds-modal__footer--directional - Makes buttons inside the footer spread to both left and right.
  static const String C_MODAL__FOOTER__DIRECTIONAL = "slds-modal__footer--directional";
  /// slds-backdrop - Creates the shaded backdrop used behind the modal. | Required
  static const String C_BACKDROP = "slds-backdrop";
  /// slds-modal-backdrop - Creates the shaded backdrop used behind the modal. | Required
  //static const String C_MODAL_BACKDROP = "slds-modal-backdrop";
  /// slds-backdrop--open - Allows the backdrop to be visible. | Required
  static const String C_BACKDROP__OPEN = "slds-backdrop--open";
  /// slds-modal-backdrop--open - Allows the backdrop to be visible.
  //static const String C_MODAL_BACKDROP__OPEN = "slds-modal-backdrop--open";

  /// slds-modal--prompt - Initializes Prompt style notification | Required
  static const String C_MODAL__PROMPT = "slds-modal--prompt"; // notification

  /// slds-modal--small default 50% - 90% max=580
  static const String C_MODAL__SMALL = "slds-modal--small";

  /// Modal Form (Touch) square header
  static const String C_MODAL__FORM = "slds-modal--form";


  static final Logger _log = new Logger("LModal");

  /// open modals
  static List<LModal> _openModals = new List<LModal>();
  /// adjust z-index of nested Modals
  static void _nestedModal(LModal m) {
    if (_openModals.isEmpty)
      return;
    int openModals = 0;
    for (LModal modal in _openModals) {
      if (modal == m)
        continue;
      if (modal.show)
        openModals++;
    }
    _log.info("nestedModals count=${_openModals.length} open=${openModals}");
    if (openModals > 0) {
      m._backdrop.style.zIndex = "${9000+(openModals*2)}";
      m._dialog.style.zIndex = "${9001+(openModals*2)}";
    }
  } // nestedModals


  /// Outer Element
  final DivElement element = new DivElement();

  final DivElement _dialog = new DivElement()
    ..classes.add(C_MODAL)
    ..attributes[Html0.ROLE] = Html0.ROLE_DIALOG;
  final DivElement _container = new DivElement()
    ..classes.add(C_MODAL__CONTAINER);
  final DivElement header = new DivElement()
    ..classes.add(C_MODAL__HEADER);
  final CDiv content = new CDiv()
    ..classes.add(C_MODAL__CONTENT);
  final DivElement footer = new DivElement()
    ..classes.add(C_MODAL__FOOTER);
  /// The backdrop
  final DivElement _backdrop = new DivElement()
    ..classes.add(C_BACKDROP);

  LButton buttonSave;
  LButton buttonCancel;

  /**
   * Modal Dialog
   */
  LModal(String idPrefix) {
    element.id = idPrefix == null || idPrefix.isEmpty ? LComponent.createId("modal", null) : idPrefix;
    element.append(_dialog);
    _dialog.append(_container);
    _container.append(header);
    _container.append(content.element);
    _container.append(footer);
    element.append(_backdrop);
    //
    // enter(parent) - over(+child) - move - out - leave
    header.onMouseEnter.listen(onHeaderMouseEnter);
    header.onMouseDown.listen(onHeaderMouseDown);
    header.onMouseMove.listen(onHeaderMouseMove);
    header.onMouseUp.listen(onHeaderMouseUp);
    header.onMouseLeave.listen(onHeaderMouseLeave);
  } // LModal


  /// Large Modal - 90% 960/640 - default 50%
  bool get large => _dialog.classes.contains(C_MODAL__LARGE);
  /// Large Modal - 90% 960/640 - default 50%
  void set large (bool newValue) {
    if (newValue) {
      _dialog.classes.add(C_MODAL__LARGE);
      _dialog.classes.remove(C_MODAL__SMALL);
    } else
      _dialog.classes.remove(C_MODAL__LARGE);
  }

  /// Small Modal - 90% max=550 - default 50%
  bool get small => _dialog.classes.contains(C_MODAL__SMALL);
  /// Small Modal - 90% max=550 - default 50%
  void set small (bool newValue) {
    if (newValue) {
      _dialog.classes.add(C_MODAL__SMALL);
      _dialog.classes.remove(C_MODAL__LARGE);
    } else
      _dialog.classes.remove(C_MODAL__SMALL);
  }

  /**
   * Set Header (and close)
   */
  void setHeaderComponents(HeadingElement h2, Element tagLine) {
    header.children.clear();
    h2.classes.add(LText.C_TEXT_HEADING__MEDIUM);
    h2.id = "${id}-h2";
    header.append(h2);
    if (tagLine != null)
      header.append(tagLine);
    // Close
    LButton buttonClose = new LButton(new ButtonElement(), "close", null, idPrefix: id,
        buttonClasses: [C_MODAL__CLOSE],
        icon: new LIconAction("close", className: LButton.C_BUTTON__ICON,
          colorOverride: LButton.C_BUTTON__ICON__INVERSE, size: LButton.C_BUTTON__ICON__LARGE),
        assistiveText: lModalClose());
    buttonClose.onClick.listen(onClickHideAndRemove);
    header.append(buttonClose.element);
  }
  /// Set header
  void setHeader(String title, {String tagLine, LIcon icon}) {
    HeadingElement h2 = new HeadingElement.h2();
    if (icon != null) {
      icon.classes.addAll([LIcon.C_ICON_TEXT_DEFAULT, LIcon.C_ICON__SMALL, LMargin.C_RIGHT__SMALL]);
      h2.append(icon.element);
    }
    h2.appendText(title);
    ParagraphElement p;
    if (tagLine != null)
      p = new ParagraphElement()
        ..text = tagLine;
    setHeaderComponents(h2, p);
  } // setHeader

  /**
   * Add to Content
   */
  void addContentText(String text) {
    append(new ParagraphElement()
      ..text = text
    );
  }

  /// Add Div to content
  CDiv addDiv() {
    CDiv div = new CDiv();
    content.add(div);
    return div;
  }

  /// Add Section to content
  CDiv addSection() {
    CDiv div = new CDiv.section();
    content.add(div);
    return div;
  }

  /// append element to content
  void append(Element newValue) {
    content.append(newValue);
  }
  /// add component to content
  void add(LComponent component) {
    content.add(component);
  }
  /// add form to content + buttons to footer
  void addForm(LForm form) {
    content.add(form);
    addFooterFormButtons(form);
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
   * Set Footer Cancel|Save Buttons - returns save button
   * [hideOnSave] hide+remove on Save
   * [addCancel] hides+removes the dialog
   */
  LButton addFooterButtons({String saveNameOverride, bool hideOnSave: true, bool addCancel: true}) {
    String saveLabel = saveNameOverride;
    if (saveLabel == null || saveLabel.isEmpty)
      saveLabel = lModalSave();
    buttonSave = new LButton(new ButtonElement(), "save", saveLabel, idPrefix: id,
      buttonClasses: [LButton.C_BUTTON__NEUTRAL, LButton.C_BUTTON__BRAND]);
    if (hideOnSave)
      buttonSave.onClick.listen(onClickHideAndRemove);

    if (addCancel) {
      addFooterCancel();
    }
    footer.append(buttonSave.element);
    return buttonSave;
  } // setFooterButtons

  /// add Cancel to Footer
  void addFooterCancel() {
    if (buttonCancel == null) {
      buttonCancel = new LButton(new ButtonElement(), "cancel", lModalCancel(), idPrefix: id,
          buttonClasses: [LButton.C_BUTTON__NEUTRAL]);
      buttonCancel.onClick.listen(onClickHideAndRemove);
      footer.append(buttonCancel.element);
      footer.classes.add(C_MODAL__FOOTER__DIRECTIONAL);
    }
  } // addFooterCancel

  /**
   * Set Footer Actions
   */
  void addFooterActions(List<AppsAction> actions, {bool addCancel:false}) {
    if (addCancel)
      addFooterCancel();
    if (actions != null) {
      for (AppsAction action in actions) {
        LButton btn = action.asButton(true, buttonClasses: [LButton.C_BUTTON__NEUTRAL], idPrefix: id);
        btn.onClick.listen(onClickHideAndRemove);
        footer.append(btn.element);
      }
    }
  } // setFooterActions

  /// Add Form Buttons + cancel to footer
  void addFooterFormButtons(LForm form) {
    addFooterCancel();

    LButton reset = form.addResetButton();
    reset.element.id = "${id}-reset";
    footer.append(reset.element);
    LPopover error = form.addErrorIndicator();
    error.element.id = "${id}-error";
    footer.append(error.element);
    LButton save = form.addSaveButton();
    save.element.id = "${id}-save";
    footer.append(save.element);

    // remove button div
    if (form.buttonDiv != null) {
      form.buttonDiv.remove();
      form.buttonDiv = null;
    }
  } // addFooterFormButtons


  /// Showing Modal
  bool get show => _backdrop.classes.contains(C_BACKDROP__OPEN);
  /// Show/Hide Modal
  void set show (bool newValue) {
    _dialog.attributes[Html0.ARIA_HIDDEN] = newValue ? "false" : "true";
    if (newValue) {
      _nestedModal(this);
      _dialog.classes.add(C_FADE_IN_OPEN);
      _backdrop.classes.add(C_BACKDROP__OPEN);
      content.focus();
      _openModals.add(this);
    } else {
      _dialog.classes.remove(C_FADE_IN_OPEN);
      _backdrop.classes.remove(C_BACKDROP__OPEN);
      _openModals.remove(this);
    }
  }

  /// Show Center Screen - or left/below evt target
  void showInComponent(LComponent parent, {MouseEvent evt}) {
    parent.append(element);
    show = true;
    if (evt != null)
      _position(evt);
  }

  /// Show Center Screen - or left/below evt target
  void showInElement(Element parent, {MouseEvent evt}) {
    parent.append(element);
    show = true;
    if (evt != null)
      _position(evt);
  }

  /// Position left/below
  void _position(MouseEvent evt) {
    // normalize
    _containerOffset = new Point(0, 0);
    _container.style
      ..top = "0px"
      ..left = "0px";
    Element target = evt.target;
    if (target == null) {
      return;
    }
    // container is full window height
    Rectangle rectHeader = header.getBoundingClientRect();
    Rectangle rectTarget = target.getBoundingClientRect();
    // position left/below
    num dx = -(rectHeader.left - rectTarget.left);
    num dy = -(rectHeader.top - rectTarget.bottom);
    _containerOffset = new Point(dx-5, dy+5);
    _log.fine("offset=${_containerOffset}");
    _container.style
      ..top = "${_containerOffset.y}px"
      ..left = "${_containerOffset.x}px";
  } // _position


  /// Hide Modal
  void onClickHideOnly(MouseEvent ignored) {
    show = false;
  }

  /// Hide and Remove Modal
  void onClickHideAndRemove(MouseEvent ignored) {
    show = false;
    element.remove();
  }

  /// Move start screen (based on center screen)
  Point _mouseDownPoint = null;
  Point _containerStart = null;
  /// Container start
  Point _containerOffset = new Point(0,0);

  void onHeaderMouseEnter(MouseEvent evt) {
    // _log.fine("onHeaderMouseEnter");
    header.classes.add("grab");
  }
  void onHeaderMouseDown(MouseEvent evt) {
    _mouseDownPoint = evt.screen;
    _containerStart = _containerOffset;
    // _log.fine("onHeaderMouseDown ${_mouseDownPoint} ${_mouseDownRect}");
    header.classes.remove("grab");
    header.classes.add("grabbing");
  }
  void onHeaderMouseMove(MouseEvent evt) {
    if (_mouseDownPoint != null) {
      Point delta = evt.screen - _mouseDownPoint;
      _containerOffset = new Point(_containerStart.x + delta.x, _containerStart.y + delta.y);
      // _log.fine("onHeaderMouseMove delta=${delta} start=${_containerStart} - offset=${_containerOffset}");
      _container.style
        ..top = "${_containerOffset.y}px"
        ..left = "${_containerOffset.x}px";
    }
  }
  void onHeaderMouseUp(MouseEvent evt) {
    // Rectangle rect = _dialog.getBoundingClientRect();
    // _log.fine("onHeaderMouseUp - ${rect}");
    header.classes.add("grab");
    header.classes.remove("grabbing");
    _mouseDownPoint = null;
    _containerStart = null;
  }
  void onHeaderMouseLeave(MouseEvent evt) {
    // _log.fine("onHeaderMouseLeave");
    if (_mouseDownPoint != null)
      onHeaderMouseUp(evt);
    header.classes.remove("grab");
  }


  // Trl
  static String lModalClose() => Intl.message("Close", name: "lModalClose", args: []);
  static String lModalCancel() => Intl.message("Cancel", name: "lModalCancel", args: []);
  static String lModalSave() => Intl.message("Save", name: "lModalSave", args: []);

} // LModal



/**
 * Modal Confirmation
 */
class LConfirmation extends LModal {

  /**
   * Confirmation
   * - header [label] optional [tagline] text or [tagLineElement]
   * - content [text] optional [contentElements]
   * - footer [actions]
   */
  LConfirmation(String idPrefix, {String label, LIcon icon, String tagLine, Element tagLineElement,
      String text, List<Element> contentElements,
      List<AppsAction> actions, bool addCancel:false}) : super(idPrefix) {
    // Heading
    HeadingElement h2 = new HeadingElement.h2();
    if (label != null)
      h2.text = label;
    if (tagLine != null && tagLine.isNotEmpty && tagLineElement == null) {
      tagLineElement = new ParagraphElement()
        ..text = tagLine;
    }
    setHeaderComponents(h2, tagLineElement);
    // Content
    if (text != null && text.isNotEmpty) {
      ParagraphElement p = new ParagraphElement()
        ..text = text;
      append(p);
    }
    if (contentElements != null) {
      for (Element e in contentElements)
        append(e);
    }
    // Footer
    addFooterActions(actions, addCancel:addCancel);
  } // LConfirmation

} // LConfirmation
