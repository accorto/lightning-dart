/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3  http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://lightningdart.com
 */

part of lightning_dart;

/**
 * Popover/Tooltip management
 */
abstract class LPopbase
    extends LComponent {

  static final Logger _log = new Logger("LPopbase");

  /// Popup Element
  DivElement get element {
    if (wrapper != null)
      return wrapper;
    return pop;
  }

  /// Set PopWidth explicitly e.g. 20rem
  String popWidth = null;

  /// wrap target + pop
  DivElement wrapper;
  /// Trigger Element to show Popover
  Element target;
  /// Pop Element (popover)
  DivElement get pop;

  bool _clickShow = false;

  /// set theme
  void set theme (String newValue) {
    pop.classes.add(newValue);
  }

  void set nubbin (String newValue) {
    pop.classes.removeAll(LPopover._NUBBINS);
    _nubbin = newValue;
    pop.classes.add(newValue);
  }
  String get nubbin => _nubbin;
  String _nubbin;

  /// Show pop above [component]
  void showAbove(LComponent component, {
      bool showOnHover: true, bool showOnClick: true}) {
    showAboveElement(component.element,
                         showOnHover:showOnHover, showOnClick:showOnClick);
  }
  /// Show pop above [target]
  void showAboveElement(Element target, {
      bool showOnHover: true, bool showOnClick: true}) {
    nubbin = LPopover.C_NUBBIN__BOTTOM;
    _showPrep(target, showOnHover, showOnClick);
  }

  /// Show pop below [component]
  void showBelow(LComponent component, {
      bool showOnHover: true, bool showOnClick: true}) {
    showBelowElement(component.element,
                         showOnHover:showOnHover, showOnClick:showOnClick);
  }
  /// Show pop below [target]
  void showBelowElement(Element target, {
      bool showOnHover: true, bool showOnClick: true}) {
    nubbin = LPopover.C_NUBBIN__TOP;
    _showPrep(target, showOnHover, showOnClick);
  }

  /// Show pop right [component]
  void showRight(LComponent component, {
      bool showOnHover: true, bool showOnClick: true}) {
    showRightElement(component.element,
                         showOnHover:showOnHover, showOnClick:showOnClick);
  }
  /// Show pop right [target]
  void showRightElement(Element target, {
      bool showOnHover: true, bool showOnClick: true}) {
    nubbin = LPopover.C_NUBBIN__LEFT;
    _showPrep(target, showOnHover, showOnClick);
  }

  /// Show pop left [component]
  void showLeft(LComponent component, {
      bool showOnHover: true, bool showOnClick: true}) {
    showLeftElement(component.element,
                        showOnHover:showOnHover, showOnClick:showOnClick);
  }
  /// Show pop left [target]
  void showLeftElement(Element target, {
      bool showOnHover: true, bool showOnClick: true}) {
    nubbin = LPopover.C_NUBBIN__RIGHT;
    _showPrep(target, showOnHover, showOnClick);
  }


  /// show preparation - attach, triggers
  void _showPrep(Element target, bool showOnHover, bool showOnClick) {
    this.target = target;
    //
    wrapper = new DivElement()
      ..classes.add("pop-wrapper")
      ..append(target)
      ..append(pop);

    pop.style
      ..position = "absolute"
      ..textAlign = "left"; // footer is right aligned

    hide();
    // trigger
    if (showOnHover) {
      target.onMouseEnter.listen((MouseEvent evt) {
        _show();
      });
      target.onMouseLeave.listen((MouseEvent evt) {
        if (!_clickShow) {
          hide();
        }
      });
    }
    if (showOnClick) {
      target.onClick.listen((MouseEvent evt){
        _clickShow = !_clickShow;
        if (_clickShow) {
          _show();
        } else {
          hide();
        }
      });
    }
  } // showPrep

  // do show
  void _show() {
    //
    pop.classes.remove(LVisibility.C_HIDE);
    // explicit width
    if (popWidth != null) {
      pop.style.width = popWidth;
    } else {
      pop.style.width = "20rem";
    }
    // Contained in Modal (cuts off)
    Rectangle contentRect = null;
    Element parent = target.parent;
    while (parent != null && contentRect == null) {
      if (parent.classes.contains(LModal.C_MODAL__CONTENT)) {
        contentRect = parent.getBoundingClientRect(); // popover (not tooltip)
      }
      parent = parent.parent;
    }

    // calc position
    pop.style
      ..left = "0"
      ..top = "0";
    Rectangle targetRect = target.getBoundingClientRect();
    Rectangle popRect = pop.getBoundingClientRect();
    //_log.fine("element ${elementRect}");
    const double nubHeight = 12.0;
    const double nubWidth = 12.0;

    // show above
    if (LPopover._NUBBINS_BOTTOM.contains(_nubbin)) {
      double top = -(popRect.height + nubHeight);
      pop.style.top = "${top.toInt()}px"; // negative - push up
      // enough room on left side?
      num left = -(popRect.width - targetRect.width) / 2;
      num deltaLeft = targetRect.left + left;
      if (contentRect != null)
        deltaLeft -= contentRect.left;
      if (deltaLeft > 0) { // enough room on left side
        pop.style.left = "${left.toInt()}px";
        //_log.finer("show above center left=${left} deltaLeft=${deltaLeft} popLeft=${popRect.left} targetLeft=${targetRect.left} contentLeft=${contentRect == null ? "-" : contentRect.left}");
      } else {
        left = popRect.left - targetRect.left; // |- flush left
        pop.style.left = "${left}px";
        //_log.fine("show above left left=${left} deltaLeft=${deltaLeft} popLeft=${popRect.left} targetLeft=${targetRect.left} contentLeft=${contentRect == null ? "-" : contentRect.left}");
        nubbin = LPopover.C_NUBBIN__BOTTOM_LEFT;
      }
    }
    // show below
    else if (LPopover._NUBBINS_TOP.contains(_nubbin)) {
      double top = targetRect.height + nubHeight;
      pop.style.top = "${top.toInt()}px";
      double left = -(popRect.width - targetRect.width) / 2;
      pop.style.left = "${left.toInt()}px";
    }
    // show right
    else if (LPopover._NUBBINS_LEFT.contains(_nubbin)) {
      double top = -(popRect.height - targetRect.height) / 2;
      pop.style.top = "${top.toInt()}px";
      double left = targetRect.width + nubWidth;
      pop.style.left = "${left.toInt()}px";
    }
    // show left
    else if (LPopover._NUBBINS_RIGHT.contains(_nubbin)) {
      double top = -(popRect.height - targetRect.height) / 2;
      pop.style.top = "${top.toInt()}px";
      double left = - (popRect.width + nubWidth);
      pop.style.left = "${left.toInt()}px";
    }
  } // show

  /// Showing
  bool get show => !pop.classes.contains(LVisibility.C_HIDE);
  /// Show pop
  void set show (bool newValue) {
    if (newValue)
      _show();
    else
      hide();
  }

  /// hide
  void hide() {
    pop.classes.add(LVisibility.C_HIDE);
  }

} // LPopbase
