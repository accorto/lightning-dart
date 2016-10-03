/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;


// Lightning Dart Utilities


/// Alignment
class LAlignment {

  /// slds-align--absolute-center: Class will absolutely center children content
  static const String C_ALIGN__ABSOLUTE_CENTER = "slds-align--absolute-center";

}

/// Floats
class LFloat {

  /// slds-float--left: Pulls element from document flow and floats left. Text and other elements wrap around it.
  static const String C_FLOAT__LEFT = "slds-float--left";
  /// slds-float--right: Pulls element from document flow and floats right. Text and other elements wrap around it.
  static const String C_FLOAT__RIGHT = "slds-float--right";
  /// slds-clearfix: Contains floats and stops wrapping of elements following it. - Applies to parent of floats
  static const String C_CLEARFIX = "slds-clearfix";

} // LFloat


// Hyphenation
class LHyphenation {

  /// slds-hyphenate (any element): Creates hyphenated text - Hyphenation will occur at the parent width if a width is not specified
  static const String C_HYPHENATE = "slds-hyphenate";

}


/// Interactions
class LInteraction {

  /// slds-has-blur-focus (any element): Blur focus is an accessibility class that will add a blurred border to an element when it is focused.
  static const String C_HAS_BLUR_FOCUS = "slds-has-blur-focus";
  /// slds-type-focus (container): Creates a faux link with interactions - This is used when an actual anchor element can not be used. For example — when a heading and button are next to each other and both need the text underline
  static const String C_TYPE_FOCUS = "slds-type-focus";
  /// slds-text-link--reset (a or .slds-button): Makes links and buttons appear as regular text
  static const String C_TEXT_LINK__RESET = "slds-text-link--reset";
  /// slds-text-link (any element): Makes text inside of .slds-text-link--reset to appear as a link.
  static const String C_TEXT_LINK = "slds-text-link";

}


/// Position
class LPosition {

  /// slds-is-relative (any element): Used to contain children if children are absolutely positioned and out of flow. Also used to position element without changing layout.
  static const String C_IS_RELATIVE = "slds-is-relative";
  /// slds-is-static (any element): Reset positioning back to normal behavior
  static const String C_IS_STATIC = "slds-is-static";

}



/// Sizing
class LSizing {

  static const String C_SIZE__1_OF_1 = "slds-size--1-of-1";

  static const String C_SIZE__1_OF_2 = "slds-size--1-of-2";

  static const String C_SIZE__1_OF_3 = "slds-size--1-of-3";
  static const String C_SIZE__2_OF_3 = "slds-size--2-of-3";

  static const String C_SIZE__1_OF_4 = "slds-size--1-of-4";
  static const String C_SIZE__2_OF_4 = "slds-size--2-of-4";
  static const String C_SIZE__3_OF_4 = "slds-size--3-of-4";

  static const String C_SIZE__1_OF_5 = "slds-size--1-of-5";
  static const String C_SIZE__2_OF_5 = "slds-size--2-of-5";
  static const String C_SIZE__3_OF_5 = "slds-size--3-of-5";
  static const String C_SIZE__4_OF_5 = "slds-size--4-of-5";

  static const String C_SIZE__1_OF_6 = "slds-size--1-of-6";
  static const String C_SIZE__2_OF_6 = "slds-size--2-of-6";
  static const String C_SIZE__3_OF_6 = "slds-size--3-of-6";
  static const String C_SIZE__4_OF_6 = "slds-size--4-of-6";
  static const String C_SIZE__5_OF_6 = "slds-size--5-of-6";

  static const String C_SIZE__1_OF_12 = "slds-size--1-of-12";
  static const String C_SIZE__2_OF_12 = "slds-size--2-of-12";
  static const String C_SIZE__3_OF_12 = "slds-size--3-of-12";
  static const String C_SIZE__4_OF_12 = "slds-size--4-of-12";
  static const String C_SIZE__5_OF_12 = "slds-size--5-of-12";
  static const String C_SIZE__6_OF_12 = "slds-size--6-of-12";
  static const String C_SIZE__7_OF_12 = "slds-size--7-of-12";
  static const String C_SIZE__8_OF_12 = "slds-size--8-of-12";
  static const String C_SIZE__9_OF_12 = "slds-size--9-of-12";
  static const String C_SIZE__10_OF_12 = "slds-size--10-of-12";
  static const String C_SIZE__11_OF_12 = "slds-size--11-of-12";

