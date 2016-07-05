/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/// go to path return false if reject
typedef bool RouteEventHandler(RouterPath path);

/**
 * Application Router [LightningCtrl.router]
 * Handles query parameters
 * and hierarchical path, e.g. /key/value/key2/value2
 * path could be direct or as  #key/value/key2/value2
 */
class Router {

  /// (Javascript LINIT) Parameter
  static const String P_SERVERURI = "serverUri";
  static const String P_CNAME = "cname";
  /// loadDiv - id
  static const String P_LOADDIV = "loadDiv";
  /// clear container - true|(false)
  static const String P_CLEARCONTAINER = "clearContainer";
  /// add header - (true)|false
  static const String P_ADDHEADER = "addHeader";
  /// clear container - (true)|false
  static const String P_ADDNAV = "addNav";
  static const String P_THEME = "theme";
  /// test mode - true|(false)
  static const String P_TEST = "test";

  /**
   * Parse Query Parameter String to Map
   */
  static Map<String, String> queryParamsFrom(String query) {
    Map<String,String> result = new Map<String,String>();
    if (query == null || query.isEmpty)
      return result;
    // beginning ? in query strings.
    if (query.startsWith('?') || query.startsWith('#'))
      query = query.substring(1);

    RegExp search = new RegExp('([^&=]+)=?([^&]*)');
    decode(String s) => Uri.decodeComponent(s.replaceAll('+', ' '));

    for (Match match in search.allMatches(query)) {
      String key = decode(match.group(1));
      String value = decode(match.group(2));
      result[key] = value;
    }
    return result;
  } //queryParams


  /** Direct URV separator */
  static const String URV_ID = "!"; // other options: ~*. - see DtoUtil
  /// Navigation Path Id (vs. urvRest) Prefix
  static const String PATH_ID_PREFIX = "!"; // options: !~*-.
  /// Navigation Path to use Id
  static bool PATH_ID = false;
  /// Clean Path Prefix /|#
  static final RegExp cleanPathPrefix = new RegExp(r"[/|#]");

  // Logging
  static Logger _log = new Logger("Router");

  /// Query Parameter
  Map<String, String> queryParams;
  // Fragments
  final bool useHash;
  // Default Route
  Route defaultRoute;
  /// Router Path
  final RouterPath routerPath = new RouterPath();
  /// initial window.location.href
  String initialHref;
  /// initial path list
  List<String> initialPathList = new List<String>();
  /// Google Analytics
  Analytics ga;

  // Routes
  final List<Route> _routeList = new List<Route>();
  /// Base URL
  String _baseUrl = "";
  /// current Path
  String _currentPath;
  /// current Path move time
  DateTime _currentPathTime;
  /// started
  StreamSubscription<Event> _hashChangeSubscription;

  /// Fall back handler in case route has no handler
  RouteEventHandler fallbackHandler;

  /**
   * Router - call start
   */
  Router({bool this.useHash: true}) {
    // location = protocol://host:port/pathname?search#hash
    // _log.log(Level.CONFIG, "href=${window.location.href} pathname=${window.location.pathname} search=${window.location.search} hash=${window.location.hash}");
    // _log.log(Level.FINE, "origin=${window.location.origin} referrer=${document.referrer}");
    initialHref = window.location.href;
    _init(initialHref, window.location.pathname, window.location.search, window.location.hash);
  } // Router

  /// initialize
  void _init(String href, String path, String search, String hash) {
    // encoded ?=#/&_ -> %3F %3D %23 %2F %26 %20

    // http://bizbase.s3-website-us-east-1.amazonaws.com/demo.html?a=b#c/5
    // href=http://bizbase.s3-website-us-east-1.amazonaws.com/demo.html?a=b#c/d pathname=/demo.html search=?a=b hash=#c/d
    // baseUrl=http://bizbase.s3-website-us-east-1.amazonaws.com/ paths=[c, d] params={a: b}

    // base url e.g. http://localhost:63342/
    _baseUrl = href;
    int index = _baseUrl.indexOf("/", 10);
    if (index != -1) {
      _baseUrl = _baseUrl.substring(0, index + 1);
    } else {
      _baseUrl += '/';
    }

    // initial path
    String initialPath = useHash ? hash : "${path}${hash}";
    if (initialPath != null && initialPath.isNotEmpty) {
      initialPath = cleanPath(initialPath, addPrefix: false);
      if (initialPath.isNotEmpty)
        initialPathList.add(initialPath);
    }

    // Parameters
    queryParams = queryParamsFrom(search);
    Map<String, String> hashParams = queryParamsFrom(hash);
    if (hashParams.length > 0) {
      queryParams.addAll(hashParams);
    }
    _loadConfig();
    // paths
    //List<String> pp = RouterPath.getPathElements(path+hash);
    // _log.log(Level.INFO, "baseUrl=${_baseUrl} paths=${pp} params=${queryParams}");
  } // init

