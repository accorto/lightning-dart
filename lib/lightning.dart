/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

library lightning_dart;

/**
 * Lightning UI View Functionality
 */

// Dart Core
import 'dart:async';
import 'dart:html';
import 'dart:svg' as svg;
import 'dart:convert';

// Packages
import 'package:logging/logging.dart';

import 'package:intl/intl.dart';
//import 'package:intl/intl_browser.dart';
//import 'package:intl/date_symbol_data_local.dart';
//
import 'lightning_model.dart';
export 'lightning_model.dart';

//

part 'src/view/components/l_badge.dart';
part 'src/view/components/l_breadcrumb.dart';
part 'src/view/components/l_button.dart';
part 'src/view/components/l_button_group.dart';
part 'src/view/components/l_card.dart';
part 'src/view/components/l_component.dart';
part 'src/view/components/l_dropdown.dart';
part 'src/view/components/l_grid.dart';
part 'src/view/components/l_icon.dart';
part 'src/view/components/l_image.dart';
part 'src/view/components/l_list.dart';
part 'src/view/components/l_lookup.dart';
part 'src/view/components/l_media.dart';
part 'src/view/components/l_modal.dart';
part 'src/view/components/l_motion.dart';
part 'src/view/components/l_notification.dart';
part 'src/view/components/l_page.dart';
part 'src/view/components/l_page_header.dart';
part 'src/view/components/l_picklist.dart';
part 'src/view/components/l_pill.dart';
part 'src/view/components/l_popover.dart';
part 'src/view/components/l_scrollable.dart';
part 'src/view/components/l_spinner.dart';
part 'src/view/components/l_tab.dart';
part 'src/view/components/l_text.dart';
part 'src/view/components/l_theme.dart';
part 'src/view/components/l_tile.dart';
part 'src/view/components/l_tooltip.dart';
part 'src/view/components/l_utilities.dart';
part 'src/view/components/l_visibility.dart';
part 'src/view/components/list_item.dart';

part 'src/view/editors/l_checkbox.dart';
part 'src/view/editors/l_datepicker.dart';
part 'src/view/editors/l_editor.dart';
part 'src/view/editors/l_input.dart';
part 'src/view/editors/l_input_date.dart';
part 'src/view/editors/l_input_duration.dart';
part 'src/view/editors/l_radio.dart';
part 'src/view/editors/l_select.dart';
part 'src/view/editors/l_textarea.dart';
part 'src/view/editors/select_data_list.dart';
part 'src/view/editors/select_option.dart';

part 'src/view/form/l_form.dart';
part 'src/view/form/l_form_compound.dart';
part 'src/view/form/l_form_element.dart';
part 'src/view/form/l_form_field_set.dart';

part 'src/view/menu/page_main.dart';
part 'src/view/menu/page_entry.dart';
part 'src/view/menu/page_simple.dart';

part 'src/view/table/l_table.dart';
part 'src/view/table/l_table_cell.dart';
part 'src/view/table/l_table_row.dart';

part 'src/view/home/apps_action.dart';
part 'src/view/home/l_object_home.dart';
part 'src/view/home/l_record_home.dart';
part 'src/view/home/l_related_list.dart';

part 'src/view/utility/html0.dart';
part 'src/view/utility/option_util.dart';

/**
 * Lightning Dart
 */
class LightningDart {

  /// SLDS Version + rel
  static const VERSION = "v0.8.0+2";
  /** Timestamp */
  static String devTimestamp = "-";

  /// Logger
  static final Logger _log = new Logger("LightningDart");

  /**
   * Initialize Logging, Locale, Intl, Date
   * optional [serverUri] to overwrite target
   */
  static Future<bool> init() {
    // Initialize
    Logger.root.level = Level.ALL;
    // local Logger
    Logger.root.onRecord.listen((LogRecord rec) {
      print(formatLog(rec));
      if (rec.error != null) {
        print(rec.error);
      }
      if (rec.stackTrace != null) {
        // Trace t = new Trace.from(rec.stackTrace);
        // print("_ ${t.toString()}");
        print(rec.stackTrace);
      }
    });
    //
    return ClientEnv.init(); // Locale, Intl, Date
  } // init

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
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   * optional [classList] (if mot defined, container/fluid)
   */
  static PageSimple createPageSimple({String id: "wrap",
    bool clearContainer: true, List<String> classList}) {
    // Top Level Main
    Element e = querySelector("#${id}");
    if (e == null) {
      for (String cls in PageMain.MAIN_CLASSES) {
        e = querySelector(".${cls}");
        if (e != null) {
          break;
        }
      }
    }
    PageSimple main = null;
    if (e == null) {
      Element body = document.body; // querySelector("body");
      main = new PageSimple(new DivElement(), id, classList);
      body.append(main.element);
    } else {
      devTimestamp = e.attributes["data-timestamp"];
      if (clearContainer) {
        e.children.clear();
      }
      main = new PageSimple(e, id, classList);
    }
    _log.info("createPageSimple ${id} version=${VERSION} timestamp=${devTimestamp}");
    return main;
  } // createPageSimple


  /**
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   * optional [classList] (if mot defined, container/fluid)
   */
  static PageMain createPageMain({String id: "wrap",
    bool clearContainer: true, List<String> classList}) {
    // Top Level Main
    Element e = querySelector("#${id}");
    if (e == null) {
      for (String cls in PageMain.MAIN_CLASSES) {
        e = querySelector(".${cls}");
        if (e != null) {
          break;
        }
      }
    }
    PageMain main = null;
    if (e == null) {
      Element body = document.body; // querySelector("body");
      main = new PageMain(new DivElement(), id, classList);
      body.append(main.element);
    } else {
      devTimestamp = e.attributes["data-timestamp"];
      if (clearContainer) {
        e.children.clear();
      }
      main = new PageMain(e, id, classList);
    }
    _log.info("createPageMain ${id} version=${VERSION} timestamp=${devTimestamp}");
    return main;
  } // createPageMain



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


  /// dump element dimensions (l,t)w*h
  static String dumpElement(Element e) =>
    " bound${dumpRectangle(e.getBoundingClientRect())}"
    " offset${dumpRectangle(e.offset)}"
    " client${dumpRectangle(e.client)}"
    " style(${e.style.left},${e.style.top})${e.style.width}*${e.style.height}"
    " scroll(${e.scrollLeft},${e.scrollTop})${e.scrollWidth}*${e.scrollHeight}"
    " content${dumpRectangle(e.contentEdge)}"
    " border${dumpRectangle(e.borderEdge)}"
    ;
  /// dump mouse event position (x,y)
  static String dumpMouse (MouseEvent e) => "(${e.which})"
    " offset(${e.offset.x},${e.offset.y})"
    " client(${e.client.x},${e.client.y})"
    " screen(${e.screen.x},${e.screen.y})"
    ;
  /// dump window sizes
  static String dumpWindow() =>
    " inner(${window.innerWidth}*${window.innerHeight})"
    " screen(${window.screenX},${window.screenY})"
    " scroll(${window.scrollX},${window.scrollY})" // offset
    ;
  // dump rectangle(l,t)wxh
  static String dumpRectangle(Rectangle r) =>
    "(${r.left},${r.top})${r.width}*${r.height}";
  // dump point (x,y)=(l,t)
  static String dumpPoint(Point p) => "(${p.x},${p.y})";

} // LightningDart
