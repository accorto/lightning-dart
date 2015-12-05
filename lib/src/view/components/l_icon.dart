/*
 * Copyright (c) 2015 Accorto, Inc. All Rights Reserved
 * License: GPLv3   http://www.gnu.org/licenses/gpl-3.0.txt
 * License options+support:  https://www.lightningdart.com
 */

part of lightning_dart;

/**
 * Component Icon
 * https://www.getslds.com/components/icons
 * https://www.getslds.com/resources/icons
 *
 *  Icons
 *
 *      all sprites
 *        <symbol id="xx" viewBox="0 0 24 24">
 *
 *      action
 *        <svg xmlns="http://www.w3.org/2000/svg" width="52" height="52" viewBox="0 0 52 52">
 *          <g fill="#fff">
 *
 *      custom
 *        <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
 *          <g fill="#fff">
 *
 *      doctype
 *        <svg xmlns="http://www.w3.org/2000/svg" width="56" height="64" viewBox="0 0 56 64">
 *          // includes fill !
 *
 *      standard (with 20 px margin)
 *        <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" viewBox="0 0 100 100">
 *          <g fill="#fff">
 *
 *      utility
 *        <svg xmlns="http://www.w3.org/2000/svg" width="52" height="52" viewBox="0 0 52 52">
 *          <path fill="#fff"
 *
 */
class LIcon {

  /// slds-icon - Defines an svg as an icon | Required
  static const String C_ICON = "slds-icon";
  /// slds-icon-text-default - Creates a text-colored fill color for utility icons |
  static const String C_ICON_TEXT_DEFAULT = "slds-icon-text-default";
  /// slds-icon-text-warning - Creates a warning colored fill color |
  static const String C_ICON_TEXT_WARNING = "slds-icon-text-warning";
  static const String C_ICON_TEXT_ERROR = "slds-icon-text-error";
  static const String C_ICON_TEXT_SUCCESS = "slds-icon-text-success";
  /// slds-icon--x-small - Creates a 1rem by 1rem icon |
  static const String C_ICON__X_SMALL = "slds-icon--x-small";
  /// slds-icon--small - Creates a 1.5rem by 1.5rem icon |
  static const String C_ICON__SMALL = "slds-icon--small";
  /// slds-icon--large - Creates a 3rem by 3rem icon |
  static const String C_ICON__LARGE = "slds-icon--large";
  /// slds-icon__container - Creates the rounded square background |
  static const String C_ICON__CONTAINER = "slds-icon__container";
  /// slds-icon__container--circle - Creates a circular icon shape |
  static const String C_ICON__CONTAINER__CIRCLE = "slds-icon__container--circle";

  /// slds-icon--selected - Creates icon when a user selects a .slds-dropdown__item
  static const String C_ICON__SELECTED = "slds-icon--selected";

  /// rotate icon right 90
  static const String C_ROTATE_RIGHT = "rotate-right";
  /// rotate icon left -90
  static const String C_ROTATE_LEFT = "rotate-left";


  /// Prefix for asset references
  static const String HREF_PREFIX = "packages/lightning";

  static const String SPRITE_ACTION =
      "/assets/icons/action-sprite/svg/symbols.svg#"; // announcement
  static const String SPRITE_CUSTOM =
      "/assets/icons/custom-sprite/svg/symbols.svg#"; // custom1
  static const String SPRITE_DOCTYPE =
      "/assets/icons/doctype-sprite/svg/symbols.svg#"; // attachment
  static const String SPRITE_STANDARD =
      "/assets/icons/standard-sprite/svg/symbols.svg#"; // account
  static const String SPRITE_UTILITY =
      "/assets/icons/utility-sprite/svg/symbols.svg#"; // 3dots


  /// Create Img vs. use
  static bool createImg() {
    if (_createImg == null) {
      _createImg = !document.implementation.hasFeature("http://www.w3.org/TR/SVG11/feature#BasicStructure", "1.1");
      if (_createImg) {
        window.alert("Browser not capable displaying SVG - images not displayed");
      }
    }
    return _createImg;
  }
  static bool _createImg;



  /**
   * Create Icon from [iconSpec] xx|yy|zz
   * where xx is action|standard|utility|custom|doctype
   * and yy is the name
   * and zz is the optional color (overwritten if [color] is specified
   */
  static LIcon create(String iconSpec,
      {String className: LIcon.C_ICON,
      String size,
      String color,
      List<String> addlCss}) {
    //
    String linkName = null;
    String linkPrefix = null;
    //
    if (iconSpec == null || iconSpec.isEmpty) {
      linkName = LIconUtility.BUCKET;
      linkPrefix = SPRITE_UTILITY;
    } else {
      List<String> parts = iconSpec.split("|");
      if (parts.length > 1) {
        String xx = parts[0];
        linkName = parts[1];
        if (color == null && parts.length > 2) {
          color = parts[2];
        }
        if (xx == "utility") {
          linkPrefix = SPRITE_UTILITY;
        } else if (xx == "action") {
          linkPrefix = SPRITE_ACTION;
          if (color == null)
            color = "${LIconAction.C_ICON_ACTION_}${linkName}";
        } else if (xx == "standard") {
          linkPrefix = SPRITE_STANDARD;
          if (color == null)
            color = "${LIconStandard.C_ICON_STANDARD_}${linkName}";
        } else if (xx == "custom") {
          linkPrefix = SPRITE_CUSTOM;
          if (color == null)
            color = "${LIconCustom.C_ICON_}${linkName}";
        } else if (xx == "doctype") {
          linkPrefix = SPRITE_DOCTYPE;
        }
      } else {
        linkName = LIconUtility.BUILDER;
        linkPrefix = SPRITE_UTILITY;
      }
    }

    if (linkPrefix == null) {
      linkName = LIconUtility.DASH;
      linkPrefix = SPRITE_UTILITY;
    }
    if (linkPrefix == SPRITE_UTILITY && color == null) {
      color = LIcon.C_ICON_TEXT_DEFAULT;
    }
    return new LIcon(linkName, linkPrefix, className, size, color, addlCss, HREF_PREFIX);
  } // create


