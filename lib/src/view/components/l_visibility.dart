/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Visibility
 */
class LVisibility {

  /// slds-hide - Hides an element from the page by setting display property to none
  static const String C_HIDE = "slds-hide";
  /// slds-show - Shows the element by setting display property to block
  static const String C_SHOW = "slds-show";
  /// slds-show--inline-block - Shows the element by setting display to inline-block
  static const String C_SHOW__INLINE_BLOCK = "slds-show--inline-block";
  /// slds-hidden - Hides an element from the page by setting the visibility property to hidden
  static const String C_HIDDEN = "slds-hidden";
  /// slds-visible - Shows the element by setting the visibility property to visible
  static const String C_VISIBLE = "slds-visible";

  /// slds-transition-hide - Hides an element from the page by setting the opacity property set to 0
  static const String C_TRANSITION_HIDE = "slds-transition-hide";
  /// slds-transition-show - Shows the element using the opacity property set to 1
  static const String C_TRANSITION_SHOW = "slds-transition-show";

  /// slds-collapsed - Hides elements inside a parent
  static const String C_COLLAPSED = "slds-collapsed";
  /// slds-expanded - Shows the elements inside the parent
  static const String C_EXPANDED = "slds-expanded";

  /// slds-assistive-text - Hides an element yet enables a screen reader to read the element that is hidden
  static const String C_ASSISTIVE_TEXT = "slds-assistive-text";



  /// active selection
  static const String C_ACTIVE = "slds-active";

  /// visible on hover/focus (*extension*)
  static const String C_AUTO_VISIBLE = "auto-visible";

} // LVisibility
