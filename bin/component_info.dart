/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import 'dart:async';
import 'dart:io';
import 'dart:convert';

/**
 * Read Component Info and create constants
 */
void main() {
  readLine().listen(processLine3);
}

Stream readLine() => stdin
    .transform(UTF8.decoder)
    .transform(new LineSplitter());

/**
 * Single line with class name
 */
void processLine1(String line) {
  String cssClass = line.trim();
  String variable = cssClass.replaceAll("slds-", "").toUpperCase().replaceAll("-", "_");

  print("  static const String C_${variable} = \"${cssClass}\";");
}

/**
 * Single line with class name
 */
void processLineQuote(String line) {
  String cssClass = line;
  int index = cssClass.indexOf('"');
  if (index != -1) // first
    cssClass = cssClass.substring(index+1);
  index = cssClass.indexOf('"');
  if (index != -1) // second
    cssClass = cssClass.substring(0, index);

  String variable = cssClass.replaceAll("slds-", "").toUpperCase().replaceAll("-", "_");
  print("  static const String C_${variable} = \"${cssClass}\";");
}

/**
 * Process line with 3 parts
 */
void processLine3(String line) {
  if (line.trim().isEmpty)
    return;
  List<String> parts = line.split("\t");
  String cssClass = parts[0].substring(1);
  String outcome = "";
  if (parts.length > 1)
    outcome = parts[1];
  String comment = "";
  if (parts.length > 2)
    comment = parts[2];
  if (comment.isNotEmpty)
    comment = "| " + comment;

  String variable = cssClass.replaceAll("slds-", "").toUpperCase().replaceAll("-", "_");

  print("  /// ${cssClass} - ${outcome} ${comment}");
  print("  static const String C_${variable} = \"${cssClass}\";");
}


void processMap(String line) {
  if (line.contains('":')) {
    String varName = line;
    int index = varName.indexOf('"');
    if (index != -1) // first
      varName = varName.substring(index+1);
    index = varName.indexOf('"');
    if (index != -1) // second
      varName = varName.substring(0, index);

    String variable = varName.replaceAll("slds-", "").toUpperCase().replaceAll("-", "_");
    print("  static const String ${variable} = \"${varName}\";");

  }
}

