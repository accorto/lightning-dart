/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Form with FormElements
 */
class LForm extends LComponent implements FormI {

  /// slds-form-element - Initializes form element | Required
  static const String C_FORM_ELEMENT = "slds-form-element";
  /// slds-form-element__label - Initializes form element label | Required
  static const String C_FORM_ELEMENT__LABEL = "slds-form-element__label";
  /// small label
  static const String C_FORM_ELEMENT__LABEL__SMALL = "slds-form-element__label--small";
  static const String C_FORM_ELEMENT__LABEL__TOP = "slds-form-element__label--top";
  /// slds-form-element__control - Initializes form element control | Required
  static const String C_FORM_ELEMENT__CONTROL = "slds-form-element__control";
  /// slds-input - Initializes text input | Required
  static const String C_INPUT = "slds-input";
  /// slds-input--small - Applies styles for a smaller text input
  static const String C_INPUT__SMALL = "slds-input--small";
  /// slds-input--bare - Removes background and border from text input
  static const String C_INPUT__BARE = "slds-input--bare";
  /// slds-input-has-icon - Lets text input know how to position .slds-input__icon
  static const String C_INPUT_HAS_ICON = "slds-input-has-icon";
  /// slds-input__icon - Hook for .slds-input-has-icon
  static const String C_INPUT__ICON = "slds-input__icon";
  /// slds-input-has-icon--left - Positions .slds-input__icon to the left of the text input
  static const String C_INPUT_HAS_ICON__LEFT = "slds-input-has-icon--left";
  /// slds-input-has-icon--right - Positions .slds-input__icon to the right of the text input
  static const String C_INPUT_HAS_ICON__RIGHT = "slds-input-has-icon--right";
  /// slds-textarea - Initializes textarea | Required
  static const String C_TEXTAREA = "slds-textarea";
  /// slds-select - Initializes select | Required
  static const String C_SELECT = "slds-select";
  /// slds-checkbox - Initializes checkbox | Required
  static const String C_CHECKBOX = "slds-checkbox";
  /// slds-checkbox--faux - Creates a custom styled checkbox
  static const String C_CHECKBOX__FAUX = "slds-checkbox--faux";
  /// slds-radio - Initializes radio butotn | Required
  static const String C_RADIO = "slds-radio";
  /// slds-radio--faux - Creates a custom styled radio button
  static const String C_RADIO__FAUX = "slds-radio--faux";
  /// slds-form--horizontal - Horizontally aligns form label and control on same line
  static const String C_FORM__HORIZONTAL = "slds-form--horizontal";
  /// slds-form--stacked - Vertically aligns form label and control, provides spacing between form elements
  static const String C_FORM__STACKED = "slds-form--stacked";
  /// slds-form--inline - horizontally align form elements on the same axis
  static const String C_FORM__INLINE = "slds-form--inline";
  /// slds-form--compound - Form consists that consists of form groups
  static const String C_FORM__COMPOUND = "slds-form--compound";
  /// slds-form-element__row - Clears a row of form elements
  static const String C_FORM_ELEMENT__ROW = "slds-form-element__row";
  /// slds-form--compound--horizontal - Layout modifier for compound forms
  static const String C_FORM__COMPOUND__HORIZONTAL = "slds-form--compound--horizontal";


  static const String C_FORM_ELEMENT__GROUP = "slds-form-element--group";
  static const String C_FORM_ELEMENT__HELPER = "slds-form-element--helper";

  static const String C_HAS_ERROR = "slds-has-error";
  static const String C_IS_REQUIRED = "slds-is-required";

  static const String C_FORM_ELEMENT__HELP = "slds-form-element__help";

  static final List<String> FORMTYPES = [C_FORM__HORIZONTAL, C_FORM__STACKED, C_FORM__INLINE];


  /// slds-input__icon - Hook for .slds-input-has-prefix
  static const String C_INPUT__PREFIX = "slds-input__prefix";
  /// slds-input-has-icon - Lets text input know how to position .slds-input__prefix
  static const String C_INPUT_HAS_PREFIX = "slds-input-has-prefix";
  /// slds-input-has-icon--left - Positions .slds-input__prefix to the left of the text input
  static const String C_INPUT_HAS_PREFIX__LEFT = "slds-input-has-prefix--left";
  /// slds-input-has-icon--right - Positions .slds-input__prefix to the right of the text input
  static const String C_INPUT_HAS_PREFIX__RIGHT = "slds-input-has-prefix--right";


