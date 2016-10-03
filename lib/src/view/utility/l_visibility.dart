/*
 * Copyright (c) 2016 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Visibility
 */
class LVisibility {

  /// slds-hide (any element): Hides an element from the page by setting display propery to none - An element hidden with this class will take up no space on the page and will not be announced by screenreaders.
  static const String C_HIDE = "slds-hide";
  /// slds-show (the hidden element): Shows the element by setting display property to block - This is toggled on the element. .slds-hide class is removed and .slds-show is added.
  static const String C_SHOW = "slds-show";
  /// slds-show--inline-block (the hidden element): Shows the element by setting display to inline-block - This is toggled on the element. .slds-hide class is removed and .slds-show--inline-block is added.
  static const String C_SHOW__INLINE_BLOCK = "slds-show--inline-block";
  /// slds-hidden (any element): Hides an element from the page by setting the visibility property to hidden - An element hidden with this class will reserve the normal space on the page and will not be announced by screenreaders.
  static const String C_HIDDEN = "slds-hidden";
  /// slds-visible (the hidden element): Shows the element by setting the visibility property to visible - This is toggled on the element. .slds-hidden class is removed and .slds-visible is added.
  static const String C_VISIBLE = "slds-visible";

  /// slds-transition-hide (any element): Hides an element from the page by setting the opacity property set to 0 - This works like the .slds-hidden class and reserves the space but allows you to add the transition property to transition the speed that it is shown or hidden.
  static const String C_TRANSITION_HIDE = "slds-transition-hide";
  /// slds-transition-show (the hidden element): Shows the element using the opacity property set to 1 - This is toggled on the element. .slds-transition-hide class is removed and .slds-transition-show is added.
  static const String C_TRANSITION_SHOW = "slds-transition-show";

  /// slds-is-collapsed (Any containing element): Hides elements inside a parent - This hides the elements contained inside the container by controlling the height and overflow properties.
  static const String C_IS_COLLAPSED = "slds-is-collapsed";
  /// slds-is-expanded (the collapsed element): Shows the elements inside the parent
  static const String C_IS_EXPANDED = "slds-is-expanded";

  /// slds-collapsed (Any containing element): Hides elements inside a parent - This hides the elements contained inside the container by controlling the height and overflow properties.
  //static const String C_COLLAPSED = "slds-collapsed";
  /// slds-expanded (the collapsed element): Shows the elements inside the parent
  //static const String C_EXPANDED = "slds-expanded";

  /// slds-assistive-text (any element): Hides an element yet enables a screen reader to read the element that is hidden - This should be used over other methods when you don't want to hide from screenreaders
  static const String C_ASSISTIVE_TEXT = "slds-assistive-text";
  /// slds-assistive-text--focus (slds-assistive-text): Enables .slds-assistive-text to become visible on focus
  static const String C_ASSISTIVE_TEXT__FOCUS = "slds-assistive-text--focus";



  /// Show on 320px and up
  static const String C_SHOW_X_SMALL = "slds-x-small-show";
  static const String C_SHOW_X_SMALL_ONLY = "slds-x-small-show-only";
  static const String C_HIDE_MAX_X_SMALL = "slds-max-x-small-hide";

  /// Show on 480px and up
  static const String C_SHOW_SMALL = "slds-small-show";
  static const String C_SHOW_SMALL_ONLY = "slds-small-show-only";
  static const String C_HIDE_MAX_SMALL = "slds-max-small-hide";

  /// Show on 768px and up
  static const String C_SHOW_MEDIUM = "slds-medium-show";
  static const String C_SHOW_MEDIUM_ONLY = "slds-medium-show-only";
  static const String C_HIDE_MAX_MEDIUM = "slds-max-medium-hide";

  /// Show on 1024px and up
  static const String C_SHOW_LARGE = "slds-large-show";


  /// trigger__click show/hide
  static const String C_IS_OPEN = "slds-is-open";

  /// active selection
  static const String C_ACTIVE = "slds-active";

  /// visible on hover/focus (*extension*)
  static const String C_AUTO_VISIBLE = "auto-visible";

} // LVisibility
