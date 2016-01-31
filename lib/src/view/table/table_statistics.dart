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

  final List<DataColumn> datacolumns;
  final List<StatCalc> calcList = new List<StatCalc>();

  /**
   * Table Statistics
   */
  TableStatistics(List<DataColumn> this.datacolumns) {
    for (DataColumn dataColumn in datacolumns) {
      StatCalc calc = new StatCalc(dataColumn.table.name,
          dataColumn.tableColumn);
      calcList.add(calc);
    }
  } // TableStatistics


  /**
   * Calculate
   */
  void calculate(List<DRecord> recordList, List<StatBy> byList,
      DColumn dateColumn, ByPeriod byPeriod) {
    for (StatCalc what in calcList) {
      what.resetCalc(byList, dateColumn, byPeriod);
    }
    for (DRecord record in recordList) {
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
    //
    for (StatCalc what in calcList) {what.dump();}
  } // calculate



} // TableStatistics
