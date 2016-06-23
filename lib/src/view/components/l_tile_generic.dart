/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Generic Tile with
 * - optional icon/image,
 * - optional actions
 * and
 * - text (one or more lines of text) [addText]
 * - items (one line with multiple items [addItem)
 * - entries (one or more label/value pairs) [addEntry]
 */
class LTileGeneric
    extends LTile {

  /// Figure Image Div - if image
  DivElement _figure;
  /// Body Text Div - if image
  DivElement _body;

  DivElement _detail;
  UListElement _detailList;

  /// Heading
  final DivElement _heading = new DivElement()
    ..classes.addAll([LGrid.C_GRID, LGrid.C_GRID__ALIGN_SPREAD, LGrid.C_HAS_FLEXI_TRUNCATE]);

  /// Dropdown button
  final LButton _button = new LButton(new ButtonElement(), "action", null,
    buttonClasses: [LButton.C_BUTTON__ICON_BORDER_FILLED, LButton.C_BUTTON__ICON_X_SMALL, LGrid.C_SHRINK_NONE],
    icon: new LIconUtility(LIconUtility.DOWN, color: LButton.C_BUTTON__ICON__HINT, size: LButton.C_BUTTON__ICON__SMALL),
    assistiveText: AppsAction.appsActions());
  /// Dropdown
  LDropdown _dropdown;

  /**
   * Generic Tile
   */
  LTileGeneric(String title, {LIcon icon, String imgSrc, ImageElement img, String alt}) {
    // Image
    if (icon != null || imgSrc != null || img != null) {
      element.classes.add(LMedia.C_MEDIA);
      _figure = new DivElement()
        ..classes.add(LMedia.C_MEDIA__FIGURE);
      element.append(_figure);
      if (icon != null) {
        icon.element.attributes[Html0.ARIA_HIDDEN] = "true";
        _figure.append(icon.element);
      } else {
        if (imgSrc != null) {
          img = new ImageElement(src:LImage.assetsSrc(imgSrc));
        }
        if (img != null) {
          if (alt != null)
            img.alt = alt;
          DivElement wrap = new DivElement()
            ..classes.addAll([LImage.C_AVATAR, LImage.C_AVATAR__SMALL, LImage.C_AVATAR__CIRCLE])
            ..append(img);
          _figure.append(wrap);
        }
      }
      /// Body Text Div
      _body = new DivElement()
        ..classes.add(LMedia.C_MEDIA__BODY);
      element.append(_body);
      _body.append(_heading);
    } else {
      element.append(_heading);
    }

    // Title link
    _heading.append(_title);
    _title.append(titleLink);
    titleLink.text = title;
  } // LTileGeneric

  /// add actions
  void addActions(List<AppsAction> actions, {Object actionReference}) {
    if (actions == null || actions.isEmpty)
      return;
    if (_dropdown == null) {
      element.classes.add(LButton.C_HINT_PARENT); // action
      _dropdown = new LDropdown(_button, element.id,
      dropdownClasses: [LDropdown.C_DROPDOWN__RIGHT, LDropdown.C_DROPDOWN__ACTIONS]);
      _heading.append(_dropdown.element);
    }
    // add actions
    for (AppsAction action in actions) {
      LDropdownItem item = action.asDropdown(false);
      item.reference = actionReference;
      _dropdown.dropdown.addDropdownItem(item);
    }
  } // addActions


  /// Get Detail Div
  DivElement get detail {
    if (_detail == null) {
      _detail = createDetail(LTile.CLASSES_DETAIL);
      if (_body == null)
        element.append(_detail);
      else
        _body.append(_detail);
    }
    return _detail;
  }

  /// Get Detail ul
  UListElement get detailList {
    if (_detailList == null) {
      _detailList = createDetailList([LList.C_LIST__HORIZONTAL, LList.C_HAS_DIVIDERS__RIGHT]);
      if (_body == null)
        element.append(_detailList);
      else
        _body.append(_detailList);
    }
    return _detailList;
  }

} // LTileGeneric
