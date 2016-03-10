/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Lightning Dart Utilities
 */
class LUtil {

  static final Logger _log = new Logger("LUtil");

  /// middle dot with spaces around
  static const String DOT_SPACE = " \u{00B7} ";

  // small circle - http://www.fileformat.info/info/unicode/char/25CF/index.htm
  static const String CIRCLE ="\u{25CF}";
  // small square - http://www.fileformat.info/info/unicode/char/25a0/index.htm
  static const String SQUARE ="\u{25A0}";
  // rectangle
  static const String RECTANGLE ="\u{25AC}";
  // small parallelogram
  static const String PARALLEL ="\u{25B0}";
  // small triangle up
  static const String TRIANGLE ="\u{25B4}";
  // inverse bullet
  static const String INV_BULLET ="\u{25D8}";

  // double left arrow
  static const String ARROW_LEFT_D = "\u{21D0}";

  // downwards single arrow
  static const String SORT_ASC = "\u{2193}";
  // upwards single arrow
  static const String SORT_DESC = "\u{2191}";


  // Format Log Record
  static String formatLog(LogRecord rec) {
    StringBuffer sb = new StringBuffer();
    // time
    int ii = rec.time.minute;
    if (ii < 10)
      sb.write("0");
    sb.write(ii);
    sb.write(":");
    ii = rec.time.second;
    if (ii < 10)
      sb.write("0");
    sb.write(ii);
    sb.write(".");
    ii = rec.time.millisecond;
    if (ii < 10)
      sb.write("00");
    else if (ii < 100)
      sb.write("0");
    sb.write(ii);
    // Level
    Level ll = rec.level;
    if (ll == Level.SHOUT)
      sb.write(">>");
    else if (ll == Level.SEVERE)
      sb.write("~~");
    else if (ll == Level.WARNING)
      sb.write("~ ");
    else if (ll == Level.INFO)
      sb.write("  ");
    else if (ll == Level.CONFIG)
      sb.write("   ");
    else if (ll == Level.FINE)
      sb.write("    ");
    else if (ll == Level.FINER)
      sb.write("     ");
    else if (ll == Level.FINEST)
      sb.write("      ");
    else {
      sb.write(" ");
      sb.write(ll.name);
    }
    //
    sb.write("${rec.loggerName}: ${rec.message}");
    return sb.toString();
  } // format

  /**
   * convert to variable/id name containing a..z A..Z 0..9
   * as well as - _ .
   * by ignoring non compliant characters
   * must start with letter (html5 id)
   */
  static String toVariableName(String text) {
    if (text == null || text.isEmpty)
      return text;
    StringBuffer sb = new StringBuffer();
    bool first = true;
    List chars = "azAZ09_-.".codeUnits;
    text.codeUnits.forEach((code) {
      if ((code >= chars[0] && code <= chars[1]) // a_z
      || (code >= chars[2] && code <= chars[3])) // A_Z
        sb.write(new String.fromCharCode(code));
      else if (!first
      && ((code >= chars[4] && code <= chars[5]) // 0_9
      || code == chars[6] || code == chars[7] || code == chars[8])) // _-.
        sb.write(new String.fromCharCode(code));
      first = false;
    });
    String retValue = sb.toString();
    // if (text.length != retValue.length)
    //  _log.warning("Invalid VariableName=${text} -> ${retValue}");
    return retValue;
  } // toVariableName

  /// format bytes
  static String formatBytes(int b) {
    if (b < 1024)
      return "${b}B";
    double kb = b / 1024;
    if (kb < 10)
      return "${kb.toStringAsFixed(1)}kB";
    double mb = kb / 1024;
    if (mb < 1)
      return "${kb.toInt()}kB";
    if (mb < 10)
      return "${mb.toStringAsFixed(1)}MB";
    double gb = mb / 1024;
    if (gb < 1)
      return "${mb.toInt()}MB";
    return "${gb.toStringAsFixed(1)}GB";
  }

  /// convert [data] map to json string
  static String toJsonString(Map<String,dynamic> data) {
    StringBuffer sb = new StringBuffer();
    String sep = "{";
    data.forEach((K,V){
      String value = "${V}".replaceAll(_reQuote, "'"); // replace "
      sb.write('${sep}"${K}":"${value}"');
      sep = ",";
    });
    sb.write("}");
    return sb.toString();
  }
  static RegExp _reQuote = new RegExp(r'"');

  /// convert [rext] to html - replace cr with <br/>
  static String textToHtml(String text) {
    if (text == null || text.isEmpty)
      return "";
    String text0 = text.replaceAll(_apro, "'"); // should be text apostrophe
    String text1 = _sanitizer.convert(text0);
    String text2 = text1.replaceAll(_crlf, "<br/>");
    return text2;
  }
  static RegExp _apro = new RegExp(r'&#39;');
  static RegExp _crlf = new RegExp(r'[\n\r]');
  static HtmlEscape _sanitizer = new HtmlEscape(HtmlEscapeMode.ELEMENT);


  /// Same day
  static bool isSameDay(DateTime one, DateTime two) {
    if (one == null || two == null)
      return false;
    return one.year == two.year
    && one.month == two.month
    && one.day == two.day;
  } // isSameDay

  static final String SPACES_REGEX = r"[\s_-]";
  static final RegExp SPACES = new RegExp(SPACES_REGEX);

  /// Create regex for [search] returns null if empty or error
  static RegExp createRegExp(String search) {
    if (search == null || search.isEmpty)
      return null;
    // fix spaces (spaces to match also _-)
    String restriction = search.replaceAll(" ", SPACES_REGEX);
    // fix regex
    if (restriction == "[" || restriction == "(" || restriction == ".")
      restriction = "\\" + restriction;
    try {
      return new RegExp(restriction, caseSensitive: false);
    } catch (ex) {
      _log.info("createRegExp search=${search} restriction=${restriction}) error=${ex}");
    }
    return null;
  }


  /// dump element dimensions (l,t)w*h
  static String dumpElement(Element e) =>
    " bound${dumpRectangle(e.getBoundingClientRect())}"
    " offset${dumpRectangle(e.offset)}"
    " client${dumpRectangle(e.client)}"
    " style(${e.style.left},${e.style.top})${e.style.width}*${e.style.height}"
    " scroll(${e.scrollLeft},${e.scrollTop})${e.scrollWidth}*${e.scrollHeight}"
    " content${dumpRectangle(e.contentEdge)}"
    " border${dumpRectangle(e.borderEdge)}";

  /// dump mouse event position (x,y)
  static String dumpMouse (MouseEvent e) => "(${e.which})"
    " offset(${e.offset.x},${e.offset.y})"
    " client(${e.client.x},${e.client.y})"
    " screen(${e.screen.x},${e.screen.y})";

  /// dump window sizes
  static String dumpWindow() =>
    " inner(${window.innerWidth}*${window.innerHeight})"
    " screen(${window.screenX},${window.screenY})"
    " scroll(${window.scrollX},${window.scrollY})"; // offset

  // dump rectangle(l,t)wxh
  static String dumpRectangle(Rectangle r) =>
    "(${r.left},${r.top})${r.width}*${r.height}";

  // dump point (x,y)=(l,t)
  static String dumpPoint(Point p) => "(${p.x},${p.y})";

} // LUtil