  static final Logger _log = new Logger("LForm");

  /// Form Element
  final Element element;
  /// Form element might be null if initiated with div
  FormElement get form {
    if (element is FormElement)
      return element as FormElement;
    return null;
  }
  /// List of Editors
  final List<LEditor> editorList = new List<LEditor>();

  /// Record Saved
  RecordSaved recordSaved;
  /// Callback when delete
  RecordDeleted recordDeleted;

  /**
   * Form - type = C_FORM__HORIZONTAL, C_FORM__STACKED, C_FORM__INLINE
   */
  LForm(Element this.element, String name, String type, {String idPrefix}) {
    element.classes.add(type);
    if (element is FormElement) {
      FormElement form = (element as FormElement);
      form.noValidate = true; // otherwise stops at first invalid field
      form.name = name;
      form.onSubmit.listen(onFormSubmit);
      form.onReset.listen(onFormReset);
    }
    element.id = LComponent.createId(idPrefix, name);
    _data = new DataRecord(onRecordChange);
  }

  LForm.horizontal(String name, {String idPrefix})
    : this(new FormElement(), name, C_FORM__HORIZONTAL, idPrefix:idPrefix);
  LForm.stacked(String name, {String idPrefix})
    : this(new FormElement(), name, C_FORM__STACKED, idPrefix:idPrefix);
  LForm.inline(String name, {String idPrefix})
    : this(new FormElement(), name, C_FORM__INLINE, idPrefix:idPrefix);

  /// Set Id
  void set id (String newValue) {
    element.id = newValue;
  }

  /// Set Section
  void setSection(LSectionTitle section) {
    _section = section;
    if (section == null) {
      _sectionElement = null;
    } else {
      _sectionElement = new DivElement();
      _section.setSectionElement(_sectionElement);
      if (_section.element is LegendElement) {
        FieldSetElement fs = new FieldSetElement()
          ..append(_section.element)
          ..append(_sectionElement);
        element.append(fs);
      } else {
        element.append(_section.element);
        element.append(_sectionElement);
      }
    }
  }
  LSectionTitle _section;
  DivElement _sectionElement;

  /// Add Editor (to current section)
  void addEditor (LEditor editor) {
    editor.editorChange = data.onEditorChange;
    editorList.add(editor);
    if (_sectionElement == null) {
      element.append(editor.element);
    } else {
      _sectionElement.append(editor.element);
    }
    editor.data = _data;
    editor.entry = _data.getEntry(editor.id, editor.name, true);
  }

  /// Get Action or null
  String get action {
    if (element is FormElement)
      return (element as FormElement).action;
    return null;
  }
  /// Set action (if form)
  void set action (String newValue) {
    if (element is FormElement)
      (element as FormElement).action = newValue;
  }
  /// Get Method or null
  String get method {
    if (element is FormElement)
      return (element as FormElement).method;
    return null;
  }
  /// Set Method (if form)
  void set method (String newValue) {
    if (element is FormElement)
      (element as FormElement).method = newValue;
  }

  /// Get Data Container
  DataRecord get data => _data;
  DataRecord _data;

  /// Data Record
  DRecord get record => _data.record;
  /// Data Record
  void set record (DRecord record) {
    setRecord(record, 0);
  }
  /// Data Record/Row No
  void setRecord (DRecord record, int rowNo) {
    _data.setRecord(record, rowNo);
    display();
  }

  /// Display Data in Editors
  void display() {
    if (_buttonSave != null) {
      _buttonSave.disabled = !data.changed;
    }
    for (LEditor editor in editorList) {
      editor.data = _data;
      editor.entry = _data.getEntry(editor.id, editor.name, true);
    }
  } // display

