/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Lightning Media
 */
class LMedia extends LComponent {

  static const String C_MEDIA = "slds-media";
  static const String C_MEDIA__FIGURE = "slds-media__figure";
  static const String C_MEDIA__BODY = "slds-media__body";

  static const String C_MEDIA__CENTER = "slds-media--center";
  static const String C_MEDIA__REVERSE = "slds-media--reverse";
  static const String C_MEDIA__DOUBLE = "slds-media--double";
  static const String C_MEDIA__RESPONSIVE = "slds-media--responsive";

  /// Alternative Media Styles
  static final List<String> MEDIA_STYLE = [C_MEDIA__CENTER, C_MEDIA__REVERSE, C_MEDIA__DOUBLE, C_MEDIA__RESPONSIVE];

  /// Media Element
  final DivElement element = new DivElement()
    ..classes.add(C_MEDIA);

  /// Figure Image Div
  final DivElement figure = new DivElement()
    ..classes.add(C_MEDIA__FIGURE);
  /// Figure Image
  final ImageElement figureImg = new ImageElement();
  /// Figure Image Right
  ImageElement figureImgRight;
  /// Body Text Div
  final DivElement body = new DivElement()
    ..classes.add(C_MEDIA__BODY);
  /// Body Text
  final ParagraphElement bodyText = new ParagraphElement();


  /**
   * div .slds-media
   * - div .slds-media__figure
   * -- img
   * - div .slds-media__body
   * -- p
   */
  LMedia() {
    element.append(figure);
    figure.append(figureImg);
    //
    element.append(body);
    body.append(bodyText);
  }

  /// Body Text
  String get text => bodyText.text;
  /// Body Text
  void set text (String newValue) {
    bodyText.text = newValue;
  }

  /// Set Image
  void setImage(String src, {int height, String alt}) {
    figureImg.src = src;
    if (height != null && height != 0) {
      figureImg.height = height;
    }
    if (alt != null) {
      figureImg.alt = alt;
    }
  } // setImage

  /// Set Image Right (Double)
  void setImageDouble(String src, {int height, String alt}) {
    if (figureImgRight == null) {
      element.classes.removeAll(MEDIA_STYLE);
      element.classes.add(C_MEDIA__DOUBLE);
      //
      final DivElement figureRight = new DivElement()
        ..classes.addAll([C_MEDIA__FIGURE, C_MEDIA__REVERSE]);
      element.insertBefore(body,figureRight);
      figureImgRight = new ImageElement();
      figureRight.append(figureImgRight);
    }
    figureImgRight.src = src;
    if (height != null && height != 0) {
      figureImgRight.height = height;
    }
    if (alt != null) {
      figureImgRight.alt = alt;
    }
  } // setImageDouble


  void set center (bool newValue) {
    element.classes.removeAll(MEDIA_STYLE);
    if (newValue) {
      element.classes.add(C_MEDIA__CENTER);
    }
  }
  void set reverse (bool newValue) {
    element.classes.removeAll(MEDIA_STYLE);
    if (newValue) {
      element.classes.add(C_MEDIA__REVERSE);
    }
  }
  void set responsive (bool newValue) {
    element.classes.removeAll(MEDIA_STYLE);
    if (newValue) {
      element.classes.add(C_MEDIA__RESPONSIVE);
    }
  }

} // LMedia
