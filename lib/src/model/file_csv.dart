/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;

/**
 * CSV File
 * https://tools.ietf.org/html/rfc4180
 */
class FileCsv {

  static const String MIME = "text/csv";
  static const String QUOTE = '"';

  static final Logger _log = new Logger("FileCsv");

  final String name;
  /// csv lines
  final List<String> lines = new List<String>();
  /// cvs cells
  final List<List<String>> cells = new List<List<String>>();

  /// csv data
  FileCsv.data(List<int> data, String this.name) {
    _parse(new String.fromCharCodes(data));
  }
  /// csv string
  FileCsv.csv(String csvString, String this.name) {
    _parse(csvString);
  }

  RegExp lineSeparatorPattern = new RegExp(r'\r*\n');
  /// single character separator
  String fieldSeparator = null;

  /// number of rows
  int get rowCount => lines.length;
  /// heading columns (assuming first row)
  List<String> get headingColumns {
    if (cells.isNotEmpty)
      return cells[0];
    return new List<String>();
  }
  /// number of columns of first line
  int get colCount {
    if (cells.isNotEmpty)
      return cells[0].length;
    return minColCount;
  }

  int minColCount = 0;
  int maxColCount = 0;
  int linesEmpty = 0;

  bool hasHeading;

  /// parse String
  void _parse(String csvString) {
    lines.clear();
    lines.addAll(csvString.split(lineSeparatorPattern));
    //
    cells.clear();
    minColCount = 0;
    maxColCount = 0;
    linesEmpty = 0;
    for (String line in lines) {
      String sep = fieldSeparator == null ? "," : fieldSeparator;
      List<String>  columns = _parseLine(line, sep);
      if (columns.length < 2 && fieldSeparator == null) {
        columns = _parseLine(line, "\t");
      }
      cells.add(columns);
      if (columns.isNotEmpty) {
        if (maxColCount < columns.length)
          maxColCount = columns.length;
        if (minColCount == 0 || minColCount > columns.length)
          minColCount = columns.length;
      }
    }
    // remove trailing empty lines
    while (cells.isNotEmpty && cells.last.isEmpty)
      cells.removeLast();
    for (List<String> cellLine in cells) {
      if (cellLine.isEmpty)
        linesEmpty++;
    }
    _log.info("parse lines=${lines.length} emptyLines=${linesEmpty} columns=${minColCount}-${maxColCount}");
  } // parse

  /// single character [separator]
  List<String> _parseLine(String csvString, String separator) {
    List<String> cols = new List<String>();
    if (csvString == null || csvString.isEmpty || csvString.trim().isEmpty)
      return cols;

    bool inComment = false;
    String col = "";
    for (int rune in csvString.runes) {
      String c = new String.fromCharCode(rune);
      if (inComment) {
        if (c == QUOTE) {
          inComment = false;
        } else {
          col += c;
        }
      } else {
        if (c == QUOTE) {
          inComment = true;
        } else if (c == separator) {
          cols.add(col.trim());
          col = "";
        } else {
          col += c;
        }
      }
    }
    cols.add(col.trim());
    return cols;
  } // parseLine

  /// get column in zero-based [line][col] or null if not exists
  String col (int line, int col) {
    if (line >= 0 && line < cells.length) {
      List<String> cellList = cells[line];
      if (col >=0 && col < cellList.length) {
        return cellList[col];
      }
    }
    return null;
  }

  void dump() {
    String info = toString();
    int lineNo = 0;
    for (List<String> line in cells) {
      info += "\n- ${lineNo} #${line.length}\n  ${line}}";
      lineNo++;
    }
    _log.config(info);
  }

  /// file
  String toString() {
    String info = "${name}[lines=${lines.length} emptyLines=${linesEmpty} columns=${minColCount}";
    if (minColCount == maxColCount)
      info += "]";
    else
      info += "-${maxColCount}]";
    return info;
  }

} // FileCsv