  /// default
  static const String C__SIZE__1_OF_ = "slds-size--1-of-";
  /// 30rem / 480px
  static const String C_SMALL_SIZE__1_OF_ = "slds-small-size--1-of-";
  /// 48rem / 768px
  static const String C_MEDIUM_SIZE__1_OF_ = "slds-medium-size--1-of-";
  /// 64rem / 1024px
  static const String C_LARGE_SIZE__1_OF_ = "slds-large-size--1-of-";

  /// 30rem / 480px
  static const String C_MAX_SMALL_SIZE__1_OF_ = "slds-max-small-size--1-of-";
  /// 48rem / 768px
  static const String C_MAX_MEDIUM_SIZE__1_OF_ = "slds-max-medium-size--1-of-";
  /// 64rem / 1024px
  static const String C_MAX_LARGE_SIZE__1_OF_ = "slds-max-large-size--1-of-";


  static String sizeXofY(int x, int y) {
    return "slds-size--${x}-of-${y}";
  }
  static String sizeSmallXofY(int x, int y) {
    return "slds-small-size--${x}-of-${y}";
  }
  static String sizeMediumXofY(int x, int y) {
    return "slds-medium-size--${x}-of-${y}";
  }
  static String sizeLargeXofY(int x, int y) {
    return "slds-large-size--${x}-of-${y}";
  }

  static String size1ofY(int y) {
    return "slds-size--1-of-${y}";
  }
  static String sizeSmall1ofY(int y) {
    return "slds-small-size--1-of-${y}";
  }
  static String sizeMedium1ofY( int y) {
    return "slds-medium-size--1-of-${y}";
  }
  static String sizeLarge1ofY(int y) {
    return "slds-large-size--y-of-${y}";
  }

} // LSizing


/**
 * Margin
 */
class LMargin {

  static const String C_TOP__NONE = "slds-m-top--none";
  static const String C_TOP__XXX_SMALL = "slds-m-top--xxx-small";
  static const String C_TOP__XX_SMALL = "slds-m-top--xx-small";
  static const String C_TOP__X_SMALL = "slds-m-top--x-small";
  static const String C_TOP__SMALL = "slds-m-top--small";
  static const String C_TOP__MEDIUM = "slds-m-top--medium";
  static const String C_TOP__LARGE = "slds-m-top--large";
  static const String C_TOP__X_LARGE = "slds-m-top--x-large";
  static const String C_TOP__XX_LARGE = "slds-m-top--xx-large";

  static const String C_RIGHT__XXX_SMALL = "slds-m-right--xxx-small";
  static const String C_RIGHT__XX_SMALL = "slds-m-right--xx-small";
  static const String C_RIGHT__X_SMALL = "slds-m-right--x-small";
  static const String C_RIGHT__SMALL = "slds-m-right--small";
  static const String C_RIGHT__MEDIUM = "slds-m-right--medium";
  static const String C_RIGHT__LARGE = "slds-m-right--large";
  static const String C_RIGHT__X_LARGE = "slds-m-right--x-large";
  static const String C_RIGHT__XX_LARGE = "slds-m-right--xx-large";

  static const String C_BOTTOM__NONE = "slds-m-bottom--none";
  static const String C_BOTTOM__XXX_SMALL = "slds-m-bottom--xxx-small";
  static const String C_BOTTOM__XX_SMALL = "slds-m-bottom--xx-small";
  static const String C_BOTTOM__X_SMALL = "slds-m-bottom--x-small";
  static const String C_BOTTOM__SMALL = "slds-m-bottom--small";
  static const String C_BOTTOM__MEDIUM = "slds-m-bottom--medium";
  static const String C_BOTTOM__LARGE = "slds-m-bottom--large";
  static const String C_BOTTOM__X_LARGE = "slds-m-bottom--x-large";
  static const String C_BOTTOM__XX_LARGE = "slds-m-bottom--xx-large";

