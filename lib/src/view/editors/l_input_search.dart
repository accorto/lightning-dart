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
  LIcon get _icon => new LIconUtility(LIconUtility.SEARCH);


  /// Search Input
  LInputSearch(String name, {String idPrefix, bool inGrid:false, bool withClearValue:false})
    : super(name, EditorI.TYPE_SEARCH, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue);

  /// Search Input
  LInputSearch.from(DataColumn dataColumn, {String idPrefix, bool inGrid:false, bool withClearValue:false})
    : super.from(dataColumn, EditorI.TYPE_SEARCH, idPrefix:idPrefix, inGrid:inGrid, withClearValue:withClearValue);

  @override
  LIcon getIconRight() => _icon;


} // LInputSearch
