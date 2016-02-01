/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Definition List Utility
 */
class DListUtil {

  /// dl
  DListElement element = new DListElement();

  /// style - default vertical with dd indented
  List<String> defListClasses = ["dl", "dt", "dd"];

  /// Horizontal Definition List
  DListUtil.horizontal()
      : this(dlClasses:[LList.C_DL__HORIZONTAL, LList.C_DL__HORIZONTAL__LABEL, LList.C_DL__HORIZONTAL__DETAIL]);

  /// Inline Definition List
  DListUtil.inline()
      : this(dlClasses:[LList.C_DL__INLINE, LList.C_DL__INLINE__LABEL, LList.C_DL__INLINE__DETAIL]);

  /// Definition List
  DListUtil({List<String> dlClasses}) {
    if (dlClasses != null) {
      defListClasses = dlClasses;
    }
    if (defListClasses.isNotEmpty) {
      element.classes.add(defListClasses[0]);
    }
  }

  /// add term (dt) with definition (dd)
  void add(String term, dynamic definition) {
    Element dt = new Element.tag("dt")
        ..text = term;
    element.append(dt);
    //
    Element dd = new Element.tag("dd");
    if (definition == null) {
    } else if (definition is String) {
      dd.text = definition;
    } else {
      dd.text = definition.toString();
    }
    element.append(dd);
    // classes
    if (defListClasses.isNotEmpty) {
      dt.classes.add(defListClasses[1]);
      dd.classes.add(defListClasses[2]);
    }
  } // add

} // DListUtil
