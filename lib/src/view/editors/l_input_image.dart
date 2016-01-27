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

  static final Logger _log = new Logger("LInputImage");

  /// IconSpec RegExp
  static final RegExp regExpImage = new RegExp(r'^(http|data:)');
  static final RegExp regExpImage2 = new RegExp(r'\.(png|jpg|gif|svg)$');


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
    // super._initEditor(type);
    input.style.maxHeight = "2.5rem";
    input.onClick.listen(onInputClick);
  }

  /// value is rendered
  bool get isValueRenderElement => true;

  /// render the value
  Element getValueRenderElement(String theValue) {
    if (theValue != null && theValue.isNotEmpty) {
      // image
      if (theValue.contains(regExpImage) || theValue.contains(regExpImage2)) {
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

  /// In input click
  void onInputClick(MouseEvent evt) {
    evt.preventDefault(); // =submit
    _log.config("onInputClick ${name}");
    if (readOnly || disabled)
      return;

  }

  /// set readOnly via disabled
  void set readOnly(bool newValue) {
    input.readOnly = newValue; // does not prevent click
    input.disabled = newValue;
  }

  bool get disabled => _disabled;
  void set disabled(bool newValue) {
    _disabled = newValue;
    input.disabled = _disabled || readOnly;
  }
  bool _disabled = false;

} // LInputImage
