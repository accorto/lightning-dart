/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Pill
 */
class LPill {

  static const String C_PILL = "slds-pill";
  static const String C_PILL__LABEL = "slds-pill__label";


  final SpanElement element = new SpanElement()
    ..classes.add(C_PILL);

  /**
   * Pill
   * [value] optional data-value on elements
   * if [onRemoveClick] is provided a remove button is created
   */
  LPill(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      LIcon icon, LImage img,
      void onRemoveClick(MouseEvent evt)) {
    // span .pill

    Element content;
    if (href == null) {
      // - span .pill__label
      content = new SpanElement()
        ..classes.add(C_PILL__LABEL);
    } else {
      // - a .pill__label
      String hrefValue = href;
      if (hrefValue == null || hrefValue.isEmpty)
        hrefValue = "#";
      content = new AnchorElement()
        ..classes.add(C_PILL__LABEL)
        ..href = hrefValue;
      if (onLinkClick != null) {
        content.onClick.listen(onLinkClick);
      }
    }
    element.append(content);
    if (icon != null) {
      icon.size = LIcon.C_ICON__SMALL;
      content.append(icon.element);
      content.appendText(label);
    } else if (img != null) {
      img.size = LImage.C_AVATAR__X_SMALL;
      content.append(img.element);
      content.appendText(label);
    } else {
      content.text = label;
    }
    if (value != null) {
      element.attributes[Html0.DATA_VALUE] = value;
      content.attributes[Html0.DATA_VALUE] = value;
    }

    // - button -- Remove
    if (onRemoveClick != null) {
      LButton remove = new LButton.iconBare("remove",
        new LIconUtility("close"),
        lPillRemove());
      if (value != null)
        remove.dataValue = value;
      remove.onClick.listen(onRemoveClick);
      element.append(remove.element);
    }
  } // LPill

  /// Base Pill
  LPill.base(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      void onRemoveClick(MouseEvent evt))
      : this(label, value, href, onLinkClick, null, null, onRemoveClick);
  /// Unlink Pill
  LPill.unlink(String label, String value)
      : this(label, value, null, null, null, null, null);
  /// Icon Pill
  LPill.icon(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      LIcon icon, void onRemoveClick(MouseEvent evt))
      : this(label, value, href, onLinkClick, icon, null, onRemoveClick);
  /// Image Pill
  LPill.image(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      LImage img, void onRemoveClick(MouseEvent evt))
      : this(label, value, href, onLinkClick, null, img, onRemoveClick);

  /// Trl
  static String lPillRemove() => Intl.message("Remove", name: "lPillRemove", args: []);

} // LPill
