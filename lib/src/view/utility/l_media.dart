/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Lightning Media
 */
class LMedia extends LComponent {

  /// slds-media: Defines the overall media object - Can be applied to any outer element and will be as wide as its parent container
  static const String C_MEDIA = "slds-media";
  /// slds-media__figure: Defines the figure area - Apply this class to the first element inside the .slds-media and contains the image, icon, svg or video
  static const String C_MEDIA__FIGURE = "slds-media__figure";
  /// slds-media__figure--reverse: Defines the figure area on the other side - Apply this class to the last element inside the .slds-media and contains the image, icon, svg or video
  static const String C_MEDIA__FIGURE__REVERSE = "slds-media__figure--reverse";
  /// slds-media__body: Defines the body area - Apply this class to the second element inside the .slds-media and contains the text or other content
  static const String C_MEDIA__BODY = "slds-media__body";
  /// slds-media--center (slds-media): Aligns the content in the .slds-media__body to the middle of the .slds-media__figure
  static const String C_MEDIA__CENTER = "slds-media--center";

  /// slds-media--responsive (slds-media): .slds-media__figure and .slds-media__body stack on smaller screens
  static const String C_MEDIA__RESPONSIVE = "slds-media--responsive";

  /// Alternative Media Styles
  static final List<String> MEDIA_STYLE = [C_MEDIA__CENTER, C_MEDIA__RESPONSIVE];

  /// Media Element
  final DivElement element = new DivElement()
    ..classes.add(C_MEDIA);

  /// Figure Image Div
  final DivElement _figure = new DivElement()
    ..classes.add(C_MEDIA__FIGURE);
  /// Figure Image Div
  DivElement _figureRight;
  /// Body Text Div
  final DivElement body = new DivElement()
    ..classes.add(C_MEDIA__BODY);


  /**
   * div .slds-media
   * - div .slds-media__figure
   * -- img
   * - div .slds-media__body
   * -- p
   */
  LMedia({List<String> mediaClasses})  {
    if (mediaClasses != null)
      element.classes.addAll(mediaClasses);
    element.append(_figure);
    element.append(body);
  }

  /// append body component
  void append(Element newValue) {
    body.append(newValue);
  }
  /// append body component
  void add(LComponent component) {
    body.append(component.element);
  }

  // Set Image
  void setImage(ImageElement img) {
    _figure.children.clear();
    if (img != null)
      _figure.append(img);
  }
  /// Set Image
  void setImageSrc(String src, {int height:100, int width:100, String alt}) {
    ImageElement img = new ImageElement(src: LImage.assetsSrc(src));
    if (height != null && height != 0) {
      img.height = height;
    }
    if (width != null && width != 0) {
      img.width = width;
    }
    if (alt != null) {
      img.alt = alt;
    }
    setImage(img);
  } // setImage

  // Set Icon
  void setIcon(LIcon icon) {
    _figure.children.clear();
    if (icon != null)
      _figure.append(icon.element);
  }

  // Set Right Double Image
  void setImageRight(ImageElement img) {
    if (_figureRight == null) {
      _figureRight = new DivElement()
        ..classes.addAll([C_MEDIA__FIGURE, C_MEDIA__FIGURE__REVERSE]);
      element.append(_figureRight);
    } else {
      _figureRight.children.clear();
    }
    if (img != null) {
      _figureRight.append(img);
    }
  }
  /// Set Right Double Image
  void setImageRightSrc(String src, {int height:100, int width:100, String alt}) {
    ImageElement img = new ImageElement(src: LImage.assetsSrc(src));
    if (height != null && height != 0) {
      img.height = height;
    }
    if (width != null && width != 0) {
      img.width = width;
    }
    if (alt != null) {
      img.alt = alt;
    }
    setImageRight(img);
  } // setImage
  // Set Right Double Icon
  void setIconRight(LIcon icon) {
    if (_figureRight == null) {
      _figureRight = new DivElement()
        ..classes.addAll([C_MEDIA__FIGURE, C_MEDIA__FIGURE__REVERSE]);
      element.append(_figureRight);
    } else {
      _figureRight.children.clear();
    }
    if (icon != null) {
      _figureRight.append(icon.element);
    }
  }

  /// Center Style
  void set center (bool newValue) {
    element.classes.removeAll(MEDIA_STYLE);
    if (newValue) {
      element.classes.add(C_MEDIA__CENTER);
    }
  }
  /// Reverse Style (assumes no right icon/image)
  void set reverse (bool newValue) {
    element.children.clear();
    if (newValue) {
      element.append(body);
      element.append(_figure);
      _figure.classes.add(C_MEDIA__FIGURE__REVERSE);
    } else {
      element.append(_figure);
      element.append(body);
      _figure.classes.remove(C_MEDIA__FIGURE__REVERSE);
    }
  }
  /// Responsive
  void set responsive (bool newValue) {
    element.classes.removeAll(MEDIA_STYLE);
    if (newValue) {
      element.classes.add(C_MEDIA__RESPONSIVE);
    }
  }

} // LMedia
