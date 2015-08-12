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
 */
class LIcon {

  /// Prefix for asset references
  static const String HREF_PREFIX = "packages/lightning_dart";

  static const String C_ICON = "slds-icon";
  static const String C_ICON__TINY = "slds-icon--tiny";
  static const String C_ICON__SMALL = "slds-icon--small";
  static const String C_ICON__MEDIUM = "slds-icon--medium";
  static const String C_ICON__LARGE = "slds-icon--large";
  static const String C_ICON_TEXT_DEFAULT = "slds-icon-text-default";
  static const String C_ICON_TEXT_WARNING = "slds-icon-text-warning";
  static const String C_ASSISTIVE_TEXT = "slds-assistive-text";

  static const String C_ICON__CONTAINER = "slds-icon__container";
  static const String C_ICON__CONTAINER__CIRCLE =
      "slds-icon__container--circle";

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

  /// Icon Prefix for ACTION_*
  static const String C_ICON_ACTION_ = "slds-icon-";

  static const String ACTION_APPROVAL = "action-approval";
  static const String ACTION_CANVASAPP = "action-canvasapp";
  static const String ACTION_GOAL = "action-goal";
  static const String ACTION_OPPORTUNITY_COMPETITOR =
      "action-opportunity-competitor";
  static const String ACTION_OPPORTUNITY_LINE_ITEM =
      "action-opportunity-line-item";
  static const String ACTION_OPPORTUNITY_TEAM_MEMBER =
      "action-opportunity-team-member";
  static const String ACTION_QUESTION_POST_ACTION =
      "action-question-post-action";
  static const String ACTION_QUOTE = "action-quote";
  static const String ACTION_REJECT = "action-reject";
  static const String ACTION_SOCIAL_POST = "action-social-post";
  static const String ACTION_FALLBACK = "action-fallback";
  static const String ACTION_EDIT = "action-edit";
  static const String ACTION_DELETE = "action-delete";
  static const String ACTION_CLONE = "action-clone";
  static const String ACTION_FOLLOW = "action-follow";
  static const String ACTION_FOLLOWING = "action-following";
  static const String ACTION_JOIN_GROUP = "action-join-group";
  static const String ACTION_LEAVE_GROUP = "action-leave-group";
  static const String ACTION_EDIT_GROUP = "action-edit-group";
  static const String ACTION_SHARE_POST = "action-share-post";
  static const String ACTION_SHARE_FILE = "action-share-file";
  static const String ACTION_NEW_TASK = "action-new-task";
  static const String ACTION_NEW_CONTACT = "action-new-contact";
  static const String ACTION_NEW_OPPORTUNITY = "action-new-opportunity";
  static const String ACTION_NEW_CASE = "action-new-case";
  static const String ACTION_NEW_LEAD = "action-new-lead";
  static const String ACTION_SHARE_THANKS = "action-share-thanks";
  static const String ACTION_SHARE_LINK = "action-share-link";
  static const String ACTION_SHARE_POLL = "action-share-poll";
  static const String ACTION_NEW_EVENT = "action-new-event";
  static const String ACTION_NEW_CHILD_CASE = "action-new-child-case";
  static const String ACTION_LOG_A_CALL = "action-log-a-call";
  static const String ACTION_NEW_NOTE = "action-new-note";
  static const String ACTION_NEW = "action-new";
  static const String ACTION_FILTER = "action-filter";
  static const String ACTION_SORT = "action-sort";
  static const String ACTION_DESCRIPTION = "action-description";
  static const String ACTION_DEFER = "action-defer";
  static const String ACTION_UPDATE = "action-update";
  static const String ACTION_LOG_THIS_EVENT = "action-log-this-event";
  static const String ACTION_EMAIL = "action-email";
  static const String ACTION_DIAL_IN = "action-dial-in";
  static const String ACTION_MAP = "action-map";
  static const String ACTION_CALL = "action-call";
  static const String ACTION_GOOGLE_NEWS = "action-google-news";
  static const String ACTION_WEB_LINK = "action-web-link";
  static const String ACTION_SUBMIT_FOR_APPROVAL = "action-submit-for-approval";
  static const String ACTION_SEARCH = "action-search";
  static const String ACTION_CLOSE = "action-close";
  static const String ACTION_BACK = "action-back";
  static const String ACTION_OFFICE_365 = "action-office-365";
  static const String ACTION_CONCUR = "action-concur";
  static const String ACTION_DROPBOX = "action-dropbox";
  static const String ACTION_EVERNOTE = "action-evernote";
  static const String ACTION_DOCUSIGN = "action-docusign";
  static const String ACTION_MORE = "action-more";
  static const String ACTION_NOTEBOOK = "action-notebook";
  static const String ACTION_PREVIEW = "action-preview";
  static const String ACTION_PRIORITY = "action-priority";
  static const String ACTION_DEFAULT_CUSTOM_OBJECT =
      "action-default-custom-object";
  static const String ACTION_NEW_CUSTOM_OBJECT = "action-new-custom-object";
  static const String ACTION_LEAD_CONVERT = "action-lead-convert";
  static const String ACTION_NEW_ACCOUNT = "action-new-account";
  static const String ACTION_NEW_CAMPAIGN = "action-new-campaign";
  static const String ACTION_NEW_GROUP = "action-new-group";
  static const String ACTION_UPDATE_STATUS = "action-update-status";
  static const String ACTION_NEW_CUSTOM_1 = "action-new-custom-1";
  static const String ACTION_NEW_CUSTOM_2 = "action-new-custom-2";
  static const String ACTION_NEW_CUSTOM_3 = "action-new-custom-3";
  static const String ACTION_NEW_CUSTOM_4 = "action-new-custom-4";
  static const String ACTION_NEW_CUSTOM_5 = "action-new-custom-5";
  static const String ACTION_NEW_CUSTOM_6 = "action-new-custom-6";
  static const String ACTION_NEW_CUSTOM_7 = "action-new-custom-7";
  static const String ACTION_NEW_CUSTOM_8 = "action-new-custom-8";
  static const String ACTION_NEW_CUSTOM_9 = "action-new-custom-9";
  static const String ACTION_NEW_CUSTOM_10 = "action-new-custom-10";
  static const String ACTION_NEW_CUSTOM_11 = "action-new-custom-11";
  static const String ACTION_NEW_CUSTOM_12 = "action-new-custom-12";
  static const String ACTION_NEW_CUSTOM_13 = "action-new-custom-13";
  static const String ACTION_NEW_CUSTOM_14 = "action-new-custom-14";
  static const String ACTION_NEW_CUSTOM_15 = "action-new-custom-15";
  static const String ACTION_NEW_CUSTOM_16 = "action-new-custom-16";
  static const String ACTION_NEW_CUSTOM_17 = "action-new-custom-17";
  static const String ACTION_NEW_CUSTOM_18 = "action-new-custom-18";
  static const String ACTION_NEW_CUSTOM_19 = "action-new-custom-19";
  static const String ACTION_NEW_CUSTOM_20 = "action-new-custom-20";
  static const String ACTION_NEW_CUSTOM_21 = "action-new-custom-21";
  static const String ACTION_NEW_CUSTOM_22 = "action-new-custom-22";
  static const String ACTION_NEW_CUSTOM_23 = "action-new-custom-23";
  static const String ACTION_NEW_CUSTOM_24 = "action-new-custom-24";
  static const String ACTION_NEW_CUSTOM_25 = "action-new-custom-25";
  static const String ACTION_NEW_CUSTOM_26 = "action-new-custom-26";
  static const String ACTION_NEW_CUSTOM_27 = "action-new-custom-27";
  static const String ACTION_NEW_CUSTOM_28 = "action-new-custom-28";
  static const String ACTION_NEW_CUSTOM_29 = "action-new-custom-29";
  static const String ACTION_NEW_CUSTOM_30 = "action-new-custom-30";
  static const String ACTION_NEW_CUSTOM_31 = "action-new-custom-31";
  static const String ACTION_NEW_CUSTOM_32 = "action-new-custom-32";
  static const String ACTION_NEW_CUSTOM_33 = "action-new-custom-33";
  static const String ACTION_NEW_CUSTOM_34 = "action-new-custom-34";
  static const String ACTION_NEW_CUSTOM_35 = "action-new-custom-35";
  static const String ACTION_NEW_CUSTOM_36 = "action-new-custom-36";
  static const String ACTION_NEW_CUSTOM_37 = "action-new-custom-37";
  static const String ACTION_NEW_CUSTOM_38 = "action-new-custom-38";
  static const String ACTION_NEW_CUSTOM_39 = "action-new-custom-39";
  static const String ACTION_NEW_CUSTOM_40 = "action-new-custom-40";
  static const String ACTION_NEW_CUSTOM_41 = "action-new-custom-41";
  static const String ACTION_NEW_CUSTOM_42 = "action-new-custom-42";
  static const String ACTION_NEW_CUSTOM_43 = "action-new-custom-43";
  static const String ACTION_NEW_CUSTOM_44 = "action-new-custom-44";
  static const String ACTION_NEW_CUSTOM_45 = "action-new-custom-45";
  static const String ACTION_NEW_CUSTOM_46 = "action-new-custom-46";
  static const String ACTION_NEW_CUSTOM_47 = "action-new-custom-47";
  static const String ACTION_NEW_CUSTOM_48 = "action-new-custom-48";
  static const String ACTION_NEW_CUSTOM_49 = "action-new-custom-49";
  static const String ACTION_NEW_CUSTOM_50 = "action-new-custom-50";
  static const String ACTION_NEW_CUSTOM_51 = "action-new-custom-51";
  static const String ACTION_NEW_CUSTOM_52 = "action-new-custom-52";
  static const String ACTION_NEW_CUSTOM_53 = "action-new-custom-53";
  static const String ACTION_NEW_CUSTOM_54 = "action-new-custom-54";
  static const String ACTION_NEW_CUSTOM_55 = "action-new-custom-55";
  static const String ACTION_NEW_CUSTOM_56 = "action-new-custom-56";
  static const String ACTION_NEW_CUSTOM_57 = "action-new-custom-57";
  static const String ACTION_NEW_CUSTOM_58 = "action-new-custom-58";
  static const String ACTION_NEW_CUSTOM_59 = "action-new-custom-59";
  static const String ACTION_NEW_CUSTOM_60 = "action-new-custom-60";
  static const String ACTION_NEW_CUSTOM_61 = "action-new-custom-61";
  static const String ACTION_NEW_CUSTOM_62 = "action-new-custom-62";
  static const String ACTION_NEW_CUSTOM_63 = "action-new-custom-63";
  static const String ACTION_NEW_CUSTOM_64 = "action-new-custom-64";
  static const String ACTION_NEW_CUSTOM_65 = "action-new-custom-65";
  static const String ACTION_NEW_CUSTOM_66 = "action-new-custom-66";
  static const String ACTION_NEW_CUSTOM_67 = "action-new-custom-67";
  static const String ACTION_NEW_CUSTOM_68 = "action-new-custom-68";
  static const String ACTION_NEW_CUSTOM_69 = "action-new-custom-69";
  static const String ACTION_NEW_CUSTOM_70 = "action-new-custom-70";
  static const String ACTION_NEW_CUSTOM_71 = "action-new-custom-71";
  static const String ACTION_NEW_CUSTOM_72 = "action-new-custom-72";
  static const String ACTION_NEW_CUSTOM_73 = "action-new-custom-73";
  static const String ACTION_NEW_CUSTOM_74 = "action-new-custom-74";
  static const String ACTION_NEW_CUSTOM_75 = "action-new-custom-75";
  static const String ACTION_NEW_CUSTOM_76 = "action-new-custom-76";
  static const String ACTION_NEW_CUSTOM_77 = "action-new-custom-77";
  static const String ACTION_NEW_CUSTOM_78 = "action-new-custom-78";
  static const String ACTION_NEW_CUSTOM_79 = "action-new-custom-79";
  static const String ACTION_NEW_CUSTOM_80 = "action-new-custom-80";
  static const String ACTION_NEW_CUSTOM_81 = "action-new-custom-81";
  static const String ACTION_NEW_CUSTOM_82 = "action-new-custom-82";
  static const String ACTION_NEW_CUSTOM_83 = "action-new-custom-83";
  static const String ACTION_NEW_CUSTOM_84 = "action-new-custom-84";
  static const String ACTION_NEW_CUSTOM_85 = "action-new-custom-85";
  static const String ACTION_NEW_CUSTOM_86 = "action-new-custom-86";
  static const String ACTION_NEW_CUSTOM_87 = "action-new-custom-87";
  static const String ACTION_NEW_CUSTOM_88 = "action-new-custom-88";
  static const String ACTION_NEW_CUSTOM_89 = "action-new-custom-89";
  static const String ACTION_NEW_CUSTOM_90 = "action-new-custom-90";
  static const String ACTION_NEW_CUSTOM_91 = "action-new-custom-91";
  static const String ACTION_NEW_CUSTOM_92 = "action-new-custom-92";
  static const String ACTION_NEW_CUSTOM_93 = "action-new-custom-93";
  static const String ACTION_NEW_CUSTOM_94 = "action-new-custom-94";
  static const String ACTION_NEW_CUSTOM_95 = "action-new-custom-95";
  static const String ACTION_NEW_CUSTOM_96 = "action-new-custom-96";
  static const String ACTION_NEW_CUSTOM_97 = "action-new-custom-97";
  static const String ACTION_NEW_CUSTOM_98 = "action-new-custom-98";
  static const String ACTION_NEW_CUSTOM_99 = "action-new-custom-99";
  static const String ACTION_NEW_CUSTOM_100 = "action-new-custom-100";
  static const String ACTION_APEX = "action-apex";
  static const String ACTION_FLOW = "action-flow";
  static const String ACTION_ANNOUNCEMENT = "action-announcement";
  static const String ACTION_RECORD = "action-record";

