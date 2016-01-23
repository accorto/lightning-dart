/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_model;

/// Client Context (Session)
Map<String, dynamic> clientContext = new Map<String, dynamic>();

/**
 * Handles Client Environment
 * - locale, language, formats
 * - Session, Role
 * - Context
 */
class ClientEnv {

  static final Logger _log = new Logger("ClientEnv");

  /** Locale Name */
  static String localeName = "en_US";
  /** Locale Name */
  static String language = "en";
  /** Time Zone */
  static TZ timeZone;

  /** Development/Test Mode */
  static bool testMode = false;

  /// Client Context (Session)
  static final Map<String, dynamic> ctx = new Map<String, dynamic>();
  /** System Session */
  static Session _session;

  /// Date Format Short - 1/1/2005
  static DateFormat dateFormat_ymd;
  /// Date Format Short -  1/1
  static DateFormat dateFormat_md;
  /// Date Format Short -  1/1 01:01
  static DateFormat dateFormat_md_hm;
  /// Date Format - Mon 1/1
  static DateFormat dateFormat_med;
  /// Date Format Long - Monday, January 1
  static DateFormat dateFormat_long;
  /// Date Format Short - 1/2005
  static DateFormat dateFormat_ym;
  /// Date Format Short - 1/2005
  static DateFormat dateFormat_yq;
  /// Time Format 01:01
  static DateFormat dateFormat_hm;
  /// Time Format 01:01:01
  static DateFormat dateFormat_hms;
  /// DateTime Format Short - 1/1/2005 01:01
  static DateFormat dateFormat_ymd_hm;
  /// Integer
  static NumberFormat numberFormat_int;
  /// Number with one decimals
  static NumberFormat numberFormat_1;
  /// Number with two decimals
  static NumberFormat numberFormat_2;

  /**
   * Initialize locale, Intl, Date
   * - called from LightningDart.init()
   */
  static Future<bool> init() {
    localeName = window.navigator.language;
    Settings.init();
    Completer<bool> completer = new Completer<bool>();
    findSystemLocale()
    .then((String locale) {
      localeName = locale;
      // localeName = "fr_BE";
      // Intl.systemLocale = localeName;
      Intl.defaultLocale = localeName;
      //
      language = locale;
      int index = language.indexOf("_");
      if (index > 0)
        language = language.substring(0, index);
      //
      return initializeDateFormatting(locale, null);
    })
    .then((_){
      return initializeMessages(language); // BaseMessages
    })
    .then((_){
      initializeFormats();
      Screen scr = window.screen;
      Navigator nav = window.navigator;
      // second log
      _log.info("locale=${localeName} language=${language} nav_lang=${nav.language}"
          " formats=[${dateFormat_ymd.pattern} - ${dateFormat_hms.pattern} - ${dateFormat_ymd_hm.pattern}]"
          " screen=${scr.width}x${scr.height}_${scr.pixelDepth}"
          " window=${window.innerWidth}x${window.innerHeight}"
          " platform=${nav.platform}"
          " cookie=${nav.cookieEnabled} doNotTrack=${nav.doNotTrack}"
          " browser=${nav.appName} nav_version=${nav.appVersion}"
      // 'ua': nav.userAgent
      );
      completer.complete(true);
    })
    .catchError((error, stackTrace) {
      _log.warning("locale=${localeName} language=${language}", error, stackTrace);
      completer.completeError(error, stackTrace);
    });
    return completer.future;
  } // init

  /// initialize date and number formats using [localeName]
  static void initializeFormats() {
    dateFormat_ymd = new DateFormat.yMd(localeName);
    dateFormat_md = new DateFormat.Md(localeName);
    dateFormat_md_hm = new DateFormat.Md(localeName);
    dateFormat_med = new DateFormat.MEd(localeName);
    dateFormat_long = new DateFormat.MMMMEEEEd(localeName);
    dateFormat_ym = new DateFormat.yM(localeName);
    dateFormat_yq = new DateFormat.yQQQ(localeName);
    dateFormat_hm = new DateFormat.Hm(localeName);
    dateFormat_hms = new DateFormat.Hms(localeName);
    dateFormat_ymd_hm = new DateFormat.yMd(localeName);
    if (language == "en") { // fix
      if (!dateFormat_hm.pattern.toString().contains("a")) {
        dateFormat_hm = new DateFormat("K:mm a", localeName);
        dateFormat_hms = new DateFormat("K:mm:ss a", localeName);
        dateFormat_ymd_hm.addPattern("K:mm a");
        dateFormat_md_hm.addPattern("K:mm a");
      } else {
        dateFormat_ymd_hm.add_Hm();
        dateFormat_md_hm.add_Hm();
      }
    }
    numberFormat_int = new NumberFormat("#,###,##0", localeName);
    numberFormat_int.minimumFractionDigits = 0;
    numberFormat_int.maximumFractionDigits = 0;
    numberFormat_1 = new NumberFormat("#,###,##0.0", localeName);
    numberFormat_1.minimumFractionDigits = 1;
    numberFormat_1.maximumFractionDigits = 1;
    numberFormat_2 = new NumberFormat("#,###,##0.00", localeName);
    numberFormat_2.minimumFractionDigits = 2;
    numberFormat_2.maximumFractionDigits = 2;
  }