  /// SVG Element
  final svg.SvgSvgElement element = new svg.SvgSvgElement();
  /// Svg Use reference
  final svg.UseElement _use = new svg.UseElement();
  /// Link Prefix
  final String linkPrefix;
  /// Package Prefix
  String packagePrefix;

  /**
   * svg
   * - use
   * [linkName] for use href #name - e.g. add
   * [linkPrefix] for use href - e.g. SPRITE_ACTION/CUSTOM/UTILITY/...
   * [className] optional className, e.g. C_ICON
   * [size] optional C_ICON__TYNY/SMALL/MEDIUM/LARGE
   * [color] optional C_ICON_TEXT_DEFAULT/WARNING
   * [addlCss] additional css classes
   * [packagePrefix] package lib, e.g. HREF_PREFIX
   */
  LIcon(String linkName, String this.linkPrefix,
        String className, String size, String color,
        List<String> addlCss, String this.packagePrefix) {
    // css classes
    if (className != null && className.isNotEmpty) {
      element.classes.add(className);
    }
    if (size != null && size.isNotEmpty) {
      element.classes.add(size);
    }
    if (color != null) {
      element.classes.add(color);
    }
    if (addlCss != null) {
      element.classes.addAll(addlCss);
    }
    element.setAttributeNS(null, Html0.ARIA_HIDDEN, "true");
    element.append(_use);
    this.linkName = linkName;
    //
    if (createImg()) {
    }
  } // LIcon

  /// Copy Icon
  LIcon copy() {
    return new LIcon(linkName, linkPrefix, null, null, null,
        new List<String>.from(element.classes), packagePrefix);
  }

  /// svg element classes
  CssClassSet get classes => element.classes;


  /// set [cssSize] - C_ICON__LARGE, C_ICON__SMALL, C_ICON__X_SMALL
  void set size (String cssSize) {
    element.classes.removeAll([C_ICON__LARGE, C_ICON__SMALL, C_ICON__X_SMALL]);
    if (cssSize != null && cssSize.isNotEmpty)
      element.classes.add(cssSize);
  }

  /// Link (Icon) Name
  String get linkName => _linkName;
  /// Set Link (Icon) Name and use reference
  void set linkName (String newValue) {
    _linkName = newValue;
    _use.href.baseVal = "${packagePrefix}${linkPrefix}${_linkName}";
  }
  /// Link name
  String _linkName;

  /// remove color classes
  void removeColor() {
    for (String cls in element.classes) {
      if (cls.startsWith(LIconAction.C_ICON_ACTION_)
          || cls.startsWith(LIconStandard.C_ICON_STANDARD_)
          || cls.startsWith(LIconCustom.C_ICON_CUSTOM_)) {
        element.classes.remove(cls);
      }
    }
  }

} // LIcon



/**
 * Span with icon
 */
class LIconSpan extends LComponent {

  /// the span element
  final SpanElement element = new SpanElement()
    ..classes.add(LIcon.C_ICON__CONTAINER);

  /**
   * Standard Icon Span
   * [name] standard icon name e.g. LIconStandard.ACCOUNT
   */
  LIconSpan.standard(String name, {bool circle: false, String assistiveText,
      String size})
    : this(new LIconStandard(name, size:size),
        circle:circle, assistiveText:assistiveText,
        spanClass: "${LIconStandard.C_ICON_STANDARD_}${name}");

  /**
   * Action Icon Span
   * [name] action icon name e.g. LIconAction.DESCRIPTION
   */
  LIconSpan.action(String name, {bool circle: false, String assistiveText,
        String size})
    : this(new LIconAction(name, size:size),
        circle:circle, assistiveText:assistiveText,
        spanClass: "${LIconAction.C_ICON_ACTION_}${name}");

  /**
   * Utility Icon Span
   * [name] utility icon name e.g. LIconUtility.ANNOUNCEMENT
   */
  LIconSpan.utility(String name, {bool circle: false, String assistiveText,
        String size, String color:LIcon.C_ICON_TEXT_DEFAULT})
    : this(new LIconUtility(name, size:size, color:color),
        circle:circle, assistiveText:assistiveText);

  /**
   * DocType Icon Span
   * [name] doctype icon name e.g. LIconDoctype.XML
   */
  LIconSpan.doctype(String name, {bool circle: false, String assistiveText,
        String size})
    : this(new LIconDoctype(name, size:size),
        circle:circle, assistiveText:assistiveText);

