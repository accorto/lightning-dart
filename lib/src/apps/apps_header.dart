/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Page Main Header - Logo (for the moment)
 */
class AppsHeader extends LComponent {

  final Element element = new Element.header()
    ..classes.addAll([LMargin.C_AROUND__SMALL, LGrid.C_GRID, LGrid.C_WRAP])
    ..id = "a-header";

  /**
   * Set Application
   */
  void set(AppsCtrl apps) {
    element.children.clear();

    // Logo
    DivElement left = new DivElement()
      ..classes.add(LGrid.C_COL);
    element.append(left);
    if (apps.icon != null) {
      left.append(apps.icon.element);
    }
    else if (apps.imageSrc != null) {
      ImageElement img = new ImageElement(src: apps.imageSrc)
        ..style.maxHeight = "52px" // same height as Title+Sub
        ..style.maxWidth = "300px"
        ..alt = apps.label
        ..title = apps.label;
      left.append(img);
    }

    // Title
    DivElement center = new DivElement()
      ..classes.add(LGrid.C_COL__PADDED);
    element.append(center);
    HeadingElement h1 = new HeadingElement.h1()
      ..classes.add(LText.C_TEXT_HEADING__MEDIUM)
      ..text = apps.label;
    center.append(h1);
    document.title = apps.label;
    if (apps.labelSub != null) {
      DivElement sub = new DivElement()
        ..classes.add(LText.C_TEXT_HEADING__SMALL)
        ..text = apps.labelSub;
      center.append(sub);
    }

    // Info
    if (apps.info != null && apps.info.isNotEmpty) {
      DivElement right = new DivElement()
        ..classes.add(LGrid.C_COL);
      element.append(right);
      List<String> parts = apps.info.split("\n");
      for (String part in parts) {
        if (right.children.isNotEmpty) {
          right.append(new Element.br());
        }
        right.append(new SpanElement()
          ..text = part);
      }
    }

    /// Additional Header Element
    if (apps.additionalHeader != null) {
      element.append(apps.additionalHeader);
    }
  } // set

} // AppsHeader