  /// load Javascript Config - query parameters overwrite!
  void _loadConfig() {
    // LINIT={cname: "accorto", serverUri: "https://accorto.bizquando.com/", loadDiv: "quando", clearContainer: "true", addHeader: "false", addNav: "false", test: "false"};
    JsObject config = context['LINIT'];
    if (config != null) {
      if (!queryParams.containsKey(P_CNAME) && config.hasProperty(P_CNAME)) {
        queryParams[P_CNAME] = config[P_CNAME];
      }
      if (!queryParams.containsKey(P_SERVERURI) && config.hasProperty(P_SERVERURI)) {
        queryParams[P_SERVERURI] = config[P_SERVERURI];
      }
      if (!queryParams.containsKey(P_LOADDIV) && config.hasProperty(P_LOADDIV)) {
        queryParams[P_LOADDIV] = config[P_LOADDIV];
      }
      if (!queryParams.containsKey(P_CLEARCONTAINER) && config.hasProperty(P_CLEARCONTAINER)) {
        queryParams[P_CLEARCONTAINER] = config[P_CLEARCONTAINER];
      }
      if (!queryParams.containsKey(P_ADDHEADER) && config.hasProperty(P_ADDHEADER)) {
        queryParams[P_ADDHEADER] = config[P_ADDHEADER];
      }
      if (!queryParams.containsKey(P_ADDNAV) && config.hasProperty(P_ADDNAV)) {
        queryParams[P_ADDNAV] = config[P_ADDNAV];
      }
      if (!queryParams.containsKey(P_THEME) && config.hasProperty(P_THEME)) {
        queryParams[P_THEME] = config[P_THEME];
      }
      if (!queryParams.containsKey(P_TEST) && config.hasProperty(P_TEST)) {
        queryParams[P_TEST] = config[P_TEST];
      }
    }
    if (queryParams[P_TEST] == "true") {
      ClientEnv.logLevel = Level.ALL;
    }
  } // loadConfig
  /// Embedded - use ServerUti
  bool get embedded => context['LINIT'] != null;

  /**
   * Start listening (call route(null) to go to url)
   * - Called By AppsMain.set(AppsCtrl)
   * - calls route
   */
  void start() {
    if (_hashChangeSubscription == null) {
      _hashChangeSubscription = window.onHashChange.listen((_) {
        String path = window.location.hash;
        // #p2
        _log.log(Level.CONFIG, "onHashChange ${path} - ${window.location.href}");
        route(path);
      });

      window.onPopState.listen((_) {
        String path = '${window.location.pathname}${window.location.hash}';
        // /components.html#p2
        if (useHash) {
          //  path = window.location.hash;
          _log.log(Level.CONFIG, "onPopState ${path} - ${window.location.href}");
          //  route(path); // duplicate
        } else {
          _log.log(Level.CONFIG, "onPopState ${path} - ${window.location.href}");
          route(path);
        }
      });
      route(null);
    }
  } // start

  /// (Server) base URL ending with /
  String get baseUrl => _baseUrl;
  /// Localhost (testing)
  bool get isLocalhost {
    return _baseUrl != null && _baseUrl.contains("localhost");
  }

  /**
   * Get current Path elements from path and #fragment
   */
  List<String> get paths => RouterPath.getPathElements("${window.location.pathname}${window.location.hash}");

  /**
   * Add Route with [name] and [path] without starting / or #
   */
  void addRoute({String name, String path, String title,
      RouteEventHandler enter,
      bool defaultRoute:false}) {
    path = cleanPath(path, addPrefix: false);
    for (Route rr in _routeList) {
      if (rr.name == name || rr.path == path) {
        _log.warning("addRoute name=${name} path=${path} - already exists: ${rr}");
      }
    }
    Route route = new Route(name, path, title, enter);
    _routeList.add(route);
    if (defaultRoute)
      this.defaultRoute = route;
  } // addRoute

  /// Get Route with [name]
  Route findRouteWithName(String name) {
    for (Route r in _routeList) {
      if (name == r.name) {
        return r;
      }
    }
    return null;
  }
  /// Get Route with [path]
  Route findRouteWithPath(String path) {
    for (Route r in _routeList) {
      if (path == r.path) {
        return r;
      }
    }
    return null;
  }

