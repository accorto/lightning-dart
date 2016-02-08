/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Table Statistics
 */
class TableStatistics {

  static final Logger _log = new Logger("TableStatistics");

  /// table name
  final String tableName;
  /// all data columns
  final List<DataColumn> datacolumnList;
  /// stat calc for data columns
  final List<StatCalc> calcList = new List<StatCalc>();
  /// date column names
  final List<String> _dateColumnNames = new List<String>();

  /**
   * Table Statistics
   */
  TableStatistics(String this.tableName, List<DataColumn> this.datacolumnList) {
    for (DataColumn dataColumn in datacolumnList) {
      dataColumn.statCol = new StatCalc(dataColumn.table.name,
          dataColumn.tableColumn);
      calcList.add(dataColumn.statCol);
      if (DataTypeUtil.isDate(dataColumn.tableColumn.dataType))
        _dateColumnNames.add(dataColumn.name);
    }
  } // TableStatistics


  /**
   * Calculate Value
   * see [GraphPanel.calculate]
   * adds group by records to [recordList]
   * returns true if records were added
   */
  bool calculate(List<DRecord> recordList,
      List<StatBy> byList,
      DColumn dateColumn, ByPeriod byPeriod) {
    _log.config("calculate '${tableName}' records=${recordList.length} calc=${calcList.length} by=${byList.length}");

    // reset
    List<StatMatch> matchList = new List<StatMatch>();
    for (StatCalc what in calcList) {
      what.resetCalc(byList, matchList, dateColumn, byPeriod);
    }

    for (DRecord record in recordList) {
      if (record.hasIsGroupBy())
        continue;
      String dateString = null;
      DateTime recordDate = null;
      if (dateColumn != null) {
        dateString = DataRecord.getColumnValue(record, dateColumn.name);
        recordDate = StatCalc.recordDate(dateString, dateColumn);
      }
      for (StatCalc what in calcList) {
        what.calculateRecord2(record, recordDate, dateString);
      }
    }

    Map<DEntry, DRecord> groupRecords = new Map<DEntry, DRecord>();
    for (StatCalc what in calcList) {
      what.dump();
      if (_dateColumnNames.contains(what.key)) {
        continue; // don't add date values
      }
      for (StatBy by in what.byList) {
        if (by.hasSum) {
          for (StatPoint byValue in by.byValueList) {
            if (byValue.hasSum) {
              DEntry key = new DEntry()
                ..columnName = by.key
                ..value = byValue.key;
              DRecord record = groupRecords[key];
              if (record == null) {
                record = new DRecord()
                  ..isGroupBy = true
                  ..drv = "${by.label}: ${byValue.label}"
                  ..who = "${tableStatisticsGroupBy()} ${by.label}: ${byValue.label}";
                record.entryList.add(key);
                groupRecords[key] = record;
              }
              record.entryList.add(new DEntry()
                ..columnName = what.key
                ..value = byValue.sum.toString());
            }
          }
        }
      }
    }
    groupRecords.forEach((DEntry key, DRecord record){
      //record.tableName = tableName;
      //_log.config("${record}");
      recordList.add(record);
    });
    _log.fine("calculate records=${recordList.length} added=${groupRecords.length}");
    return groupRecords.isNotEmpty;
  } // calculate

  static String tableStatisticsGroupBy() => Intl.message("Group by", name: "tableStatisticsGroupBy");


} // TableStatistics
