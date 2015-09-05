/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Lookup
 * - div .form-element
 * - div .lookup__menu
 *
 * https://www.getslds.com/components/lookups#role=regular&status=all
 */
class LLookup extends LEditor implements LSelectI {

  /// slds-lookup - Initializes lookup | Required
  static const String C_LOOKUP = "slds-lookup";
  /// slds-lookup__control - Initializes lookup form control | Required
  static const String C_LOOKUP__CONTROL = "slds-lookup__control";
  /// slds-lookup__menu - Initializes lookup results list container | Required
  static const String C_LOOKUP__MENU = "slds-lookup__menu";
  /// slds-lookup__list - Initializes lookup results list | Required
  static const String C_LOOKUP__LIST = "slds-lookup__list";
  /// slds-lookup__item - Results lsit item | Required
  static const String C_LOOKUP__ITEM = "slds-lookup__item";


  static final Logger _log = new Logger("LLookup");

  static const String DATA_SELECT_MULTI = "multi";
  static const String DATA_SELECT_SINGLE = "single";

  static final String SPACES_REGEX = r"[\s_-]";
  static final RegExp SPACES = new RegExp(SPACES_REGEX);

  /// Lookup form + menu
  final DivElement element = new DivElement()
    ..classes.add(C_LOOKUP);

  /// Form Element - lookup needs to be top element
  final LFormElement _formElement = new LFormElement();
  /// Form Element Input
  final InputElement input = new InputElement(type: EditorI.TYPE_TEXT);
  /// Lookup form + menu
  final DivElement _lookupMenu = new DivElement()
    ..classes.add(C_LOOKUP__MENU)
    ..attributes[Html0.ROLE] = Html0.ROLE_LISTBOX;

  final UListElement _lookupList = new UListElement()
    ..classes.add(C_LOOKUP__LIST)
    ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;

  /// Lookup Items
  final List<LLookupItem> _items = new List<LLookupItem>();
  /// Display for Single Select
  LPill _singlePill;

  /**
   * Lookup
   * [input] should have labelText set and be of type text
   * [select] single|multi
   * [scope] single|multi
   */
  LLookup(String name, {String idPrefix,
      String select: DATA_SELECT_SINGLE,
      String scope: "single",
      bool typeahead: false}) {
    _setAttributes(select, scope, typeahead);
    _formElement.createStandard(this);
    input
      ..classes.clear()
      ..classes.add(LForm.C_INPUT__BARE);
    input
      ..attributes[Html0.ROLE] = Html0.ROLE_COMBOBOX
      ..attributes[Html0.ARIA_AUTOCOMPLETE] = Html0.ARIA_AUTOCOMPLETE_LIST
      ..attributes[Html0.ARIA_HASPOPUP] = "true";
    _formElement.labelInputText = lLookupLabel();

    input.name = name;
    _formElement.id = createId(idPrefix, name);
    element.id = "${_formElement.id}-lookup";

    if (typeahead) { // show input with search icon
      input.onKeyUp.listen(onInputKeyUp);
      input.onFocus.listen((Event e) {
        _lookupMenu.classes.remove(LVisibility.C_HIDE);
      });
    } else if (select == DATA_SELECT_SINGLE) { // show pill - hide input
      input.classes.add(LVisibility.C_HIDE);
      _singlePill = new LPill("", "", null, null, null, null, null);
      _singlePill.element.classes.add(LPill.C_PILL__BARE);
      _formElement._elementControl.insertBefore(_singlePill.element, input);
    } else {
      /// Multi
    }
    // div .lookup
    // - div .form-element ... label...
    // - div .menu
    // -- ul
    element.append(_formElement.element);
    element.append(_lookupMenu);
    _lookupMenu.append(_lookupList);
    //
    _lookupMenu.classes.add(LVisibility.C_AUTO_VISIBLE);
    _lookupMenu.onKeyDown.listen(onMenuKeyDown);
  } // LLookup


  LLookup.base(String name, {String idPrefix})
    : this(name, idPrefix:idPrefix, typeahead: true);

  LLookup.single(String name, {String idPrefix})
    : this(name, idPrefix:idPrefix, typeahead: false);

  LLookup.multi(String name, {String idPrefix})
    : this(name, idPrefix:idPrefix, select:DATA_SELECT_MULTI, typeahead: false);


