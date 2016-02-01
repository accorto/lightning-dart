/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Graph Dialog
 * (graph element in dialog)
 * launched by button click
 */
class GraphDialog
    extends GraphElement {

  static final Logger _log = new Logger("GraphDialog");


  LModal _modal;
  final Element parent;

  /**
   * Graph Dialog for [table]
   */
  GraphDialog(Element this.parent, Datasource datasource)
      : super(datasource) {
  } // GraphDialog

  /// Initialize Dialog
  void init() {
    String id = LComponent.createId("gd", table.name);
    _modal = new LModal(id)
      ..large = true
      ..content.element.style.minHeight = "400px";
    _modal.setHeader("${graphDialogTitle()}: ${table.label}",
        icon: new LIconUtility(LIconUtility.CHART));

    LForm form = _initForm(id);
    _modal.add(form);

    _graphPanel = new GraphPanel(id, table.name);
    _modal.add(_graphPanel);
  } // init

  /// Init and show dialog
  void onGraphClick(MouseEvent evt) {
    _log.config("onGraphClick");
    if (_modal == null) {
      init();
    }
    _modal.showInElement(parent);
  }


  static String graphDialogTitle() => Intl.message("Graph", name: "graphDialogTitle");

} // GraphDialog
