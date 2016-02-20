/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_ctrl;

/**
 * The Route
 */
class Route {

  /// Route Name
  static final String NAME_DEFAULT = "default";
  static const String NAME_LOGIN = "login";

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
