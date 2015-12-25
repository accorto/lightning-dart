/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Timezone Lookup Editor
 */
class LLookupTimezone
    extends LLookup {

  static final Logger _log = new Logger("LLookupTimezone");

  /// Left Inside Input Element
  static const String C_INPUT__DOCK = "slds-input__dock";
  /// Input has Left Inside Input Element
  static const String C_INPUT_HAS_DOCK = "slds-input-has-dock";


  /// Search Icon
  final LIcon icon = new LIconUtility(LIconUtility.LOCATION);

  DivElement _dock = new DivElement()
    ..classes.add(C_INPUT__DOCK)
    ..title = lLookupTimezoneTimeTitle();

  /**
   * Timezone Editor
   */
  LLookupTimezone(String name, {String idPrefix, bool inGrid:false})
      : super(name, idPrefix:idPrefix, withClearValue:true, inGrid:inGrid) {
    _initTz();
  }

  /**
   * Timezone Editor
   */
  LLookupTimezone.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false})
      : super.from(dataColumn, idPrefix:idPrefix, withClearValue:true, inGrid:inGrid) {
    _initTz();
  }

  /// init behaviour
  void _initTz() {
    icon.element.onClick.listen(onDefaultClick);

    if (TZ.tzList == null || TZ.tzList.isEmpty) {
      _waitSeconds++;
      _log.info("initTz -waiting- ${_waitSeconds}");
      if (_waitSeconds < 20) {
        new Timer(new Duration(seconds: _waitSeconds), _initTz);
      }
      return;
    }
    for (TZ tz in TZ.tzList) {
      addLookupItem(new LLookupTimezoneItem(tz));
    }
    onDefaultClick(null);
    _formElement._inputWrapper.insertBefore(_dock, input);

    // start clock
    clockRun = !inGrid && !disabled && !readOnly;
  } // initTz
  int _waitSeconds = 0;

  /**
   * Set Default TZ
    */
  void onDefaultClick(MouseEvent ignored) {
    DateTime dt = new DateTime.now();
    String tzName = dt.timeZoneName;
    String theValue = tzName;
    String alias = TzRef.alias(tzName); // try first
    if (alias != null && TZ.tzMap.containsKey(alias)) {
      theValue = alias;
    } else {
      alias = TzRef.offset(dt.timeZoneOffset, tzName); // second
      if (alias != null && TZ.tzMap.containsKey(alias)) {
        theValue = alias;
      } else if (TZ.tzMap.containsKey(tzName)) {
        theValue = tzName;
      }
    }
    value = theValue;
    defaultValue = theValue;
    if (editorChange != null) {
      editorChange(name, theValue, null, _valueItem);
    }
  } // setDefault

  /// Get Timezone or null
  TZ get valueAsTz {
    if (_valueItem != null) {
      return _valueItem.reference as TZ;
    }
    return null;
  }

  @override
  void set readOnly (bool newValue) {
    super.readOnly = newValue;
    clockRun = !readOnly && !disabled;
  }
  @override
  void set disabled (bool newValue) {
    super.disabled = newValue;
    clockRun = !readOnly && !disabled;
  }

  bool get clockRun => input.classes.contains(C_INPUT_HAS_DOCK);
  void set clockRun (bool newValue) {
    if (newValue) {
      _clockTick(null);
      input.classes.add(C_INPUT_HAS_DOCK);
      _dock.classes.remove(LVisibility.C_HIDE);
      if (_clockTimer == null) {
        int ms = new DateTime.now().millisecond;
        _clockTimer = new Timer(new Duration(milliseconds: 1000 - ms), () {
          _clockTimer =
          new Timer.periodic(new Duration(seconds: 1), _clockTick);
        });
      }
    } else {
      _dock.classes.add(LVisibility.C_HIDE);
      input.classes.remove(C_INPUT_HAS_DOCK);
      if (_clockTimer != null) {
        _clockTimer.cancel();
        _clockTimer = null;
      }
    }
  }
  Timer _clockTimer;

  /// Tick - Update display
  void _clockTick(Timer timer) {
    DateTime dt = new DateTime.now();
    TZ tz = valueAsTz;
    if (tz == null) {
      _dock.text = ClientEnv.dateFormat_hms.format(dt);
    } else {
      _dock.text = ClientEnv.dateFormat_hms.format(dt.subtract(tz.delta));
    }
  } // _clockTick


  //
  static String lLookupTimezoneTimeTitle() => Intl.message("Time in selected Timezone", name: "lLookupTimezoneTimeTitle");

} // LLookupTimezone


/**
 * TZ Lookup Item
 */
class LLookupTimezoneItem
    extends LLookupItem {

  /// TZ Lookup Item
  LLookupTimezoneItem(TZ tz) : super(tz.asOption()) {
    reference = tz;
  }

  /// Get TimeZone
  TZ get tz {
    return reference as TZ;
  }

} // LLookupTimezoneItem
