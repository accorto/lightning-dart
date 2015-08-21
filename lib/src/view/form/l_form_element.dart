/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Form Element
 */
class LFormElement extends LComponent {

  /// Form Element
  final DivElement element = new DivElement()
    ..classes.add(LForm.C_FORM_ELEMENT);

} // LFormElement
