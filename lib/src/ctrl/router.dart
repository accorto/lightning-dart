/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/// go to path return false if reject
typedef bool RouteEventHandler(RouterPath path);

/**
 * Application Router
 * Handles query parameters
 * and hierarchical path, e.g. /key/value/key2/value2
 * path could be direct or as  #key/value/key2/value2
 */
class Router {

  // (Javascript) Parameter
  static const String P_SERVERURI = "serverUri";
  static const String P_CNAME = "cname";
  static const String P_LOADDIV = "loadDiv";
  static const String P_FLUID = "fluid";
  static const String P_CLEARCONTAINER = "clearContainer";
  static const String P_ADDHEADER = "addHeader";
  static const String P_ADDNAV = "addNav";
  static const String P_THEME = "theme";
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
      result[decode(match.group(1))] = decode(match.group(2));
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

  // Routes
  final List<Route> _routes = new List<Route>();
  /// Base URL
  String _baseUrl = "";
  /// current Path
  String _currentPath;
  /// current Path move time
  DateTime _currentPathTime;

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

    _baseUrl = href;
    int index = _baseUrl.indexOf("/", 10);
    if (index != -1)
      _baseUrl = _baseUrl.substring(0, index+1);
    else
      _baseUrl += '/';

    // Parameters
    queryParams = queryParamsFrom(search);
    Map<String, String> hashParams = queryParamsFrom(hash);
    if (hashParams.length > 0)
      queryParams.addAll(hashParams);
    // paths
    //List<String> pp = RouterPath.getPathElements(path+hash);
    // _log.log(Level.INFO, "baseUrl=${_baseUrl} paths=${pp} params=${queryParams}");
  } // init

  /// load Javascript Config - query parameters overwrite!
  void loadConfig() {
    // LINIT={cname: "accorto", loadDiv: "quando", fluid: "true", clearWrap: "false", addHeader: "false", addNav: "false"};
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
      if (!queryParams.containsKey(P_FLUID) && config.hasProperty(P_FLUID)) {
        queryParams[P_FLUID] = config[P_FLUID];
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
  } // loadConfig

  /**
   * Start listening (call route(null) to go to url)
   */
  RouterPath start() {
    window.onHashChange.listen((_) {
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
        //  _log.log(Level.CONFIG, "onPopState ${path} - ${window.location.href}");
        //  route(path); // duplicate
      } else {
        _log.log(Level.CONFIG, "onPopState ${path} - ${window.location.href}");
        route(path);
      }
    });

    // Router Path from URL
    List<String> pp = paths;
    if (pp.isNotEmpty) {
      String key = pp.first;
      Route route = findRouteWithPath(key);
      if (route != null) {
        routerPath.setRoutePath(route, paths: pp);
      }
    }

    _log.info("start ${routerPath}");
    //
    return routerPath;
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
  void addRoute({String name, String path, String title, RouteEventHandler enter, bool defaultRoute : false}) {
    path = cleanPath(path, addPrefix: false);
    for (Route rr in _routes) {
      if (rr.name == name || rr.path == path) {
        _log.warning("addRoute name=${name} path=${path} - already exists: ${rr}");
      }
    }
    Route route = new Route(name, path, title, enter);
    _routes.add(route);
    if (defaultRoute)
      this.defaultRoute = route;
  } // addRoute

  /// Get Route with [name]
  Route findRouteWithName(String name) {
    for (Route r in _routes) {
      if (name == r.name) {
        return r;
      }
    }
    return null;
  }
  /// Get Route with [path]
  Route findRouteWithPath(String path) {
    for (Route r in _routes) {
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
   * Find route with matching [path] or default - return false if not routed
   */
  bool route(final String path) {
    String thePath = path;
    // Path
    if (path == null)
      thePath = useHash ? window.location.hash : "${window.location.pathname}${window.location.hash}";
    thePath = cleanPath(thePath, addPrefix: false);
    // Pattern pattern = new RegExp(thePath);
    // find route
    for (Route r in _routes) {
      if (thePath.startsWith(r.path)) {
        routerPath.setRoutePath(r, path: thePath);
        if (go())
          return true;
      }
    }
    if (defaultRoute != null) {
      routerPath.setRoutePath(defaultRoute, path: thePath);
      return go();
    }
    return false;
  } // route

  /**
   * Clean path (no /#)
   */
  String cleanPath(String path, {bool addPrefix: true}) {
    String thePath = path;
    while (thePath.startsWith(cleanPathPrefix)) // /#
      thePath = thePath.substring(1);
    if (addPrefix) {
      return (useHash ? "#/" : "/") + thePath;
    }
    return thePath;
  }

  /**
   * GoTo route [routeName] with optional [value] and [map]
   * - return false if not found or rejected
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
   * Go to [routerPath] - return false if rejected
   */
  bool go () {
    Route theRoute = routerPath.route;
    String thePath = routerPath.toPath();
    _log.log(Level.CONFIG, "go ${theRoute} path=${thePath}");
    bool result = theRoute.handler(routerPath);
    if (result) {
      updateWindow(thePath, theRoute.title);
    //  GoogleAnalytics.gaSendPageview(theRoute.path);
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
    for (Route r in _routes) {
      if (name == r.name) {
        updateWindow(r.path, r.title, replace: replace, clean: clean);
        return;
      }
    }
    _log.log(Level.CONFIG, "set ${name} not found");
  } // set

  /**
   * Update Window directly
   * [clean] removes parameter if [replace]
   */
  void updateWindow(String path, String title, {bool replace: false, bool clean: false}) {
    String thePath = cleanPath(path, addPrefix: true);

    if (title != null && title.isNotEmpty)
      document.title = title;

    if (replace) {
      if (clean) {
        String href = window.location.href;
        int pos = href.indexOf("?");
        if (pos > 0)
          href = href.substring(0, pos);
        pos = href.indexOf("#");
        if (pos > 0)
          href = href.substring(0, pos);
        href += thePath;
        window.history.replaceState(null, title, href);
      } else {
        window.history.replaceState(null, title, thePath);
      }
    } else {
      window.history.pushState(null, title, thePath);
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



/** ** **
 * The Route
 */
class Route {

  /// Route Name
  static final String NAME_DEFAULT = "default";
  static const String NAME_LOGIN = "login";
  static const String NAME_MENU = "menu";

  /// name
  String name;
  /// path/key
  String path;
  /// optional title
  String title;
  /// handler
  RouteEventHandler handler;
  /// additional keys
  List<String> keys;
  /// keys required
  bool keysRequired = false;

  /**
   * Route with [name], [path] (= key e.g. menu - without /)
   * and [handler] with optional [title]
   */
  Route(String this.name, String this.path, String this.title, RouteEventHandler this.handler) {
  }

  @override
  String toString() {
    return "Route=${name}[path=${path} title=${title}]";
  }
} // Route



/** ** **
 * List of hierarchy key/value elements
 * e.g. /key/value/key2/value2
 * where the first key is the route path
 */
class RouterPath {

  /// get Path Elements
  static List<String> getPathElements(String pathHash) {
    List<String> list = new List<String>();
    if (pathHash == null || pathHash.isEmpty)
      return list;
    pathHash = pathHash.replaceAll("#", "/");
    int index = pathHash.indexOf(".html");
    if (index != -1) {
      int index2 = pathHash.lastIndexOf("/", index);
      if (index2 != null)
        pathHash = pathHash.substring(0, index2+1) + pathHash.substring(index+5);
    }
    List<String> values = pathHash.split("/");
    // remove empty
    for (String path in values) {
      if (path.isNotEmpty) {
        list.add(path);
      }
    }
    return list;
  } // getPathElements


  Route _route;
  String _value;
  Map<String,String> map;

  /// The Route
  Route get route => _route;

  /**
   * (Re) Set [route] path with optional [value] and [map]
   */
  void setRoute(Route route, {String value, Map<String,String> map}) {
    _route = route;
    _value = value;
    this.map = null;
  }

  /**
   * (Re) Set [route] path from [path] or [paths]
   */
  void setRoutePath(Route route, {String path, List<String> paths}) {
    if (paths == null) {
      paths = getPathElements(path);
    }
    String value = null;
    if (route.path.isEmpty) {
      value = paths.join("/");
    } else {
      if (paths.length > 1)
        value = paths[1];
    }
    setRoute(route, value: value);
    String key = null;
    for (int i = 2; i < paths.length; i++) {
      String p = paths[i];
      if (key == null)
        key = p;
      else {
        addPath(key, p);
        key = null;
      }
    }
    if (key != null) {
      addPath(key, "");
    }
  } // setRouterPath

  /**
   * Add Path element
   */
  void addPath(String key, String value) {
    if (key == null || _route == null)
      return;
    if (key == _route.path) {
      _value = value;
    } else {
      if (map == null)
        map = new Map<String,String>();
      if (value == null || value.isEmpty)
        map.remove(key);
      else
        map[key] = value;
    }
  } // addPath

  /**
   * Get Value for [key] (path element)
   */
  String get(String key) {
    if (key == null || _route == null)
      return null;
    if (key == _route.path)
      return _value;
    if (map != null)
      return map[key];
    return null;
  } // get

  /**
   * Get Path
   */
  String toPath() {
    StringBuffer sb = new StringBuffer();
    if (_route != null) {
      sb.write(_route.path);
      if (_value != null && _value.isNotEmpty) {
        sb.write("/${_value}");
        _toPath(sb);
      } else if (map != null && map.isNotEmpty) {
        sb.write("/");
        _toPath(sb);
      }
    }
    return sb.toString();
  } // toPath

  /// add map to path ordered by route keys (if exist)
  void _toPath(StringBuffer sb) {
    if (map == null || map.isEmpty)
      return;
    if (_route.keys != null) {
      for (String key in _route.keys) {
        String value = map[key];
        if (value == null || value.isEmpty) {
          if (_route.keysRequired)
            return;
        } else {
          sb.write("/${key}/${value}");
        }
      }
    }
    // additional unordered keys
    map.forEach((String key, String value){
      if (value != null && value.isNotEmpty) {
        if (_route.keys == null || !_route.keys.contains(key))
          sb.write("/${key}/${value}");
      }
    });
  } // toPath

  String toString() => toPath();

} // RouterPath