  /// Set Lookup Attributes
  void _setAttributes(String select, String scope, bool typeahead) {
    element.attributes["data-select"] = select;
    element.attributes["data-scope"] = scope;
    element.attributes["dara-typeahead"] = typeahead.toString();
  }
  // data-select single|multi
  bool get multiple => element.attributes["data-select"] == DATA_SELECT_MULTI;
  // data-typeahead
  bool get typeahead => element.attributes["data-typeahead"] == "true";
  // data-scope single
  bool get singleScope => element.attributes["data-scope"] == "single";

  /// Editor Id
  String get id => input.id;
  void set id (String newValue) {
    _formElement.id = newValue;
    element.id = "${_formElement.id}-lookup";
  }
  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  String get name => input.name;
  String get type => input.type;

  void set label (String newValue) {
    super.label = newValue;
    // TODO
  }
  void set help (String newValue) {}
  String get help => null;
  void set hint (String newValue) {}
  String get hint => null;

  /// Small Editor/Label
  void set small (bool newValue){}


  String get value => input.value;
  void set value (String newValue) {
    input.value = newValue;
    // TODO
  }

  String get defaultValue => null; // ignore
  void set defaultValue (String newValue) {
  }

  bool get required => input.required;
  void set required (bool newValue) {
    input.required = newValue;
  }

  bool get readOnly => input.readOnly;
  void set readOnly (bool newValue) {
    input.readOnly = newValue;
  }

  bool get disabled => input.disabled;
  void set disabled (bool newValue) {
    input.disabled = newValue;
  }

  bool get spellcheck => input.spellcheck;
  void set spellcheck (bool newValue) {
    input.spellcheck = newValue;
  }

  bool get autofocus => input.autofocus;
  void set autofocus (bool newValue) {
    input.autofocus = newValue;
  }

  String get title => _formElement.title;
  void set title (String newValue) {
    _formElement.title = title;
  }

  /// Validation state from Input
  ValidityState get inputValidationState => input.validity;
  /// Validation Message from Input
  String get inputValidationMsg => input.validationMessage;



  /// Get options
  List<OptionElement> get options {
    List<OptionElement> list = new List<OptionElement>();
    for (LLookupItem item in _items) {
      list.add(item.asOption());
    }
    return list;
  }
  /// Set options
  void set options (List<OptionElement> list) {
    for (OptionElement oe in list) {
      LLookupItem item = new LLookupItem.fromOption(oe);
      addItem(item);
    }
  }
  /// Add Option
  void addOption(OptionElement oe) {
    addItem(new LLookupItem.fromOption(oe));
  }

  /// Add Option
  void addSelectOption(SelectOption op) {
    LLookupItem item = new LLookupItem.fromSelectOption(op);
    addItem(item);
  }
  /// Add Option List
  void set selectOptions(List<SelectOption> list) {
    for (SelectOption so in list)
      addSelectOption(so);
  }
  /// Add Option List
  void set dOptions(List<DOption> options) {
    for (DOption op in options) {
      SelectOption so = new SelectOption(op);
      addSelectOption(so);
    }
  }
  void set listText (List<String> textList) {
    selectOptions = SelectOption.createListFromText(textList);
  }

  /// Set List Items
  void set listItems (List<ListItem> listItems) {
    clear();
    for (ListItem li in listItems) {
      LLookupItem lookup = new LLookupItem.from(li);
      addItem(lookup);
    }
  }
  /// Set Lookup Items
  void set items (List<LLookupItem> itemList) {
    clear();
    for (LLookupItem item in itemList) {
      addItem(item);
    }
  }

  /// Clear Items
  void clear() {
    _items.clear();
    _lookupList.children.clear();
  }

  /// add Lookup Item
  void addItem(LLookupItem item) {
    _items.add(item);
    _lookupList.append(item.element);
    item.onClick.listen(onItemClick);
  }


  void onMenuKeyDown(KeyboardEvent evt) {
    int kc = evt.keyCode;
    Element telement = evt.target;
    String tvalue = telement.attributes[Html0.DATA_VALUE];
    print("Menu ${kc} ${tvalue}");
  }
  void onInputKeyUp(KeyboardEvent evt) {
    int kc = evt.keyCode;
    String match = input.value;
    print("Input u ${kc} ${match}");
    if (kc == KeyCode.ESC) {
      showResults = false;
    } else {
      lookupUpdateList(false);
    }
  }