  /// editor changed
  void onRecordChange(DRecord record, DEntry columnChanged, int rowNo) {
    bool changed = _data.checkChanged();
    String name = columnChanged == null ? "-" : columnChanged.columnName;
    _log.config("onRecordChange - ${name} - changed=${changed}");
    if (_buttonSave != null) {
      _buttonSave.disabled = !changed;
    }
    String info = "change ";
    for (EditorI editor in editorList) {
      if (editor.hasDependentOn) {
        for (EditorIDependent edDep in editor.dependentOnList) {
          if (name == edDep.columnName) {
            _log.fine("onRecordChange ${name} dependent: ${editor.name}");
            editor.onDependentOnChanged(columnChanged);
            info += "(dependent:${edDep.columnName})";
          }
        }
      }
    }
    info += name + ":";
    _debug(info);
  } // onRecordChange


  /// Add Reset Button
  LButton addResetButton({String label}) {
    if (_buttonReset == null) {
      _buttonReset = new LButton.neutralIcon("reset",
          label == null ? lFormReset() : label,
          new LIconUtility(LIconUtility.UNDO), iconLeft:true)
        ..typeReset = true;
      element.append(_buttonReset.element);
      if (element is! FormElement) {
        _buttonReset.onClick.listen(onFormReset);
      }
    }
    return _buttonReset;
  }
  LButton _buttonReset;

  /// Add Save Button
  LButton addSaveButton({String label, String name:"save", LIcon icon}) {
    if (_buttonSave == null) {
      LIcon theIcon = icon;
      if (theIcon == null)
        theIcon = new LIconUtility(LIconAction.CHECK);
      theIcon.element.style.setProperty("fill", "white"); // TODO add style
      //
      _buttonSave = new LButton.brandIcon(name,
          label == null ? lFormSave() : label,
          theIcon, iconLeft:true)
         ..typeSubmit = true;
      element.append(_buttonSave.element);
      if (element is! FormElement) {
        _buttonSave.onClick.listen(onFormSubmit);
      }
    }
    _buttonSave.disabled = !_data.changed;
    return _buttonSave;
  }
  LButton _buttonSave;


  /// Small Editor/Label
  void set small (bool newValue) {
    for (LEditor editor in editorList) {
      editor.small = newValue;
    }
    if (_buttonReset != null)
      _buttonReset.small = newValue;
    if (_buttonSave != null)
      _buttonSave.small = newValue;
  } // small

  /// On Form Reset
  void onFormReset(Event evt) {
    //_log.info("onFormReset");
    evt.preventDefault(); // resets to default
    data.resetRecord(); // resets to original/default
    display();
    _debug("reset:");
  }

  /// On Form Submit
  void onFormSubmit(Event evt) {
    //_log.info("onFormSubmit - ${record}");
    bool valid = doValidate();
    _debug("submit valid=${valid}:");
    String a = action;
    if (!valid || a == null || a.isEmpty) {
      evt.preventDefault();
    }
    if (recordSaved != null) {
      String error = recordSaved(record);
      if (error != null) {

      }
    }
  } // onFormSubmit

  bool doValidate() {
    bool valid = true;
    for (LEditor editor in editorList) {
      if (!editor.doValidate()) {
        valid = false;
      }
    }
    return valid;
  }

  /// Layout

  /// Form Type (horizontal/stacked/inline)
  String get formType {
    for (String cls in element.classes) {
      if (FORMTYPES.contains(cls))
        return cls;
    }
    return null;
  }
  /// Set Form Type, e.g. C_FORM__HORIZONTAL, C_FORM__STACKED, C_FORM__INLINE
  void set formType (String newValue) {
    element.classes.removeAll(FORMTYPES);
    if (newValue != null && newValue.isNotEmpty)
      element.classes.add(newValue);
  }

  // add trace field/info
  void showTrace() {
    if (_debugElement == null) {
      _debugElement = new DivElement()
        ..classes.addAll([LTheme.C_BOX, LMargin.C_TOP__SMALL, LTheme.C_THEME__ALERT_TEXTURE]);
      form.append(_debugElement);
      _debugElement.text = "Trace: Enter your email and press Subscribe to test :-)";
    }
  }
  void _debug(String info) {
    for (DEntry entity in data.record.entryList) {
      if (entity.hasValue()) {
        info += " ${entity.columnName}=${entity.value}";
      }
    }
    if (_debugElement == null) {
      _log.config(info);
    } else {
      _debugElement.text = info;
    }
  }
  DivElement _debugElement;

  // Trl
  static String lFormSave() => Intl.message("Save", name: "lFormSave");
  static String lFormReset() => Intl.message("Reset", name: "lFormReset");

} // LForm
