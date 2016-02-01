/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_graph;

/**
 * Stat (Group) By
 */
class GraphBy extends StatBy {

  static final Logger _log = new Logger("GraphBy");

  /**
   * Graph (Group) by
   */
  GraphBy(String columnName, String label, Map<String,String> keyLabelMap)
    : super(columnName, label, keyLabelMap) {

    if (keyLabelMap == null) {
      _log.config("${columnName} keyMap for FK");
      FkService.instance.getFkMapFuture(columnName)
          .then((Map<String, String> map) {
        keyLabelMap = map;
        needLabelUpdate = true;
      });
    }
  } // GraphBy

} // GraphBy
