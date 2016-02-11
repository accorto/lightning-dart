/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

/**
 * Lightning Dart View level Functionality - basic UI components
 *
 * Lightning Dart main entry point
 *
 *     LightningDart.init()
 *     .then((_){
 *       // application code
 *     });
 *
 * - or-
 *
 *    main() async {
 *      await LightningDart.init(); // client env
 *      PageSimple.create()
 *        ..add(...content...);
 *    }
 *
 */
library lightning_dart;

import 'dart:async';
import 'dart:html';
import 'dart:svg' as svg;
import 'dart:convert';
import 'dart:math';
//import 'dart:collection';

// Packages
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

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
part 'src/view/components/l_card_compact.dart';
part 'src/view/components/l_card_compact_entry.dart';
part 'src/view/components/l_component.dart';
part 'src/view/components/l_dropdown.dart';
part 'src/view/components/l_dropdown_element.dart';
part 'src/view/components/l_dropdown_item.dart';
part 'src/view/components/l_grid.dart';
part 'src/view/components/l_icon.dart';
part 'src/view/components/l_image.dart';
part 'src/view/components/l_list.dart';
part 'src/view/components/l_lookup.dart';
part 'src/view/components/l_lookup_item.dart';
part 'src/view/components/l_lookup_select.dart';
part 'src/view/components/l_lookup_timezone.dart';
part 'src/view/components/l_media.dart';
part 'src/view/components/l_modal.dart';
part 'src/view/components/l_motion.dart';
part 'src/view/components/l_notification.dart';
part 'src/view/components/l_page.dart';
part 'src/view/components/l_page_header.dart';
part 'src/view/components/l_path.dart';
part 'src/view/components/l_picklist.dart';
part 'src/view/components/l_picklist_multi.dart';
part 'src/view/components/l_pill.dart';
part 'src/view/components/l_popbase.dart';
part 'src/view/components/l_popover.dart';
part 'src/view/components/l_scrollable.dart';
part 'src/view/components/l_spinner.dart';
part 'src/view/components/l_tab.dart';
part 'src/view/components/l_text.dart';
part 'src/view/components/l_theme.dart';
part 'src/view/components/l_tile.dart';
part 'src/view/components/l_tile_generic.dart';
part 'src/view/components/l_tooltip.dart';
part 'src/view/components/l_utilities.dart';
part 'src/view/components/l_visibility.dart';
part 'src/view/components/list_item.dart';

part 'src/view/cpanel/card_panel.dart';
part 'src/view/cpanel/card_panel_column.dart';

part 'src/view/editors/editor_util.dart';
part 'src/view/editors/l_checkbox.dart';
part 'src/view/editors/l_datepicker.dart';
part 'src/view/editors/l_datepicker_dropdown.dart';
part 'src/view/editors/l_editor.dart';
part 'src/view/editors/l_input.dart';
part 'src/view/editors/l_input_color.dart';
part 'src/view/editors/l_input_date.dart';
part 'src/view/editors/l_input_duration.dart';
part 'src/view/editors/l_input_file.dart';
part 'src/view/editors/l_input_image.dart';
part 'src/view/editors/l_input_number.dart';
part 'src/view/editors/l_input_range.dart';
part 'src/view/editors/l_input_search.dart';
part 'src/view/editors/l_radio.dart';
part 'src/view/editors/l_select.dart';
part 'src/view/editors/l_select_i.dart';
part 'src/view/editors/l_textarea.dart';
part 'src/view/editors/select_data_list.dart';
part 'src/view/editors/select_option.dart';

part 'src/view/form/form_i.dart';
part 'src/view/form/form_section.dart';
part 'src/view/form/l_form.dart';
part 'src/view/form/l_form_compound.dart';
part 'src/view/form/l_form_element.dart';
part 'src/view/form/l_form_field_set.dart';

part 'src/view/table/l_table.dart';
part 'src/view/table/l_table_action_cell.dart';
part 'src/view/table/l_table_cell.dart';
part 'src/view/table/l_table_header_cell.dart';
part 'src/view/table/l_table_header_row.dart';
part 'src/view/table/l_table_row.dart';
part 'src/view/table/l_table_sum_cell.dart';
part 'src/view/table/l_table_sum_row.dart';
part 'src/view/table/table_statistics.dart';

