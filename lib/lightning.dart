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
part 'src/view/components/l_card_compact.dart';
part 'src/view/components/l_card_compact_entry.dart';
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
part 'src/view/components/l_picklist_multi.dart';
part 'src/view/components/l_picklist_quick.dart';
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

part 'src/view/editors/editor_util.dart';
part 'src/view/editors/l_checkbox.dart';
part 'src/view/editors/l_datepicker.dart';
part 'src/view/editors/l_editor.dart';
part 'src/view/editors/l_input.dart';
part 'src/view/editors/l_input_date.dart';
part 'src/view/editors/l_input_duration.dart';
part 'src/view/editors/l_input_search.dart';
part 'src/view/editors/l_radio.dart';
part 'src/view/editors/l_select.dart';
part 'src/view/editors/l_textarea.dart';
part 'src/view/editors/select_data_list.dart';
part 'src/view/editors/select_option.dart';

part 'src/view/form/form_i.dart';
part 'src/view/form/l_form.dart';
part 'src/view/form/l_form_compound.dart';
part 'src/view/form/l_form_element.dart';
part 'src/view/form/l_form_field_set.dart';

part 'src/view/table/l_table.dart';
part 'src/view/table/l_table_cell.dart';
part 'src/view/table/l_table_row.dart';

part 'src/view/home/apps_action.dart';
part 'src/view/home/l_object_home.dart';
part 'src/view/home/l_object_home_filter.dart';
part 'src/view/home/l_record_home.dart';
part 'src/view/home/l_related_list.dart';
part 'src/view/home/page_simple.dart';

part 'src/view/utility/html0.dart';
part 'src/view/utility/l_util.dart';
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
      print(LUtil.formatLog(rec));
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
      for (String cls in PageSimple.MAIN_CLASSES) {
        e = querySelector(".${cls}");
        if (e != null) {
          break;
        }
      }
    }
    PageSimple main = null;
    if (e == null) {
      Element body = document.body; // querySelector("body");
      main = new PageSimple(new DivElement(), id, classList:classList);
      body.append(main.element);
    } else {
      devTimestamp = e.attributes["data-timestamp"];
      if (clearContainer) {
        e.children.clear();
      }
      main = new PageSimple(e, id, classList:classList);
    }
    _log.info("createPageSimple ${id} version=${VERSION} timestamp=${devTimestamp}");
    return main;
  } // createPageSimple

} // LightningDart
