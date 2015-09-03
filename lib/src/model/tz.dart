/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_model;


/** **
 * Time Zone Entry
 */
class TZ {

  static final Logger _log = new Logger("TZ");


  /// List of Json TimeZones
  static List tzList;

  /// find time zones with same offset (now)
  static List<TZ> findTimeZones() {
    List<TZ> list = new List<TZ>();
    if (tzList == null) {
      _log.warning("findTimeZones - NoTzList");
      return list;
    }
    DateTime now = new DateTime.now();
    int offset = now.timeZoneOffset.inMilliseconds;
    for (var tzJson in tzList) {
      if (tzJson["o"] == offset) {
        list.add(new TZ(tzJson));
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
    for (var tzJson in tzList) {
      if (tzJson["id"] == tzId) {
        return new TZ(tzJson);
      }
    }
    return null;
  } // findTimeZone


  /// Local Offset
  static Duration localOffset = new DateTime.now().timeZoneOffset;

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

  /// update Example
  //@override
  //void exampleUpdate() {
  //  example = timeString(EditorTimezone._now);
  //}

  toString() => json.toString();
} // TZ



/** **
 * Time Zone References - convert to Locations
 */
class TzRef {

  static final Logger _log = new Logger("TzRef");

  /// Get TimeZone - check alias
  static String alias (String tzName) {
    if (tzName == null || tzName.isEmpty)
      return tzName;
    //
    if (_refs.isEmpty)
      _buildTzRef();
    for (TzRef ref in _refs) {
      if (ref.aliasList.contains(tzName))
        return ref.tzId;
    }
    return tzName;
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
