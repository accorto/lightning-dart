/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

/**
 * Lightning Dart Business Graphics
 * based on DRecord and built on Charted
 * include
    <link rel="stylesheet" href="packages/lightning/assets/styles/charted_theme.css">
 *
 */
library lightning_graph;

import 'dart:html';

import 'package:logging/logging.dart';
import 'package:intl/intl.dart';

import 'lightning_ctrl.dart';

import 'package:charted/charted.dart';
import 'package:observe/observe.dart';


part 'src/graph/graph_by.dart';
part 'src/graph/graph_calc.dart';
part 'src/graph/graph_dialog.dart';
part 'src/graph/graph_element.dart';
part 'src/graph/graph_panel.dart';
part 'src/graph/engine_base.dart';
part 'src/graph/engine_charted.dart';
part 'src/graph/engine_charted_theme.dart';

/**
 * Business Graphics based on DRecord
 */
class LightningGraph {

}
