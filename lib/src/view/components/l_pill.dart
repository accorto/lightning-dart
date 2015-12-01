/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Pill
 */
class LPill extends LComponent {

  /// slds-pill - Initializes pill | Required
  static const String C_PILL = "slds-pill";
  /// slds-pill__label - Initializes pill label | Required
  static const String C_PILL__LABEL = "slds-pill__label";
  /// slds-pill__icon - Initializes pill icon that sits to the left of the label | Required
  static const String C_PILL__ICON = "slds-pill__icon";
  /// slds-pill__remove - Initializes remove icon in pill that sits to the right of the label | Required
  static const String C_PILL__REMOVE = "slds-pill__remove";
  /// slds-pill__container - Container to hold pill(s) | Required
  static const String C_PILL__CONTAINER = "slds-pill__container";
  /// slds-pill--bare - Modifier that removes border and background from a pill
  static const String C_PILL__BARE = "slds-pill--bare";



  /// Pill Element
  final SpanElement element = new SpanElement()
    ..classes.add(C_PILL);

  // Content (a|span)
  Element _content;
  /// Remove button
  LButton _remove;

  /**
   * Pill
   * [value] optional data-value on elements
   * if [onRemoveClick] is provided a remove button is created
   * if a [href] is provided, a link is created, otherwise a span
   */
  LPill(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      LIcon icon, LImage img,
      void onRemoveClick(MouseEvent evt)) {
    // span .pill
    if (href == null) {
      // - span .pill__label
      _content = new SpanElement()
        ..classes.add(C_PILL__LABEL);
    } else {
      // - a .pill__label
      String hrefValue = href;
      if (hrefValue == null || hrefValue.isEmpty)
        hrefValue = "#";
      _content = new AnchorElement()
        ..classes.add(C_PILL__LABEL)
        ..href = hrefValue;
    }
    if (onLinkClick != null) {
      _content.onClick.listen(onLinkClick);
    }
    element.append(_content);
    _icon = icon;
    _image = img;

    // - button -- Remove
    if (onRemoveClick != null) {
      _remove = new LButton.iconBare("remove",
        new LIconUtility(LIconUtility.CLOSE), lPillRemove());
      _remove.classes.add(C_PILL__REMOVE);
      _remove.onClick.listen(onRemoveClick);
      element.append(_remove.element);
    }
    this.label = label; // rebuilds
    this.value = value;
  } // LPill


  String get label => _label;
  void set label (String newValue) {
    _label = newValue;
    _rebuild();
  }
  String _label;


  /// get value
  String get value => element.attributes[Html0.DATA_VALUE];
  void set value (String newValue) {
    if (newValue != null) {
      element.attributes[Html0.DATA_VALUE] = newValue;
      _content.attributes[Html0.DATA_VALUE] = newValue;
      if (_remove != null)
        _remove.dataValue = newValue;
    }
  } // setValue


  LIcon get icon => _icon;
  void set icon (LIcon newValue) {
    _icon = newValue;
    _rebuild();
  }
  LIcon _icon;

  LImage get image => _image;
  void set img (LImage newValue) {
    _image = newValue;
    _rebuild();
  }
  LImage _image;

  /// href if link
  String get href => _content is AnchorElement ? (_content as AnchorElement).href : null;
  /// update href - ignored if not a link
  void set href (String newValue) {
    if (_content is AnchorElement) {
      String theHref = newValue;
      if (theHref == null || theHref.isEmpty)
        theHref = "#";
      (_content as AnchorElement).href = theHref;
    }
  }

  /// rebuild content
  void _rebuild() {
    if (_icon != null) {
      _icon.classes.add(C_PILL__ICON);
      _content.append(_icon.element);
      _content.appendText(_label);
    } else if (_image != null) {
      _image.size = LImage.C_AVATAR__X_SMALL;
      _content.append(_image.element);
      _content.appendText(_label);
    } else {
      _content.text = _label;
    }
  } // rebuild

  /// Base Pill
  LPill.base(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      void onRemoveClick(MouseEvent evt))
      : this(label, value, href, onLinkClick, null, null, onRemoveClick);
  /// Unlink Pill
  LPill.unlink(String label, String value)
      : this(label, value, null, null, null, null, null);
  /// Icon Pill
  LPill.iconPill(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      LIcon icon, void onRemoveClick(MouseEvent evt))
      : this(label, value, href, onLinkClick, icon, null, onRemoveClick);
  /// Image Pill
  LPill.imagePill(String label, String value,
      String href, void onLinkClick(MouseEvent evt),
      LImage img, void onRemoveClick(MouseEvent evt))
      : this(label, value, href, onLinkClick, null, img, onRemoveClick);

  /// Trl
  static String lPillRemove() => Intl.message("Remove", name: "lPillRemove", args: []);

} // LPill