  /// User Agent mobile (main only)
  static bool get isMobileUserAgent {
    String ua = window.navigator.userAgent;
    return ua.contains(_mobilePattern);
  }
  /// http://detectmobilebrowsers.com/
  static RegExp _mobilePattern = new RegExp(r'(phone|pad|pod|android|mobile)', caseSensitive:false);
  /// Phone (based on size)
  static bool get isPhone {
    // http://www.paintcodeapp.com/news/ultimate-guide-to-iphone-resolutions
    String ua = window.navigator.userAgent;
    return ua.contains(_phonePattern);
  }
  static RegExp _phonePattern = new RegExp(r'(phone|pod|android|mobile)', caseSensitive:false);

  /// is this in an iframe
  static bool get inIFrame {
    try {
      return window.top != window.self;
    } catch (ex) {
      return true;
    }
  }

  /// Next Window Number
  static int get windowNo {
    return _windowNo++;
  }
  static int _windowNo = 1;

  /**
   * Add Context to Log
   */
  static void logInfoMap(Map<String,dynamic> map) {
    if (_session != null) {
      if (_session.hasTenantName())
        map["tenantName"] = _session.tenantName;
      else if (_session.hasTenantId())
        map["tenantId"] = _session.tenantId;
      if (_session.hasUserEmail())
        map["userEmail"] = _session.userEmail;
      else if (_session.hasUserId())
        map["userId"] = _session.userId;
      if (_session.hasSid())
        map["sid"] = _session.sid;
    }
    // map["clientId"] = Service.clientId;
    // map["clientHref"] = window.location.href;

    // analytics
    // if (document.referrer != null && document.referrer.isNotEmpty)
    //   map["dr"] = document.referrer;
  } // addToLogRecord

  /// Log Context Info
  static String logInfo(String prefix) {
    if (session == null)
      return "";
    String retValue = prefix;
    if (_session.hasSid())
      retValue += " sid=${_session.sid}";
    if (_session.hasTenantName())
      retValue += " tenantName=${_session.tenantName}";
    else if (_session.hasTenantId())
      retValue += " tenantId=${_session.tenantId}";
    if (_session.hasUserEmail())
      retValue += " userEmail=${_session.userEmail}";
    else if (_session.hasUserId())
      retValue += " userId=${_session.userId}";
    return retValue;
  } // logInfo

  // logged in
  static bool isLoggedIn() {
    return _session != null && _session.sid != null && _session.sid.isNotEmpty;
  }

  /// Session
  static Session get session => _session;
  static void set session (Session value) {
    _session = value;
    ctx['isDecimalPoint'] = value.isDecimalPoint;
    ctx['isTenantMultiCurrency'] = value.isTenantMultiCurrency;
    ctx['isTenantSystem'] = value.isTenantSystem;
    ctx['isUserExpert'] = value.isUserExpert;
    if (value.hasIsUserExpert())
      Settings.set(Settings.EXPERT_MODE, value.isUserExpert, saveToPreferences: true);

    ctx['languageIsoCode'] = value.languageIsoCode;
    ctx['sid'] = value.sid;
    ctx['tenantId'] = value.tenantId;
    ctx['AD_Tenant_ID'] = value.tenantId;
    ctx['tenantName'] = value.tenantName;
    ctx['timeZone'] = value.timeZone;

    ctx['userEmail'] = value.userEmail;
    ctx['userFullName'] = value.userFullName;
    ctx['userId'] = value.userId;
    ctx['AD_User_ID'] = value.userId;
    ctx['userName'] = value.userName;
    ctx['resourceId'] = value.userResourceId;

    // copy context from server
    for (DKeyValue nv in value.contextList) {
      ctx[nv.key] = nv.value;
    }
  } // setSession

  /// logout
  static void logout() {
    _session = null;
  }

  /// User Name
  static String userName() {
    String name = _session.userFullName;
    if (name == null || name.isEmpty)
      name = _session.userEmail;
    if (name == null || name.isEmpty)
      name = _session.userName;
    return name;
  }