  /**
   * DocType Icon Span
   * [name] doctype icon name e.g. LIconDoctype.XML
   */
  LIconSpan.custom(String name, {bool circle: false, String assistiveText,
      String size})
  : this(new LIconCustom(name, size:size),
      circle:circle, assistiveText:assistiveText);

  /**
   * Create Span with Icon
   */
  LIconSpan(LIcon icon, {bool circle: false, String assistiveText, String spanClass}) {
    if (spanClass != null && spanClass.isNotEmpty) {
      element.classes.add(spanClass);
    }
    if (circle) {
      element.classes.add(LIcon.C_ICON__CONTAINER__CIRCLE);
    }
    element.append(icon.element);
    //
    if (assistiveText != null && assistiveText.isNotEmpty) {
      SpanElement span = new SpanElement()
        ..classes.add(LText.C_ASSISTIVE_TEXT)
        ..text = assistiveText;
      element.append(span);
    }
  }

} // LIconSpan


/**
 * Action Icon
 * https://www.getslds.com/resources/icons#action&role=regular&status=all
 */
class LIconAction extends LIcon {

  static const String ANNOUNCEMENT = "announcement";
  static const String APEX = "apex";
  static const String APPROVAL = "approval";
  static const String BACK = "back";
  static const String CALL = "call";
  static const String CANVAS = "canvas";
  static const String CHECK = "check";
  static const String CLONE = "clone";
  static const String CLOSE = "close";
  static const String DEFER = "defer";
  static const String DELETE = "delete";
  static const String DESCRIPTION = "description";
  static const String DIAL_IN = "dial_in";
  static const String DOWNLOAD = "download";
  static const String EDIT_GROUPS = "edit_groups";
  static const String EDIT = "edit";
  static const String EMAIL = "email";
  static const String FALLBACK = "fallback";
  static const String FILTER = "filter";
  static const String FLOW = "flow";
  static const String FOLLOW = "follow";
  static const String FOLLOWING = "following";
  static const String FREEZE_USER = "freeze_user";
  static const String GOAL = "goal";
  static const String GOOGLE_NEWS = "google_news";
  static const String JOIN_GROUP = "join_group";
  static const String LEAD_CONVERT = "lead_convert";
  static const String LEAVE_GROUP = "leave_group";
  static const String LOG_A_CALL = "log_a_call";
  static const String LOG_EVENT = "log_event";
  static const String MANAGE_PERM_SETS = "manage_perm_sets";
  static const String MAP = "map";
  static const String MORE = "more";
  static const String NEW_ACCOUNT = "new_account";
  static const String NEW_CAMPAIGN = "new_campaign";
  static const String NEW_CASE = "new_case";
  static const String NEW_CHILD_CASE = "new_child_case";
  static const String NEW_CONTACT = "new_contact";
  static const String NEW_EVENT = "new_event";
  static const String NEW_GROUP = "new_group";
  static const String NEW_LEAD = "new_lead";
  static const String NEW_NOTE = "new_note";
  static const String NEW_NOTEBOOK = "new_notebook";
  static const String NEW_OPPORTUNITY = "new_opportunity";
  static const String NEW_TASK = "new_task";
  static const String NEW = "new";
  static const String PASSWORD_UNLOCK = "password_unlock";
  static const String PREVIEW = "preview";
  static const String PRIORITY = "priority";
  static const String QUESTION_POST_ACTION = "question_post_action";
  static const String QUOTE = "quote";
  static const String RECORD = "record";
  static const String REJECT = "reject";
  static const String RESET_PASSWORD = "reset_password";
  static const String SHARE_FILE = "share_file";
  static const String SHARE_LINK = "share_link";
  static const String SHARE_POLL = "share_poll";
  static const String SHARE_POST = "share_post";
  static const String SHARE_THANKS = "share_thanks";
  static const String SORT = "sort";
  static const String SUBMIT_FOR_APPROVAL = "submit_for_approval";
  static const String UPDATE_STATUS = "update_status";
  static const String UPDATE = "update";
  static const String USER_ACTIVATION = "user_activation";
  static const String WEB_LINK = "web_link";
  static const String NEW_CUSTOM1 = "new_custom1";
  static const String NEW_CUSTOM2 = "new_custom2";
  static const String NEW_CUSTOM3 = "new_custom3";
  static const String NEW_CUSTOM4 = "new_custom4";
  static const String NEW_CUSTOM5 = "new_custom5";
  static const String NEW_CUSTOM6 = "new_custom6";
  static const String NEW_CUSTOM7 = "new_custom7";
  static const String NEW_CUSTOM8 = "new_custom8";
  static const String NEW_CUSTOM9 = "new_custom9";
  static const String NEW_CUSTOM10 = "new_custom10";
  static const String NEW_CUSTOM11 = "new_custom11";
  static const String NEW_CUSTOM12 = "new_custom12";
  static const String NEW_CUSTOM13 = "new_custom13";
  static const String NEW_CUSTOM14 = "new_custom14";
  static const String NEW_CUSTOM15 = "new_custom15";
  static const String NEW_CUSTOM16 = "new_custom16";
  static const String NEW_CUSTOM17 = "new_custom17";
  static const String NEW_CUSTOM18 = "new_custom18";
  static const String NEW_CUSTOM19 = "new_custom19";
  static const String NEW_CUSTOM20 = "new_custom20";
  static const String NEW_CUSTOM21 = "new_custom21";
  static const String NEW_CUSTOM22 = "new_custom22";
  static const String NEW_CUSTOM23 = "new_custom23";
  static const String NEW_CUSTOM24 = "new_custom24";
  static const String NEW_CUSTOM25 = "new_custom25";
  static const String NEW_CUSTOM26 = "new_custom26";
  static const String NEW_CUSTOM27 = "new_custom27";
  static const String NEW_CUSTOM28 = "new_custom28";
  static const String NEW_CUSTOM29 = "new_custom29";
  static const String NEW_CUSTOM30 = "new_custom30";
  static const String NEW_CUSTOM31 = "new_custom31";
  static const String NEW_CUSTOM32 = "new_custom32";
  static const String NEW_CUSTOM33 = "new_custom33";
  static const String NEW_CUSTOM34 = "new_custom34";
  static const String NEW_CUSTOM35 = "new_custom35";
  static const String NEW_CUSTOM36 = "new_custom36";
  static const String NEW_CUSTOM37 = "new_custom37";
  static const String NEW_CUSTOM38 = "new_custom38";
  static const String NEW_CUSTOM39 = "new_custom39";
  static const String NEW_CUSTOM40 = "new_custom40";
  static const String NEW_CUSTOM41 = "new_custom41";
  static const String NEW_CUSTOM42 = "new_custom42";
  static const String NEW_CUSTOM43 = "new_custom43";
  static const String NEW_CUSTOM44 = "new_custom44";
  static const String NEW_CUSTOM45 = "new_custom45";
  static const String NEW_CUSTOM46 = "new_custom46";
  static const String NEW_CUSTOM47 = "new_custom47";
  static const String NEW_CUSTOM48 = "new_custom48";
  static const String NEW_CUSTOM49 = "new_custom49";
  static const String NEW_CUSTOM50 = "new_custom50";
  static const String NEW_CUSTOM51 = "new_custom51";
  static const String NEW_CUSTOM52 = "new_custom52";
  static const String NEW_CUSTOM53 = "new_custom53";
  static const String NEW_CUSTOM54 = "new_custom54";
  static const String NEW_CUSTOM55 = "new_custom55";
  static const String NEW_CUSTOM56 = "new_custom56";
  static const String NEW_CUSTOM57 = "new_custom57";
  static const String NEW_CUSTOM58 = "new_custom58";
  static const String NEW_CUSTOM59 = "new_custom59";
  static const String NEW_CUSTOM60 = "new_custom60";
  static const String NEW_CUSTOM61 = "new_custom61";
  static const String NEW_CUSTOM62 = "new_custom62";
  static const String NEW_CUSTOM63 = "new_custom63";
  static const String NEW_CUSTOM64 = "new_custom64";
  static const String NEW_CUSTOM65 = "new_custom65";
  static const String NEW_CUSTOM66 = "new_custom66";
  static const String NEW_CUSTOM67 = "new_custom67";
  static const String NEW_CUSTOM68 = "new_custom68";
  static const String NEW_CUSTOM69 = "new_custom69";
  static const String NEW_CUSTOM70 = "new_custom70";
  static const String NEW_CUSTOM71 = "new_custom71";
  static const String NEW_CUSTOM72 = "new_custom72";
  static const String NEW_CUSTOM73 = "new_custom73";
  static const String NEW_CUSTOM74 = "new_custom74";
  static const String NEW_CUSTOM75 = "new_custom75";
  static const String NEW_CUSTOM76 = "new_custom76";
  static const String NEW_CUSTOM77 = "new_custom77";
  static const String NEW_CUSTOM78 = "new_custom78";
  static const String NEW_CUSTOM79 = "new_custom79";
  static const String NEW_CUSTOM80 = "new_custom80";
  static const String NEW_CUSTOM81 = "new_custom81";
  static const String NEW_CUSTOM82 = "new_custom82";
  static const String NEW_CUSTOM83 = "new_custom83";
  static const String NEW_CUSTOM84 = "new_custom84";
  static const String NEW_CUSTOM85 = "new_custom85";
  static const String NEW_CUSTOM86 = "new_custom86";
  static const String NEW_CUSTOM87 = "new_custom87";
  static const String NEW_CUSTOM88 = "new_custom88";
  static const String NEW_CUSTOM89 = "new_custom89";
  static const String NEW_CUSTOM90 = "new_custom90";
  static const String NEW_CUSTOM91 = "new_custom91";
  static const String NEW_CUSTOM92 = "new_custom92";
  static const String NEW_CUSTOM93 = "new_custom93";
  static const String NEW_CUSTOM94 = "new_custom94";
  static const String NEW_CUSTOM95 = "new_custom95";
  static const String NEW_CUSTOM96 = "new_custom96";
  static const String NEW_CUSTOM97 = "new_custom97";
  static const String NEW_CUSTOM98 = "new_custom98";
  static const String NEW_CUSTOM99 = "new_custom99";
  static const String NEW_CUSTOM100 = "new_custom100";


