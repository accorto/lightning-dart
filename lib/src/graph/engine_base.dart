/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Chart Engine Interface
 */
abstract class EngineBase {

  /// Graph Element
  Element get element;

  /// Set Heading
  void set title (String newValue);

  /// Set Sub Heading
  void set subTitle (String newValue);

  /// Reset Elements
  void reset();


  /// render stacked chart - true if success
  bool renderStacked(GraphCalc calc);

  /// render pie chart - true if success
  bool renderPie(GraphCalc calc);

} // PanelBase