  /// Icon Prefix for STD_*
  static const String C_ICON_STD_ = "slds-icon-standard-";

  static const String STD_LOG_A_CALL = "log-a-call";
  static const String STD_ACCOUNT = "account";
  static const String STD_SOCIAL_POST = "social-post";
  static const String STD_CAMPAIGN_MEMBERS = "campaign-members";
  static const String STD_ARTICLE = "article";
  static const String STD_ANSWER_PUBLIC = "answer-public";
  static const String STD_ANSWER_PRIVATE = "answer-private";
  static const String STD_ANSWER_BEST = "answer-best";
  static const String STD_AVATAR_LOADING = "avatar-loading";
  static const String STD_CAMPAIGN = "campaign";
  static const String STD_CALIBRATION = "calibration";
  static const String STD_AVATAR = "avatar";
  static const String STD_APPROVAL = "approval";
  static const String STD_APPS = "apps";
  static const String STD_USER = "user";
  static const String STD_EVERNOTE = "evernote";
  static const String STD_COACHING = "coaching";
  static const String STD_CONNECTED_APPS_ADMINS = "connected-apps-admins";
  static const String STD_DRAFTS = "drafts";
  static const String STD_EMAIL = "email";
  static const String STD_ENDORSEMENT = "endorsement";
  static const String STD_EVENT = "event";
  static const String STD_DROPBOX = "dropbox";
  static const String STD_CONCUR = "concur";
  static const String STD_EMAIL_CHATTER = "email-chatter";
  static const String STD_CASE_TRANSCRIPT = "case-transcript";
  static const String STD_CASE_COMMENT = "case-comment";
  static const String STD_CASE_CHANGE_STATUS = "case-change-status";
  static const String STD_CONTRACT = "contract";
  static const String STD_DASHBOARD = "dashboard";
  static const String STD_CASE = "case";
  static const String STD_EMPTY = "empty";
  static const String STD_DEFAULT = "default";
  static const String STD_CUSTOM = "custom";
  static const String STD_CANVAS = "canvas";
  static const String STD_CONTACT = "contact";
  static const String STD_PORTAL = "portal";
  static const String STD_PRODUCT = "product";
  static const String STD_FEED = "feed";
  static const String STD_FEEDBACK = "feedback";
  static const String STD_FILE = "file";
  static const String STD_GOALS = "goals";
  static const String STD_GROUPS = "groups";
  static const String STD_INSIGHTS = "insights";
  static const String STD_PERFORMANCE = "performance";
  static const String STD_LINK = "link";
  static const String STD_METRICS = "metrics";
  static const String STD_NOTE = "note";
  static const String STD_LEAD = "lead";
  static const String STD_OPPORTUNITY = "opportunity";
  static const String STD_LOG_A_CALL_CHATTER = "log-a-call-chatter";
  static const String STD_ORDERS = "orders";
  static const String STD_POST = "post";
  static const String STD_POLL = "poll";
  static const String STD_PHOTO = "photo";
  static const String STD_PEOPLE = "people";
  static const String STD_GENERIC_LOADING = "generic-loading";
  static const String STD_GROUP_LOADING = "group-loading";
  static const String STD_RECENT = "recent";
  static const String STD_SOLUTION = "solution";
  static const String STD_RECORD = "record";
  static const String STD_QUESTION_BEST = "question-best";
  static const String STD_QUESTION_FEED = "question-feed";
  static const String STD_RELATED_LIST = "related-list";
  static const String STD_SKILL_ENTITY = "skill-entity";
  static const String STD_SCAN_CARD = "scan-card";
  static const String STD_REPORT = "report";
  static const String STD_QUOTES = "quotes";
  static const String STD_TASK = "task";
  static const String STD_TEAM_MEMBER = "team-member";
  static const String STD_THANKS = "thanks";
  static const String STD_THANKS_LOADING = "thanks-loading";
  static const String STD_TODAY = "today";
  static const String STD_TOPIC = "topic";
  static const String STD_UNMATCHED = "unmatched";
  static const String STD_MARKETING_ACTIONS = "marketing-actions";
  static const String STD_MARKETING_RESOURCES = "marketing-resources";

