/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Popover
 */
class LPopover {

  static const String C_DIALOG = "slds-dialog";
  static const String C_DIALOG__CONTENT = "slds-dialog__content";
  static const String C_DIALOG__HEAD = "slds-dialog__head";
  static const String C_DIALOG__BODY = "slds-dialog__body";

  static const String C_NUBBIN__TOP = "slds-nubbin--top";
  static const String C_NUBBIN__BOTTOM = "slds-nubbin--bottom";
  static const String C_NUBBIN__LEFT = "slds-nubbin--left";
  static const String C_NUBBIN__RIGHT = "slds-nubbin--right";


  /// Popover element
  final DivElement element = new DivElement()
    ..classes.add(C_DIALOG)
    ..attributes[Html0.ROLE] = Html0.ROLE_DIALOG;

  final DivElement content = new DivElement()
    ..classes.add(C_DIALOG__CONTENT)
    ..attributes[Html0.ROLE] = Html0.ROLE_DOCUMENT;

  final DivElement head = new DivElement()
    ..classes.add(C_DIALOG__HEAD);
  final DivElement body = new DivElement()
    ..classes.add(C_DIALOG__BODY);


  /**
   * Popover
   * optional [nubbin] e.g. C_NUBBIN__TOP
   */
  LPopover(String headText, String bodyText, {String nubbin}) {
    element.append(content);
    if (nubbin != null && nubbin.isNotEmpty)
      element.classes.add(nubbin);

    content.append(head);
    if (headText != null) {
      ParagraphElement p = new ParagraphElement()
        ..classes.add(LText.C_TEXT_HEADING__SMALL)
        ..text = headText;
      head.append(p);
    }
    content.append(body);
    if (bodyText != null)
      body.text = bodyText;
  } // LPopover


} // LPopover
