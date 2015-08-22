/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

library lightning_dart;

// Dart Core
import 'dart:async';
import 'dart:html';
import 'dart:svg' as svg;
import 'dart:convert';

// Packages
import 'package:logging/logging.dart';

import 'intl/base-messages_all.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';
//
import 'biz_fabrik_base.dart';
export 'biz_fabrik_base.dart';

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
part 'src/view/components/l_table.dart';
part 'src/view/components/l_text.dart';
part 'src/view/components/l_theme.dart';
part 'src/view/components/l_tile.dart';
part 'src/view/components/l_tooltip.dart';
part 'src/view/components/l_utilities.dart';
part 'src/view/components/l_visibility.dart';
part 'src/view/components/list_item.dart';

part 'src/view/editors/l_checkbox.dart';
part 'src/view/editors/l_editor.dart';
part 'src/view/editors/l_input.dart';
part 'src/view/editors/l_radio.dart';
part 'src/view/editors/l_select.dart';
part 'src/view/editors/l_textarea.dart';
part 'src/view/editors/select_data_list.dart';
part 'src/view/editors/select_option.dart';

part 'src/view/form/l_form.dart';
part 'src/view/form/l_form_compound.dart';
part 'src/view/form/l_form_element.dart';

part 'src/view/utility/html0.dart';
part 'src/view/utility/option_util.dart';

/**
 * Lightning Dart
 */
class LightningDart {

  /** Locale Name */
  static String localeName = "en_US";
  /** Locale Name */
  static String language = "en";

  /// Logger
  static final Logger _log = new Logger("LightningDart");

  /**
   * Initialize Logging, Locale, Intl, Date
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
    localeName = window.navigator.language;
    Completer<bool> completer = new Completer<bool>();
    findSystemLocale()
    .then((String locale) {
      localeName = locale;
      // localeName = "fr_BE";
      // Intl.systemLocale = localeName;
      Intl.defaultLocale = localeName;
      //
      language = locale;
      int index = language.indexOf("_");
      if (index > 0)
        language = language.substring(0, index);
      //
      return initializeDateFormatting(locale, null);
    })
    .then((_) {
      return initializeMessages(language); // BaseMessages
    })
    .then((_) {
    //  initializeFormats();
      _log.info("locale=${localeName} language=${language}");
      //  " ${dateFormat_ymd.pattern} ${dateFormat_hms.pattern} - ${dateFormat_ymd_hm.pattern}");
      completer.complete(true);
    })
    .catchError((error, stackTrace) {
      _log.warning("locale=${localeName} language=${language}", error, stackTrace);
      completer.completeError(error, stackTrace);
    });
    return completer.future;
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

} // LightningDart
