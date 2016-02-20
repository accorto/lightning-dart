/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
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


  /// The Route
  Route get route => _route;
  Route _route;

  /// The Value
  String get value => _value;
  String _value;
  /// Path Map
  Map<String,String> map;

  /**
   * (Re) Set [route] path with optional [value] and [map]
   */
  void setRoute(Route route, {String value, Map<String,String> map}) {
    _route = route;
    _value = value;
    this.map = map;
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


  String get routeName => _route == null ? null : _route.name;
  String get routePath => _route == null ? null : _route.path;
  RouteEventHandler get handler => _route == null ? null : _route.handler;

  /// title
  String get title => _title == null ? _route.title : _title;
  void set title (String newValue) {
    _title = newValue;
    if (_title != null && _title.isEmpty)
      _title = null;
  }
  String _title;

  /**
   * Get full Path
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

  String toString() {
    return "RouterPath [${_route}] value=${_value} map=${map}";
  }

} // RouterPath
