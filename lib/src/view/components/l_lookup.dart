/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Lookup
 * https://www.getslds.com/components/lookups#role=regular&status=all
 */
class LLookup extends LComponent implements LSelectI {

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
  /// Lookup Input
  final LInput input;

  /// Lookup form + menu
  final DivElement menu = new DivElement()
    ..classes.add(C_LOOKUP__MENU)
    ..attributes[Html0.ROLE] = Html0.ROLE_LISTBOX;

  final UListElement _lookupList = new UListElement()
    ..classes.add(C_LOOKUP__LIST)
    ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;

  /// Lookup Items
  final List<LLookupItem> _items = new List<LLookupItem>();

  /**
   * Lookup
   * [input] should have labelText set and be of type text
   * [select] single|multi
   * [scope] single|multi
   */
  LLookup(LInput this.input, {
      String select: DATA_SELECT_SINGLE,
      String scope: "single",
      bool typeahead: false}) {
    _setAttributes(select, scope, typeahead);
    //
    input.input
      ..classes.add(LEditor.C_INPUT__BARE)
      ..attributes[Html0.ROLE] = Html0.ROLE_COMBOBOX
      ..attributes[Html0.ARIA_AUTOCOMPLETE] = Html0.ARIA_AUTOCOMPLETE_LIST
      ..attributes[Html0.ARIA_HASPOPUP] = "true";
    input.labelInputText = lLookupLabel();
    // div .lookup
    // - div .form-element ... label...
    // - div .menu
    // -- ul
    element.append(input.elementLookup); // adds search icon
    element.append(menu);
    menu.append(_lookupList);
    //
    menu.classes.add(LVisibility.C_AUTO_VISIBLE);
    menu.onKeyDown.listen(onMenuKeyDown);
    input.input.onKeyUp.listen(onInputKeyUp);
  } // LLookup


  LLookup.base(String name, {String idPrefix})
    : this(new LInput(name, "text", idPrefix:idPrefix));


  /// Set Lookup Attributes
  void _setAttributes(String select, String scope, bool typeahead) {
    element.attributes["data-select"] = select;
    element.attributes["data-scope"] = scope;
    element.attributes["dara-typeahead"] = typeahead.toString();
  }

  bool get required => false;
  void set required (bool newValue) {
    // TOOD
  }

  bool get multiple => element.attributes["data-select"] == DATA_SELECT_MULTI;

  /// Get options
  List<OptionElement> get options {
    List<OptionElement> list = new List<OptionElement>();
    for (LLookupItem item in _items) {
      list.add(item.toOption());
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
  void addSelectOptions(List<SelectOption> list) {
    for (SelectOption so in list)
      addSelectOption(so);
  }
  /// Add Option List
  void addDOptions(List<DOption> options) {
    for (DOption op in options) {
      SelectOption so = new SelectOption(op);
      addSelectOption(so);
    }
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
    lookupUpdateList(false);
  }


  void lookupUpdateList(bool showAll) {
    String restriction = input.value;
    RegExp exp = null;
    if (!showAll) {
      exp = _createRegExp(restriction);
    }
    int count = 0;
    for (LLookupItem item in _items) {
      if (exp == null) {
        item.hide = false;
        //item.clearHighlight();
        //item.exampleUpdate();
        count++;
      }
      else if (item.labelHighlight(exp) || item.descriptionHighlight(exp)) {
        item.hide = false;
        //item.exampleUpdate();
        count++;
      }
      else { // no match
        item.hide = true;
      }
    }
    if (count == 0 && _items.isNotEmpty) {
      input.input.setCustomValidity("No matching options");
    } else {
      input.input.setCustomValidity("");
    }
    //doValidate();
    _log.fine("popupUpdateList ${input.name} '${restriction}' ${count} of ${_items.length}");
  }

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
    if (selectedItem == null) {
      input.value = "";
      input.input.attributes[Html0.DATA_VALUE] = "";
      input.input.attributes[Html0.ARIA_ACTIVEDECENDNT] = "";
      if (input.editorChange != null)
        input.editorChange(input.name, null, false, null);
    } else {
      input.value = selectedItem.label;
      input.input.attributes[Html0.DATA_VALUE] = selectedItem.value;
      input.input.attributes[Html0.ARIA_ACTIVEDECENDNT] = selectedItem.value;

      if (input.editorChange != null)
        input.editorChange(input.name, selectedItem.value, false, selectedItem);
    }
    showResults = false;
  } // onItemClick



  /// Show Popup
  void set showResults (bool newValue) {
    input.input.attributes[Html0.ARIA_EXPANED] = newValue.toString();
    // Input has aria-activedescendant attribute whose value is the id of the highlighted results list option, no value if nothing's highlighted in the list
  }

  /// Create regex for [search] returns null if empty or error
  RegExp _createRegExp(String search) {
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
  LLookupItem({String id, String label, String value, String href,
          LIcon leftIcon, LIcon rightIcon, bool selected, bool disabled})
    : super(id:id, label:label, value:value, href:href,
          leftIcon:leftIcon, rightIcon:rightIcon, selected:selected, disabled:disabled) {
    element
      ..classes.add(LLookup.C_LOOKUP__ITEM)
      ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;
    a
      ..attributes[Html0.ROLE] = Html0.ROLE_OPTION;
  } // LLookupItem


  /// Lookup Item from List
  LLookupItem.from(ListItem item)
    : this(id:item.id, label:item.label, value:item.value, href:item.href,
        leftIcon:item.leftIcon, rightIcon:item.rightIcon, selected:item.selected, disabled:item.disabled);

  /// Lookup Item from Option
  LLookupItem.fromOption(OptionElement option)
     : this(id:option.id, label:option.label, value:option.value, selected:option.selected, disabled:option.disabled);

  /// Lookup Item from SelectOption
  LLookupItem.fromSelectOption(SelectOption option)
      : this(id:option.id, label:option.label, value:option.value, selected:option.selected, disabled:option.disabled);


  /// On Click
  ElementStream<MouseEvent> get onClick => a.onClick;


} // LLookupItem
