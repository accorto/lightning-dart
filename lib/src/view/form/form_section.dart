/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Form Section
 *
 * if the column count > 0, the section element is a grid
 * and for the editor, the size is set
 *
 * A new row adds a new section element.
 */
class FormSection
    extends LSectionTitle {

  /// Section column Count
  final int columnCount;
  /// Editors
  List<LEditor> _editors = new List<LEditor>();
  /// Actual Columns used
  int _columnsUsed = 0;

  /// Form Section
  FormSection(int this.columnCount, {bool open:true, String label})
    : super.legend(open:open, label:label) {
    if (columnCount > 0) {
      sectionContent.classes.addAll([LGrid.C_GRID, LGrid.C_WRAP]); // new section
    }
  } // FormSection


  /// append element
  void append(Element newValue) {
    sectionContent.append(newValue);
  }
  /// add component
  void add(LComponent component) {
    sectionContent.append(component.element);
  }

  /// add editor
  void addEditor (LEditor editor, Element formElement, bool newRow,
      int width, bool fillRemainingRow, int height) {
    _editors.add(editor);
    if (columnCount > 0) {
      if (newRow && sectionContent.children.isNotEmpty) {
        DivElement div = new DivElement()
          ..classes.addAll([LGrid.C_GRID, LGrid.C_WRAP]); // new section
        formElement.append(div);
        addSectionElement(div); // sets _sectionElement
        _columnsUsed = 0;
      }
      // default size 100%
      DivElement div = new DivElement()
        ..classes.addAll([LPadding.C_HORIZONTAL__SMALL, // TODO check
            LGrid.C_GROW_NONE, LSizing.C_SIZE__1_OF_1])
        ..append(editor.element);
      int remaining = columnCount - (_columnsUsed % columnCount);
      if (columnCount > 1 && columnCount != width) { // for medium or up
        int theWidth = width;
        if (fillRemainingRow != null && fillRemainingRow && remaining > theWidth) {
          theWidth = remaining;
        }
        div.classes.add(LSizing.sizeMediumXofY(theWidth, columnCount));
        _columnsUsed += theWidth;
      } else {
        _columnsUsed++;
      }
      sectionContent.append(div);
    } else {
      sectionContent.append(editor.element);
    }
  } // addEditor


  /// Expand if section contains editor
  void expandIfContains(LEditor editor) {
    if (!open && _editors.contains(editor)) {
      open = true;
    }
  }

} // FormSection
