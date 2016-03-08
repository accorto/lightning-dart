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

  /// slds-spinner (div): This is the gray base class for spinner
  static const String C_SPINNER = "slds-spinner";
  /// slds-spinner_container (outer <div): This container creates a full overlay to dim the page when needed
  static const String C_SPINNER_CONTAINER = "slds-spinner_container";
  /// slds-spinner--small (slds-spinner): This is the small spinner
  static const String C_SPINNER__SMALL = "slds-spinner--small";
  /// slds-spinner--medium (slds-spinner): This is the medium spinner
  static const String C_SPINNER__MEDIUM = "slds-spinner--medium";
  /// slds-spinner--large (slds-spinner): This is the large spinner
  static const String C_SPINNER__LARGE = "slds-spinner--large";
  /// slds-spinner--brand (slds-spinner): This creates the blue brand spinner
  static const String C_SPINNER__BRAND = "slds-spinner--brand";
  /// slds-spinner--inverse (slds-spinner): This is the inverse spinner
  static const String C_SPINNER__INVERSE = "slds-spinner--inverse";
  /// slds-spinner__dot-a (div): This creates two of the circles
  static const String C_SPINNER__DOT_A = "slds-spinner__dot-a";
  /// slds-spinner__dot-b (div): This creates two of the circles
  static const String C_SPINNER__DOT_B = "slds-spinner__dot-b";

  //static const String SRC_BASE = "/assets/images/spinners/slds_spinner.gif";
  //static const String SRC_BRAND = "/assets/images/spinners/slds_spinner_brand.gif";
  //static const String SRC_INVERSE = "/assets/images/spinners/slds_spinner_inverse.gif";


  /// Spinner Element
  final DivElement element = new DivElement()
    ..classes.add(C_SPINNER_CONTAINER);
  final DivElement spinner = new DivElement()
    ..attributes[Html0.ARIA_HIDDEN] = "false"
    ..attributes[Html0.ROLE] = Html0.ROLE_ALERT;

  /// Spinner Image
  final ImageElement img = new ImageElement();

  /**
   * Spinner [size] css - [src] image
   */
  LSpinner(String brand, String size, {String altText}) {
    if (brand != null)
      spinner.classes.add(brand);
    spinner
      ..classes.add(C_SPINNER)
      ..append(new DivElement()..classes.add(C_SPINNER__DOT_A))
      ..append(new DivElement()..classes.add(C_SPINNER__DOT_B));
    if (size != null)
      spinner.classes.add(size);
    if (altText == null)
      element.title = lSpinnerWorking() + " ...";
    else
      element.title = altText;
    element.append(spinner);

    /*
    element.classes.add(size);
    img.src = LIcon.HREF_PREFIX + src;
    if (altText == null)
      img.alt = lSpinnerWorking() + " ...";
    else
      img.alt = altText;
    element.append(img);
    */
  } // LSpinner

  /// Base Spinner
  LSpinner.base({String size: C_SPINNER__MEDIUM})
    : this(null, size);
  /// Brand Spinner
  LSpinner.brand({String size: C_SPINNER__MEDIUM})
    : this(C_SPINNER__BRAND, size);
  /// Inverse Spinner
  LSpinner.inverse({String size: C_SPINNER__MEDIUM})
    : this(C_SPINNER__INVERSE, size);


  void set large (bool newValue) {
    if (newValue) {
      spinner.classes.removeAll([C_SPINNER__MEDIUM, C_SPINNER__SMALL]);
      spinner.classes.add(C_SPINNER__LARGE);
    }
  }
  void set medium (bool newValue) {
    if (newValue) {
      spinner.classes.removeAll([C_SPINNER__LARGE, C_SPINNER__SMALL]);
      spinner.classes.add(C_SPINNER__MEDIUM);
    }
  }
  void set small (bool newValue) {
    if (newValue) {
      spinner.classes.removeAll([C_SPINNER__MEDIUM, C_SPINNER__LARGE]);
      spinner.classes.add(C_SPINNER__SMALL);
    }
  }

  /// Translation
  static String lSpinnerWorking() => Intl.message("working", name: "lSpinnerWorking");

} // LSpinner