  /// update lookup list and display
  void lookupUpdateList(bool showAll) {
    String restriction = input.value;
    RegExp exp = null;
    if (!showAll && restriction.isNotEmpty) {
      exp = _createRegExp(restriction);
    }
    int count = 0;
    for (LLookupItem item in _items) {
      if (exp == null) {
        item.show = true;
        item.labelHighlightClear();
        //item.exampleUpdate();
        count++;
      }
      else if (item.labelHighlight(exp) || item.descriptionHighlight(exp)) {
        item.show = true;
        //item.exampleUpdate();
        count++;
      }
      else { // no match
        item.show = false;
      }
    }
    if (count == 0 && _items.isNotEmpty) {
      input.setCustomValidity("No matching options"); // TODO Trl
    } else {
      input.setCustomValidity("");
    }
    //doValidate();
    _log.fine("lookupUpdateList ${name} '${restriction}' ${count} of ${_items.length}");
    showResults = true;
  } // lookupUpdateList

  /**
   * Clicked on Item
   */
  void onItemClick(MouseEvent evt) {
    evt.preventDefault();
    Element telement = evt.target;
    String tvalue = telement.attributes[Html0.DATA_VALUE];
    LLookupItem selectedItem = null;
    for (LLookupItem item in _items) {
      if (item.value == tvalue) {
        selectedItem = item;
        break;
      }
    }
    // Input has aria-activedescendant attribute whose value is the id of the highlighted results list option, no value if nothing's highlighted in the list
    if (selectedItem == null) {
      input.value = "";
      input.attributes[Html0.DATA_VALUE] = "";
      input.attributes[Html0.ARIA_ACTIVEDECENDNT] = "";
      if (editorChange != null)
        editorChange(name, null, null, null);
    } else {
      input.value = selectedItem.label;
      input.attributes[Html0.DATA_VALUE] = selectedItem.value;
      input.attributes[Html0.ARIA_ACTIVEDECENDNT] = selectedItem.value;

      if (editorChange != null)
        editorChange(name, selectedItem.value, null, selectedItem);
    }
    showResults = false;
    for (LLookupItem item in _items) { // remove restrictions
      item.show = true;
      item.labelHighlightClear();
    }
  } // onItemClick



  /// Show Popup
  void set showResults (bool newValue) {
    input.attributes[Html0.ARIA_EXPANED] = newValue.toString();
    if (newValue) {
      _lookupMenu.classes.remove(LVisibility.C_HIDE);
    } else {
      _lookupMenu.classes.add(LVisibility.C_HIDE);
      new Timer(new Duration(seconds: 5), () { // focus somewhere else
        _lookupMenu.classes.remove(LVisibility.C_HIDE);
      });
    }
  }

  /// Create regex for [search] returns null if empty or error
  static RegExp _createRegExp(String search) {
    if (search == null || search.isEmpty)
      return null;
    // fix spaces (spaces to match also _-)
    String restriction = search.replaceAll(" ", SPACES_REGEX);
    // fix regex
    if (restriction == "[" || restriction == "(" || restriction == ".")
      restriction = "\\" + restriction;
    try {
      return new RegExp(restriction, caseSensitive: false);
    } catch (ex) {
      _log.info("createRegExp search=${search} restriction=${restriction}) error=${ex}");
    }
    return null;
  }

  void updateStatusValidationState() {
  }


  static String lLookupLabel() => Intl.message("Lookup", name: "lLookupLabel", args: []);

} // LLookup


/**
 * Lookup Item
 * - li > a|span
 */
class LLookupItem extends ListItem {

  /**
   * Lookup Option
   */
  LLookupItem(DOption option, {LIcon leftIcon, LIcon rightIcon})
    : super(option, leftIcon:leftIcon, rightIcon:rightIcon) {
    element
      ..classes.add(LLookup.C_LOOKUP__ITEM)
      ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;
    a
      ..attributes[Html0.ROLE] = Html0.ROLE_OPTION;
  } // LLookupItem


  /// Lookup Item from List
  LLookupItem.from(ListItem item)
    : this(item.option, leftIcon:item.leftIcon, rightIcon:item.rightIcon);

  /// Lookup Item from Option
  LLookupItem.fromOption(OptionElement option)
     : this(OptionUtil.optionFromElement(option));

  /// Lookup Item from SelectOption
  LLookupItem.fromSelectOption(SelectOption option)
      : this(option.option);


  /// On Click
  ElementStream<MouseEvent> get onClick => a.onClick;


} // LLookupItem
