/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
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
  /// slds-grid--reverse (slds-grid): Reverses the main axis starting point in which your grid flows
  static const String C_GRID__REVERSE = "slds-grid--reverse";
  /// slds-grid--vertical-reverse (slds-grid): Reverses the cross axis starting point in which your grid flows
  static const String C_GRID__VERTICAL_REVERSE = "slds-grid--vertical-reverse";
  /// slds-grid--align-center (slds-grid): Columns align in the center to the main axis and expand in each direction
  static const String C_GRID__ALIGN_CENTER = "slds-grid--align-center";
  /// slds-grid--align-spread (slds-grid): Columns align to the left and right followed by center. Space is equal between them - With only two columns — you can get a similar effect by setting one of the columns to .slds-no-flex. (See details below.)
  static const String C_GRID__ALIGN_SPREAD = "slds-grid--align-spread";
  /// slds-grid--align-space (slds-grid): Columns are evenly distributed with equal space around them all
  static const String C_GRID__ALIGN_SPACE = "slds-grid--align-space";
  /// slds-grid--align-end (slds-grid): Columns start on the opposite end of the grid's main axis
  static const String C_GRID__ALIGN_END = "slds-grid--align-end";
  /// slds-grid--vertical-align-center (slds-grid): Columns align in the center to the cross axis and expand it each direction
  static const String C_GRID__VERTICAL_ALIGN_CENTER = "slds-grid--vertical-align-center";
  /// slds-grid--vertical-align-end (slds-grid): Columns start on the opposite end of the grid's cross axis
  static const String C_GRID__VERTICAL_ALIGN_END = "slds-grid--vertical-align-end";
  /// slds-grid--vertical-stretch (slds-grid): Stretch the grid items for both single row and multi-line rows to fill the height of the parent grid container - Grid items will stretch the height of the parent grid container by default, unless <wrap> is used
  static const String C_GRID__VERTICAL_STRETCH = "slds-grid--vertical-stretch";
  /// slds-grid--pull-padded (slds-grid): Normalizes the 0.75rem of padding when nesting a grid in a .slds-col--padded
  static const String C_GRID__PULL_PADDED = "slds-grid--pull-padded";
  /// slds-grid--pull-padded-medium (slds-grid): Normalizes the 1rem of padding when nesting a grid in a .slds-col--padded-medium
  static const String C_GRID__PULL_PADDED_MEDIUM = "slds-grid--pull-padded-medium";
  /// slds-grid--pull-padded-large (slds-grid): Normalizes the 1.5rem of padding when nesting a grid in a .slds-col--padded-large
  static const String C_GRID__PULL_PADDED_LARGE = "slds-grid--pull-padded-large";
  /// slds-col (Grid items of .slds-grid): Initializes a grid column - This class is not required since all child nodes of a flex grid become columns. It can help with clarity.
  static const String C_COL = "slds-col";
  /// slds-col--padded (Grid items of .slds-grid): Initializes a grid column with 0.75rem of horizontal padding - This is used instead of .slds-col — not in addition to it
  static const String C_COL__PADDED = "slds-col--padded";
  /// slds-col--padded-medium (Grid items of .slds-grid): Initializes a grid column with 1rem of horizontal padding - This is used instead of .slds-col — not in addition to it
  static const String C_COL__PADDED_MEDIUM = "slds-col--padded-medium";
  /// slds-col--padded-large (Grid items of .slds-grid): Initializes a grid column with 1.5rem of horizontal padding - This is used instead of .slds-col — not in addition to it
  static const String C_COL__PADDED_LARGE = "slds-col--padded-large";
  /// slds-col--bump-left (Grid item(s) of .slds-grid): Bumps grid item(s) away from the other grid items to sit to the left, taking up the remaining white-space of the grid container
  static const String C_COL__BUMP_LEFT = "slds-col--bump-left";
  /// slds-col--bump-right (Grid item(s) of .slds-grid): Bumps grid item(s) away from the other grid items to sit to the right, taking up the remaining white-space of the grid container
  static const String C_COL__BUMP_RIGHT = "slds-col--bump-right";
  /// slds-col--bump-top (Grid item(s) of .slds-grid): Bumps grid item(s) away from the other grid items to sit to the top, taking up the remaining white-space of the grid container
  static const String C_COL__BUMP_TOP = "slds-col--bump-top";
  /// slds-col--bump-bottom (Grid item(s) of .slds-grid): Bumps grid item(s) away from the other grid items to sit to the bottom, taking up the remaining white-space of the grid container
  static const String C_COL__BUMP_BOTTOM = "slds-col--bump-bottom";
  /// slds-wrap (slds-grid): Allows columns to wrap when they exceed 100% of their parent’s width
  static const String C_WRAP = "slds-wrap";
  /// slds-nowrap (slds-grid): Keeps columns on one line. Allows columns to stretch and fill 100% of the parent’s width and height.
  static const String C_NOWRAP = "slds-nowrap";
  /// slds-small-nowrap (slds-grid): Allows columns to stretch and fill 100% of the parent’s width and height when viewport width is wider than 480px.
  static const String C_SMALL_NOWRAP = "slds-small-nowrap";
  /// slds-medium-nowrap (slds-grid): Allows columns to stretch and fill 100% of the parent’s width and height when viewport width is wider than 768px.
  static const String C_MEDIUM_NOWRAP = "slds-medium-nowrap";
  /// slds-large-nowrap (slds-grid): Allows columns to stretch and fill 100% of the parent’s width and height when viewport width is wider than 1024px.
  static const String C_LARGE_NOWRAP = "slds-large-nowrap";
  /// slds-col--rule-right (slds-col): Adds border to right side of column
  static const String C_COL__RULE_RIGHT = "slds-col--rule-right";
  /// slds-col--rule-left (slds-col): Adds border to left side of column
  static const String C_COL__RULE_LEFT = "slds-col--rule-left";
  /// slds-col--rule-top (slds-col): Adds border to top of column
  static const String C_COL__RULE_TOP = "slds-col--rule-top";
  /// slds-col--rule-bottom (slds-col): Adds border to bottom of column
  static const String C_COL__RULE_BOTTOM = "slds-col--rule-bottom";
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

  /// slds-container--small: Restrict width of containers to a maximum of 480px
  static const String C_CONTAINER__SMALL = "slds-container--small";
  /// slds-container--medium: Restrict width of containers to a maximum of 768px
  static const String C_CONTAINER__MEDIUM = "slds-container--medium";
  /// slds-container--large: Restrict width of containers to a maximum of 1024px
  static const String C_CONTAINER__LARGE = "slds-container--large";
  /// slds-container--x-large: Restrict width of containers to a maximum of 1280px
  static const String C_CONTAINER__X_LARGE = "slds-container--x-large";
  /// slds-container--center: Horizontally positions containers in the center of the viewport
  static const String C_CONTAINER__CENTER = "slds-container--center";
  /// slds-container--left: Horizontally positions containers to the left of the viewport
  static const String C_CONTAINER__LEFT = "slds-container--left";
  /// slds-container--right: Horizontally positions containers to the right of the viewport
  static const String C_CONTAINER__RIGHT = "slds-container--right";


  /// slds-container Marker Class
  static const String C_CONTAINER = "slds-container";
  /// slds-container--fluid - width 100%
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