  /// Icon Prefix for  *
  static const String C_ICON_ACTION_ = "slds-icon-action-";

  /**
   * Action Icon - [name] e.g. CIcon.ACTION_DESCRIPTION
   * [size] optional C_ICON__TYNY/SMALL/MEDIUM/LARGE
   * [colorOverride] optional overwrite C_ICON_TEXT_DEFAULT/WARNING
   * [addlCss] additional css classes
   */
  LIconAction(String name, {String className: LIcon.C_ICON, String size,
        String colorOverride, List<String> addlCss})
    : super(name, LIcon.SPRITE_ACTION, className, size,
        colorOverride == null ? "${C_ICON_ACTION_}${name}" : colorOverride,
        addlCss, LIcon.HREF_PREFIX);


} // LIconAction


/**
 * Standard Icon
 */
class LIconStandard extends LIcon {

  static const String ACCOUNT = "account";
  static const String ANNOUNCEMENT = "announcement";
  static const String ANSWER_BEST = "answer_best";
  static const String ANSWER_PRIVATE = "answer_private";
  static const String ANSWER_PUBLIC = "answer_public";
  static const String APPROVAL = "approval";
  static const String APPS_ADMIN = "apps_admin";
  static const String APPS = "apps";
  static const String ARTICLE = "article";
  static const String AVATAR_LOADING = "avatar_loading";
  static const String AVATAR = "avatar";
  static const String CALIBRATION = "calibration";
  static const String CALL_HISTORY = "call_history";
  static const String CALL = "call";
  static const String CAMPAIGN_MEMBERS = "campaign_members";
  static const String CAMPAIGN = "campaign";
  static const String CANVAS = "canvas";
  static const String CASE_CHANGE_STATUS = "case_change_status";
  static const String CASE_COMMENT = "case_comment";
  static const String CASE_EMAIL = "case_email";
  static const String CASE_LOG_A_CALL = "case_log_a_call";
  static const String CASE_TRANSCRIPT = "case_transcript";
  static const String CASE = "case";
  static const String COACHING = "coaching";
  static const String CONNECTED_APPS = "connected_apps";
  static const String CONTACT = "contact";
  static const String CONTRACT = "contract";
  static const String CUSTOM = "custom";
  static const String DASHBOARD = "dashboard";
  static const String DEFAULT = "default";
  static const String DOCUMENT = "document";
  static const String DRAFTS = "drafts";
  static const String EMAIL_CHATTER = "email_chatter";
  static const String EMAIL = "email";
  static const String EMPTY = "empty";
  static const String ENDORSEMENT = "endorsement";
  static const String EVENT = "event";
  static const String FEED = "feed";
  static const String FEEDBACK = "feedback";
  static const String FILE = "file";
  static const String FLOW = "flow";
  static const String GENERILOADING = "generiloading";
  static const String GOALS = "goals";
  static const String GROUP_LOADING = "group_loading";
  static const String GROUPS = "groups";
  static const String HOME = "home";
  static const String INSIGHTS = "insights";
  static const String LEAD = "lead";
  static const String LINK = "link";
  static const String LOG_A_CALL = "log_a_call";
  static const String MARKETING_ACTIONS = "marketing_actions";
  static const String MARKETING_RESOURCES = "marketing_resources";
  static const String METRICS = "metrics";
  static const String NEWS = "news";
  static const String NOTE = "note";
  static const String OPPORTUNITY = "opportunity";
  static const String ORDERS = "orders";
  static const String PEOPLE = "people";
  static const String PERFORMANCE = "performance";
  static const String PHOTO = "photo";
  static const String POLL = "poll";
  static const String PORTAL = "portal";
  static const String POST = "post";
  static const String PRICEBOOK = "pricebook";
  static const String PROCESS = "process";
  static const String PRODUCT = "product";
  static const String QUESTION_BEST = "question_best";
  static const String QUESTION_FEED = "question_feed";
  static const String QUOTES = "quotes";
  static const String RECENT = "recent";
  static const String RECORD = "record";
  static const String RELATED_LIST = "related_list";
  static const String REPORT = "report";
  static const String REWARD = "reward";
  static const String SCAN_CARD = "scan_card";
  static const String SKILL_ENTITY = "skill_entity";
  static const String SOCIAL = "social";
  static const String SOLUTION = "solution";
  static const String SOSSESSION = "sossession";
  static const String TASK = "task";
  static const String TASK2 = "task2";
  static const String TEAM_MEMBER = "team_member";
  static const String THANKS_LOADING = "thanks_loading";
  static const String THANKS = "thanks";
  static const String TODAY = "today";
  static const String TOPIC = "topic";
  static const String UNMATCHED = "unmatched";
  static const String USER = "user";

