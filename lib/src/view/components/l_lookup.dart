/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Base Lookup
 * - div .form-element
 * - div .lookup__menu
 *
 * https://www.getslds.com/components/lookups#role=regular&status=all
 */
class LLookup
    extends LEditor with LSelectI {

  /// slds-lookup (div): Initializes lookup - Accepts [data-select] and [data-scope] attributes with the values of single/multi
  static const String C_LOOKUP = "slds-lookup";
  /// slds-lookup__menu (div): Initializes lookup results list container - Applies positioning and container styles
  static const String C_LOOKUP__MENU = "slds-lookup__menu";
  /// slds-lookup__list (ul): Initializes lookup results list
  static const String C_LOOKUP__LIST = "slds-lookup__list";
  /// slds-lookup__item (li): Results list item
  static const String C_LOOKUP__ITEM = "slds-lookup__item";
  /// slds-form-element (div): Initializes lookup form element - Wraps <input> and .slds-pill-container
  static const String C_FORM_ELEMENT = "slds-form-element";


  /// selection
  static const String C_HAS_SELECTION = "slds-has-selection";

  static final Logger _log = new Logger("LLookup");

  /// data select attribute
  static const String _DATA_SELECT = "data-select";
  /// data select value
  static const String _DATA_SELECT_MULTI = "multi";
  /// data select value
  static const String _DATA_SELECT_SINGLE = "single";

  /// data scope attribute
  static const String _DATA_SCOPE = "data-scope";
  /// data scope value
  static const String _DATA_SCOPE_SINGLE = "single";

  /// data type ahead attribure (true/false)
  static const String _DATA_TYPEAHEAD = "data-typeahead";

  /// Lookup form + menu
  final DivElement element = new DivElement()
    ..classes.add(C_LOOKUP);

  /// Form Element - lookup needs to be top element
  final LFormElement _formElement = new LFormElement();

  /// Form Element Input
  final InputElement input = new InputElement(type: EditorI.TYPE_TEXT);

  /// Search Icon
  final LIcon icon = new LIconUtility(LIconUtility.SEARCH);

  /// Lookup form + menu
  final DivElement _lookupMenu = new DivElement()
    ..classes.add(C_LOOKUP__MENU)
    ..attributes[Html0.ROLE] = Html0.ROLE_LISTBOX;

  final UListElement _lookupList = new UListElement()
    ..classes.add(C_LOOKUP__LIST)
    ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;

  /// Lookup Items
  final List<LLookupItem> _lookupItemList = new List<LLookupItem>();
  /// Value - Item Map
  Map<String, LLookupItem> _lookupItemMap;

  /// Displayed in Grid
  final bool inGrid;
  bool isMobileUi = Settings.getAsBool(Settings.MOBILE_UI);

  /**
   * Lookup
   * [input] should have labelText set and be of type text
   * [select] single|multi
   * [scope] single|multi
   */
  LLookup(String name, {String idPrefix,
      bool multiple: false,
      bool singleScope: true,
      bool typeahead: false,
      bool withClearValue:false,
      bool this.inGrid:false}) {
    _initEditor(name, idPrefix, multiple, singleScope, typeahead, withClearValue);
  }

  // Base Lookup
  LLookup.base(String name, {String idPrefix,
      bool withClearValue:false,
      bool inGrid:false})
    : this(name, idPrefix:idPrefix, multiple:false, singleScope:true, typeahead: true, withClearValue:withClearValue, inGrid:inGrid);

  /// Lookup Editor
  LLookup.from(DataColumn dataColumn, {String idPrefix,
      bool multiple:false,
      bool singleScope: true,
      bool typeahead: true,
      bool withClearValue:false,
      bool this.inGrid:false}) {
    _initEditor(dataColumn.name, idPrefix, multiple, singleScope, typeahead, withClearValue);
    this.dataColumn = dataColumn;
  }

  /// Init Lookup
  void _initEditor(String name, String idPrefix, bool multiple, bool singleScope, bool typeahead, bool withClearValue) {
    _setAttributes(multiple, singleScope, typeahead);
    //
    _formElement.createStandard(this, leftElement: getLeftElement(), iconRight: icon,
      withClearValue: withClearValue, inGrid:inGrid);
    input
      ..attributes[Html0.ROLE] = Html0.ROLE_COMBOBOX
      ..attributes[Html0.ARIA_AUTOCOMPLETE] = Html0.ARIA_AUTOCOMPLETE_LIST
      ..attributes[Html0.ARIA_EXPANED] = "false";
    _formElement.labelInputText = lLookupLabel();
    input.name = name;
    id = createId(idPrefix, input.name);

    _initEditor2(multiple, singleScope, typeahead);

    // div .lookup
    // - div .form-element ... label...
    // - div .menu
    // -- ul
    element.append(_formElement.element);
    element.append(_lookupMenu);
    _lookupMenu.append(_lookupList);
    //
    showDropdown = false;
    _lookupMenu.onKeyDown.listen(onMenuKeyDown);
  } // initEditor

  /// Init for Base Lookup
  void _initEditor2(bool multiple, bool singleScope, bool typeahead) {
    // show input with search icon
    input.onKeyUp.listen(onInputKeyUp);
    // toggle dropdown on click
    input.onClick.listen((Event evt) {
      if (readOnly || disabled) {
        showDropdown = false;
      } else {
        showDropdown = !_showDropdown;
      }
    });
  } // initEditor


  /// Set Lookup Attributes
  void _setAttributes(bool multiple, bool singleScope, bool typeahead) {
    element.attributes[_DATA_SELECT] = multiple ? _DATA_SELECT_MULTI : _DATA_SELECT_SINGLE;
    element.attributes[_DATA_SCOPE] = _DATA_SCOPE_SINGLE;
    element.attributes[_DATA_TYPEAHEAD] = typeahead.toString();
  }

  // data-select single|multi
  bool get multiple => element.attributes[_DATA_SELECT] == _DATA_SELECT_MULTI;
  // data-typeahead
  bool get typeahead => element.attributes[_DATA_TYPEAHEAD] == "true";
  // data-scope single
  bool get singleScope => element.attributes[_DATA_SCOPE] == _DATA_SCOPE_SINGLE;

  /// Editor Id
  String get id => input.id;

  void set id(String newValue) {
    _formElement.id = newValue;
    element.id = "${newValue}-lookup";
    icon.element.id = "${newValue}-icon";
    _lookupMenu.attributes[Html0.DATA_NAME] = newValue;
  }

  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => input.name;

  String get type => input.type;

  String get label => _formElement.label;

  void set label(String newValue) {
    _formElement.label = newValue;
  }

  String get help => _formElement.help;
  void set help(String newValue) {
    _formElement.help = newValue;
  }


  String get hint => _formElement.hint;
  void set hint(String newValue) {
    _formElement.hint = newValue;
  }

  /// Small Editor/Label
  void set small(bool newValue) {
  }

  /// Get Value from display
  String get value {
    //String display = input.value;
    //return parse(display, true);
    return _value;
  }
  /// Set Value
  void set value(String newValue) {
    _value = newValue;
    _valueItem = null;
    //validateOptions();
    render(newValue, true)
    .then((String display){
      input.value = display;
    });
  }
  String _value = "";
  LLookupItem _valueItem = null;

  /// display -> value - sets validity
  String parse(String display, bool setValidity) {
    if (setValidity)
      input.setCustomValidity("");
    if (display == null || display.isEmpty)
      return display;
    for (LLookupItem item in _lookupItemList) {
      if (item.label == display)
        return item.value;
    }
    input.setCustomValidity("${lLookupInvalidInput()}=${display}");
    _log.warning("parse ${name} NotFound ${display}");
    return display;
  } // parse

  /**
   * Rendered Value (different from value)
   */
  String get valueDisplay => renderSync(value, false);
  /// is the rendered [valueDisplay] different from the [value]
  bool get valueRendered => true;

  /// render [newValue]
  @override
  Future<String> render(String newValue, bool setValidity) {
    Completer<String> completer = new Completer<String>();
    completer.complete(renderSync(newValue, setValidity));
    return completer.future;
  } // render

  /// render [newValue]
  String renderSync(String newValue, bool setValidity) {
    if (setValidity) {
      input.setCustomValidity("");
    }
    if (newValue == null || newValue.isEmpty) {
      return "";
    }
    for (LLookupItem item in _lookupItemList) {
      if (item.value == newValue) {
        if (setValidity)
          _valueItem = item;
        return item.label;
      }
    }
    if (setValidity) {
      input.setCustomValidity("${lLookupInvalidValue()}=${newValue}");
    }
    return newValue;
  } // render

  String get defaultValue => null; // ignore
  void set defaultValue (String newValue) {
  }

  bool get required => input.required;
  void set required (bool newValue) {
    input.required = newValue;
    _formElement.required = newValue;
    if (newValue && input.value.isEmpty && _lookupItemList.isNotEmpty) {
      value = _lookupItemList.first.value;
    }
  }

  bool get readOnly => input.readOnly;
  void set readOnly (bool newValue) {
    input.readOnly = newValue;
    if (input.readOnly || input.disabled) {
      showDropdown = false;
    }
  }

  bool get disabled => input.disabled;
  void set disabled (bool newValue) {
    input.disabled = newValue;
    if (input.readOnly || input.disabled) {
      showDropdown = false;
    }
  }

  bool get spellcheck => input.spellcheck;
  void set spellcheck (bool newValue) {
    input.spellcheck = newValue;
  }

  bool get autofocus => input.autofocus;
  void set autofocus (bool newValue) {
    input.autofocus = newValue;
  }

  String get placeholder => input.placeholder;
  void set placeholder (String newValue) {
    input.placeholder = newValue;
  }

  /// Get Left Element
  Element getLeftElement() => null;

  String get title => _formElement.title;
  void set title (String newValue) {
    _formElement.title = title;
  }

  /// Validation state from Input
  ValidityState get inputValidationState => input.validity;
  /// Validation Message from Input
  String get inputValidationMsg => input.validationMessage;

  /// set border Color
  void set borderColor (String newValue) {
    if (newValue == null || newValue.isEmpty) {
      input.style.removeProperty("border-color");
    } else {
      input.style.borderColor = newValue;
    }
  }

  /// Get options
  List<OptionElement> get options {
    List<OptionElement> list = new List<OptionElement>();
    for (LLookupItem item in _lookupItemList) {
      list.add(item.asOption());
    }
    return list;
  }
  /// Set options
  void set options (List<OptionElement> list) {
    for (OptionElement oe in list) {
      LLookupItem item = new LLookupItem.fromOption(oe);
      addLookupItem(item);
    }
  }
  /// Add Option
  void addOption(OptionElement oe) {
    addLookupItem(new LLookupItem.fromOption(oe));
  }

  /// Option Count
  int get length => _lookupItemList.length;

  /// Selected count
  int get selectedCount {
    String vv = value;
    return vv == null || vv.isEmpty ? 0 : 1;
  }


  /// Get select option list
  List<SelectOption> get selectOptionList {
    List<SelectOption> retValue = new List<SelectOption>();
    for (LLookupItem item in _lookupItemList) {
      retValue.add(item.asSelectOption());
    }
    return retValue;
  }
  /// Add Option
  void addSelectOption(SelectOption op) {
    LLookupItem item = new LLookupItem.fromSelectOption(op);
    addLookupItem(item);
  }

  /// Add Option
  void addDOption(DOption option) {
    LLookupItem item = new LLookupItem(option);
    addLookupItem(item);
  }

  /// Set Lookup Items
  void set lookupItemList (List<LLookupItem> itemList) {
    clearOptions();
    for (LLookupItem item in itemList) {
      addLookupItem(item);
    }
  }
  /// Get Lookup Items
  List<LLookupItem> get lookupItemList => _lookupItemList;

  /// Clear Items
  void clearOptions() {
    _lookupItemList.clear();
    _lookupList.children.clear();
  }

  /// add Lookup Item
  void addLookupItem(LLookupItem item) {
    _lookupItemList.add(item);
    _lookupList.append(item.element);
    item.onClick.listen(onItemClick);
  }


  void onMenuKeyDown(KeyboardEvent evt) {
    int kc = evt.keyCode;
    Element telement = evt.target;
    String tvalue = telement.attributes[Html0.DATA_VALUE];
    _log.fine("onMenuKeyDown ${kc} ${tvalue}");
  }

  /**
   * Input Key Up
   * ESC closes - if ALt/Shift/Meta - clear
   * ENTER selects first
   */
  void onInputKeyUp(KeyboardEvent evt) {
    if (readOnly || disabled) {
      return;
    }
    int kc = evt.keyCode;
    String match = input.value;
    _log.fine("onInputKeyUp ${kc} ${match}");
    if (kc == KeyCode.ESC) {
      if (evt.ctrlKey || evt.altKey || evt.metaKey) {
        _value = "";
        input.value = "";
        lookupUpdateList(false, false);
      } else {
        showDropdown = false;
      }
    } else if (kc == KeyCode.ENTER) {
      lookupUpdateList(false, true);
    } else {
      lookupUpdateList(false, false);
    }
  } // onInputKeyUp

  /// update lookup list and display
  int lookupUpdateList(bool showAll, bool selectFirst) {
    String restriction = input.value;
    RegExp exp = null;
    if (!showAll && restriction.isNotEmpty) {
      exp = LUtil.createRegExp(restriction);
    }
    int count = 0;
    LLookupItem first = null;
    for (LLookupItem item in _lookupItemList) {
      if (exp == null) {
        item.show = true;
        item.labelHighlightClear();
        //item.exampleUpdate();
        if (first == null)
          first = item;
        count++;
      }
      else if (item.labelHighlight(exp) || item.descriptionHighlight(exp)) {
        item.show = true;
        //item.exampleUpdate();
        if (first == null)
          first = item;
        count++;
      }
      else { // no match
        item.show = false;
      }
    }
    if (count == 0 && _lookupItemList.isNotEmpty) {
      input.setCustomValidity(lLookupNoMatch());
    } else {
      input.setCustomValidity("");
    }
    doValidate();
    _log.fine("lookupUpdateList ${name} '${restriction}' ${count} of ${_lookupItemList.length}");
    if (selectFirst && first != null) {
      _valueItem = first;
      value = first.value;
      showDropdown = false;
    } else {
      showDropdown = true;
    }
    return count;
  } // lookupUpdateList

  /**
   * Clicked on Item (select)
   */
  void onItemClick(MouseEvent evt) {
    evt.preventDefault(); // a
    if (readOnly || disabled) {
      showDropdown = false;
      return;
    }
    Element telement = evt.target;
    String tvalue = telement.attributes[Html0.DATA_VALUE];
    _valueItem = null;
    for (LLookupItem item in _lookupItemList) {
      if (item.value == tvalue) {
        _valueItem = item;
        break;
      }
    }
    // Input has aria-activedescendant attribute whose value is the id of the highlighted results list option, no value if nothing's highlighted in the list
    if (_valueItem == null) {
      _value = "";
      input.value = "";
      input.attributes[Html0.DATA_VALUE] = "";
      input.attributes[Html0.ARIA_ACTIVEDECENDNT] = "";
      //
      if (editorChange != null)
        editorChange(name, null, null, null);
    } else {
      _value = _valueItem.value;
      input.value = _valueItem.label;
      input.attributes[Html0.DATA_VALUE] = _valueItem.value;
      input.attributes[Html0.ARIA_ACTIVEDECENDNT] = _valueItem.value;
      //
      if (editorChange != null) {
        editorChange(name, _valueItem.value, null, _valueItem);
      }
    }
    showDropdown = false;
    for (LLookupItem item in _lookupItemList) { // remove restrictions
      item.show = true;
      item.labelHighlightClear();
    }
  } // onItemClick



  /// Show/Hide Popup
  void set showDropdown (bool newValue) {
    if (newValue && (readOnly || disabled)) {
      newValue = false;
    }
    _showDropdown = newValue;
    input.attributes[Html0.ARIA_EXPANED] = newValue.toString();
    if (newValue) {
      _lookupMenu.classes.remove(LVisibility.C_HIDE);
    } else {
      _lookupMenu.classes.add(LVisibility.C_HIDE);
    }
  } // showDropdown
  bool _showDropdown = false;


  void validateOptions() {
    if (data != null && hasDependentOn) {
      /*
      String currentValue = input.value;
      int count = 0;
      bool invalidated = false;
      List<OptionElement> options = input.options;
      for (OptionElement oe in options) {
        bool valid = _validateOption(oe.value);
        oe.disabled = !valid;
        if (valid) {
          oe.classes.remove(LVisibility.C_HIDE);
        } else {
          count++;
          oe.classes.add(LVisibility.C_HIDE);
          if (oe.value == currentValue) {
            input.value = ""; // invalidate current
            invalidated = true;
          }
        }
      }
      _log.fine("validateOptions disabled=${count} of ${options.length} - invalidated=${invalidated}");
      */
    }
  } // validateOptions

  void updateStatusValidationState() {
    _formElement.updateStatusValidationState();
  }


  static String lLookupLabel() => Intl.message("Lookup", name: "lLookupLabel");
  static String lLookupInvalidInput() => Intl.message("Invalid option", name: "lLookupInvalidInput");
  static String lLookupInvalidValue() => Intl.message("Invalid value", name: "lLookupInvalidValue");

  static String lLookupNoMatch() => Intl.message("No matching options found", name: "lLookupNoMatch");

} // LLookup
