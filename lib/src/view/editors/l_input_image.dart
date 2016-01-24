/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


/**
 * Image Input
 */
class LInputImage extends LInput {

  /// IconSpec RegExp
  static final RegExp regExpImage = new RegExp(r'^(http|data:)');


  /// File Input
  LInputImage(String name, {String idPrefix, bool inGrid:false, bool withClearValue:false})
      : super(name, EditorI.TYPE_IMAGE, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue) {
  }

  /// File Input
  LInputImage.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false, bool withClearValue:false})
      : super.from(dataColumn, EditorI.TYPE_IMAGE, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue) {
  }

  /// Init editor
  _initEditor(String type) {
    super._initEditor(type);
  }

  /// value is rendered
  bool get isValueRenderElement => true;

  /// render the value
  Element getValueRenderElement(String theValue) {
    if (theValue != null && theValue.isNotEmpty) {
      // image
      if (theValue.contains(regExpImage)) {
        ImageElement img = new ImageElement(src: theValue);
        return img;
      }
      // icon
      if (theValue.contains(LIcon.regExpIconSpec)) {
        return LIcon.create(theValue, size: LIcon.C_ICON__X_SMALL,
            color: LIcon.C_ICON_TEXT_DEFAULT)
            .element;
      }
      // fallback
      return new DivElement()
        ..classes.add(LText.C_TRUNCATE)
        ..text = theValue;
    }

    return new DivElement();
  }

} // LInputImage
