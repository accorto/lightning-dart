/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Image Avatars
 */
class LImage {

  static const String C_AVATAR = "slds-avatar";

  static const String C_AVATAR__X_SMALL = "slds-avatar--x-small";
  static const String C_AVATAR__SMALL = "slds-avatar--small";
  static const String C_AVATAR__MEDIUM = "slds-avatar--medium";
  static const String C_AVATAR__LARGE = "slds-avatar--large";

  static const String C_AVATAR__CIRCLE = "slds-avatar--circle";

  /// Image Sizes
  static final List<String> SIZES = [C_AVATAR__X_SMALL, C_AVATAR__SMALL, C_AVATAR__MEDIUM, C_AVATAR__LARGE];

  /// Image Element
  final SpanElement element = new SpanElement()
    ..classes.add(C_AVATAR);

  final ImageElement img;

  /// Image
  LImage(ImageElement this.img, String size, bool circle) {
    element.append(img);
    if (size != null)
      this.size = size;
    if (circle != null && circle)
      this.circle = circle;
  }

  LImage.srcXSmall(String src, String alt, {bool circle:true})
    : this (new ImageElement(src:src)..alt=alt, C_AVATAR__X_SMALL, circle);
  LImage.srcSmall(String src, String alt, {bool circle:true})
    : this (new ImageElement(src:src)..alt=alt, C_AVATAR__SMALL, circle);
  LImage.srcMedium(String src, String alt, {bool circle:true})
    : this (new ImageElement(src:src)..alt=alt, C_AVATAR__MEDIUM, circle);
  LImage.srcLarge(String src, String alt, {bool circle:true})
    : this (new ImageElement(src:src)..alt=alt, C_AVATAR__LARGE, circle);

  LImage.imgXSmall(ImageElement img, {bool circle:true})
    : this (img, C_AVATAR__X_SMALL, circle);
  LImage.imgSmall(ImageElement img, {bool circle:true})
    : this (img, C_AVATAR__SMALL, circle);
  LImage.imgMedium(ImageElement img, {bool circle:true})
    : this (img, C_AVATAR__MEDIUM, circle);
  LImage.imgLarge(ImageElement img, {bool circle:true})
    : this (img, C_AVATAR__LARGE, circle);

  /// circle
  bool get circle => element.classes.contains(C_AVATAR__CIRCLE);
  /// circle
  void set circle (bool newValue) {
    if (newValue)
      element.classes.add(C_AVATAR__CIRCLE);
    else
      element.classes.remove(C_AVATAR__CIRCLE);
  }

  /// set Size
  void set size (String newSize) {
    element.classes.removeAll(SIZES);
    if (newSize != null && newSize.isNotEmpty)
      element.classes.add(newSize);
  }

} // LImage
