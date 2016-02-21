/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Grid Component + Utility
 * https://www.getslds.com/components/grid-system
 */
class LGrid extends LComponent {

  /// slds-grid (any container): Initializes grid
  static const String C_GRID = "slds-grid";
  /// slds-grid--frame (slds-grid): 100% of the width and height of the viewport
  static const String C_GRID__FRAME = "slds-grid--frame";
  /// slds-grid--vertical (slds-grid): Stack your columns vertically instead of the default row behavior
  static const String C_GRID__VERTICAL = "slds-grid--vertical";
  /// slds-grid--align-center (slds-grid): Columns align to the center axis and expand in each direction
  static const String C_GRID__ALIGN_CENTER = "slds-grid--align-center";
  /// slds-grid--align-spread (slds-grid): Columns align to the left and right followed by center. Space is equal between them - With only two columns — you can get a similar effect by setting one of the columns to .slds-no-flex. (See details below.)
  static const String C_GRID__ALIGN_SPREAD = "slds-grid--align-spread";
  /// slds-grid--align-space (slds-grid): Columns are evenly distributed with equal space around them all
  static const String C_GRID__ALIGN_SPACE = "slds-grid--align-space";
  /// slds-col (Direct descendant of .slds-grid): Initializes a grid column - This class is not required since all child nodes of a flex grid become columns. It can help with clarity.
  static const String C_COL = "slds-col";
  /// slds-col--padded (Direct descendant of .slds-grid): Initializes a grid column with 0.75rem of horizontal padding - This is used instead of .slds-col — not in addition to it
  static const String C_COL__PADDED = "slds-col--padded";
  /// slds-col--padded-medium (Direct descendant of .slds-grid): Initializes a grid column with 1rem of horizontal padding - This is used instead of .slds-col — not in addition to it
  static const String C_COL__PADDED_MEDIUM = "slds-col--padded-medium";
  /// slds-col--padded-large (Direct descendant of .slds-grid): Initializes a grid column with 1.5rem of horizontal padding - This is used instead of .slds-col — not in addition to it
  static const String C_COL__PADDED_LARGE = "slds-col--padded-large";
  /// slds-grid--pull-padded (Direct descendant of .slds-grid): Normalizes the 0.75rem of padding when nesting a grid in a .slds-col--padded - Nested .slds-grid
  static const String C_GRID__PULL_PADDED = "slds-grid--pull-padded";
  /// slds-grid--pull-padded-medium (Direct descendant of .slds-grid): Normalizes the 1rem of padding when nesting a grid in a .slds-col--padded-medium - Nested .slds-grid
  static const String C_GRID__PULL_PADDED_MEDIUM = "slds-grid--pull-padded-medium";
  /// slds-grid--pull-padded-large (Direct descendant of .slds-grid): Normalizes the 1.5rem of padding when nesting a grid in a .slds-col--padded-large - Nested .slds-grid
  static const String C_GRID__PULL_PADDED_LARGE = "slds-grid--pull-padded-large";
  /// slds-col-rule--right (slds-col): Adds border to right side of column - This is only applied on a viewport width wider than 1024px
  static const String C_COL_RULE__RIGHT = "slds-col-rule--right";
  /// slds-col-rule--left (slds-col): Adds border to left side of column - This is only applied on a viewport width wider than 1024px
  static const String C_COL_RULE__LEFT = "slds-col-rule--left";
  /// slds-col-rule--top (slds-col): Adds border to top of column - This is only applied on a viewport width wider than 1024px
  static const String C_COL_RULE__TOP = "slds-col-rule--top";
  /// slds-col-rule--bottom (slds-col): Adds border to bottom of column - This is only applied on a viewport width wider than 1024px
  static const String C_COL_RULE__BOTTOM = "slds-col-rule--bottom";
  /// slds-wrap (slds-grid): Allows columns to wrap when they exceed 100% of their parent’s width
  static const String C_WRAP = "slds-wrap";
  /// slds-nowrap (slds-grid): Keeps columns on one line. Allows columns to stretch and fill 100% of the parent’s width.
  static const String C_NOWRAP = "slds-nowrap";
  /// slds-nowrap--small (slds-grid): Allows columns to stretch and fill 100% of the parent’s width when viewport width is wider than 480px.
  static const String C_NOWRAP__SMALL = "slds-nowrap--small";
  /// slds-nowrap--medium (slds-grid): Allows columns to stretch and fill 100% of the parent’s width when viewport width is wider than 768px.
  static const String C_NOWRAP__MEDIUM = "slds-nowrap--medium";
  /// slds-nowrap--large (slds-grid): Allows columns to stretch and fill 100% of the parent’s width when viewport width is wider than 1024px.
  static const String C_NOWRAP__LARGE = "slds-nowrap--large";
  /// slds-has-flexi-truncate (slds-col): Needed when truncation is nested in a flexible container in a grid - This class is placed on a parent column that contains a flexbox element containing .slds-truncate. For example — for a media object that is nested in a grid column and contains truncation — the grid column would require this class.
  static const String C_HAS_FLEXI_TRUNCATE = "slds-has-flexi-truncate";
  /// slds-no-flex (slds-col): Removes flexbox from grid column - Using this class makes the column the same width as the children within and allows the other column to take up all the extra space. The outcome is very much like using .slds-grid--align-spread on a .slds-grid element with two columns.
  static const String C_NO_FLEX = "slds-no-flex";
  /// slds-no-space (slds-col): Sets the column to a min-width of 0 - Occasionally needed on a flexible element containing .slds-truncate.
  static const String C_NO_SPACE = "slds-no-space";
  /// slds-grow (slds-col): Allows column to grow to children’s content
  static const String C_GROW = "slds-grow";
  /// slds-grow-none (slds-col): Prevents column from growing to children’s content
  static const String C_GROW_NONE = "slds-grow-none";
  /// slds-shrink (slds-col): Allows column to shrink to children's content
  static const String C_SHRINK = "slds-shrink";
  /// slds-shrink-none (slds-col): Prevents column from shrinking to children's content
  static const String C_SHRINK_NONE = "slds-shrink-none";
  /// slds-align-top (slds-col): Vertically aligns element to top of .slds-grid
  static const String C_ALIGN_TOP = "slds-align-top";
  /// slds-align-middle (slds-col): Vertically aligns element to middle of .slds-grid
  static const String C_ALIGN_MIDDLE = "slds-align-middle";
  /// slds-align-bottom (slds-col): Vertically aligns element to bottom of .slds-grid
  static const String C_ALIGN_BOTTOM = "slds-align-bottom";
  /// slds-container--small: Restrict width of containers to a maximum of 576px/36rem
  static const String C_CONTAINER__SMALL = "slds-container--small";
  /// slds-container--medium: Restrict width of containers to a maximum of 960px/60rem
  static const String C_CONTAINER__MEDIUM = "slds-container--medium";
  /// slds-container--large: Restrict width of containers to a maximum of 1280px/80rem
  static const String C_CONTAINER__LARGE = "slds-container--large";
  /// slds-container--center: Horizontally positions containers in the center of the viewport
  static const String C_CONTAINER__CENTER = "slds-container--center";
  /// slds-container--left: Horizontally positions containers to the left of the viewport
  static const String C_CONTAINER__LEFT = "slds-container--left";
  /// slds-container--right: Horizontally positions containers to the right of the viewport
  static const String C_CONTAINER__RIGHT = "slds-container--right";


