/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Spinner
 */
class LSpinner {

  static const String C_SPINNER__SMALL = "slds-spinner--small";
  static const String C_SPINNER__MEDIUM = "slds-spinner--medium";
  static const String C_SPINNER__LARGE = "slds-spinner--large";


  static const String SRC_BASE = "/assets/images/spinners/slds_spinner.gif";
  static const String SRC_BRAND = "/assets/images/spinners/slds_spinner_brand.gif";
  static const String SRC_INVERSE = "/assets/images/spinners/slds_spinner_inverse.gif";

  /// Spinner Element
  final DivElement element = new DivElement();
  /// Spinner Image
  final ImageElement img = new ImageElement();

  /**
   * Spinner [size] css - [src] image
   */
  LSpinner(String size, String src, String altText) {
    element.classes.add(size);
    img.src = LIcon.HREF_PREFIX + src;
    img.alt = altText;
    element.append(img);
  }

  /// Base Spinner
  LSpinner.base({String size: C_SPINNER__MEDIUM, String altText: "Loading..."})
    : this(size, SRC_BASE, altText);
  /// Brand Spinner
  LSpinner.brand({String size: C_SPINNER__MEDIUM, String altText: "Loading..."})
    : this(size, SRC_BRAND, altText);
  /// Inverse Spinner
  LSpinner.inverse({String size: C_SPINNER__MEDIUM, String altText: "Loading..."})
    : this(size, SRC_INVERSE, altText);

} // LSpinner