  /**
   * Set Default Route - return true if found
   */
  bool setDefaultRoute(String name) {
    Route r = findRouteWithName(name);
    if (r != null) {
      defaultRoute = r;
      return true;
    }
    return false;
  } // setDefaultRoute

  /**
   * Get path parameter or query parameter with [key]
   */
  String param(String key) {
    if (key == null || key.isEmpty)
      return null;
    String value = routerPath.get(key);
    if (value != null && value.isNotEmpty)
      return value;
    return queryParams[key];
  }
  /// does the parameter or query parameter with [key] exist?
  bool hasParam(String key) {
    if (key == null || key.isEmpty)
      return false;
    String value = routerPath.get(key);
    if (value != null && value.isNotEmpty)
      return true;
    return queryParams.containsKey(key);
  }

  /**
   * Find route with matching [path] initial path or default
   * - return false if not routed or null if "stay there"
   */
  bool route(final String path) {
    String thePath = path;
    // Path from initial list
    if (path == null && initialPathList.isNotEmpty) {
      thePath = initialPathList.removeLast();
      List<String> pathList = RouterPath.getPathElements(thePath);
      for (String path in RouterPath.getPathElements(thePath)) {
        Route route = findRouteWithPath(path);
        if (route == null) {
          pathList.removeAt(0);
        } else {
          routerPath.setRoutePath(route, paths: pathList);
          bool result = go();
          if (result == null || result)
            return result;
        }
      }
    }
    thePath = cleanPath(thePath, addPrefix: false);
    // find route
    if (thePath.isNotEmpty) {
      // Pattern pattern = new RegExp(thePath);
      for (Route r in _routeList) {
        if (thePath.startsWith(r.path)) {
          routerPath.setRoutePath(r, path: thePath);
          bool result = go();
          if (result == null || result)
            return result;
        }
      }
    }
    if (defaultRoute != null) {
      routerPath.setRoutePath(defaultRoute, path: thePath);
      return go();
    }
    return false;
  } // route

  /**
   * GoTo route [routeName] with optional [value] and [map]
   * - return false if not found or rejected or full if "stay there"
   */
  bool goto(String routeName, {String value, Map<String,String> map}) {
    Route r = findRouteWithName(routeName);
    if (r != null) {
      routerPath.setRoute(r, value: value, map: map);
      return go();
    }
    _log.log(Level.CONFIG, "goto ${routeName} not found");
    return false;
  } // goto

  /**
   * Go to [routerPath] - return false if rejected or null if "stay there"
   */
  bool go () {
    String thePath = routerPath.toPath();
    if (routerPath.handler == null) {
      if (fallbackHandler == null) {
        _log.log(Level.CONFIG, "go NoHandler for ${routerPath.route} path=${thePath}");
        return false;
      }
      routerPath.route.handler = fallbackHandler;
      _log.log(Level.CONFIG, "go FallbackHandler for ${routerPath.route} path=${thePath}");
    } else {
      _log.log(Level.CONFIG, "go ${routerPath.route} path=${thePath}");
    }
    bool result = routerPath.handler(routerPath); // might return null
    if (result != null && result) {
      updateWindow(thePath, routerPath.title);
      if (ga != null) {
        ga.setSessionValue("dt", routerPath.title); // DocumentTitle
        ga.sendScreenView(thePath);
      }
      //
      DateTime now = new DateTime.now();
      ServiceAnalytics.sendPage(now, thePath, _currentPath, _currentPathTime);
      _currentPath = thePath;
      _currentPathTime = now;
    }
    return result;
  } // go

  /**
   * Set Window Directly via route [name]
   * [clean] removes parameter if [replace]
   */
  void set(String name, {bool replace: false, bool clean: false}) {
    for (Route r in _routeList) {
      if (name == r.name) {
        updateWindow(r.path, r.title, replace: replace, clean: clean);
        initialPathList.add(r.path);
        return;
      }
    }
    _log.log(Level.CONFIG, "set ${name} not found");
  } // set

  /**
   * Clean path (no /#)
   */
  String cleanPath(String path, {bool addPrefix: true}) {
    String thePath = path;
    if (thePath == null || thePath.isEmpty) {
      thePath = "";
    } else {
      while (thePath.startsWith(cleanPathPrefix)) { // /#
        thePath = thePath.substring(1);
      }
    }
    if (addPrefix) {
      return (useHash ? "#/" : "/") + thePath;
    }
    return thePath;
  } // cleanPath

