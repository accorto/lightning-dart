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
  /// Editor count
  int _currentEditor = 0;
  /// Editors
  List<LEditor> _editors = new List<LEditor>();

  /// Form Section
  FormSection(int this.columnCount, {bool open:true, String label})
    : super.legend(open:open, label:label) {
    if (columnCount > 0) {
      sectionElement.classes.addAll([LGrid.C_GRID, LGrid.C_WRAP]); // new section
    }
  } // FormSection


  /// append element
  void append(Element newValue) {
    sectionElement.append(newValue);
  }
  /// add component
  void add(LComponent component) {
    sectionElement.append(component.element);
  }

  /// add editor
  void addEditor (LEditor editor, Element formElement, bool newRow, int width, int height) {
    _editors.add(editor);
    if (columnCount > 0) {
      if (newRow && sectionElement.children.isNotEmpty) {
        DivElement div = new DivElement()
          ..classes.addAll([LGrid.C_GRID, LGrid.C_WRAP]); // new section
        formElement.append(div);
        addSectionElement(div); // sets _sectionElement
      }
      DivElement div = new DivElement()
        ..classes.addAll([LGrid.C_COL__PADDED, LGrid.C_GROW_NONE, LSizing.C_SIZE__1_OF_1])
        ..append(editor.element);
      if (columnCount > 1 && columnCount != width) {
        div.classes.add(LSizing.sizeMediumXofY(width, columnCount));
      }
      sectionElement.append(div);
    } else {
      sectionElement.append(editor.element);
    }
    _currentEditor++;
    editor.element.tabIndex = _currentEditor;
  } // addEditor


  /// Expand if section contains editor
  void expandIfContains(LEditor editor) {
    if (!open && _editors.contains(editor)) {
      open = true;
    }
  }

} // FormSection