  /// Icon Prefix for CUSTOM_*
  static const String C_ICON_CUSTOM_ = "slds-icon-";

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



  /// SVG Element
  final svg.SvgSvgElement element = new svg.SvgSvgElement();
  /// Svg Use reference
  final svg.UseElement _use = new svg.UseElement();
  /// Link name
  final String linkName;
  /// Link Prefix
  final String linkPrefix;

  /**
   * Utility Icon
   */
  LIcon.utility(String linkName, {String className, String size, String color})
      : this(linkName, SPRITE_UTILITY, className, size, color);

  /**
   * Standard Icon [linkName] e.g. CIcon.STD_CASE
   */
  LIcon.standard(String linkName, {String className: C_ICON, String size: C_ICON__LARGE})
      : this(linkName, SPRITE_STANDARD, size, className, "${C_ICON_STD_}${linkName}");

  /**
   * Action Icon - [name] e.g. CIcon.ACTION_DESCRIPTION
   */
  LIcon.action(String name, {String className: C_ICON, String size: C_ICON__LARGE})
      : this(name.replaceAll("action-", ""), SPRITE_ACTION, className, size, "${C_ICON_ACTION_}${name}");

  /**
   * Custom Icon - [name] e.g. CIcon.CUSTOM_1
   */
  LIcon.custom(String name, {String className: C_ICON, String size: C_ICON__LARGE})
      : this(name, SPRITE_CUSTOM, className, size, "${C_ICON_CUSTOM_}${name}");

