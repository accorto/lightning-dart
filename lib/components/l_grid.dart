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

  /// slds-grid - Initializes grid | Required
  static const String C_GRID = "slds-grid";
  /// slds-grid--frame - 100% of the width and height of the viewport | Optional, apply to .grid
  static const String C_GRID__FRAME = "slds-grid--frame";
  /// slds-grid--vertical - Stack your columns vertically instead of the default row behavior | Optional, apply to .grid
  static const String C_GRID__VERTICAL = "slds-grid--vertical";
  /// slds-grid--align-center - Columns to grow from the the center axis | Optional, apply to .grid
  static const String C_GRID__ALIGN_CENTER = "slds-grid--align-center";
  /// slds-grid--align-spread - Spread out your columns on the main axis | Optional, apply to .grid
  static const String C_GRID__ALIGN_SPREAD = "slds-grid--align-spread";
  /// slds-grid--align-space - Evenly distribute columns on the main axis | Optional, apply to .grid
  static const String C_GRID__ALIGN_SPACE = "slds-grid--align-space";
  /// slds-col - Initializes grid column | Optional
  static const String C_COL = "slds-col";
  /// slds-col--padded - Adds horizontal padding to column | Optional, apply to .col
  static const String C_COL__PADDED = "slds-col--padded";
  /// slds-col-rule--right - Adds border to right side of column | Optional, apply to .col
  static const String C_COL_RULE__RIGHT = "slds-col-rule--right";
  /// slds-col-rule--left - Adds border to left side of column | Optional, apply to .col
  static const String C_COL_RULE__LEFT = "slds-col-rule--left";
  /// slds-col-rule--top - Adds border to top of column | Optional, apply to .col
  static const String C_COL_RULE__TOP = "slds-col-rule--top";
  /// slds-col-rule--bottom - Adds border to bottom of column | Optional, apply to .col
  static const String C_COL_RULE__BOTTOM = "slds-col-rule--bottom";
  /// slds-wrap - Forces columns to wrap when they exceed 100% of their parent’s width | Optional, apply to .grid
  static const String C_WRAP = "slds-wrap";
  /// slds-nowrap - Forces columns to not wrap and stretch 100% of their parent's width | Optional, apply to .grid
  static const String C_NOWRAP = "slds-nowrap";
  /// slds-nowrap--small - Forces columns to wrap at small breakpoint | Optional, apply to .grid
  static const String C_NOWRAP__SMALL = "slds-nowrap--small";
  /// slds-nowrap--medium - Forces columns to wrap at medium breakpoint | Optional, apply to .grid
  static const String C_NOWRAP__MEDIUM = "slds-nowrap--medium";
  /// slds-nowrap--large - Forces columns to wrap at large breakpoint | Optional, apply to .grid
  static const String C_NOWRAP__LARGE = "slds-nowrap--large";
  /// slds-has-flexi-truncate - IE fix for truncation in flexbox | Required if .truncate is used within a .grid
  static const String C_HAS_FLEXI_TRUNCATE = "slds-has-flexi-truncate";
  /// slds-no-flex - Removes flexbox from grid column | Optional
  static const String C_NO_FLEX = "slds-no-flex";
  /// slds-no-space - Fix for FFOX | Optional, apply to .col
  static const String C_NO_SPACE = "slds-no-space";
  /// slds-grow - Forces element to grow to children's content | Optional
  static const String C_GROW = "slds-grow";
  /// slds-grow-none - Prevents element from growing to children's content | Optional
  static const String C_GROW_NONE = "slds-grow-none";
  /// slds-shrink - Forces element to shrink to children's content | Optional
  static const String C_SHRINK = "slds-shrink";
  /// slds-shrink-none - Prevents element from shrinking to children's content | Optional
  static const String C_SHRINK_NONE = "slds-shrink-none";
  /// slds-align-top - Vertically aligns element to top of .grid | Optional
  static const String C_ALIGN_TOP = "slds-align-top";
  /// slds-align-center - Vertically aligns element to middle of .grid | Optional
  static const String C_ALIGN_CENTER = "slds-align-center";
  /// slds-align-bottom - Vertically aligns element to bottom of .grid | Optional
  static const String C_ALIGN_BOTTOM = "slds-align-bottom";


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
