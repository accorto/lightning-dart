/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Process - Sales Path [LPath] or [LWizard]
 * [input] is the actual element [element] is the .form-element
 */
abstract class LProcess
    extends LEditor with LFormElement, LSelectI {

  /// slds-tabs--path (div): Initializes default tabset
  static const String C_TABS__PATH = "slds-tabs--path";
  /// slds-tabs--path__nav (ul): Creates the container for the default tabs
  static const String C_TABS__PATH__NAV = "slds-tabs--path__nav";
  /// slds-tabs--path__item (li): Styles each list item as a single tab
  static const String C_TABS__PATH__ITEM = "slds-tabs--path__item";
  /// slds-tabs--path__link (a): Styles each <a> element in the <li>
  static const String C_TABS__PATH__LINK = "slds-tabs--path__link";
  /// slds-tabs--path__content (div): Styles each tab content wrapper
  static const String C_TABS__PATH__CONTENT = "slds-tabs--path__content";
  /// slds-tabs--path__stage (span): Contains the check mark when the stage is completed - This class is only required in the sales path tabs and is contained inside the .slds-tabs--path__link
  static const String C_TABS__PATH__STAGE = "slds-tabs--path__stage";
  /// slds-tabs--path__title (span): Contains the name of the stage - This class is only required in the sales path tabs and is contained inside the .slds-tabs--path__link
  static const String C_TABS__PATH__TITLE = "slds-tabs--path__title";
  /// slds-is-complete (slds-tabs--path__item): Creates the completed stage of the sales path
  static const String C_IS_COMPLETE = "slds-is-complete";
  /// slds-is-current (slds-tabs--path__item): Creates the current stage of the sales path
  static const String C_IS_CURRENT = "slds-is-current";
  /// slds-is-incomplete (slds-tabs--path__item): Creates the incomplete stage of the sales path
  static const String C_IS_INCOMPLETE = "slds-is-incomplete";
  /// slds-is-active (slds-tabs--path__item): Creates the active stage of the sales path - This class must be placed on the item programatically when the guidance section is used
  static const String C_IS_ACTIVE = "slds-is-active";

  /// slds-wizard (div): Initializes popover
  static const String C_WIZARD = "slds-wizard";
  /// slds-wizard__list (ol): An ordered list containing steps of a process
  static const String C_WIZARD__LIST = "slds-wizard__list";
  /// slds-wizard__item (li): A list item for each step of the process
  static const String C_WIZARD__ITEM = "slds-wizard__item";
  /// slds-wizard__link (a): Hyperlink of the list item, user can jump between steps
  static const String C_WIZARD__LINK = "slds-wizard__link";
  /// slds-wizard__marker (span): Dot indicator for each step
  static const String C_WIZARD__MARKER = "slds-wizard__marker";
  /// slds-wizard__label (span class="slds-text-heading--label): Text description for each step
  static const String C_WIZARD__LABEL = "slds-wizard__label";
  /// slds-wizard__progress (span): Container for progress bar - <span> sits outside of <ol>
  static const String C_WIZARD__PROGRESS = "slds-wizard__progress";
  /// slds-wizard__progress-bar (span): Bar showcasing which step of the process a user is on - Inline width styles should be modified with Javascript
  static const String C_WIZARD__PROGRESS_BAR = "slds-wizard__progress-bar";


  static final Logger _log = new Logger("LProcess");

  final DivElement input = new DivElement();

  final List<LProcessItem> _itemList = new List<LProcessItem>();

  // name
  String name;

  void updateId(String idPrefix) {
    id = createId(idPrefix, name);
  }

  /// get value
  String get value => _value;
  void set value (String newValue);
  String _value;


  String get defaultValue => _defaultValue;
  void set defaultValue (String newValue) {
    _defaultValue = newValue;
  }
  String _defaultValue;


  bool get readOnly => _readOnly;
  void set readOnly (bool newValue) {
    _readOnly = newValue;
  }
  bool _readOnly = false;

  bool get disabled => _readOnly;
  void set disabled (bool newValue) {
    _disabled = newValue;
  }
  bool _disabled = false;


  String get type => EditorI.TYPE_SELECT;
  bool get spellcheck => false;
  void set spellcheck (bool ignored) {}
  bool get autofocus => false;
  void set autofocus (bool ignored) {}
  bool get multiple => false;
  bool get required => true;
  void set required (bool ignored) {}

  int get selectedCount => _value == null || _value.isEmpty ? 0 : 1;
  int get length => _itemList.length;

  /// Validation state from Input
  ValidityState get inputValidationState => null;
  /// Validation Message from Input
  String get inputValidationMsg => _validationMsg == null ? "" : _validationMsg;
  /// set custom validity explicitly
  void setCustomValidity(String newValue) {
    _validationMsg = newValue;
  }
  String _validationMsg;

  /// -- options --

  /// Get options
  List<OptionElement> get options {
    List<OptionElement> retValue = new List<OptionElement>();
    for (LProcessItem item in _itemList) {
      SelectOption so = item.asSelectOption();
      retValue.add(so.asOptionElement());
    }
    return retValue;
  }
  /// Add Option List
  void set options (List<OptionElement> list) {
    clearOptions();
    defaultValue = null;
    for (OptionElement oe in list) {
      SelectOption so = new SelectOption.fromElement(oe);
      addSelectOption(so);
      if (so.option.isDefault)
        defaultValue = so.value;
    }
    if (defaultValue != null)
      value = defaultValue;
  }
  /// Add Option
  void addOption(OptionElement oe) {
    addSelectOption(new SelectOption.fromElement(oe));
  }

  /// -- select options --

  /// get updated Option list
  List<SelectOption> get selectOptionList {
    List<SelectOption> retValue = new List<SelectOption>();
    for (LProcessItem item in _itemList) {
      retValue.add(item.asSelectOption());
    }
    return retValue;
  }
  /// Set Option List
  void set selectOptionList(List<SelectOption> list) {
    clearOptions();
    defaultValue = null;
    for (SelectOption so in list) {
      addSelectOption(so);
      if (so.option.isDefault)
        defaultValue = so.value;
    }
    if (defaultValue != null)
      value = defaultValue;
  } // selectOptionList

  /// Set Option List
  void set dOptionList(List<DOption> options) {
    clearOptions();
    defaultValue = null;
    for (DOption option in options) {
      addDOption(option);
      if (option.isDefault)
        defaultValue = option.value;
    }
    if (defaultValue != null)
      value = defaultValue;
  }

  /// clear options
  void clearOptions() {
    _itemList.clear();
  }


  /// Add DOption
  void addDOption(DOption option);
  /// Add Option
  void addSelectOption(SelectOption so);


  /// Item Selected - callback - onInputChange
  void onProcessItemChange(DOption option) {
    if (_readOnly || _disabled) {
      return;
    }
    value = option == null ? null : option.value;
    String theValue = value;
    _log.config("onItemChange ${name}=${theValue}");
    if (data != null && entry != null) {
      data.updateEntry(entry, theValue);
      valueDisplayUpdate();
    }
    if (editorChange != null) {
      editorChange(name, theValue, entry, null);
    }
  } // inItemChange

} // LProcess