  static const String C_LEFT__NONE = "slds-m-left--none";
  static const String C_LEFT__XXX_SMALL = "slds-m-left--xxx-small";
  static const String C_LEFT__XX_SMALL = "slds-m-left--xx-small";
  static const String C_LEFT__X_SMALL = "slds-m-left--x-small";
  static const String C_LEFT__SMALL = "slds-m-left--small";
  static const String C_LEFT__MEDIUM = "slds-m-left--medium";
  static const String C_LEFT__LARGE = "slds-m-left--large";
  static const String C_LEFT__X_LARGE = "slds-m-left--x-large";
  static const String C_LEFT__XX_LARGE = "slds-m-left--xx-large";

  static const String C_VERTICAL__NONE = "slds-m-vertical--none";
  static const String C_VERTICAL__XXX_SMALL = "slds-m-vertical--xxx-small";
  static const String C_VERTICAL__XX_SMALL = "slds-m-vertical--xx-small";
  static const String C_VERTICAL__X_SMALL = "slds-m-vertical--x-small";
  static const String C_VERTICAL__SMALL = "slds-m-vertical--small";
  static const String C_VERTICAL__MEDIUM = "slds-m-vertical--medium";
  static const String C_VERTICAL__LARGE = "slds-m-vertical--large";
  static const String C_VERTICAL__X_LARGE = "slds-m-vertical--x-large";
  static const String C_VERTICAL__XX_LARGE = "slds-m-vertical--xx-large";

  static const String C_HORIZONTAL__NONE = "slds-m-horizontal--none";
  static const String C_HORIZONTAL__XXX_SMALL = "slds-m-horizontal--xxx-small";
  static const String C_HORIZONTAL__XX_SMALL = "slds-m-horizontal--xx-small";
  static const String C_HORIZONTAL__X_SMALL = "slds-m-horizontal--x-small";
  static const String C_HORIZONTAL__SMALL = "slds-m-horizontal--small";
  static const String C_HORIZONTAL__MEDIUM = "slds-m-horizontal--medium";
  static const String C_HORIZONTAL__LARGE = "slds-m-horizontal--large";
  static const String C_HORIZONTAL__X_LARGE = "slds-m-horizontal--x-large";
  static const String C_HORIZONTAL__XX_LARGE = "slds-m-horizontal--xx-large";

  static const String C_AROUND__NONE = "slds-m-around--none";
  static const String C_AROUND__XXX_SMALL = "slds-m-around--xxx-small";
  static const String C_AROUND__XX_SMALL = "slds-m-around--xx-small";
  static const String C_AROUND__X_SMALL = "slds-m-around--x-small";
  static const String C_AROUND__SMALL = "slds-m-around--small";
  static const String C_AROUND__MEDIUM = "slds-m-around--medium";
  static const String C_AROUND__LARGE = "slds-m-around--large";
  static const String C_AROUND__X_LARGE = "slds-m-around--x-large";
  static const String C_AROUND__XX_LARGE = "slds-m-around--xx-large";

} // LMargin


/**
 * Padding
 */
class LPadding {

  static const String C_TOP__NONE = "slds-p-top--none";
  static const String C_TOP__XXX_SMALL = "slds-p-top--xxx-small";
  static const String C_TOP__XX_SMALL = "slds-p-top--xx-small";
  static const String C_TOP__X_SMALL = "slds-p-top--x-small";
  static const String C_TOP__SMALL = "slds-p-top--small";
  static const String C_TOP__MEDIUM = "slds-p-top--medium";
  static const String C_TOP__LARGE = "slds-p-top--large";
  static const String C_TOP__X_LARGE = "slds-p-top--x-large";
  static const String C_TOP__XX_LARGE = "slds-p-top--xx-large";

  static const String C_RIGHT__NONE = "slds-p-right--none";
  static const String C_RIGHT__XXX_SMALL = "slds-p-right--xxx-small";
  static const String C_RIGHT__XX_SMALL = "slds-p-right--xx-small";
  static const String C_RIGHT__X_SMALL = "slds-p-right--x-small";
  static const String C_RIGHT__SMALL = "slds-p-right--small";
  static const String C_RIGHT__MEDIUM = "slds-p-right--medium";
  static const String C_RIGHT__LARGE = "slds-p-right--large";
  static const String C_RIGHT__X_LARGE = "slds-p-right--x-large";
  static const String C_RIGHT__XX_LARGE = "slds-p-right--xx-large";

