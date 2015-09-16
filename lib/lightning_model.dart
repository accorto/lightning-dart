/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

/**
 * Lightning Dart Model level Functionality.
 *
 * Uses Protocol Buffers.
 */
library lightning_model;

import 'dart:async';
import 'dart:html';
import 'dart:js';

// Packages
import 'package:logging/logging.dart';

// International
import 'intl/ldart_messages_all.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_browser.dart';
import 'package:intl/date_symbol_data_local.dart';

// Protocol Buffers
//import 'package:protobuf/protobuf.dart';
//import 'dart:typed_data';
import 'package:fixnum/fixnum.dart';

//Protocol Buffers - Generated
import 'protoc/structure.pb.dart';
import 'protoc/data.pb.dart';
import 'protoc/display.pb.dart';
import 'protoc/rr.pb.dart';
import 'protoc/rr_data.pb.dart';
import 'protoc/rr_display.pb.dart';

export 'protoc/structure.pb.dart';
export 'protoc/data.pb.dart';
export 'protoc/display.pb.dart';
export 'protoc/rr.pb.dart';
export 'protoc/rr_data.pb.dart';
export 'protoc/rr_display.pb.dart';


import 'dart:indexed_db';
import 'dart:web_sql';

// Model Functionality
part 'src/model/client_env.dart';
part 'src/model/data_column.dart';
part 'src/model/data_context.dart';
part 'src/model/data_record.dart';
part 'src/model/data_type_util.dart';
part 'src/model/data_util.dart';
part 'src/model/duration_util.dart';
part 'src/model/editor_i.dart';
part 'src/model/preference.dart';
part 'src/model/preference_storage.dart';
part 'src/model/record_sorting.dart';
part 'src/model/string_tokenizer.dart';
part 'src/model/tz.dart';
part 'src/model/ui_util.dart';
