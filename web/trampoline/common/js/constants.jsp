// core.js: for the Trampoline 5.x admin
// Built against jQuery 1.4.x

/* constants do not need to be namespaced. */
var _DEBUG = false;

//
var __TRAMP_ROOT__					= "<%= request.getContextPath() %>/trampoline/";

// INTERFACE CONSTANTS
var __MAIN_AREA_WIDTH__ 			= 757;

// DOM ELMENTS
var __MODULES__ 					= "#modules";
var __TOP_LEVEL_MODULE_NAV__ 		= "#modules > a";
var __MAIN_CONTENT__				= "#main";
var __COLORBOX_CONTENT__			= "#cb_content_container";		// holds colorbox content
var __CONTAINER__                   = "#container";                 // holds everything
var __TABS__ 					    = "#tabs";                      // container for the tabs
var __TABS_MASK__ 					= "#tabs_mask";                 // container mask for the tabs
var __TABS_ARROWS__ 				= "#tab_arrows";                // container arrows for the tabs
var __TABS_ARROW_LEFT__ 			= "#tabs_arrow_left";           // container arrow left for the tabs
var __TABS_ARROW_RIGHT__ 			= "#tabs_arrow_right";          // container arrow right for the tabs
var __TAB_ACTIVE_CLASS__            = "active";
var __INVISIBLE_DIV__				= "#invisible";
var __INVISIBLE_DIV_ID__			= "invisible";
var __DEFAULT_SUBMISSION_FRAME__	= "__default_submissionframe";

// ATTRIB NAMES
var __TABSET_FOR_PAGE__             = "#tabset_for_page";           //
var __MODULE_ACTIONS_FOR_TABSET__   = "#module_actions_for_tabset"; //    
var __TABSET_HIGHLIGHT_FOR_PAGE__   = "#tabset_highlight";          // 

// CLASS NAMES
var AJAX_LOADABLE					= "ajax_loadable";
var _ACTIVE_MODULE					= "active_module";
var _OPEN_NAV						= "open";
var _MODULE_TOGGLE_					= "module_bar_toggle";
var __WARNING_MESSAGE__				= "warning_msg";

// PAGE NAMES (including leading slash)
var __MODULE_ACTIONS_PAGE__		    = "/_moduleactions.jsp";       // where dynamic module actions are contained
var __PROCESS_PAGE__				= "process.jsp";

// MESSAGES
var __DEFAULT_ERROR_MESSAGE__ 		= "TODO: PUT THIS IN A NOTIFICATION: Your Request could not be processed. There was an error";


//HTML
var __TOGGLE_BTN_SET__ 				= "<div id='toggle_btn'><a><img id='toggle_plus' class='toggle_img' src='common/images/toggle_plus.gif' width='18' height='19' alt='Toggle Plus' border='0' /><img id='toggle_minus' class='toggle_img'' src='common/images/toggle_minus.gif' width='18' height='19' alt='Toggle Plus' border='0' /></a></div>";

var __TOGGLE_TXT_SET__ 				= "<div id='toggle_txt'><a>[ toggle ]</a></div>";

var __TAB_SET_SAME_FLAG__			= false;
var __TAB_SET_DATA__;
