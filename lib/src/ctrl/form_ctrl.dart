/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * Form Util - create Form from UI
 *
 *    form          .form--stacked        .grid .wrap
 *      div                               .col--padded .size-1-of-..
 *        div       .form-element
 *          label   .form-element__label
 *          div     .form-element__control
 *            input .input
 *
 *  Multi Column
 *  - Z flow (not supported: N flow)
 *  - stacked only
 *  - wrap or not
 *  - change no of column per panel
 *
 */
class FormCtrl
    extends LForm {

  static final Logger _log = new Logger("FormCtrl");


  /// The UI
  final UI ui;
  /// Data Columns
  final List<DataColumn> dataColumns = new List<DataColumn>();
  /// Processes
  LButtonGroup processGroup;
  /// editor margin class
  String marginClass = null; // LMargin.C_TOP__X_SMALL;

  /**
   * Form Util
   * must call [buildPanels]
   */
  FormCtrl(String name, UI this.ui, {
      Element element,
      String type: LForm.C_FORM__STACKED,
      String idPrefix})
    : super(element == null ? new FormElement() : element, name, type, idPrefix:idPrefix) {
  } // FormUtil


  /// Build form panels
  void buildPanels({bool addButtons:true, bool addProcesses:true, bool showSection1label:true}) {
    if (addProcesses && ui.processList.isNotEmpty) {
      processGroup = buildProcesses()
        ..classes.add(LMargin.C_BOTTOM__SMALL);
      add(processGroup);
    }
    // Panels as Field Sets
    int count = 0;
    for (UIPanel panel in ui.panelList) {
      bool closed = panel.type == UIPanelType.ICLOSED || panel.type == UIPanelType.HIDDEN;
      FormSection section = new FormSection(panel.panelColumnNumber, label:panel.name, open:!closed);
      section.showLabel = count > 0 || showSection1label;
      setSection(section);
      for (UIPanelColumn pc in panel.panelColumnList) {
        DataColumn dataColumn = DataColumn.fromUi(ui, pc.columnName,
            tableColumn:pc.column, panelColumn:pc, columnId:pc.columnId);
        dataColumns.add(dataColumn);
        if (dataColumn.isActivePanel) {
          LEditor editor = EditorUtil.createfromColumn(null, dataColumn, false,
              idPrefix: element.id, data:data, isAlternativeDisplay:pc.isAlternativeDisplay);
          addEditor(editor, newRow:pc.isNewRow, width:pc.width, height:pc.height, marginClass:marginClass);
        }
      }
      count++;
    }
    if (addButtons) {
      addResetButton();
      addErrorIndicator();
      addSaveButton();
    }
  } // build


  /// are there any processes
  bool get hasProcesses => ui.processList.isNotEmpty;

  /// build Processes as button group
  LButtonGroup buildProcesses() {
    LButtonGroup group = new LButtonGroup();
    for (UIProcess process in ui.processList) {
      LIcon icon = null;
      if (process.hasIconImage())
        icon = LIcon.create(process.iconImage);
      LButton btn;
      // Web
      if (process.hasWebLocation() || process.hasWebLinkUrl()) {
        String href = process.webLocation;
        if (href.isEmpty)
          href = process.webLinkUrl;
        if (icon == null) {
          btn = new LButton.neutralAnchor(process.name, process.label, href:href,
            idPrefix:id);
        } else {
          btn = new LButton.neutralAnchorIcon(process.name, process.label, icon, href:href,
            idPrefix:id, iconLeft: true);
        }
        if (process.hasWebLinkUrl())
          (btn.element as AnchorElement).target = NewWindow.NAME_BLANK;
      } else {
        if (icon == null) {
          btn = new LButton.neutral(process.name, process.label,
            idPrefix:id);
        } else {
          btn = new LButton.neutralIcon(process.name, process.label, icon,
            idPrefix:id, iconLeft: true);
        }
        btn.element.attributes[Html0.DATA_VALUE] = process.processId;
        btn.onClick.listen(onClickProcess);
      }
      group.add(btn);
    }
    return group;
  } // buildProcess

  /**
   * Process Dialog
   */
  void onClickProcess(MouseEvent evt) {
    Element target = evt.target;
    String name = target.attributes["name"];
    String processId = target.attributes[Html0.DATA_VALUE];
    UIProcess uiProcess = null;
    for (UIProcess process in ui.processList) {
      if (process.name == name || process.processId == processId) {
        uiProcess = process;
        if (name == null)
          name = process.name;
        break;
      }
    }
    if (data.isReadOnly) {
      _log.info("onClickProcess ${name} found=${uiProcess != null} readOnly");
      return;
    }
    _log.info("onClickProcess ${name} found=${uiProcess != null}");
  } // onClickProcess

} // FormCtrl
