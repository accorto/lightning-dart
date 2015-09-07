/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Search Input
 */
class LInputSearch extends LInput {

  /// The Icon
  final LIcon _iconRight = new LIconUtility(LIconUtility.SEARCH);


  /// Search Input
  LInputSearch(String name, {String idPrefix, bool inGrid:false})
    : super(name, EditorI.TYPE_SEARCH, idPrefix:idPrefix, inGrid:inGrid);

  /// Search Input
  LInputSearch.from(DColumn column, {String idPrefix, bool inGrid:false})
    : super.from(column, EditorI.TYPE_SEARCH, idPrefix:idPrefix, inGrid:inGrid);

  @override
  LIcon getIconRight() => _iconRight;


} // LInputSearch
