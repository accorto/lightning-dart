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
  LInputSearch(String name, {String idPrefix}) : super(name, EditorI.TYPE_SEARCH, idPrefix:idPrefix);

  /// Search Input
  LInputSearch.from(DColumn column, {String idPrefix}) :super.from(column, idPrefix:idPrefix, type:EditorI.TYPE_SEARCH);

  @override
  LIcon getIconRight() => _iconRight;


} // LInputSearch
