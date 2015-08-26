/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Simple Page
 */
class PageSimple extends LComponent {

  /**
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   * optional [classList] (if mot defined, container/fluid)
   */
  static PageSimple create({String id: "wrap",
      bool clearContainer: true, List<String> classList}) {
    // Top Level Main
    Element e = querySelector("#${id}");
    if (e == null) {
      for (String cls in PageMain.MAIN_CLASSES) {
        e = querySelector(".${cls}");
        if (e != null) {
          break;
        }
      }
    }
    PageSimple main = null;
    if (e == null) {
      Element body = document.body; // querySelector("body");
      main = new PageSimple(new DivElement(), id, classList);
      body.append(main.element);
    } else {
      if (clearContainer) {
        e.children.clear();
      }
      main = new PageSimple(e, id, classList);
    }
    return main;
  } // init

  final Element element;

  /**
   * Simple Page
   * optional [classList] (if mot defined, container/fluid)
   */
  PageSimple(Element this.element, String id, List<String> classList){
    element.classes.clear();
    if (classList != null && classList.isNotEmpty) {
      element.classes.addAll(classList);
    } else {
      element.classes.addAll([LGrid.C_CONTAINER, LGrid.C_CONTAINER__FLUID]);
    }
    element.id = id;
  }

}
