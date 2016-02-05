/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * SVG Utility
 */
class SvgUtil {

  static final Logger _log = new Logger("SvgUtil");

  /// Create Img vs. svg
  static bool createImg() {
    if (_createImg == null) {
      _createImg = !document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
      if (_createImg) {
        window.alert("Browser not capable displaying SVG - images not displayed");
      }
    }
    return _createImg;
  }
  static bool _createImg;

  /// Create svg direct vs. use
  static bool createDirect(bool implementationOnly) {
    if (implementationOnly)
      return !document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Structure", "1.1");
    if (_createDirect == null) {
      _createDirect = !document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Structure", "1.1");
      if (!_createDirect) {
        _createDirect = ClientEnv.isIE11  || ClientEnv.isChrome;
      }
    }
    return _createDirect;
  }
  static bool _createDirect;

  /**
   * Replace use in SVG by content of symbol
   */
  static void svgDirect (svg.SvgSvgElement svgElement, String symbolSvgUrl, String symbolName) {
    Element sym = _symbolMap[symbolSvgUrl];
    if (sym == null) {
      List<SvgUtilDirect> list = _requestMap[symbolSvgUrl];
      if (list == null) {
        list = new List<SvgUtilDirect>();
        _requestMap[symbolSvgUrl] = list;
        list.add(new SvgUtilDirect(svgElement, symbolName));
        _svgDirectProcess(symbolSvgUrl);
      } else {
        list.add(new SvgUtilDirect(svgElement, symbolName));
      }
    } else {
      svgDirectUpdate(svgElement, sym, symbolName);
    }
  }
  static Map<String, Element> _symbolMap = new Map<String, Element>();
  static Map<String, List<SvgUtilDirect>> _requestMap = new Map<String, List<SvgUtilDirect>>();

  /// process symbol request
  static void _svgDirectProcess(String symbolSvgUrl) {
    HttpRequest.getString(symbolSvgUrl)
    .then((String svgSymbolCode){
      _log.fine("received ${symbolSvgUrl}");
      Element e = new DivElement()
        ..setInnerHtml(svgSymbolCode, treeSanitizer: NodeTreeSanitizer.trusted);
      Element sym = e.children.first;
      _symbolMap[symbolSvgUrl] = sym;

      // existing requests
      List<SvgUtilDirect> list = _requestMap[symbolSvgUrl];
      _log.fine("requests=${list.length}");
      for (SvgUtilDirect dir in list) {
        svgDirectUpdate(dir.svgElement, sym, dir.symbolName);
      }
      _requestMap.remove(symbolSvgUrl);
    })
    .catchError((error, stackTrace){
      _log.warning(symbolSvgUrl, error, stackTrace);
    });
  }

  /// Replace use in svg
  static void svgDirectUpdate (svg.SvgSvgElement svgElement, svg.SvgSvgElement symbolSvg, String symbolName) {
    Element sym = symbolSvg.getElementById(symbolName);
    if (sym == null) {
      svgElement.setAttribute("data-info", "NotFound ${symbolName}");
    } else {
      String viewBox = sym.getAttribute("viewBox"); // as text
      svgElement.setAttribute("viewBox", viewBox);
      // find path in symbol
      Element path = null;
      for (var p in sym.childNodes) { // might be text (space)
        if (p is svg.PathElement) {
          path = p;
          break;
        }
      }
      if (path == null) {
        svgElement.setAttribute("data-info", "NoPath ${symbolName}");
      } else {
        Element clone = path.clone(true);
        // if use has title, we loose it
        if (svgElement.children.length == 1) {
          svgElement.children.clear(); // remove use
          svgElement.append(clone); // add path
        } else {
          for (var use in svgElement.children) {
            if (use is svg.UseElement) {
              use.replaceWith(clone); // replace use
            }
          }
        }
      }
    }
  } // svgDirectUpdate

} // SvgUtil

/**
 * Request queue Element
 */
class SvgUtilDirect {
  final svg.SvgSvgElement svgElement;
  final String symbolName;
  SvgUtilDirect(svg.SvgElement this.svgElement, String this.symbolName);
}
