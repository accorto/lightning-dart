/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Charted Theme Mod
 * include
    <link rel="stylesheet" href="packages/lightning/assets/styles/charted_theme.css">
 */
class EngineChartedTheme
    extends QuantumChartTheme {

  @override
  ChartAxisTheme getMeasureAxisTheme([Scale _]) =>
      const EngineChartedAxisTheme(ChartAxisTheme.FILL_RENDER_AREA, 5);

  @override
  ChartAxisTheme getDimensionAxisTheme([Scale scale]) =>
      scale == null || scale is OrdinalScale
          ? const EngineChartedAxisTheme(0, 10)
          : const EngineChartedAxisTheme(4, 10);


  String get ticksFont => '12px Salesforce Sans';
}

/**
 * Charted Axis Theme
 */
class EngineChartedAxisTheme
    implements ChartAxisTheme {

  @override
  final axisOuterPadding = 0.1;

  @override
  final axisBandInnerPadding = 0.35;

  @override
  final axisBandOuterPadding = 0.175;

  @override
  final axisTickPadding = 6;

  @override
  final axisTickSize;

  @override
  final axisTickCount;

  @override
  final verticalAxisAutoResize = true;

  @override
  final verticalAxisWidth = 75;

  @override
  final horizontalAxisAutoResize = false;

  @override
  final horizontalAxisHeight = 50;

  @override
  final ticksFont = '12px Salesforce Sans';

  /// Instance
  const EngineChartedAxisTheme(this.axisTickSize, this.axisTickCount);

} // EngineChartedAxisTheme
