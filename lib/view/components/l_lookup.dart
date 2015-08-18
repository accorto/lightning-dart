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
class LLookup extends LComponent {

  static const String C_LOOKUP = "slds-lookup";
  static const String C_LOOKUP__CONTROL = "slds-lookup__control";

  static const String C_LOOKUP__MENU = "slds-lookup__menu";
  static const String C_LOOKUP__LIST = "slds-lookup__list";
  static const String C_LOOKUP__ITEM = "slds-lookup__item";

  /// Lookup form + menu
  final DivElement element = new DivElement()
    ..classes.add(C_LOOKUP);
  /// Lookup Input
  final LInput input;

  /// Lookup form + menu
  final DivElement menu = new DivElement()
    ..classes.add(C_LOOKUP__MENU)
    ..attributes[Html0.ROLE] = Html0.ROLE_LISTBOX;

  final UListElement _menuList = new UListElement()
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
      String select: "single",
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
    element.append(input.formElementLookup); // adds search icon
    element.append(menu);
    menu.append(_menuList);
    //
    menu.classes.add(LVisibility.C_AUTO_VISIBLE);
  } // LLookup


  LLookup.base(String name, {String idPrefix})
    : this(new LInput(name, "text", idPrefix:idPrefix));


  /// Set Lookup Attributes
  void _setAttributes(String select, String scope, bool typeahead) {
    element.attributes["data-select"] = select;
    element.attributes["data-scope"] = scope;
    element.attributes["dara-typeahead"] = typeahead.toString();
  }

  /// add Lookup Item
  void addItem(LLookupItem item) {
    _items.add(item);
    _menuList.append(item.element);
  }

  /// Set Lookup Items
  void set items (List<LLookupItem> itemList) {
    clear();
    _items.addAll(itemList);
    for (LLookupItem item in items) {
      _menuList.append(item.element);
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

  /// Clear Items
  void clear() {
    _items.clear();
    _menuList.children.clear();
  }

  /// Show Popup
  void set showResults (bool newValue) {
    input.input.attributes[Html0.ARIA_EXPANED] = newValue.toString();
    // Input has aria-activedescendant attribute whose value is the id of the highlighted results list option, no value if nothing's highlighted in the list
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
  LLookupItem({String id, String label, String value, String href, LIcon leftIcon, LIcon rightIcon})
      : super(id:id, label:label, value:value, href:href, leftIcon:leftIcon, rightIcon:rightIcon) {
    element
      ..classes.add(LLookup.C_LOOKUP__ITEM)
      ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;
    a
      ..attributes[Html0.ROLE] = Html0.ROLE_OPTION;
  } // LLookupItem


  LLookupItem.from(ListItem item) // not copied: selected/disabled
    : this(id:item.id, label:item.label, value:item.value, href:item.href, leftIcon:item.leftIcon, rightIcon:item.rightIcon);


} // LLookupItem
