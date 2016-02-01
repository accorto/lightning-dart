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

  /// css for positioning
  //static CssStyleSheet _cssStyleSheet;
  /// Css Rule for this
  //CssStyleRule _cssRule;

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
    wrapper = new DivElement();
    wrapper.style.position = "relative";
    wrapper.style.display = "inline-block";
    wrapper.append(target);
    wrapper.append(pop);

    pop.style.float = "left";
    pop.style.position = "absolute";
    pop.style.textAlign = "left"; // footer is right aligned

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
    Rectangle targetRect = target.getBoundingClientRect();
    // Contained in Modal (cuts off)
    Rectangle contentRect = null;
    Element parent = target.parent;
    while (parent != null && contentRect == null) {
      if (parent.classes.contains(LModal.C_MODAL__CONTENT)) {
        contentRect = parent.getBoundingClientRect();
      }
      parent = parent.parent;
    }
    //
    pop.classes.remove(LVisibility.C_HIDE);
    // explicit width
    if (popWidth != null) {
      pop.style.width = popWidth;
    } else {
      pop.style.maxWidth = "20rem";
    }
    // should calculate max required with from content
    Rectangle elementRect = pop.getBoundingClientRect();
    //_log.fine("element ${elementRect}");

    const double nubHeight = 12.0;
    const double nubWidth = 12.0;

    // show above
    if (LPopover._NUBBINS_BOTTOM.contains(_nubbin)) {
      double top = -(elementRect.height + nubHeight);
      pop.style.top = "${top.toInt()}px"; // negative - push up
      num left = -(elementRect.width - targetRect.width) / 2;
      // enough room on left side?
      num deltaLeft = targetRect.left + left;
      if (contentRect != null)
        deltaLeft -= contentRect.left;
      if (deltaLeft > 0) { // enough room on left side
        pop.style.left = "${left.toInt()}px";
      } else {
        left = elementRect.left - targetRect.left; // |- flush left
        if (contentRect != null)
          left += contentRect.left;
        pop.style.left = "${left}px";
        nubbin = LPopover.C_NUBBIN__BOTTOM_LEFT;

        // num popLeft = (targetRect.width / 2) - left;
        // set pseudo before/after element css left
        //_setCssPseudoClass(popLeft);
      }
    }
    // show below
    else if (LPopover._NUBBINS_TOP.contains(_nubbin)) {
      double top = targetRect.height + nubHeight;
      pop.style.top = "${top.toInt()}px";
      double left = -(elementRect.width - targetRect.width) / 2;
      pop.style.left = "${left.toInt()}px";
    }
    // show right
    else if (LPopover._NUBBINS_LEFT.contains(_nubbin)) {
      double top = -(elementRect.height - targetRect.height) / 2;
      pop.style.top = "${top.toInt()}px";
      double left = targetRect.width + nubWidth;
      pop.style.left = "${left.toInt()}px";
    }
    // show left
    else if (LPopover._NUBBINS_RIGHT.contains(_nubbin)) {
      double top = -(elementRect.height - targetRect.height) / 2;
      pop.style.top = "${top.toInt()}px";
      double left = - (elementRect.width + nubWidth);
      pop.style.left = "${left.toInt()}px";
    }
  } // show

  /* set css for pseudo classes
  void _setCssPseudoClass(num popLeft) {
    //String id = _content.id;
    //if (id == null || id.isEmpty) {
    //  id = LComponent.createId(null, null, autoPrefixId: "pop");
    //  _content.id = id;
    //}
    // List<CssRule> rulesB = window.getMatchedCssRules(_content, ':before');
    // modifies css class - need to create new rule

    //if (_cssRule == null) {
    //  if (_cssStyleSheet == null) {
    //    StyleElement se = new StyleElement();
    //    document.head.append(se);
    //    _cssStyleSheet = se.sheet as CssStyleSheet;
    //  }
    //  _cssStyleSheet.addRule("#${id}:before, #${id}:after", "left: ${popLeft}px");
    //  int length = _cssStyleSheet.cssRules.length;
    //  _cssRule = _cssStyleSheet.cssRules[length - 1];
    //} else {
    //  _cssRule.style.left = "${popLeft}px";
    //}
  } // setCssPseudoClass */


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
