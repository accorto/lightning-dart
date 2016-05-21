/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Charted Engine Container
 */
class EngineChartedContainer {

  static final Logger _log = new Logger("EngineChartedContainer");

  /// element
  final Element element = new Element.article()
    ..classes.add("chart-wrapper");

  DivElement _wrapper = new DivElement()
    ..classes.add("chart-title-wrapper");
  HeadingElement _title = new HeadingElement.h2()
    ..classes.add("chart-title");
  HeadingElement _subTitle = new HeadingElement.h4()
    ..classes.add("chart-subtitle");

  /// Data
  ChartData _data;

  /**
   * Charted Engine Container
   * chart-wrapper
   * - chart-title-wrapper
   * --  chart-title
   * - chart-host-wrapper
   * --  chart-host
   * ---   chart-canvas (svg)
   * ---   hovercard
   * --  chart-legend-host
   * ---   chart-legend-heading
   * ---   chart-legend-row
   */
  EngineChartedContainer(){
    element.append(_wrapper);
  }

  /// set chart title
  void set title (String newValue) {
    _title.text = newValue;
    if (newValue == null || newValue.isEmpty)
      _title.remove();
    else if (_title.parent == null) {
      _wrapper.append(_title);
    }
  }
  void set subTitle (String newValue) {
    _subTitle.text = newValue;
    if (newValue == null || newValue.isEmpty)
      _subTitle.remove();
    else if (_subTitle.parent == null) {
      _wrapper.append(_subTitle);
    }
  }

  /// reset elements
  void reset() {
    element.children.clear();
    element.append(_wrapper);
    _legendHost = null;
    _chartHost = null;
    _data = null;
  }

  /// create Charted layout - horizontal/vertical or flow - return width
  int _createLayout(bool displayHorizontal) {
    if (_chartHost == null) {
      DivElement chartHostWrapper = new DivElement()
        ..classes.addAll(["chart-host-wrapper"]);
      element.append(chartHostWrapper);

      String vh = "";
      if (displayHorizontal != null)
        displayHorizontal ? "-h" : "-v";
      _chartHost = new DivElement()
        ..classes.add("chart-host${vh}")
        ..dir = "ltr";
      chartHostWrapper.append(_chartHost);
      _legendHost = new DivElement()
        ..classes.add("chart-legend-host${vh}");
      chartHostWrapper.append(_legendHost);
    }
    int width = _chartHost.clientWidth;
    if (displayHorizontal == null) {
      if (width == 0)
        width = element.clientWidth;
    } else if (displayHorizontal) {
    } else { // vertical
      if (width == 0)
        width = element.clientWidth;
    }
    return width;
  } // createLayout
  DivElement _legendHost;
  DivElement _chartHost;

  /// set chart host size
  void _setChartSize(ChartConfig config, int width) {
    if (config.minimumSize.width > width) { // 400x300
      int height = 300*(width~/400);
      config.minimumSize = new Rect.size(width, height);
    }
    int height = config.minimumSize.height;
    if (height > 0) {
      _legendHost.style.maxHeight = "${height}px";
    }
    _log.fine("setChartSize size=${config.minimumSize} hostWidth=${width} height=${height}"); // x y w h
  } // setChartSize

  /// Helper method to create default behaviors for cartesian chart demos.
  Iterable<ChartBehavior> _createDefaultCartesianBehaviors() =>
      new List.from([
        new Hovercard(showDimensionTitle: true, isMouseTracking: true, isMultiValue: true),
        new AxisLabelTooltip()
      ]);

  /// dump data
  void dumpData() {
    String info = "";
    int i = 0;
    for (ChartColumnSpec col in _data.columns) {
      info += "\n\tc${i} ${col.label}: ${col.type}";
      i++;
    }
    i = 0;
    for (Iterable row in _data.rows) {
      info += "\n\tr${i} ";
      for (var d in row) {
        info += "\t${d} ";
      }
      i++;
    }
    _log.config("dumpData " + info);
  }

} // EngineChartedContainer