  /**
   * Update Window directly
   * [clean] removes parameter if [replace]
   */
  void updateWindow(String path, String title, {bool replace: false, bool clean: false}) {
    String thePath = cleanPath(path, addPrefix: true);

    String theTitle = title;
    if (title != null && title.isNotEmpty) {
      if (ClientEnv.session != null && ClientEnv.session.hasTenantName()) {
        theTitle = "${title} - ${ClientEnv.session.tenantName} | ${LightningCtrl.productLabel}";
      } else {
        theTitle = "${title} | ${LightningCtrl.productLabel}";
      }
    }
    document.title = theTitle;
    String href = window.location.href;
    int pos = href.indexOf("?");
    if (pos > 0) {
      _log.warning("updateWindow href=${href} path=${path}");
    }

    if (replace) {
      if (clean) {
        if (pos > 0)
          href = href.substring(0, pos);
        pos = href.indexOf("#");
        if (pos > 0)
          href = href.substring(0, pos);
        href += thePath;
        window.history.replaceState(null, theTitle, href);
      } else {
        window.history.replaceState(null, theTitle, thePath);
      }
    } else {
      window.history.pushState(null, theTitle, thePath);
    }
  } // updateWindow

  /// href for [urv]
  String hrefFromUrv(String urv) {
    if (useHash)
      return "#${urv}";
    return urv;
  }
  /// href for table name with id
  String hrefFromTableId(String tableName, var id) {
    if (useHash)
      return "#${tableName}${URV_ID}${id}";
    return "${tableName}${URV_ID}${id}";
  }
  /// href from [record]
  String hrefFromDRecord (DRecord record) {
    if (record == null)
      return "#";
    return hrefFromTableId(record.tableName, record.recordId);
  }
  /// href from [fk]
  String hrefFromDFK (DFK fk) {
    if (fk == null)
      return "#";
    return hrefFromTableId(fk.tableName, fk.id);
  }
  /// href from Recent
  String hrefFromRecent(Recent recent) {
    if (recent == null)
      return "#";
    return hrefFromTableId(recent.recentType, recent.recordId);
  }

  String toString() {
    return "Router useHash=${useHash} embedded=${embedded} initialHref=${initialHref} "
        " baseUrl=${_baseUrl} queryParams=${queryParams}"
        " currentPath=${_currentPath}" // currentPathTime=${_currentPathTime}""
        " routes=#${_routeList.length}"
        " [${routerPath}]";
  }


  /********************************************************
   * Get Cookie with [name] or null
   * "--" is interpreted as null
   * https://developer.mozilla.org/en-US/docs/Web/API/document.cookie
   * http://www.ietf.org/rfc/rfc2965.txt
   */
  static String cookieGet(final String name) {
    String cookieString = document.cookie;
    if (cookieString == null || cookieString.isEmpty || name == null || name.isEmpty)
      return null;
    List<String> cookies = cookieString.split('; ');
    for (String cookie in cookies) {
      List<String> parts = cookie.split('=');
      if (parts.length >= 2) {
        String cookieName = Uri.decodeComponent(parts[0].replaceAll(r"\+", " "));
        if (name == cookieName.trim() && parts[1] != null) {
          String value = Uri.decodeComponent(parts[1]).replaceAll(r"\+", " ").trim();
          return (value.isEmpty || value == "--") ? null : value;
        }
      }
    }
    return null;
  } // cookieGet

  /**
   * Set single [name] cookie
   * [value] null is stored as "--"
   * [maxAge] in seconds default 1d
   */
  static void cookieSet(final String name, final String value,
      {String domain, String path, bool secure, int maxAge: 86400}) {
    String expires = null;
    if (maxAge > 0) {
      int time = new DateTime.now().millisecondsSinceEpoch + (maxAge * 1000);
      expires = DataUtil.dateGmtString(new DateTime.fromMillisecondsSinceEpoch(time, isUtc: true));
    }

    if (secure == null) {
      String url = window.location.href;
      secure = url.startsWith("https");
    }

    var cookie = ([
      Uri.encodeQueryComponent(name),
      '=',
      (value == null || value.isEmpty) ? "--" : Uri.encodeQueryComponent(value),
      "; max-age=${maxAge}",
      expires == null ? "" : ", expires=${expires}",
      path == null ? "" : ";path=${path}",
      domain == null ? "" : ";domain=${domain}",
      (secure == null || secure == false) ? "" : ";secure"
    ].join(''));
    _log.fine("cookieSet ${name}=${value}");
    document.cookie = cookie;
  } // cookieSet

  /**
   * Remove cookie with [name]
   */
  static void cookieRemove(final String name) {
    String cookie = "${Uri.encodeQueryComponent(name)}=;expires=Thu, 01 Jan 1970 00:00:01 GMT;";
    _log.fine("cookieRemove ${name}");
    document.cookie = cookie;
  }

} // Router