  /// slds-container Marker Class
  static const String C_CONTAINER = "slds-container";
  /// slds-container--fluid - 100%
  static const String C_CONTAINER__FLUID = "slds-container--fluid";



  /// Container Sizes
  static final List<String> CONTAINER_SIZES = [C_CONTAINER__LARGE, C_CONTAINER__MEDIUM, C_CONTAINER__SMALL, C_CONTAINER__FLUID];
  /// Container HAlign
  static final List<String> CONTAINER_HALIGN = [C_CONTAINER__LEFT, C_CONTAINER__CENTER, C_CONTAINER__RIGHT];


  /// Grid Element
  final Element element;

  /**
   * Grid
   */
  LGrid(Element this.element) {
    element.classes.add(C_GRID);
  }
  /// Div Grid
  LGrid.div() : this(new DivElement());

  /// add grid class
  void addGridClass(String gridClass) {
    if (gridClass != null && gridClass.isNotEmpty)
      element.classes.add(gridClass);
  }
  /// add grid classes
  void addGridClasses(List<String> gridClasses) {
    for (String cls in gridClasses)
      addGridClass(cls);
  }


  /**
   * Append a Paragraph
   */
  ParagraphElement appendParagraph(String text, {String colClass: C_COL}) {
    ParagraphElement p = new ParagraphElement()
      ..text = text;
    element.append(p);
    return p;
  }

} // LGrid