  /// Icon Prefix for Standard
  static const String C_ICON_STANDARD_ = "slds-icon-standard-";

  /**
   * Standard Icon [linkName] e.g. CASE
   * [size] optional C_ICON__TYNY/SMALL/MEDIUM/LARGE
   * [colorOverride] optional overwrite C_ICON_TEXT_DEFAULT/WARNING
   * [addlCss] additional css classes
   */
  LIconStandard(String linkName, {String className: LIcon.C_ICON, String size,
      String colorOverride, List<String> addlCss})
    : super(linkName, LIcon.SPRITE_STANDARD, size, className,
        colorOverride == null ? "${C_ICON_STANDARD_}${linkName}" : colorOverride,
        addlCss, LIcon.HREF_PREFIX);

} // LIconStandard


/**
 * Utility Icon
 * https://www.getslds.com/resources/icons#utility&role=regular&status=all
 */
class LIconUtility extends LIcon {

  static const String THREEDOTS = "3dots";
  static const String ADD = "add";
  static const String ADDUSER = "adduser";
  static const String ANNOUNCEMENT = "announcement";
  static const String APPS = "apps";
  static const String ARROWDOWN = "arrowdown";
  static const String ARROWUP = "arrowup";
  static const String ATTACH = "attach";
  static const String BACK = "back";
  static const String BAN = "ban";
  static const String BOLD = "bold";
  static const String BOOKMARK = "bookmark";
  static const String BRUSH = "brush";
  static const String BUCKET = "bucket";
  static const String BUILDER = "builder";
  static const String CALL = "call";
  static const String CAPSLOCK = "capslock";
  static const String CASES = "cases";
  static const String CENTER_ALIGN_TEXT = "center_align_text";
  static const String CHART = "chart";
  static const String CHAT = "chat";
  static const String CHECK = "check";
  static const String CHECKIN = "checkin";
  static const String CHEVRONDOWN = "chevrondown";
  static const String CHEVRONLEFT = "chevronleft";
  static const String CHEVRONRIGHT = "chevronright";
  static const String CHEVRONUP = "chevronup";
  static const String CLEAR = "clear";
  static const String CLOCK = "clock";
  static const String CLOSE = "close";
  static const String COMMENTS = "comments";
  static const String COMPANY = "company";
  static const String CONNECTED_APPS = "connected_apps";
  static const String CONTRACT = "contract";
  static const String COPY = "copy";
  static const String CROSSFILTER = "crossfilter";
  static const String CUSTOM_APPS = "custom_apps";
  static const String CUT = "cut";
  static const String DASH = "dash";
  static const String DAYVIEW = "dayview";
  static const String DELETE = "delete";
  static const String DEPRECATE = "deprecate";
  static const String DESKTOP = "desktop";
  static const String DOWN = "down";
  static const String DOWNLOAD = "download";
  static const String EDIT = "edit";
  static const String EMAIL = "email";
  static const String ERROR = "error";
  static const String EVENT = "event";
  static const String EXPAND = "expand";
  static const String FAVORITE = "favorite";
  static const String FILTER = "filter";
  static const String FILTERLIST = "filterList";
  static const String FORWARD = "forward";
  static const String FROZEN = "frozen";
  static const String GROUPS = "groups";
  static const String HELP = "help";
  static const String HOME = "home";
  static const String IDENTITY = "identity";
  static const String IMAGE = "image";
  static const String INBOX = "inbox";
  static const String INFO = "info";
  static const String INSERT_TAG_FIELD = "insert_tag_field";
  static const String INSERT_TEMPLATE = "insert_template";
  static const String ITALIC = "italic";
  static const String JUSTIFY_TEXT = "justify_text";
  static const String KANBAN = "kanban";
  static const String KNOWLEDGE_BASE = "knowledge_base";
  static const String LAYOUT = "layout";
  static const String LEFT_ALIGN_TEXT = "left_align_text";
  static const String LEFT = "left";
  static const String LIKE = "like";
  static const String LINK = "link";
  static const String LIST = "list";
  static const String LOCATION = "location";
  static const String LOCK = "lock";
  static const String LOGOUT = "logout";
  static const String MAGICWAND = "magicwand";
  static const String MATRIX = "matrix";
  static const String MONTHLYVIEW = "monthlyview";
  static const String MOVE = "move";
  static const String NEW_WINDOW = "new_window";
  static const String NEW = "new";
  static const String NEWS = "news";
  static const String NOTEBOOK = "notebook";
  static const String NOTIFICATION = "notification";
  static const String OFFICE365 = "office365";
  static const String OFFLINE = "offline";
  static const String OPEN_FOLDER = "open_folder";
  static const String OPEN = "open";
  static const String OPENED_FOLDER = "opened_folder";
  static const String PACKAGE_ORG_BETA = "package_org_beta";
  static const String PACKAGE_ORG = "package_org";
  static const String PACKAGE = "package";
  static const String PAGE = "page";
  static const String PALETTE = "palette";
  static const String PASTE = "paste";
  static const String PEOPLE = "people";
  static const String PHONE_LANDSCAPE = "phone_landscape";
  static const String PHONE_PORTRAIT = "phone_portrait";
  static const String PHOTO = "photo";
  static const String POWER = "power";
  static const String PREVIEW = "preview";
  static const String PRIORITY = "priority";
  static const String PROCESS = "process";
  static const String PUSH = "push";
  static const String PUZZLE = "puzzle";
  static const String QUESTION = "question";
  static const String QUESTIONS_AND_ANSWERS = "questions_and_answers";
  static const String REDO = "redo";
  static const String REFRESH = "refresh";
  static const String RELATE = "relate";
  static const String REMOVE_FORMATTING = "remove_formatting";
  static const String REMOVE_LINK = "remove_link";
  static const String REPLACE = "replace";
  static const String REPLY = "reply";
  static const String RETWEET = "retweet";
  static const String RICHTEXTBULLETEDLIST = "richtextbulletedlist";
  static const String RICHTEXTINDENT = "richtextindent";
  static const String RICHTEXTNUMBEREDLIST = "richtextnumberedlist";
  static const String RICHTEXTOUTDENT = "richtextoutdent";
  static const String RIGHT_ALIGN_TEXT = "right_align_text";
  static const String RIGHT = "right";
  static const String ROTATE = "rotate";
  static const String ROWS = "rows";
  static const String SALESFORCE1 = "salesforce1";
  static const String SEARCH = "search";
  static const String SETTINGS = "settings";
  static const String SETUP_ASSISTANT_GUIDE = "setup_assistant_guide";
  static const String SETUP = "setup";
  static const String SHARE = "share";
  static const String SHIELD = "shield";
  static const String SIDE_LIST = "side_list";
  static const String SIGNPOST = "signpost";
  static const String SMS = "sms";
  static const String SNIPPET = "snippet";
  static const String SOCIALSHARE = "socialshare";
  static const String SORT = "sort";
  static const String SPINNER = "spinner";
  static const String STANDARD_OBJECTS = "standard_objects";
  static const String STRIKETHROUGH = "strikethrough";
  static const String SUCCESS = "success";
  static const String SUMMARY = "summary";
  static const String SUMMARYDETAIL = "summarydetail";
  static const String SWITCH = "switch";
  static const String TABLE = "table";
  static const String TABLET_LANDSCAPE = "tablet_landscape";
  static const String TABLET_PORTRAIT = "tablet_portrait";
  static const String TEXT_BACKGROUND_COLOR = "text_background_color";
  static const String TEXT_COLOR = "text_color";
  static const String TILE_CARD_LIST = "tile_card_list";
  static const String TOPIC = "topic";
  static const String TRAIL = "trail";
  static const String UNDELETE = "undelete";
  static const String UNDEPRECATE = "undeprecate";
  static const String UNDERLINE = "underline";
  static const String UNDO = "undo";
  static const String UNLOCK = "unlock";
  static const String UP = "up";
  static const String UPLOAD = "upload";
  static const String USER = "user";
  static const String WARNING = "warning";
  static const String WEEKLYVIEW = "weeklyview";
  static const String ZOOMIN = "zoomin";
  static const String ZOOMOUT = "zoomout";