  static const String C_BOTTOM__NONE = "slds-p-bottom--none";
  static const String C_BOTTOM__XXX_SMALL = "slds-p-bottom--xxx-small";
  static const String C_BOTTOM__XX_SMALL = "slds-p-bottom--xx-small";
  static const String C_BOTTOM__X_SMALL = "slds-p-bottom--x-small";
  static const String C_BOTTOM__SMALL = "slds-p-bottom--small";
  static const String C_BOTTOM__MEDIUM = "slds-p-bottom--medium";
  static const String C_BOTTOM__LARGE = "slds-p-bottom--large";
  static const String C_BOTTOM__X_LARGE = "slds-p-bottom--x-large";
  static const String C_BOTTOM__XX_LARGE = "slds-p-bottom--xx-large";

  static const String C_LEFT__NONE = "slds-p-left--none";
  static const String C_LEFT__XXX_SMALL = "slds-p-left--xxx-small";
  static const String C_LEFT__XX_SMALL = "slds-p-left--xx-small";
  static const String C_LEFT__X_SMALL = "slds-p-left--x-small";
  static const String C_LEFT__SMALL = "slds-p-left--small";
  static const String C_LEFT__MEDIUM = "slds-p-left--medium";
  static const String C_LEFT__LARGE = "slds-p-left--large";
  static const String C_LEFT__X_LARGE = "slds-p-left--x-large";
  static const String C_LEFT__XX_LARGE = "slds-p-left--xx-large";

  static const String C_VERTICAL__NONE = "slds-p-vertical--none";
  static const String C_VERTICAL__XXX_SMALL = "slds-p-vertical--xxx-small";
  static const String C_VERTICAL__XX_SMALL = "slds-p-vertical--xx-small";
  static const String C_VERTICAL__X_SMALL = "slds-p-vertical--x-small";
  static const String C_VERTICAL__SMALL = "slds-p-vertical--small";
  static const String C_VERTICAL__MEDIUM = "slds-p-vertical--medium";
  static const String C_VERTICAL__LARGE = "slds-p-vertical--large";
  static const String C_VERTICAL__X_LARGE = "slds-p-vertical--x-large";
  static const String C_VERTICAL__XX_LARGE = "slds-p-vertical--xx-large";

  static const String C_HORIZONTAL__NONE = "slds-p-horizontal--none";
  static const String C_HORIZONTAL__XXX_SMALL = "slds-p-horizontal--xxx-small";
  static const String C_HORIZONTAL__XX_SMALL = "slds-p-horizontal--xx-small";
  static const String C_HORIZONTAL__X_SMALL = "slds-p-horizontal--x-small";
  static const String C_HORIZONTAL__SMALL = "slds-p-horizontal--small";
  static const String C_HORIZONTAL__MEDIUM = "slds-p-horizontal--medium";
  static const String C_HORIZONTAL__LARGE = "slds-p-horizontal--large";
  static const String C_HORIZONTAL__X_LARGE = "slds-p-horizontal--x-large";
  static const String C_HORIZONTAL__XX_LARGE = "slds-p-horizontal--xx-large";

  static const String C_AROUND__NONE = "slds-p-around--none";
  static const String C_AROUND__XXX_SMALL = "slds-p-around--xxx-small";
  static const String C_AROUND__XX_SMALL = "slds-p-around--xx-small";
  static const String C_AROUND__X_SMALL = "slds-p-around--x-small";
  static const String C_AROUND__SMALL = "slds-p-around--small";
  static const String C_AROUND__MEDIUM = "slds-p-around--medium";
  static const String C_AROUND__LARGE = "slds-p-around--large";
  static const String C_AROUND__X_LARGE = "slds-p-around--x-large";
  static const String C_AROUND__XX_LARGE = "slds-p-around--xx-large";

} // LPadding


/**
 * Truncation
 */
class LTruncate {

  /// slds-truncate (any element): Creates truncated text - Truncation will occur at the parent width if a width is not specified
  static const String C_TRUNCATE = "slds-truncate";
  /// slds-has-flexi-truncate (.slds-col--padded): Allows truncation in nested flexbox containers - This class is placed on a parent element that contains a flexbox element containing .slds-truncate. For example — for a media object that is nested in a grid column and contains truncation — the grid column would require this class.
  static const String C_HAS_FLEXI_TRUNCATE = "slds-has-flexi-truncate";

}