  /**
   * svg
   * - use
   * [linkName] for use href #name - e.g. add
   * [linkPrefix] for use href - e.g. SPRITE_ACTION/CUSTOM/UTILITY/...
   * [className] optional className, e.g. C_ICON
   * [size] optional C_ICON__TYNY/SMALL/MEDIUM/LARGE
   * [color] optional C_ICON_TEXT_DEFAULT/WARNING
   */
  LIcon(String this.linkName, String this.linkPrefix, String className, String size, String color) {
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
    element.setAttributeNS(null, "aria-hidden", "true");
    element.append(_use);
    _use.href.baseVal = "${HREF_PREFIX}${linkPrefix}${linkName}";
  }

  /// svg element classes
  CssClassSet get classes => element.classes;


  /// set [cssSize] - C_ICON__LARGE, C_ICON__MEDIUM, C_ICON__SMALL, C_ICON__TINY
  void set size (String cssSize) {
    element.classes.removeAll([C_ICON__LARGE, C_ICON__MEDIUM, C_ICON__SMALL, C_ICON__TINY]);
    if (cssSize != null && cssSize.isEmpty)
      element.classes.add(cssSize);
  }

} // LIcon

/**
 * Span with icon
 */
class LIconSpan {

  /// the span element
  final SpanElement element = new SpanElement();

