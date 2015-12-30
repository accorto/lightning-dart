/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;


/**
 * Time Zone Entry
 * {"id":"America/Los_Angeles","name":"Pacific Standard Time","s":-28800000,"d":-25200000,"o":-28800000}
 */
class TZ {

  static final Logger _log = new Logger("TZ");


  /// List of Json TimeZones
  static List tzListJson; // loaded from Timezone.init()

  /// Timezone List
  static List<TZ> get tzList {
    if (_tzList == null) {
      if (tzListJson == null) {
        return null;
      }
      _tzList = new List<TZ>();
      for (var tzJson in tzListJson) {
        TZ tz = new TZ(tzJson);
        _tzList.add(tz);
      }
    }
    return _tzList;
  }
  static List<TZ> _tzList;

  /// Map id-label - or null
  static Map<String,String> get tzMap {
    if (_tzMap == null) {
      if (tzList == null) {
        return null;
      }
      _tzMap = new Map<String,String>();
      for (TZ tz in tzList) {
        _tzMap[tz.id] = tz.label;
      }
    }
    return _tzMap;
  }
  static Map<String,String> _tzMap;

  /// find time zones with same offset (now)
  static List<TZ> findTimeZones() {
    List<TZ> list = new List<TZ>();
    if (tzList == null) {
      _log.warning("findTimeZones - NoTzList");
      return list;
    }
    DateTime now = new DateTime.now();
    int offset = now.timeZoneOffset.inMilliseconds;
    for (TZ tz in tzList) {
      if (tz.offset == offset) {
        list.add(tz);
      }
    }
    return list;
  }

  /// find time zone with [tzId]
  static TZ findTimeZone(String tzId) {
    if (tzList == null) {
      _log.warning("findTimeZone - NoTzList");
      return null;
    }
    for (TZ tz in tzList) {
      if (tz.id == tzId) {
        return tz;
      }
    }
    return null;
  } // findTimeZone

  /// Local Offset
  static Duration localOffset = new DateTime.now().timeZoneOffset;

  /// Fallback
  static TZ get fallback {
    DateTime now = new DateTime.now();
    var data = {};
    data["id"] = now.timeZoneName;
    data["name"] = "default";
    int offsetMs = now.timeZoneOffset.inMilliseconds;
    data["s"] = offsetMs;
    data["d"] = offsetMs;
    data["o"] = offsetMs;
    return new TZ(data);
  }


  // source
  var json;
  /// delta to local time
  Duration delta;

  /**
   * TimeZone
   */
  TZ(var this.json) {
    int dd = localOffset.inMilliseconds;
    dd -= offset; // now
    delta = new Duration(milliseconds: dd);
  }

  /// TimeZone Id
  String get id => json["id"];
  String get name => json["name"];
  /// offset standard time (ms)
  int get std => json["s"];
  /// offset daylight time (ms)
  int get day => json["d"];
  /// offset (ms)
  int get offset => json["o"]; // now
  /// currently daylight
  bool get dayLight => day == offset;

  /**
   * Format Time based on delta
   */
  String timeString(DateTime dt) {
    return ClientEnv.dateFormat_hm.format(dt.subtract(delta));
  }

  /// Label
  String get label => "${id} (${name})";

  /// TZ as Option
  DOption asOption() {
    DOption option = new DOption()
      ..value = id
      ..label = label;
    return option;
  }

  String toString() => json.toString();

} // TZ



/** **
 * Time Zone References - convert to Locations
 */
class TzRef {

  static final Logger _log = new Logger("TzRef");

  /// Get TimeZone - check alias
  static String alias (String tzName) {
    if (tzName == null || tzName.isEmpty)
      return null;
    //
    if (_refs.isEmpty)
      _buildTzRef();
    for (TzRef ref in _refs) {
      if (ref.aliasList.contains(tzName))
        return ref.tzId;
    }
    return null;
  }

  /// Get TimeZone - check offset
  static String offset (Duration delta, String tzName) {
    if (delta == null)
      return null;
    //
    if (_refs.isEmpty)
      _buildTzRef();

    String tzIdS = null;
    String tzIdD = null;
    for (TzRef ref in _refs) {
      if (ref.offsetDurationS == delta)
        tzIdS = ref.tzId;
      if (ref.offsetDurationD == delta)
        tzIdD = ref.tzId;
    }
    // http://en.wikipedia.org/wiki/Daylight_saving_time_in_the_United_States
    // 2015 Mar 8 - Nov 1
    // 2016 Mar 13 - Nov 2
    // Europe: last sunday Mar - last sunday Oct
    // 2015 Mar 29 - Oct 25
    // 2016 Mar 27 - Oct 30

    if (tzIdD != null) {
      TZ tz = TZ.findTimeZone(tzIdD);
      if (tz != null && tz.dayLight && tz.day == delta.inMilliseconds)
        return tz.id;
      _log.warning("NoMatch Day ${tzName} - ${tzIdD} - delta=${delta} - ${tz}");
    }
    if (tzIdS != null) {
      TZ tz = TZ.findTimeZone(tzIdS);
      if (tz != null && !tz.dayLight && tz.std == delta.inMilliseconds)
        return tz.id;
      _log.warning("NoMatch Std ${tzName} - ${tzIdD} - delta=${delta} - ${tz}");
    }
    if (tzIdD != null)
      return tzIdD;
    return tzIdS;
  } // offset


  /// The references
  static List<TzRef> _refs = new List<TzRef>();
  /// add reference list
  static void _buildTzRef() {
    // -7
    _refs.add(new TzRef("America/Los_Angeles", ["PST", "PDT", "Pacific Standard Time", "Pacific Daylight Time"], -28800000, -25200000));
    // -6
    _refs.add(new TzRef("America/Denver", ["MST", "MDT", "Mountain Standard Time", "Mountain Daylight Time"], -25200000, -21600000));
    // -5
    _refs.add(new TzRef("America/Chicago", ["CST", "CDT", "Central Standard Time", "Central Daylight Time"], -21600000, -18000000));
    // -4
    _refs.add(new TzRef("America/New_York", ["EST", "EDT", "Eastern Standard Time", "Eastern Daylight Time"], -18000000, -14400000));
    // 0
    _refs.add(new TzRef("UTC", ["UCT", "Zulu", "Coordinated Universal Time"], -1, -1));
    // +1
    _refs.add(new TzRef("Europe/London", ["GMT", "Greenwich Mean Time"], 0, 3600000));
    // +2
    _refs.add(new TzRef("Europe/Paris", ["CET", "CEST", "Central European Time", "Central European Summer Time"], 3600000, 7200000));
    // +3
    _refs.add(new TzRef("Europe/Helsinki", ["EET", "EEST", "Eastern European Time", "Eastern European Summer Time"], 7200000, 10800000));
  }

  final String tzId;
  final List<String> aliasList;
  // Standard
  final int offsetMsS;
  Duration offsetDurationS;
  // Daylight
  int offsetMsD;
  Duration offsetDurationD;

  /// [offsetMsS] standard time !
  TzRef(String this.tzId, List<String> this.aliasList, int this.offsetMsS, int this.offsetMsD){
    offsetDurationS = new Duration(milliseconds: offsetMsS);
    offsetDurationD = new Duration(milliseconds: offsetMsD);
  }

} // TzRef