  /**
   * Utility Icon with [linkName] like [ADD]
   * [size] optional C_ICON__TYNY/SMALL/MEDIUM/LARGE
   * [colorOverride] optional overwrite C_ICON_TEXT_DEFAULT/WARNING
   * [addlCss] additional css classes
   */
  LIconUtility(String linkName, {String className:LIcon.C_ICON, String size,
      String color, List<String> addlCss})
    : super(linkName, LIcon.SPRITE_UTILITY, className, size, color,
        addlCss, LIcon.HREF_PREFIX);


} // LIconUtility


/**
 * Custom Icon
 */
class LIconCustom extends LIcon {

  static const String CUSTOM_1 = "custom-1";
  static const String CUSTOM_2 = "custom-2";
  static const String CUSTOM_3 = "custom-3";
  static const String CUSTOM_4 = "custom-4";
  static const String CUSTOM_5 = "custom-5";
  static const String CUSTOM_6 = "custom-6";
  static const String CUSTOM_7 = "custom-7";
  static const String CUSTOM_8 = "custom-8";
  static const String CUSTOM_9 = "custom-9";
  static const String CUSTOM_10 = "custom-10";
  static const String CUSTOM_11 = "custom-11";
  static const String CUSTOM_12 = "custom-12";
  static const String CUSTOM_13 = "custom-13";
  static const String CUSTOM_14 = "custom-14";
  static const String CUSTOM_15 = "custom-15";
  static const String CUSTOM_16 = "custom-16";
  static const String CUSTOM_17 = "custom-17";
  static const String CUSTOM_18 = "custom-18";
  static const String CUSTOM_19 = "custom-19";
  static const String CUSTOM_20 = "custom-20";
  static const String CUSTOM_21 = "custom-21";
  static const String CUSTOM_22 = "custom-22";
  static const String CUSTOM_23 = "custom-23";
  static const String CUSTOM_24 = "custom-24";
  static const String CUSTOM_25 = "custom-25";
  static const String CUSTOM_26 = "custom-26";
  static const String CUSTOM_27 = "custom-27";
  static const String CUSTOM_28 = "custom-28";
  static const String CUSTOM_29 = "custom-29";
  static const String CUSTOM_30 = "custom-30";
  static const String CUSTOM_31 = "custom-31";
  static const String CUSTOM_32 = "custom-32";
  static const String CUSTOM_33 = "custom-33";
  static const String CUSTOM_34 = "custom-34";
  static const String CUSTOM_35 = "custom-35";
  static const String CUSTOM_36 = "custom-36";
  static const String CUSTOM_37 = "custom-37";
  static const String CUSTOM_38 = "custom-38";
  static const String CUSTOM_39 = "custom-39";
  static const String CUSTOM_40 = "custom-40";
  static const String CUSTOM_41 = "custom-41";
  static const String CUSTOM_42 = "custom-42";
  static const String CUSTOM_43 = "custom-43";
  static const String CUSTOM_44 = "custom-44";
  static const String CUSTOM_45 = "custom-45";
  static const String CUSTOM_46 = "custom-46";
  static const String CUSTOM_47 = "custom-47";
  static const String CUSTOM_48 = "custom-48";
  static const String CUSTOM_49 = "custom-49";
  static const String CUSTOM_50 = "custom-50";
  static const String CUSTOM_51 = "custom-51";
  static const String CUSTOM_52 = "custom-52";
  static const String CUSTOM_53 = "custom-53";
  static const String CUSTOM_54 = "custom-54";
  static const String CUSTOM_55 = "custom-55";
  static const String CUSTOM_56 = "custom-56";
  static const String CUSTOM_57 = "custom-57";
  static const String CUSTOM_58 = "custom-58";
  static const String CUSTOM_59 = "custom-59";
  static const String CUSTOM_60 = "custom-60";
  static const String CUSTOM_61 = "custom-61";
  static const String CUSTOM_62 = "custom-62";
  static const String CUSTOM_63 = "custom-63";
  static const String CUSTOM_64 = "custom-64";
  static const String CUSTOM_65 = "custom-65";
  static const String CUSTOM_66 = "custom-66";
  static const String CUSTOM_67 = "custom-67";
  static const String CUSTOM_68 = "custom-68";
  static const String CUSTOM_69 = "custom-69";
  static const String CUSTOM_70 = "custom-70";
  static const String CUSTOM_71 = "custom-71";
  static const String CUSTOM_72 = "custom-72";
  static const String CUSTOM_73 = "custom-73";
  static const String CUSTOM_74 = "custom-74";
  static const String CUSTOM_75 = "custom-75";
  static const String CUSTOM_76 = "custom-76";
  static const String CUSTOM_77 = "custom-77";
  static const String CUSTOM_78 = "custom-78";
  static const String CUSTOM_79 = "custom-79";
  static const String CUSTOM_80 = "custom-80";
  static const String CUSTOM_81 = "custom-81";
  static const String CUSTOM_82 = "custom-82";
  static const String CUSTOM_83 = "custom-83";
  static const String CUSTOM_84 = "custom-84";
  static const String CUSTOM_85 = "custom-85";
  static const String CUSTOM_86 = "custom-86";
  static const String CUSTOM_87 = "custom-87";
  static const String CUSTOM_88 = "custom-88";
  static const String CUSTOM_89 = "custom-89";
  static const String CUSTOM_90 = "custom-90";
  static const String CUSTOM_91 = "custom-91";
  static const String CUSTOM_92 = "custom-92";
  static const String CUSTOM_93 = "custom-93";
  static const String CUSTOM_94 = "custom-94";
  static const String CUSTOM_95 = "custom-95";
  static const String CUSTOM_96 = "custom-96";
  static const String CUSTOM_97 = "custom-97";
  static const String CUSTOM_98 = "custom-98";
  static const String CUSTOM_99 = "custom-99";
  static const String CUSTOM_100 = "custom-100";

