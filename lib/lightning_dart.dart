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

// Packages
import 'package:logging/logging.dart';

import 'intl/base-messages_all.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';
//
import 'biz_base_dart.dart';

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
part 'src/view/components/l_spacing.dart';
part 'src/view/components/l_spinner.dart';
part 'src/view/components/l_tab.dart';
part 'src/view/components/l_table.dart';
part 'src/view/components/l_text.dart';
part 'src/view/components/l_theme.dart';
part 'src/view/components/l_tile.dart';
part 'src/view/components/l_tooltip.dart';
part 'src/view/components/l_visibility.dart';
part 'src/view/components/list_item.dart';

part 'src/view/editors/l_checkbox.dart';
part 'src/view/editors/l_editor.dart';
part 'src/view/editors/l_editor_std.dart';
part 'src/view/editors/l_input.dart';
part 'src/view/editors/l_radio.dart';
part 'src/view/editors/l_select.dart';
part 'src/view/editors/select_data_list.dart';
part 'src/view/editors/select_option.dart';

part 'src/view/form/l_form.dart';
part 'src/view/form/l_form_compound.dart';

part 'src/view/utility/html0.dart';

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
   * Initialize
   */
  static Future<bool> init() {
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
}
