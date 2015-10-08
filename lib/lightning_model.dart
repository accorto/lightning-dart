/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

/**
 * Lightning Dart Model level Functionality.
 *
 * Protocol Buffers based Model and utilities.
 * Not required if only View layer used.
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
import 'protoc/structure_pb.dart';
import 'protoc/data_pb.dart';
import 'protoc/display_pb.dart';
import 'protoc/rr_pb.dart';
import 'protoc/rr_data_pb.dart';
//import 'protoc/rr_display.pb.dart';

export 'protoc/structure_pb.dart';
export 'protoc/data_pb.dart';
export 'protoc/display_pb.dart';
export 'protoc/rr_pb.dart';
export 'protoc/rr_data_pb.dart';
export 'protoc/rr_display_pb.dart';


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