  /**
   * Get Short Date/Time Formats
   */
  static DateFormat getDateFormat(DataType dt) {
    if (dt == DataType.DATE)
      return dateFormat_ymd;
    if (dt == DataType.TIME)
      return dateFormat_hm;
    return dateFormat_ymd_hm;
  }

  /**
   * Get Number Formats - int or 2 decimal
   */
  static NumberFormat getNumberFormat(DataType dt) {
    if (dt == DataType.INT || dt == DataType.RATING)
      return numberFormat_int;
    return numberFormat_2;
  }

  /// Format Date
  static String formatDate64(Int64 ms) {
    if (ms == null)
      return "";
    return formatDateMs(ms.toInt());
  }
  /// Format Date
  static String formatDateMs(int ms) {
    if (ms == 0)
      return "";
    return formatDate(new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true));
  }
  /// Format Date ymd
  static String formatDate(DateTime date) {
    if (date == null)
      return "";
    if (dateFormat_ymd == null) {
      return new DateFormat.yMd().format(date);
    }
    return dateFormat_ymd.format(date);
  }

  /// Format Date ym
  static String formatMonth(DateTime date) {
    if (date == null)
      return "";
    if (dateFormat_ym == null) {
      return new DateFormat.yM().format(date);
    }
    return dateFormat_ym.format(date);
  }

  /// Format Date ym
  static String formatQuarter(DateTime date) {
    if (date == null)
      return "";
    if (dateFormat_yq == null) {
      return new DateFormat.yQQQ().format(date);
    }
    return dateFormat_yq.format(date);
  }

  /// Format Date Time
  static String formatDateTime64(Int64 ms) {
    if (ms == null)
      return "";
    return formatDateTimeMs(ms.toInt());
  }
  /// Format Date Time
  static String formatDateTimeMs(int ms) {
    if (ms == 0)
      return "";
    return formatDateTime(new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: false));
  }
  /// Format Date Time
  static String formatDateTime(DateTime dateTime) {
    if (dateTime == null)
      return "";
    if (dateFormat_ymd_hm == null) {
      return new DateFormat.yMd().add_Hm().format(dateTime);
    }
    return dateFormat_ymd_hm.format(dateTime);
  }

  /// Format Time
  static String formatTime64(Int64 ms) {
    if (ms == null)
      return "";
    return formatTimeMs(ms.toInt());
  }
  /// Format Time
  static String formatTimeMs(int ms) {
    if (ms == 0)
      return "";
    return formatTime(new DateTime.fromMillisecondsSinceEpoch(ms, isUtc: false));
  }
  /// Format Time
  static String formatTime(DateTime time) {
    if (time == null)
      return "";
    if (dateFormat_hm == null) {
      return new DateFormat.Hm().format(time);
    }
    return dateFormat_hm.format(time);
  }

  /// Items in session to ignore
  static final List<String> sessionConfidential = ["context", "awsSecretKey",
    "tenantLogo", "customCss", "sfToken"];

  /**
   * Get Context Value
   */
  static String contextValue(String varName) {
    if (varName == null || varName.isEmpty) {
      return null;
    }
    var ctxValue = ctx[varName];
    if (ctxValue != null) {
      return ctxValue.toString();
    }
    // Date
    if (varName == "now") {
      return new DateTime.now().millisecondsSinceEpoch.toString();
    }
    if (varName == "today") {
      DateTime now = new DateTime.now().toUtc();
      DateTime today = new DateTime.utc(now.year, now.month, now.day);
      return today.millisecondsSinceEpoch.toString();
    }
    _log.warning("contextValue ${varName}");
    return null;
  }

  /**
   * Get SF Server URL or null
   */
  static String getSfServerUrl(String sfHref) {
    // https://na6.salesforce.com/services/Soap/u/31.0/...
    if (session != null && session.hasSfEndpoint()) {
      String href = session.sfEndpoint;
      int index = href.indexOf("services/");
      if (index != -1)
        return href.substring(0, index) // leave /
          + sfHref;
    }
    return null;
  }

  /// running on IE or Edge
  static bool get isIE {
    if (_isIE11 == null) {
      String ua = window.navigator.userAgent;
      _isIE = ua.contains(new RegExp(r'Edge|Trident|MSIE'));
      _log.fine("isIE");
    }
    return _isIE;
  }
  static bool _isIE;
  /// running IE 11 or older
  static bool get isIE11 {
    if (_isIE11 == null) {
      String ua = window.navigator.userAgent;
      _isIE11 = ua.contains(new RegExp(r'Trident|MSIE'));
      _log.fine("isIE11");
    }
    return _isIE11;
  }
  static bool _isIE11;


} // ClientEnv
