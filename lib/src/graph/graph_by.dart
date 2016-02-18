/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Stat (Group) By for FK handling
 */
class GraphBy
    extends StatBy {

  static final Logger _log = new Logger("GraphBy");

  /**
   * Graph (Group) by
   */
  GraphBy(String key, String label, Map<String,String> keyLabelMap)
    : super(key, label, keyLabelMap) {
    _init();
  } // GraphBy

  /**
   * Graph (Group) by
   */
  GraphBy.column(DColumn column)
      : super.column(column) {
    _init();
  } // GraphBy

  /// Initiate FK query
  void _init() {
    if (keyLabelMap == null && FkService.instance != null) {
      String fkTableName = key; // column name
      if (column != null) {
        fkTableName = column.fkReference;
        if (fkTableName.isEmpty) {
          fkTableName = key;
          _log.warning("keyMap for FK=${key} - no FkReference");
        } else {
          _log.config("keyMap for FK=${key} - ${fkTableName}");
        }
      } else {
        _log.info("keyMap for FK=${key} - no Column.FkReference");
      }
      keyLabelMap = FkService.instance.getFkMap(fkTableName);
      needLabelUpdate = true;
      if (keyLabelMap == null) {
        FkService.instance.getFkMapFuture(fkTableName)
            .then((Map<String, String> map) {
          keyLabelMap = map;
          needLabelUpdate = true;
        });
      }
    }
  }

} // GraphBy
