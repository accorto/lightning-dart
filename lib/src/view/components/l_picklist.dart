/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;


/**
 * Picklist (Select Element alternative)
 * div .form-element
 * * div .picklist
 * -- button
 * -- div .dropdown
 */
class LPicklist
    extends LEditor with LFormElement, LSelectI {

  /// slds-picklist - Initializes picklist | Required
  static const String C_PICKLIST = "slds-picklist";
  /// slds-picklist--fluid - Forces width of picklist and picklist dropdown to inherit width of its content
  static const String C_PICKLIST__FLUID = "slds-picklist--fluid";
  /// slds-picklist__label - Custom select | Required
  static const String C_PICKLIST__LABEL = "slds-picklist__label";


  /// slds-picklist--draggable - Initializes draggable picklists | Required
  static const String C_PICKLIST__DRAGGABLE = "slds-picklist--draggable";
  /// slds-picklist__options - Custom select group of options | Required
  static const String C_PICKLIST__OPTIONS = "slds-picklist__options";

  static const String C_PICKLIST__OPTIONS__MULTI = "slds-picklist__options--multi";

  /// slds-picklist__item - Styles for items within the optiongroup | Required
  static const String C_PICKLIST__ITEM = "slds-picklist__item";

  static const String C_PICKLIST__MULTI = "slds-picklist--multi";


  /// Picklist Element
  final DivElement _plDiv = new DivElement()
    ..classes.add(C_PICKLIST);
  /// Button (proxy input)
  LButton _plButton;
  /// Button Label
  final SpanElement _plButtonLabel = new SpanElement()
    ..classes.add(LText.C_TRUNCATE);
  /// The Dropdown
  LDropdownElement _dropdown;


  /// Displayed in Grid
  final bool inGrid;

  /**
   * Picklist
   * div  element .form_element
   * - div .picklist
   * -- button .form-element--label
   * -- div .dropdown
   */
  LPicklist(String name, {String idPrefix, bool this.inGrid:false}) {
    _initEditor(name, idPrefix, null);
  } // LPicklist

  /// Picklist Editor
  LPicklist.from(DataColumn dataColumn, {String idPrefix, bool this.inGrid:false}) {
    _initEditor(dataColumn.name, idPrefix, dataColumn);
  }
  /// initialize
  void _initEditor(String name, String idPrefix, DataColumn dataColumn) {
    _plButton = new LButton(new ButtonElement(), name, null, idPrefix:idPrefix,
      buttonClasses: [LButton.C_BUTTON__NEUTRAL, C_PICKLIST__LABEL],
      labelElement: _plButtonLabel,
      icon: new LIconUtility(LIconUtility.DOWN)); // seta id
    _plButton.element.attributes[Html0.ARIA_HASPOPUP] = "true";
    _plButton.iconButton = false;
    _plButton.onClick.listen(onButtonClick);
    _plDiv.append(_plButton.element);
    _plButtonLabel.text = lPicklistSelectOption();
    //
    createStandard(this);
    element.append(_plDiv);
    //
    _dropdown = new LDropdownElement(
        new DivElement()
          ..classes.addAll([LDropdown.C_DROPDOWN, LDropdown.C_DROPDOWN__LEFT,
            LDropdown.C_DROPDOWN__MENU])
          ..style.marginTop = "0",
        name:name, idPrefix:id);
    _dropdown.selectMode = true;
    _plDiv.append(_dropdown.element);

    _plButton.element.style.width = "100%"; // C_Picklist_Label has width=15rem
    _dropdown.element.style.width = "100%"; // C_Dropdown has width of 15rem
    //
    showDropdown = false;
    _dropdown.selectMode = true;

    // Selection list
    if (dataColumn != null) {
      DColumn tableColumn = dataColumn.tableColumn;
      if (tableColumn.pickValueList.isNotEmpty) {
        dOptionList = tableColumn.pickValueList;
      } else if (dataColumn.tableColumn.dataType == DataType.BOOLEAN) {
        // Alternative display
        dOptionList = OptionUtil.optioneYesNo();
        // make optional
        if (dataColumn.uiPanelColumn != null
            && dataColumn.uiPanelColumn.hasIsMandatory()
            && !dataColumn.uiPanelColumn.isMandatory) {
          dataColumn.tableColumn.clearIsMandatory();
          required = false;
        }
      }
      // set required, value, etc.
      this.dataColumn = dataColumn;
    }
    _dropdown.editorChange = onEditorChange; // after init
  } // initEditor

  String get id => _plButton.id;
  void set id (String newValue) {
    if (newValue != null && newValue.isNotEmpty) {
      _plButton.element.id = newValue;
    //  if (_labelElement != null)
    //    _labelElement.htmlFor = newValue;
    }
  }
  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => _plButton.name;
  String get type => EditorI.TYPE_SELECT;
  Element get input => _plButton.element;
  bool get multiple => false;

  /// Small Editor/Label
  void set small (bool newValue) {}

  /// String Value

  String get value => _dropdown.value;
  void set value (String newValue) {
    _settingValue = true;
    _dropdown.value = newValue;
    _settingValue = false;
  }
  bool _settingValue = false;

  /// Set Button - label
  void _setValue(ListItem item) {
    if (item != null && item.label != null && item.label.isNotEmpty) {
      _plButtonLabel.text = item.label;
    } else if (required) {
      _plButtonLabel.text = lPicklistSelectOption();
    } else {
      _plButtonLabel.text = Html0.SPACE_NB;
    }
  }

  /**
   * Rendered Value (different from value)
   */
  String get valueDisplay => renderSync(value, false);
  /// is the rendered [valueDisplay] different from the [value]
  bool get isValueDisplay => true;

  /// render [newValue]
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    completer.complete(renderSync(newValue, setValidity));
    return completer.future;
  } // render
  /// render [newValue]
  String renderSync(String newValue, bool setValidity) {
    if (setValidity) {
    //input.setCustomValidity("");
    }
    String display = _dropdown.render(newValue);
    if (display != null)
        return display;
    if (setValidity) {
    //input.setCustomValidity("${lLookupInvalidValue()}=${newValue}");
    }
    return newValue;
  } // render

  /// Editor Change callback
  void onEditorChange(String name, String newValue, DEntry entry, var details) {
    if (details == null) {
      _setValue(null);
    } else if (details is ListItem) {
      _setValue(details as ListItem);
    }
    if (!_settingValue && editorChange != null) {  // this is the actual editor
      editorChange(name, newValue, entry, details);
    }
    showDropdown = false;
  } // onEditorChange


  String get defaultValue => _defaultValue;
  void set defaultValue (String newValue) {
    _defaultValue = newValue;
  }
  String _defaultValue;


  /// base editor methods

  bool get readOnly => _plButton.disabled;
  void set readOnly (bool newValue) {
    _plButton.disabled = newValue;
  }

  bool get disabled => _plButton.disabled;
  void set disabled (bool newValue) {
    _plButton.disabled = newValue;
  }

  bool get required => _dropdown.required;
  void set required (bool newValue) {
    super.required = newValue; // UI - FormElement
    String txt = _plButtonLabel.text;
    if (newValue) {
      if (txt == null || txt.isEmpty || txt == Html0.SPACE_NB) {
        _plButtonLabel.text = lPicklistSelectOption();
      }
    } else {
      if (txt == lPicklistSelectOption()) {
        _plButtonLabel.text = Html0.SPACE_NB;
      }
    }
    if (newValue && defaultValue != null) {
      String vv = value;
      if (vv == null || value.isEmpty) {
        value = defaultValue;
      }
    }
    _dropdown.required = newValue; // if required sets first
  } // required

  bool get spellcheck => false;
  void set spellcheck (bool newValue) { // ignore
  }

  bool get autofocus => false;
  void set autofocus (bool newValue) { // ignore
  }

  /// Validation state from Input
  ValidityState get inputValidationState => null;
  /// Validation Message from Input
  String get inputValidationMsg => null;


  /// Get options
  List<OptionElement> get options => _dropdown.options;
  /// Set options
  void set options (List<OptionElement> list) {
    _dropdown.options = list;
  }
  /// Add Option
  void addOption(OptionElement oe) {
    _dropdown.addOption(oe);
  }
  /// Option Count
  int get length => _dropdown.length;
  /// Selected count
  int get selectedCount {
    String vv = value;
    return vv == null || vv.isEmpty ? 0 : 1;
  }

  /// Get select option list
  List<SelectOption> get selectOptionList => _dropdown.selectOptionList;
  /// Add Option List
  void set selectOptionList(List<SelectOption> list) {
    _dropdown.selectOptionList = list;
  }
  /// Add Option
  void addSelectOption(SelectOption op) {
    _dropdown.addSelectOption(op);
  }
  /// clear options
  void clearOptions() {
    _dropdown.clearOptions();
  }
  /// Add Option
  void addDOption(DOption option) {
    _dropdown.addDOption(option);
  }


  /// Button clicked
  void onButtonClick(MouseEvent evt) {
    showDropdown = !showDropdown; // toggle dropdown
  }


  /// PickList Expanded
  bool get showDropdown => _plDiv.attributes[Html0.ARIA_EXPANED] == "true";
  /// PickList Expanded
  void set showDropdown (bool newValue) {
    _plDiv.attributes[Html0.ARIA_EXPANED] = newValue.toString();
    _dropdown.show = newValue;
  }

  // Trl
  static String lPicklistSelectOption() => Intl.message("Select an Option", name: "lPicklistSelectOption");

} // LPicklist
