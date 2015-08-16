/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Tooltip
 */
class LTooltip {

  static const String C_TOOLTIP = "slds-tooltip";
  static const String C_TOOLTIP__CONTENT = "slds-tooltip__content";
  static const String C_TOOLTIP__BODY = "slds-tooltip__body";


  /// Tooltip element
  final DivElement element = new DivElement()
    ..classes.add(C_TOOLTIP)
    ..attributes[Html0.ROLE] = Html0.ROLE_TOOLTIP;

  final DivElement content = new DivElement()
    ..classes.add(C_TOOLTIP__CONTENT)
    ..attributes[Html0.ROLE] = Html0.ROLE_DOCUMENT;

  final DivElement body = new DivElement()
    ..classes.add(C_TOOLTIP__CONTENT);


  /**
   * Tooltip
   * [nubbin] e.g. LTooltip.C_NUBBIN__TOP
   */
  LTooltip(String bodyText, {String nubbin}) {
    element.append(content);
    if (nubbin != null && nubbin.isNotEmpty)
      element.classes.add(nubbin);

    content.append(body);
    if (bodyText != null)
      body.text = bodyText;
  }

} // LTooltip
