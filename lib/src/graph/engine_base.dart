/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Chart Engine Interface
 */
abstract class EngineBase {

  /// Graph Element
  Element get element;

  /// Group By Column Names
  List<String> groupByColumnNames = new List<String>();

  /// Set Heading
  void set title (String newValue);

  /// Set Sub Heading
  void set subTitle (String newValue);

  /// Sync Table
  LTable syncTable;

  /// Reset Elements
  void reset();


  /// render stacked chart - true if success
  bool renderStacked(GraphCalc calc, bool displayHorizontal);

  /// render pie chart - true if success
  bool renderPie(GraphCalc calc, bool displayHorizontal);

  /// need label update
  bool get needLabelUpdate;

} // PanelBase
