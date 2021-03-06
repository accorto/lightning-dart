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

  /// Create svg direct vs. use
  static bool createIconImage() {
    if (_createIconImage == null) {
      // _createIconImage = false; //!document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#Structure", "1.1");
      _createIconImage = ClientEnv.isIE11; // Edge OK
    }
    return _createIconImage;
  }
  static bool _createIconImage;

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
    String msg = "";
    HttpRequest.getString(symbolSvgUrl)
    .then((String svgSymbolCode){
      msg = "svgDirectProcess received symbolUrl=${symbolSvgUrl}";
      _log.fine(msg);
      Element e = new DivElement()
        ..setInnerHtml(svgSymbolCode, treeSanitizer: NodeTreeSanitizer.trusted);
      Element sym = e.children.first;
      if (sym == null || e.children.isEmpty) {
        _log.warning("svgDirectProcess NoSym symbolUrl=${symbolSvgUrl} location=${window.location.href} referrer=${document.referrer} code=${svgSymbolCode}");
        _requestMap.remove(symbolSvgUrl);
        return;
      } else {
        _symbolMap[symbolSvgUrl] = sym;
      }

      // existing requests
      List<SvgUtilDirect> list = _requestMap[symbolSvgUrl];
      if (list != null) {
        _log.fine("svgDirectProcess requests=${list.length}");
        for (SvgUtilDirect dir in list) {
          svgDirectUpdate(dir.svgElement, sym, dir.symbolName);
        }
        _requestMap.remove(symbolSvgUrl);
      }
    })
    .catchError((error, stackTrace){
      _log.warning("svgDirectProcess symbolUrl=${symbolSvgUrl} location=${window.location.href} referrer=${document.referrer} ${window.location.href}",
          error, stackTrace);
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
      try {
        // remove use
        if (svgElement.children.length <= 1) {
          svgElement.children.clear();
        } else {
          for (var ee in svgElement.children) {
            if (ee is svg.UseElement) {
              svgElement.children.remove(ee);
              break;
            }
          }
        }
        // add symbol content
        Element clone = sym.clone(true);
        for (var ee in clone.children) {
          if (ee is svg.SvgElement) {
            svgElement.append(ee);
          }
        }
      } catch (error, stackTrace) {
        _log.warning("svgDirectUpdate symbolName=${symbolName}", error, stackTrace);
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
  SvgUtilDirect(svg.SvgSvgElement this.svgElement, String this.symbolName);
}