  /**
   * Standard Icon Span
   * [name] standard icon name e.g. CIcon.STD_CASE
   */
  LIconSpan.standard(String name, {bool circle: false, String title}) : this(
          new LIcon.standard(name),
          circle: circle,
          title: title,
          spanClass: "${LIcon.C_ICON_STD_}${name}");

  /**
   * Action Icon Span
   * [name] action icon name e.g. CIcon.ACTION_DESCRIPTION
   */
  LIconSpan.action(String name, {bool circle: false, String title}) : this(
          new LIcon.action(name),
          circle: circle,
          title: title,
          spanClass: "${LIcon.C_ICON_ACTION_}${name}");

  /**
   * Create Span with Icon
   */
  LIconSpan(LIcon icon, {bool circle: false, String title, String spanClass}) {
    element.classes.add(LIcon.C_ICON__CONTAINER);
    if (spanClass != null && spanClass.isNotEmpty) {
      element.classes.add(spanClass);
    }
    if (circle) {
      element.classes.add(LIcon.C_ICON__CONTAINER__CIRCLE);
    }
    element.append(icon.element);
    //
    if (title != null && title.isNotEmpty) {
      SpanElement span = new SpanElement()
        ..classes.add(LIcon.C_ASSISTIVE_TEXT)
        ..text = title;
      element.append(span);
    }
  }

} // LIconSpan