part 'src/view/home/apps_action.dart';
part 'src/view/home/l_object_home.dart';
part 'src/view/home/l_object_home_filter.dart';
part 'src/view/home/l_object_home_filter_item.dart';
part 'src/view/home/l_object_home_filter_lookup.dart';
part 'src/view/home/l_object_home_filter_panel.dart';
part 'src/view/home/l_record_home.dart';
part 'src/view/home/l_related_list.dart';
part 'src/view/home/new_window.dart';
part 'src/view/home/page_simple.dart';

part 'src/view/utility/dl_util.dart';
part 'src/view/utility/html0.dart';
part 'src/view/utility/l_util.dart';
part 'src/view/utility/option_util.dart';
part 'src/view/utility/svg_util.dart';

/**
 * Lightning Dart main entry point
 *
 *     LightningDart.init()
 *     .then((_){
 *      LightningDart.createPageSimple()
 *        ..add(...content...);
 *     });

 * - or-
 *
 *    main() async {
 *      await LightningDart.init(); // client env
 *      // check example: http://lightningdart.com/exampleForm.html
 *      LightningDart.createPageSimple()
 *        ..add(...content...);
 *    }
 *
 */
class LightningDart {

  /// SLDS Version + rel
  static const VERSION = "v0.12.1";
  /** Timestamp */
  static String devTimestamp = "-";

  /// Logger
  static final Logger _log = new Logger("LightningDart");

  /**
   * Initialize Logging, Locale, Intl, Date
   */
  static Future<bool> init() {
    // Initialize Logging
    // print("hierarchicalLoggingEnabled=${hierarchicalLoggingEnabled} recordStackTraceAtLevel=${recordStackTraceAtLevel}");
    Logger.root.level = Level.ALL;
    // local Logger
    Logger.root.onRecord.listen(onLogRecord);
    return ClientEnv.init(); // Locale, Intl, Date
  } // init

  /**
   * Local Log Record
   */
  static void onLogRecord(LogRecord rec) {
    String logObject = LUtil.formatLog(rec);
    if (rec.error != null) {
      logObject += "\n  ${rec.error}";
    }
    if (rec.stackTrace != null) {
      // logObject += "\n${rec.stackTrace}";
      Trace t = new Trace.from(rec.stackTrace);
      logObject += "\n${t}";
    }

    if (rec.level == Level.SHOUT)
      window.console.error(logObject);
    else if (rec.level == Level.SEVERE)
      window.console.error(logObject);
    else if (rec.level == Level.WARNING)
      window.console.warn(logObject);
    else if (rec.level == Level.INFO)
      window.console.info(logObject);
    else if (rec.level == Level.CONFIG)
      window.console.debug(logObject);
    else
      window.console.log(logObject);
  } // onLogRecord

  /**
   * Create Page (slds-grid)
   * [id] id of the application
   * [clearContainer] clears all content from container
   * optional [classList] (if mot defined, container/fluid)
   */
  static PageSimple createPageSimple({String id: "wrap",
    bool clearContainer: true, List<String> classList}) {
    // Top Level Main
    Element loadDiv = querySelector("#${id}");
    if (loadDiv == null) {
      for (String cls in PageSimple.MAIN_CLASSES) {
        loadDiv = querySelector(".${cls}");
        if (loadDiv != null) {
          break;
        }
      }
    }
    PageSimple main = null;
    if (loadDiv == null) {
      Element body = document.body; // querySelector("body");
      main = new PageSimple(new DivElement(), id, classList:classList);
      body.append(main.element);
    } else {
      devTimestamp = loadDiv.attributes["data-timestamp"];
      if (clearContainer) {
        loadDiv.children.clear();
      }
      main = new PageSimple(loadDiv, id, classList:classList);
    }
    _log.info("createPageSimple ${id} version=${VERSION} ts=${devTimestamp}");
    return main;
  } // createPageSimple

} // LightningDart
