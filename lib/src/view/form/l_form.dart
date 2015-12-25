/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Form Submitted [valid] form validated
 * return true if continue
 */
typedef bool FormSubmitPre (bool valid);

/**
 * Form submitted and operation completed [response] is null if error
 */
typedef void FormSubmitPost (SResponse response);

/**
 * Form Reset (info)
 */
typedef void FormResetted ();

/**
 * Form with FormElements
 */
class LForm
    extends LComponent implements FormI {

  /// slds-form-element (div): Initializes form element
  static const String C_FORM_ELEMENT = "slds-form-element";
  /// slds-form-element__label (div): Initializes form element label
  static const String C_FORM_ELEMENT__LABEL = "slds-form-element__label";
  /// slds-form-element__control (div): Initializes form element control - Control can contain an <input>, <textarea>, <select>
  static const String C_FORM_ELEMENT__CONTROL = "slds-form-element__control";
  /// slds-input (input): Initializes text input
  static const String C_INPUT = "slds-input";
  /// slds-input--small (slds-input): Applies styles for a smaller text input
  static const String C_INPUT__SMALL = "slds-input--small";
  /// slds-input--bare (slds-input): Removes background and border from text input
  static const String C_INPUT__BARE = "slds-input--bare";
  /// slds-input-has-icon (div around <input): Lets text input know how to position .slds-input__icon - The <div> contains both the <svg> and the <input>
  static const String C_INPUT_HAS_ICON = "slds-input-has-icon";
  /// slds-input__icon (svg): Hook for .slds-input-has-icon
  static const String C_INPUT__ICON = "slds-input__icon";
  /// slds-input-has-icon--left (slds-input-has-icon): Positions .slds-input__icon to the left of the text input
  static const String C_INPUT_HAS_ICON__LEFT = "slds-input-has-icon--left";
  /// slds-input-has-icon--right (slds-input-has-icon): Positions .slds-input__icon to the right of the text input
  static const String C_INPUT_HAS_ICON__RIGHT = "slds-input-has-icon--right";
  /// slds-textarea (textarea): Initializes textarea
  static const String C_TEXTAREA = "slds-textarea";
  /// slds-select (select): Initializes select
  static const String C_SELECT = "slds-select";
  /// slds-checkbox (label): Initializes checkbox - Label wraps the faux checkbox and text, <input> requires [type=checkbox]
  static const String C_CHECKBOX = "slds-checkbox";
  /// slds-checkbox--faux (span): Creates a custom styled checkbox - Apply to <span> inside .slds-checkbox
  static const String C_CHECKBOX__FAUX = "slds-checkbox--faux";
  /// slds-radio (label): Initializes radio button - Label wraps the faux radio and text, <input> requires [type=radio]
  static const String C_RADIO = "slds-radio";
  /// slds-radio--faux (span): Creates a custom styled radio button - Apply to <span> inside .slds-radio
  static const String C_RADIO__FAUX = "slds-radio--faux";
  /// slds-form--horizontal (form): Horizontally aligns a single form label and control on the same line
  static const String C_FORM__HORIZONTAL = "slds-form--horizontal";
  /// slds-form--stacked (form): Vertically aligns form label and control, provides spacing between form elements - This is the default
  static const String C_FORM__STACKED = "slds-form--stacked";
  /// slds-form--inline (form): horizontally align multiple form elements on the same axis
  static const String C_FORM__INLINE = "slds-form--inline";
  /// slds-form--compound (form): Creates a form that consists of multiple form groups - Groups are placed in fieldsets and small labels are used for inputs
  static const String C_FORM__COMPOUND = "slds-form--compound";
  /// slds-form-element__row (div): Use to create rows of form elements in a compound form - Wrap form elements in this class
  static const String C_FORM_ELEMENT__ROW = "slds-form-element__row";
  /// slds-form--compound--horizontal (slds-form--compound): Layout modifier for compound forms - Positions form labels to the left of the form control
  static const String C_FORM__COMPOUND__HORIZONTAL = "slds-form--compound--horizontal";

  /// select container
  static const String C_SELECT_CONTAINER = "slds-select_container";

  /// top label (top 0)
  static const String C_FORM_ELEMENT__LABEL__TOP = "slds-form-element__label--top";
  /// marker only
  static const String C_FORM_ELEMENT__LABEL__SMALL = "slds-form-element__label--small";

  /// marker
  static const String C_FORM_ELEMENT__GROUP = "slds-form-element--group";
  /// font-size 0.75rem
  static const String C_FORM_ELEMENT__HELPER = "slds-form-element--helper";

  static const String C_HAS_ERROR = "slds-has-error";
  static const String C_IS_REQUIRED = "slds-is-required";

  /// Help Block
  static const String C_FORM_ELEMENT__HELP = "slds-form-element__help";

  static final List<String> FORMTYPES = [C_FORM__HORIZONTAL, C_FORM__STACKED, C_FORM__INLINE];


  /// slds-input__icon - Hook for .slds-input-has-prefix
  static const String C_INPUT__PREFIX = "slds-input__prefix";
  /// slds-input-has-icon - Lets text input know how to position .slds-input__prefix
  static const String C_INPUT_HAS_PREFIX = "slds-input-has-prefix";

  /// Second right icon (clear)
  static const String C_INPUT_HAS_ICON__RIGHT2 = "slds-input-has-icon--right2";
  static const String C_INPUT__ICON2 = "slds-input__icon2";


  /// before the field
  static const String C_INPUT_HAS_PREFIX__LEFT = "slds-input-has-prefix--left";
  /// in the field
  static const String C_INPUT_HAS_PREFIX__START = "slds-input-has-prefix--start";
  /// after the field
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

  /// Calback when Record saved
  RecordSaved recordSaved;
  /// Callback when Record deleted
  RecordDeleted recordDeleted;
  /// Callback when Form submitted - allows to prevent submitting form
  FormSubmitPre formSubmitPre;
  /// Callback when Form submitted and [recordSaved] complete
  FormSubmitPost formSubmitPost;
  /// Callback after Form reset
  FormResetted formResetted;
  /// Callback after record was changed in Form (info only)
  RecordChange formRecordChange;
  /// optional Buttons
  DivElement buttonDiv;

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
  } // LForm

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
  void setSection(FormSection section) {
    _section = section;
    if (section != null) {
      if (_sections == null)
        _sections = new List<FormSection>();
      _sections.add(_section);
      element.append(_section.createFieldSet("${id}-s${_sections.length}"));
    }
  }
  FormSection _section;
  List<FormSection> _sections;


  /// Add Editor (to current section)
  void addEditor (LEditor editor, {bool newRow:false, int width:1, int height:1,
      String marginClass}) {
    if (marginClass != null && marginClass.isNotEmpty) {
      editor.element.classes.add(marginClass);
    }
    editor.editorChange = data.onEditorChange;
    editorList.add(editor);
    if (_section == null) {
      element.append(editor.element);
    } else {
      _section.addEditor(editor, element, newRow, width, height);
    }
    editor.data = _data;
    editor.entry = _data.getEntry(editor.id, editor.name, true, createDefault:editor.value);
    editor.onFocus.listen(onEditorFocus); // close other dropdowns
  } // addEditor

  /// Editor Focused - close other editor dropdowns
  void onEditorFocus(FocusEvent evt) {
    String id = "";
    if (evt != null) {
      Element target = evt.target;
      id = target.id;
    }
    for (LEditor ed in editorList) {
      // _log.fine("onEditorFocus ${id} - ${ed.id}");
      if (id != ed.id) {
        ed.showDropdown = false;
      }
    }
  } // onEditorFocus


  /**
   * Add AutoSubmit (on ENTER) - returns true if found
   */
  bool addAutoSubmit(String editorName) {
    for (LEditor ed in editorList) {
      if (ed.name == editorName) {
        ed.autoSubmit = onFormSubmit;
        return true;
      }
    }
    return false;
  }

  /// append element
  void append(Element newValue) {
    element.append(newValue);
  }
  /// add component
  void add(LComponent component) {
    element.append(component.element);
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
  /// Data Record/Row No + Display
  void setRecord (DRecord record, int rowNo) {
    _data.setRecord(record, rowNo);
    display();
  }

  /// Display Data in Editors
  void display() {
    if (_buttonSave != null && _buttonSaveChangeOnly) {
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
    if (_buttonSave != null && _buttonSaveChangeOnly) {
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
    if (formRecordChange != null) {
      formRecordChange(record, columnChanged, rowNo);
    }
  } // onRecordChange


  /// Add Reset Button - use [formResetted] to listen to reset events
  LButton addResetButton({String label, String title}) {
    if (_buttonReset == null) {
      _buttonReset = new LButton.neutralIcon("reset",
          label == null ? lFormReset() : label,
          new LIconUtility(LIconUtility.UNDO), iconLeft:true, idPrefix:id)
        ..typeReset = false; // channel explicitly through onFormReset
      if (title != null)
        _buttonReset.title = title;
      _buttonReset.onClick.listen(onFormReset);
      if (buttonDiv == null)
        add(_buttonReset);
      else
        buttonDiv.append(_buttonReset.element);
    }
    return _buttonReset;
  }
  LButton _buttonReset;

  /// Add Save Button - use [formSubmitted] to listen to submit events
  LButton addSaveButton({String label, String title, String name:"save", LIcon icon, bool buttonSaveChangeOnly:true}) {
    if (_buttonSave == null) {
      LIcon theIcon = icon;
      if (theIcon == null)
        theIcon = new LIconUtility(LIconAction.CHECK);
      //
      _buttonSave = new LButton.brandIcon(name,
          label == null ? lFormSave() : label,
          theIcon, iconLeft:true, idPrefix:id)
        ..typeSubmit = false; // channel explicitly through onFormSubmit
      _buttonSave.autofocus = true;
      if (title != null)
        _buttonSave.title = title;
      _buttonSave.onClick.listen(onFormSubmit);
      _buttonSaveChangeOnly = buttonSaveChangeOnly;
      if (buttonDiv == null)
        add(_buttonSave);
      else
        buttonDiv.append(_buttonSave.element);
    }
    //
    if (_buttonSaveChangeOnly) {
      _buttonSave.disabled = !_data.changed;
    } else {
      _buttonSave.disabled = false;
    }
    return _buttonSave;
  }
  LButton _buttonSave;
  bool _buttonSaveChangeOnly = true;


  /// Error Indicator
  LPopover addErrorIndicator() {
    if (_errorBtn == null) {
      _errorBtn = new LButton.iconBare("formError", new LIconUtility(LIconUtility.ERROR), lFormError(), idPrefix: id);
      _errorBtn.icon.classes.add(LText.C_TEXT_ERROR);
      _errorBtn.classes.add(LVisibility.C_HIDE); // button hide
      //
      _errorPop = new LPopover()
        ..headText = lFormError();
      _errorPop.showAbove(_errorBtn, showOnClick:true, showOnHover:true);
      _errorPop.wrapper.classes.add(LMargin.C_HORIZONTAL__X_SMALL);
      //
      if (buttonDiv == null)
        add(_errorPop);
      else
        buttonDiv.append(_errorPop.element);
    }
    return _errorPop;
  }
  LButton _errorBtn;
  LPopover _errorPop;


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
    evt.preventDefault(); // resets to form default
    //_log.info("onFormReset");
    onEditorFocus(null); // hide all dropdowns
    data.resetRecord(); // resets to original/default
    if (formResetted != null) {
      formResetted();
    }
    display();
    _debug("reset:");
  } // onFormReset

  /// On Form Submit
  void onFormSubmit(Event evt) {
    evt.preventDefault(); // might be form or button event
    //_log.info("onFormSubmit - ${record}");
    onEditorFocus(null); // hide all dropdowns
    bool valid = doValidate();
    if (formSubmitPre != null) {
      valid = formSubmitPre(valid); // inform/confirm
    }
    _debug("onFormSubmit valid=${valid}:");

    if (valid && recordSaved != null) {
      recordSaved(record)
      .then((SResponse response){
        _log.fine("onFormSubmit success=${response.isSuccess} ${response.msg}");
        if (formSubmitPost != null) {
          formSubmitPost(response); // inform/confirm
        }
      })
      .catchError((Event error, StackTrace stackTrace) {
        if (formSubmitPost != null)
          formSubmitPost(null);
      });
    }

    // Submit form if there is an action
    if (valid && element is FormElement) {
      FormElement ff = element as FormElement;
      if (ff.action.isNotEmpty)
        ff.submit();
    }
  } // onFormSubmit

  /// Validate Form and display errors
  bool doValidate() {
    bool valid = true;
    List<String> errors = new List<String>();
    for (LEditor editor in editorList) {
      if (!editor.doValidate()) { // validation
        valid = false;
        errors.add("${editor.label}: ${editor.statusText}");
        // display if hidden
        if (_sections != null) {
          for (FormSection section in _sections) {
            section.expandIfContains(editor);
          }
        }
        editor.focus();
      }
    }
    // show error indicator
    if (_errorBtn != null) {
      _errorPop.bodyLines = errors;
      if (valid)
        _errorBtn.classes.add(LVisibility.C_HIDE); // button
      else
        _errorBtn.classes.remove(LVisibility.C_HIDE);
    }
    return valid;
  } // doValidate

  /// show error [message]
  void showError(String message) {
    if (_errorBtn != null) {
      _errorPop.bodyText = message;
      _errorBtn.classes.remove(LVisibility.C_HIDE); // button
    }
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
        if (entity.value != DataRecord.NULLVALUE)
          info += " ${entity.columnName}=${entity.value}";
      }
    }
    _log.fine(info);
    if (_debugElement != null) {
      _debugElement.text = info;
    }
  }
  DivElement _debugElement;

  /// focus form
  void focus() {
    if (_buttonSave != null && !_buttonSave.disabled) {
      _buttonSave.focus();
      _log.fine("focus ${_buttonSave.name}");
      return;
    }
    if (editorList.isNotEmpty) {
      for (LEditor ed in editorList) {
        if (!ed.readOnly) {
          ed.focus();
          _log.fine("focus ${ed.name}");
          return;
        }
      }
    }
    _log.fine("focus");
    element.focus();
  } // focus

  /// get editor with [columnName] or null
  LEditor getEditor(String columnName) {
    for (LEditor ed in editorList) {
      if (ed.name == columnName)
        return ed;
    }
    return null;
  }

  /// set html of editors
  void set html5 (bool newValue) {
    for (LEditor ed in editorList) {
      ed.html5 = newValue;
    }
  }

  // Trl
  static String lFormSave() => Intl.message("Save", name: "lFormSave");
  static String lFormReset() => Intl.message("Reset", name: "lFormReset");
  static String lFormError() => Intl.message("Form Error", name: "lFormError");

} // LForm
