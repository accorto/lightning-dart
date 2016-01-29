/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

library lightning_graph;

import 'dart:html';

import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

import 'lightning_ctrl.dart';


part 'src/graph/graph_by.dart';
part 'src/graph/graph_calc.dart';
part 'src/graph/graph_dialog.dart';
part 'src/graph/graph_match.dart';
part 'src/graph/graph_panel.dart';
part 'src/graph/graph_point.dart';


/// Match Numeric Operator
enum MatchOpNum { EQ, GE, GT, LE, LT }

/// Match Date Operator
enum MatchOpDate { Today, ThisWeek, LastWeek, Last4Weeks }

/// By Date
enum ByPeriod { Day, Week, Month, Quarter, Year }

/// Match Types
enum MatchType { Regex, Num, Date, Null, NotNull }


/**
 * Business Graphics based on DRecord
 */
class LightningGraph {


  /// find by Period
  static ByPeriod findPeriod(String value) {
    if (ByPeriod.Day.toString() == value)
      return ByPeriod.Day;
    if (ByPeriod.Week.toString() == value)
      return ByPeriod.Week;
    if (ByPeriod.Month.toString() == value)
      return ByPeriod.Month;
    if (ByPeriod.Quarter.toString() == value)
      return ByPeriod.Quarter;
    if (ByPeriod.Year.toString() == value)
      return ByPeriod.Year;
    return null;
  }

  static String graphByDay() => Intl.message("Day", name: "graphByDay");
  static String graphByWeek() => Intl.message("Week", name: "graphByWeek");
  static String graphByMonth() => Intl.message("Month", name: "graphByMonth");
  static String graphByQuarter() => Intl.message("Quarter", name: "graphByQuarter");
  static String graphByYear() => Intl.message("Year", name: "graphByYear");

}
