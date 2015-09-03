/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Spinner - see LComponent
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
  LSpinner(String size, String src, {String altText}) {
    element.classes.add(size);
    img.src = LIcon.HREF_PREFIX + src;
    if (altText == null)
      img.alt = lSpinnerWorking() + " ...";
    else
      img.alt = altText;
    element.append(img);
  }

  /// Base Spinner
  LSpinner.base({String size: C_SPINNER__MEDIUM})
    : this(size, SRC_BASE);
  /// Brand Spinner
  LSpinner.brand({String size: C_SPINNER__MEDIUM})
    : this(size, SRC_BRAND);
  /// Inverse Spinner
  LSpinner.inverse({String size: C_SPINNER__MEDIUM})
    : this(size, SRC_INVERSE);


  void set large (bool newValue) {
    if (newValue) {
      element.classes.removeAll([C_SPINNER__MEDIUM, C_SPINNER__SMALL]);
      element.classes.add(C_SPINNER__LARGE);
    }
  }
  void set medium (bool newValue) {
    if (newValue) {
      element.classes.removeAll([C_SPINNER__LARGE, C_SPINNER__SMALL]);
      element.classes.add(C_SPINNER__MEDIUM);
    }
  }
  void set small (bool newValue) {
    if (newValue) {
      element.classes.removeAll([C_SPINNER__MEDIUM, C_SPINNER__LARGE]);
      element.classes.add(C_SPINNER__SMALL);
    }
  }

  /// Translation
  static String lSpinnerWorking() => Intl.message("working", name: "lSpinnerWorking");

} // LSpinner