  /// Icon Prefix for CUSTOM_* - custom-# added
  static const String C_ICON_ = "slds-icon-";
  /// Icon Prefix for Custom - just number added
  static const String C_ICON_CUSTOM_ = "slds-icon-custom-";

  /**
   * Custom Icon - [colorName] e.g. LIconCustom.CUSTOM_1
   * - color names are custom-1
   * - svg names are custom1
   * [size] optional C_ICON__TYNY/SMALL/MEDIUM/LARGE
   * [colorOverride] optional overwrite C_ICON_TEXT_DEFAULT/WARNING
   * [addlCss] additional css classes
   */
  LIconCustom(String colorName, {String className: LIcon.C_ICON, String size,
      String colorOverride, List<String> addlCss})
    : super(colorName.replaceAll("-", ""), LIcon.SPRITE_CUSTOM, className, size,
        colorOverride == null ? "${C_ICON_}${colorName}" : colorOverride,
        addlCss, LIcon.HREF_PREFIX);

} // LIconCustom


/**
 * Document Type Icon
 */
class LIconDoctype extends LIcon {

  static const String ATTACHMENT = "attachment";
  static const String AUDIO = "audio";
  static const String CSV = "csv";
  static const String EPS = "eps";
  static const String EXCEL = "excel";
  static const String EXE = "exe";
  static const String FLASH = "flash";
  static const String GDOC = "gdoc";
  static const String GDOCS = "gdocs";
  static const String GPRES = "gpres";
  static const String GSHEET = "gsheet";
  static const String HTML = "html";
  static const String IMAGE = "image";
  static const String KEYNOTE = "keynote";
  static const String LINK = "link";
  static const String MP4 = "mp4";
  static const String OVERLAY = "overlay";
  static const String PACK = "pack";
  static const String PAGES = "pages";
  static const String PDF = "pdf";
  static const String PPT = "ppt";
  static const String PSD = "psd";
  static const String RTF = "rtf";
  static const String SLIDE = "slide";
  static const String STYPI = "stypi";
  static const String TXT = "txt";
  static const String UNKNOWN = "unknown";
  static const String VIDEO = "video";
  static const String VISIO = "visio";
  static const String WEBEX = "webex";
  static const String WORD = "word";
  static const String XML = "xml";


  /**
   * Custom Icon - [name] e.g. LIconCustom.CUSTOM_1
   * [size] optional C_ICON__TYNY/SMALL/MEDIUM/LARGE
   * [colorOverride] optional overwrite C_ICON_TEXT_DEFAULT/WARNING
   * [addlCss] additional css classes
   */
  LIconDoctype(String name, {String className: LIcon.C_ICON, String size,
      String colorOverride, List<String> addlCss})
    : super(name, LIcon.SPRITE_DOCTYPE, className, size,
        colorOverride, addlCss, LIcon.HREF_PREFIX);

}
