/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Badge / Label
 */
class LBadge extends LComponent {

  /// slds-badge (span): Initializes a Badge
  static const String C_BADGE = "slds-badge";

  /// Badge Element
  final SpanElement element = new SpanElement()
    ..classes.add(C_BADGE);

  /**
   * Badge with optional theme
   */
  LBadge(String label, {String theme}) {
    element.text = label;
    if (theme != null && theme.isNotEmpty)
      element.classes.add(theme);
  }

  /// Default Theme
  LBadge.def(String label) : this(label, theme: LTheme.C_THEME__DEFAULT);
  /// Shade Theme
  LBadge.shade(String label) : this(label, theme: LTheme.C_THEME__SHADE);
  /// Inverse Theme
  LBadge.inverse(String label) : this(label, theme: LTheme.C_THEME__INVERSE);
  /// Inverse Theme
  LBadge.altInverse(String label) : this(label, theme: LTheme.C_THEME__ALT_INVERSE);

  /// Info Theme
  LBadge.info(String label) : this(label, theme: LTheme.C_THEME__INFO);
  /// Warning Theme
  LBadge.warning(String label) : this(label, theme: LTheme.C_THEME__WARNING);
  /// Success Theme
  LBadge.success(String label) : this(label, theme: LTheme.C_THEME__SUCCESS);
  /// Error Theme
  LBadge.error(String label) : this(label, theme: LTheme.C_THEME__ERROR);


}
