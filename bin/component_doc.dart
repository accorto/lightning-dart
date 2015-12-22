/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

import 'dart:async';
import 'dart:io';
import 'dart:convert';

/**
 * Process SLDS Doc Info
 */
void main() {
  new SldsDoc();
}



class SldsDoc {

  SldsDoc() {
    readLine().listen(processLine);
  }

  Stream readLine() => stdin
      .transform(UTF8.decoder)
      .transform(new LineSplitter());

  void processLine(String line) {
    line = line.trim();

    if (index == 0 && line.startsWith(".slds-")) {
      content[0] = line.substring(1);
      index = 1;
      return;
    }
    if (line == "Applied to:")
      index = 1;
    else if (line == "Outcome:")
      index = 2;
    else if (line == "Required:")
      index = 3;
    else if (line == "Comments:")
      index = 4;
    else {
      if (line.isNotEmpty && line != "--")
        content[index] = line;
      if (index == 4)
        printIt();
    }
  }

  List<String> content = new List<String>(5);
  int index = 0;
  String get cssClass  => content[0];
  String get appliedTo => content[1];
  String get outcome   => content[2];
  String get required  => content[3];
  String get comments  => content[4];

  /// Print Dart
  void printIt() {
    String comment = "  /// ${cssClass}";
    if (appliedTo != null && appliedTo.isNotEmpty) {
      String s = appliedTo;
      if (s.startsWith(".") || s.startsWith("<"))
        s = s.substring(1);
      s = s.replaceAll(">", "");
      comment += " (${s}): ";
    } else {
      comment += ": ";
    }
    if (outcome != null && outcome.isNotEmpty) {
      comment += outcome;
    }
    if (comments != null && comments.isNotEmpty) {
      comment += " - ${comments}";
    }
    print(comment);

    String variable = cssClass.replaceAll("slds-", "").toUpperCase().replaceAll("-", "_");
    print("  static const String C_${variable} = \"${cssClass}\";");
    content = new List<String>(5);
    index = 0;
  }

}