/// Item Selected
typedef void ProcessItemChange(DOption option);


/**
 * Process Item
 */
abstract class LProcessItem {

  final LIElement element = new LIElement()
    ..attributes[Html0.ROLE] = Html0.ROLE_PRESENTATION;
  final AnchorElement _a = new AnchorElement(href: "#")
    ..attributes[Html0.ROLE] = Html0.ROLE_TAB;


  final DOption option;
  /// callback
  final ProcessItemChange processItemChange;
  SelectOption so;

  /// Process Item
  LProcessItem(DOption this.option, ProcessItemChange this.processItemChange,
    {SelectOption this.so}) {
    element.append(_a);
    _a.onClick.listen(onLinkClick);
  } //

  /// Return as Select Option
  SelectOption asSelectOption() {
    if (so == null)
      so = new SelectOption(option);
    return so;
  }

  /// value
  String get value => option.value;
  /// label
  String get label => option.label;


  bool get active => element.classes.contains(LProcess.C_IS_ACTIVE);
  void set active (bool newValue) {
    element.classes.toggle(LProcess.C_IS_ACTIVE, newValue);
  }

  /// option is displayed (active or overwrite)
  bool get optionDisplayed {
    return true;
  }
  /// overwrite if displayed
  void set optionDisplayed (bool newValue) {
  }

  /**
   * Clicked On Click
   */
  void onLinkClick(MouseEvent evt) {
    if (_href == "#") {
      evt.preventDefault();
      evt.stopPropagation();
    }
    //
    processItemChange(option);
  }

  String get href => _href;
  /// set Link
  void set href (String newValue) {
    if (newValue == null || newValue.isEmpty) {
      _href = "#";
    } else {
      _href = newValue;
    }
    _a.href = _href;
  }
  String _href = "#";

  void set target (String newValue) {
    _a.target = newValue;
  }

} // LProcessItem
