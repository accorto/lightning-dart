/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Stat (Group) By
 */
class GraphBy
    extends StatBy {

  static final Logger _log = new Logger("GraphBy");

  /**
   * Graph (Group) by
   */
  GraphBy(String key, String label, Map<String,String> keyLabelMap)
    : super(key, label, keyLabelMap) {

    if (keyLabelMap == null) {
      _log.config("keyMap for FK=${key}");
      FkService.instance.getFkMapFuture(key) // columnName
      .then((Map<String, String> map) {
        keyLabelMap = map;
        needLabelUpdate = true;
      });
    }
  } // GraphBy

  /**
   * Graph (Group) by
   */
  GraphBy.column(DColumn column)
      : super.column(column) {

    if (keyLabelMap == null) {
      _log.config("keyMap for FK=${key}");
      FkService.instance.getFkMapFuture(key) // columnName
      .then((Map<String, String> map) {
        keyLabelMap = map;
        needLabelUpdate = true;
      });
    }
  } // GraphBy


} // GraphBy
