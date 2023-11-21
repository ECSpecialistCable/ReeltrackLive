
// admin.js: main javascript functionality for the Trampoline 4.x admin
// Built against Yahoo! YUI v2.5.x

// self invoking namespace for the Trampoline ADMIN
var ADMIN = function(){
    
    var DEBUG = true;
	
	var EDITOR_CONFIG = {
		height: '300px', 
		// width: '522px', 
		dompath: false, //Turns on the bar at the bottom 
		animate: true, //Animates the opening, closing and moving of Editor windows 
        toolbar: { 
            // titlebar: 'Editing Tools', 
            collapse: false, 
            buttons: [ 
                { group: 'textstyle', label: 'Font Style', 
                    buttons: [ 
                        { type: 'push', label: 'Bold', value: 'bold' }, 
                        { type: 'push', label: 'Italic', value: 'italic' }, 
                        { type: 'push', label: 'Underline', value: 'underline' }
                        // { type: 'separator' },
                        // { type: 'push', label: 'Subscript', value: 'subscript' },
                        // { type: 'push', label: 'Superscript', value: 'superscript' }

                    ] 
                }, 
                // { type: 'separator' },
                // { group: 'alignment', label: 'Alignment',
                //     buttons: [
                //         { type: 'push', label: 'Align Left CTRL + SHIFT + [', value: 'justifyleft' },
                //         { type: 'push', label: 'Align Center CTRL + SHIFT + |', value: 'justifycenter' },
                //         { type: 'push', label: 'Align Right CTRL + SHIFT + ]', value: 'justifyright' },
                //         { type: 'push', label: 'Justify', value: 'justifyfull' }
                //     ]
                // },
                // { type: 'separator' },
                // { group: 'indentlist', label: 'Lists',
                //     buttons: [
                //         { type: 'push', label: 'Create an Unordered List', value: 'insertunorderedlist' },
                //         { type: 'push', label: 'Create an Ordered List', value: 'insertorderedlist' }
                //     ]
                // },
                { type: 'separator' },
                { group: 'insertitem', label: 'Insert Item',
                    buttons: [
                        { type: 'push', label: 'HTML Link CTRL + SHIFT + L', value: 'createlink' }
						// ,
						//                         { type: 'push', label: 'Insert Image', value: 'insertimage' }
                    ]
                }

			]
 
        } 
	};


	var GLOBALS = {};	// for debug purposes only


    //-------------------------> BEGIN CONSTANTS FOR THE ADMIN
    // YUI shortcuts
    var $E = YAHOO.util.Event;
    var $D = YAHOO.util.Dom;
    var $C = YAHOO.util.Connect;
    var $A = YAHOO.util.Anim;
    var $ = $D.get;    

    
    // contants
    // IDs of DOM elements
    var __CONTAINER__                   = "container";                  // holds everything
    var __MAIN__ 					    = "main";                       // container for the forms
    var __TABS__ 					    = "tabs";                       // container for the tabs
    
    var __TAB_ACTIVE_CLASS__            = "active";

    var __MODULES__ 				    = "modules";                    // container for the module menu and actions
    var __MODULE_ACTIONS__			    = "moduleactions";	            // list of displayed module actions 
    var __MODULE_MENU__ 				= "moduleselector";	            // the drop down
    var __MODULES_GO_BUTTON__			= "modules_go_button";          // the submit button
                                                                        
    var __BRANDING__ 				    = "branding";                   // container for client logo
    var __FOOTER__ 					    = "footer";

    var __SEARCH_FORM__				    = "search";
    var __SEARCH_TERMS__				= "search_terms";
    var __SEARCH_RESULTS_CONTAINER__	= "searchresultscontainer";     // container; can be shown or hidden
    var __SEARCH_RESULTS__			    = "searchresults";              // the actual results
    var __SEARCH_HIDER__				= "searchresultshider";         // button/link for hiding the search results
    var __SEARCH_BY_COLUMNS__			= "search_by";                  // the select box/dropdown holding the search_by columns

    var __LOGIN_FORM_STUB__             = "loginform_stub";
    var __LOGIN_FORM_URL__              = "common/includes/login.jsp";
    var __LOGIN_FORM__                 	= "login";
    var __LOGOUT_FORM__                 = "logout";
    
    var __SUBMISSION_FRAME__            = "_submissionFrame";
    
    // these are the error strings returned by Tomcat
    var __ERROR_503__                   = "HTTP Status 503";
    var __ERROR_502__                   = "HTTP Status 502";
    var __ERROR_501__                   = "HTTP Status 501";
    var __ERROR_500__                   = "HTTP Status 500";
    var __ERROR_408__                   = "HTTP Status 408";
    var __ERROR_404__                   = "HTTP Status 404";
    var __ERROR_403__                   = "HTTP Status 403";
    var __ERROR_400__                   = "HTTP Status 403";
    
    // aggregate the useful ones into an array
    var __ERRORS__                      = [ __ERROR_503__, 
                                            __ERROR_502__, 
                                            __ERROR_501__, 
                                            __ERROR_500__, 
                                            __ERROR_408__, 
                                            __ERROR_404__, 
                                            __ERROR_403__, 
                                            __ERROR_400__
                                        ];

    var __ERROR_CODES__                 = [500, 404]

    var __FLASH__                       = "flash";                      // the global notifier div
    var __REQUIRED__                    = "required";
    var __REQUIRED_TEXT__               = "The following fields are required: ";

    var __TABSET_FOR_PAGE__             = "tabset_for_page";            //
    var __MODULE_ACTIONS_FOR_TABSET__   = "module_actions_for_tabset";  //    
    var __TABSET_HIGHLIGHT_FOR_PAGE__   = "tabset_highlight";           // 
    
    // global notifier's colors
    var __FLASH_COLOR_START__           = "#ccc";
    var __FLASH_COLOR_END__             = "#000";
    var __FLASH_BG_START__              = "#f00";
    var __FLASH_BG_END__                = "#fff";
    

    // PAGE NAMES (including leading slash)
    var __MODULE_ACTIONS_PAGE__		    = "/_moduleactions.jsp";        // where dynamic module actions are contained
    var __MODULE_DEFAULT_PAGE__		    = "/_default.jsp";              // where dynamic module actions are contained
    var __SEARCH_BY_COLUMNS_PAGE__		= "/_searchbycolumns.jsp";      // where searchable field names are held
    var __SEARCH_ACTION__			    = "/search.jsp";                // where the search results come from


    // NUMERICAL CONSTANTS
    // The speed, in seconds, of the show/hide effect:
    var __ANISPEED__                    = 1.2;
    
    var __HTML_EDITOR__                 = false;

    // END CONSTANTS FOR THE ADMIN <-------------------------



    //-------------------------> BEGIN PRIVATE METHODS FOR THE ADMIN
    

    /************************************************************************************************
    ADMIN.util:
        utility functions
    ************************************************************************************************/            
    var util = {

        /************************************************************************************************
        ADMIN.util.thread:
            partially simulate threading in the browser's javascript engine
        ************************************************************************************************/            
        thread: {
            /************************************************************************************************
            start: 
                convenience method to yield execution control back to the browser
                essentially, fire off a "thread" so that things don't get held up
                takes a function object as a param (which can also be a function literal)
            ************************************************************************************************/                    
            start: function(fn){
               setTimeout(fn, 0);            
            }
        },

        /************************************************************************************************
        ADMIN.util.validate:
            generic form validator
        ************************************************************************************************/
        validate: function(whichform){
			if(whichform){
				if(DEBUG){
					console.log("got something passed in...");
					console.log(whichform);
				}
				var forms = [];
				forms.push(whichform);
			} else {
				if(DEBUG){
					console.log("grabbing all forms out of the maincontent div");
				}
                var forms = $(__MAIN__).getElementsByTagName('form');				
			}
            // get any forms in the maincontent area
            var ok = true;
            var missing = __REQUIRED_TEXT__;

			if(DEBUG){
				console.log("these are the forms we've got");
				console.log(forms);
			}

            for (var i = forms.length - 1; i >= 0; i--){
                // var elms = forms[i].getElementsByTagName('*');

                var elms = $D.getElementsBy(function(el){
                    return el.getAttribute(__REQUIRED__);
                }, '*', forms[i].getAttribute('id'));

                for (var j=0; j < elms.length; j++) {
                    // if(elms[j].getAttribute(__REQUIRED__) == "true" && elms[j].value == ""){
                    if(elms[j].value == "" || elms[j].value == "<p>&nbsp;</p>"){
                        missing +=  "\n" + elms[j].getAttribute('name');
                        ok = false;
                    }
                };
            };

            if(!ok){
                alert(missing);
            };
            
            if(DEBUG){
              console.log("everything is cool. we're returning from the form");
            }
            return ok;
        },
        
        /************************************************************************************************
        ADMIN.util.show_iframe:
            show the contents of the iframe in a new window
        ************************************************************************************************/
        show_iframe: function(doc, inline){     
	       if(inline){
				// $D.setStyle(__SUBMISSION_FRAME__, 'height', '500px');
				// $D.setStyle(__SUBMISSION_FRAME__, 'width', '500px');
			} else {	
				var errwindow = window.open("");
				errwindow.document.write(doc);
				errwindow.document.close();
			}
		}, // end util.show_iframe


        /************************************************************************************************
        ADMIN.util.exception:
            server error exceptions and errors
        ************************************************************************************************/
        exception: {            
            report: function(error, doc){                
                if(confirm("The server encountered error: " + error+ "\n\nView Error?")){
					util.show_iframe(doc, false);
                } else {
                    return;
                }
            }, // end util.exception.report
            
            handle: function(o){
                for (var i = __ERROR_CODES__.length - 1; i >= 0; i--){
                    if(o){
                        if(o.status == __ERROR_CODES__[i]){
                            util.exception.report(__ERROR_CODES__[i], o.responseText);
                        }                                                    
                    } else {
                        var doc = frames[__SUBMISSION_FRAME__].document.body.innerHTML;
                        var location = frames[__SUBMISSION_FRAME__].location.href;
                        if(doc.indexOf(__ERROR_CODES__[i]) != -1){
                           util.exception.report(__ERROR_CODES__[i], doc);
                           // console.log(location);
                        }
                    }
                };                    
                return;
            } // end util.exception.handle
            
        },

        /************************************************************************************************
        ADMIN.util.ajax:
        	provides convenience methods for ajax calls
        	also handles the state of the ajax app, allowing reloads of last visited locations
        ************************************************************************************************/            
        ajax: {
            _lasturi: "",
            _lastcallback: {},

            /*
                add workaround: had to put '../' in the get
                when i call the reload, i'm usually in a sub-folder
            */
            reload: function(){
                util.ajax.get('../' + util.ajax._lasturi, util.ajax._lastcallback);
            },

            cachebuster: function(){
                return "?cachebuster=" + (new Date()).getTime();
            },

            /*
                todo: modify the callback wrapper so that it handles all different callbacks expected

            */
            get: function(uri, callback){
                // preprocess the uri, adding the cachebuster
                
                // add the cachebuster
                uri = uri + util.ajax.cachebuster()
                
                // make sure we don't have a malformed querystring
                while(uri.indexOf("?") != uri.lastIndexOf("?")){
                    uri = uri.substring(0, uri.lastIndexOf("?")) + "&" + uri.substring(uri.lastIndexOf("?") + 1);
                }

                var current_uri = uri;              // cache to avoid closure problems in the callback_wrapper            
                var current_callback = callback;    // cache to avoid closure problems in the callback_wrapper
                
                var callback_wrapper = {
                    success: function(o){
                        current_callback.success(o);
                        util.ajax._lasturi = current_uri;
                        util.ajax._lastcallback = current_callback;                                      
                    },
                    failure : function(o){
                        if(current_callback.failure){
                            current_callback.failure(o);
                        }
                        
                        util.exception.handle(o);
                    }
                };
                try{
                    $C.asyncRequest('POST', current_uri, callback_wrapper); 
                } catch(e) {
                    // console.log(e);
                }
            }
        } // end ajax

        
    }; // end ADMIN.util

    
    /************************************************************************************************
    ADMIN.fx:
        special effects, eye candy, and other frivilous UI enhancements
    ************************************************************************************************/      
    var fx = {
        
        /************************************************************************************************
        ADMIN.fx.flash:
        	visual effects to notify the user that something has happened.        	
        ************************************************************************************************/
        flash: {
            go: function(){
                var attributes = {
                    color: { from: __FLASH_COLOR_START__, to: __FLASH_COLOR_END__ },
                    backgroundColor: { from: __FLASH_BG_START__, to: __FLASH_BG_END__ }
                };
                var anim = new YAHOO.util.ColorAnim(__FLASH__, attributes, __ANISPEED__);
                anim.animate();
            },
            
            set: function(){
                $E.onAvailable(__FLASH__, fx.flash.go);                          
            },
            
            reset: function(){
                $E.onAvailable(__FLASH__, fx.flash.go);                          
            }
        }, // end flash
        

        /************************************************************************************************
        ADMIN.fx.viewport:
        	cross browser function to get the inner area of the web page
        	taken from: http://www.quirksmode.org/viewport/compatibility.html
        ************************************************************************************************/
        viewport: function(){
            var _x;
            var _y;
            var _adjust = 18;
            var _window = self; // bind to the global window object...not sure if this will work

            if(_window.innerHeight){ 
                // all except Explorer
            	_x = _window.innerWidth;
            	_y = _window.innerHeight;
            } else if(document.documentElement && document.documentElement.clientHeight){
            	// Explorer 6 Strict Mode
            	_x = document.documentElement.clientWidth;
            	_y = document.documentElement.clientHeight;
            } else if(document.body){
                // other Explorers                 
            	_x = document.body.clientWidth;
            	_y = document.body.clientHeight;
            }

            return {
                width: _x,
                height: (_y - _adjust)
            };
        }, // end viewport            	
    	
        
        /************************************************************************************************
        ADMIN.fx.resize_win:
        	measures resizes the admin frame according to the size of the browser window
        ************************************************************************************************/
        resize_win: function() {
            var container = $D.getRegion($(__CONTAINER__));
            var containerheight = container.bottom - container.top;

            var main = $D.getRegion($(__MAIN__));
            var mainheight = main.bottom - main.top;

            var height = fx.viewport().height - (containerheight - mainheight);
            $D.setStyle(__MAIN__, 'height', height + 'px');
        }, // end ADMIN.fx.resize_win    	
        
        
        /************************************************************************************************
        ADMIN.fx.blind:
        	some basic animation borrowed from Dustin Diaz' blog:
        	http://www.thinkvitamin.com/misc/yui-demos/demo-05.html
        ************************************************************************************************/        
        blind: function(el){
        	var oEl = $D.get(el);
        	var height = parseInt($D.getStyle(oEl,'height'));
        	var width = parseInt($D.getStyle(oEl,'width'));

            return {            
                down: function(iTimer, onStart, onTween, onComplete) {
                	var timer = iTimer || 1;
                	var blind = new $A(oEl, { height: { to: 0 } }, timer, YAHOO.util.Easing.easeBothStrong);
                    oEl.style.overflow = 'hidden';

                	if(onStart) {
                		blind.onStart.subscribe(onStart);
                	}
                	if(onTween) {
                		blind.onTween.subscribe(onTween);
                	}
                	if(onComplete) {
                		blind.onComplete.subscribe(onComplete);
                	}

                	blind.animate();
                },
            
                up: function(iTimer, onStart, onTween, onComplete) {
                    oEl.style.visibility = 'hidden';    
                	oEl.style.overflow = 'hidden';	
                	oEl.style.height = '';

                	var height = parseInt(YAHOO.util.Dom.getStyle(oEl,'height'));	
                	oEl.style.height = '0';
                    oEl.style.visibility = 'visible';

                	var timer = iTimer || 1;
                	var blind = new $A(oEl, { height: { to: height, from: 0 } }, timer, YAHOO.util.Easing.easeBothStrong);

                	if(onStart) {
                		blind.onStart.subscribe(onStart);
                	}
                	if(onTween) {
                		blind.onTween.subscribe(onTween);
                	}
                	if(onComplete) {
                		blind.onComplete.subscribe(onComplete);
                	}

                	blind.animate();
                }
            
            };
        } // end blind
    }; // end ADMIN.fx
    
    
    
    /************************************************************************************************
    ADMIN.widget:
        behaviors for UI components that map to html elements
    ************************************************************************************************/      
    var widget = {

	
        /************************************************************************************************
        ADMIN.widget.util:
            collection of handy functions for widget actions
                        
        ************************************************************************************************/            
		util: {
			parseopts: function(query){
				var obj = {};
				var vars = query.split("?")[1].split("&");
				for (var i = vars.length - 1; i >= 0; i--){
					var pair = vars[i].split("=");
					if(pair[1]){
						obj[pair[0]] = pair[1];
					}
				};
			
				return obj;
			}, // end widget.util.parseopts
			
			setopts: function(obj, opts){
				for(prop in opts){
					if(opts.hasOwnProperty(prop)){
						obj[prop] = opts[prop];
					}
				}
					
			} // end widget.util.setopts
		},    
	
	
    
        /************************************************************************************************
        ADMIN.widget.submissionframe:
            utility methods attached to the submision frame
        ************************************************************************************************/            
        submissionframe: {                        
            init: function(){
               // attach a method to the submission frame that scans the contents of the submission frame for error messages
               $E.on($(__SUBMISSION_FRAME__), 'load', util.exception.handle);
            }

        }, // end ADMIN.widget.submissionframe
    
	
	
        /************************************************************************************************
        ADMIN.widget.modulemenu:
            provides functionality to the dropdown module menu
            
            @change:
            when it first loads, it will have to go into the module and pull out the actions
            all the modules and all the actions will be listed out
                        
        ************************************************************************************************/            
        modulemenu: {
            _previous_menu: 0,        
            _NOW_LOADED: '',
            _TYPE_OPTION: 'option',
            _TYPE_LIST: 'list',
            _MENU_TYPE: '', // defaults to nothing

            NOW_LOADED: function(){
                return widget.modulemenu._NOW_LOADED;
            }, // end NOW_LOADED

            is_list: function(){
               if(widget.modulemenu._MENU_TYPE == widget.modulemenu._TYPE_LIST){
                   return true;
               }
            },
        
            is_option: function(){
               if(widget.modulemenu._MENU_TYPE == widget.modulemenu._TYPE_OPTION){
                   return true;
               }
            },
        
            set_current: function(uri){
                widget.modulemenu._NOW_LOADED = uri;
            }, // end set_current
        
            set_actions: function(req){
                $(__MODULE_ACTIONS__).innerHTML = req.responseText;
            },
            
            set_actions_list: function(el){
                var actions_url = el.rel + __MODULE_ACTIONS_PAGE__;
                var new_callback = function(o){

                    var new_el = document.createElement('div');
                    new_el.innerHTML = o.responseText;
                    
                    var links = $D.getChildrenBy(new_el, function(el){ return el.nodeName == 'A';});
                    if(links.length > 0){
                       for (var i = links.length - 1; i >= 0; i--){                           
                           $E.on(links[i], 'click', function(e){
                               var others = $D.getElementsByClassName('active_module');
                               for (var i = others.length - 1; i >= 0; i--){
                                   $D.removeClass(others[i], 'active_module');
                               };
                               var element = $E.getTarget(e);                               
                               $D.addClass(element, 'active_module');
                           });
                       };
                    } else {
                      $D.setStyle(el, 'display', 'none');
                    }

                    $D.insertAfter(new_el, el);
                    $D.setStyle(new_el, 'display', 'none');
					// attach the show/hide behavior...should this be here or in the ADMIN.fx package?
					$E.on(el, 'mousedown', function(){
                                                var child_imgs = $D.getChildrenBy(el, function(e){return e.nodeName == 'IMG';});
						if(/block/.test($D.getStyle(new_el, 'display'))){
							$D.setStyle(new_el, 'display', 'none');

							// manually setting the class should * not be here
							// another special case for this app
							for (var i = child_imgs.length - 1; i >= 0; i--){								
								$D.removeClass(child_imgs[i], 'open');
							};
							
						} else {							
							$D.setStyle(new_el, 'display', 'block');


							// another special case for this app
							for (var i = child_imgs.length - 1; i >= 0; i--){								
								$D.addClass(child_imgs[i], 'open');                        
							}
						}
					});
					
                };
                util.ajax.get(actions_url, { success: new_callback });                                                
                
            },
        
            set_selected: function(which){
                $(__MODULE_MENU__).selectedIndex = which; 
            },
            
            goto_actions: function(actions_uri){
                if(widget.modulemenu.is_option()){
                
                    var new_callback = function(o){
                        widget.modulemenu.set_actions(o);                    
                    }
                    util.ajax.get(actions_uri, { success: new_callback });                                                
                }
            },
        
            go: function(e) {
                var element = $E.getTarget(e);
                if(widget.modulemenu.is_option()){
                    if(element.value != ""){

                        var setup = function(){
                            // remember this as the last selected menu                
                            widget.modulemenu._previous_menu = element.selectedIndex;
                        }();

                        var load_module_default_page = function(){
                            var url = element.value + __MODULE_DEFAULT_PAGE__;
                            dispatch.load.page(url);
                        }();


                    } else {                
                        var teardown = function(){
                            widget.modulemenu.set_selected(widget.modulemenu._previous_menu);
                        }();
                    }
                } else if(widget.modulemenu.is_list()){
//                   console.log("um. it's a list, dummy");
                }
            }, // end modulemenu.go


            init: function() {
                function set_type(type){
                    widget.modulemenu._MENU_TYPE = type;
                    //console.log(widget.modulemenu._MENU_TYPE);
                }                
                
                if($D.getChildrenBy($(__MODULES__), function(el){ return el.nodeName == 'A';}).length){
	                set_type(widget.modulemenu._TYPE_LIST);
	                // since it's a list, we need to dive through all the dirs listed in each <a>s "rel" attribute
	                // each of these has a "moduleactions" file
	                // we'll append those below each corresponding <a>
                
	                var main_modules = $D.getChildrenBy($(__MODULES__), function(el){ return el.nodeName == 'A';});
	                for (var i = main_modules.length - 1; i >= 0; i--){
	                    widget.modulemenu.set_actions_list(main_modules[i]);
	                };

                   
                } else {
                    set_type(widget.modulemenu._TYPE_OPTION);
                    widget.modulemenu.set_selected(0);
                    $E.on(__MODULE_MENU__, 'change', widget.modulemenu.go);                                                   
                }                    
                
            } // end modulemenu.init
        }, // end ADMIN.widget.modulemenu
    


        /************************************************************************************************
        ADMIN.widget.tabset:
        	methods to manipulate the contents of the tab bar
        ************************************************************************************************/    
        tabset: {
            _NOW_LOADED: '',

            NOW_LOADED: function(){
                return widget.tabset._NOW_LOADED;
            }, // end NOW_LOADED
        
            set_current: function(uri){
                widget.tabset._NOW_LOADED = uri;
            }, // end set_current

            set_highlight: function(highlight){
                var tabs = $(__TABS__).getElementsByTagName('a');                
                if(tabs.length > 0){
                    var highlight_idx = 0;
                    for (var i = tabs.length - 1; i >= 0; i--){
                        if(tabs[i].href.indexOf(highlight) != -1){
                            $D.addClass(tabs[i], __TAB_ACTIVE_CLASS__);                
                        } else {
                            $D.removeClass($(tabs[i]), __TAB_ACTIVE_CLASS__);                        
                        }
                    };
                } // end if tabs.length
            }, // end set_highlight
        
            retrieve_module_actions: function() {                
                if($(__MODULE_ACTIONS_FOR_TABSET__)){
                    return $(__MODULE_ACTIONS_FOR_TABSET__).href;
                }
            }, // end retrieve_module_actions

            clear: function(){
                $(__TABS__).innerHTML = '';            
            }, // end clear
        
            load: function(req){
                $(__TABS__).innerHTML = req.responseText;

				var specials = $D.getChildrenBy($(__TABS__), function(el){ return el.rel == "specials";});
				for (var i = specials.length - 1; i >= 0; i--){
					specials[i].onclick();
				};

            }, // end load
            
            go: function(tabset_uri, highlight){
                // don't check this
//                if(tabset_uri != widget.tabset.NOW_LOADED()){
                    var new_callback = function(o){
                        widget.tabset.load(o);                    
                        widget.tabset.set_current(tabset_uri);

						// parse any opts that come from the uri
						var opts = widget.util.parseopts(tabset_uri);
						widget.util.setopts(widget.tabset, opts);

                        if(highlight){
                            widget.tabset.set_highlight(highlight);
                        }
                                        
                        var module_actions = widget.tabset.retrieve_module_actions();
                        if(module_actions){
                            dispatch.load.module_actions(module_actions);
                        }
                    };               

                    util.ajax.get(tabset_uri, { success: new_callback });                                
//                }
                
            } // end widget.tabset.go
        
        
        }, // end ADMIN.widget.tabset



        /************************************************************************************************
        ADMIN.widget.maincontent:
        	methods to manipulate the contents of the main content area
        ************************************************************************************************/    
        maincontent: {
            _NOW_LOADED: '',

			_EDITORS : {},
			_VALUES : {},

            NOW_LOADED: function(){
                return widget.maincontent._NOW_LOADED;
            }, // end NOW_LOADED
        
            set_current: function(uri){
                widget.maincontent._NOW_LOADED = uri;
            }, // end set_current
        
            retrieve_tabset: function(){
                if($(__TABSET_FOR_PAGE__)){
                    return $(__TABSET_FOR_PAGE__).href;
                }
            }, // end retrieve_tabset
            
            retrieve_highlight: function(){
                if($(__TABSET_FOR_PAGE__)){
                   return $(__TABSET_FOR_PAGE__).innerHTML;
                }
            },
        
            clear: function(){
                $(__MAIN__).innerHTML = '';            
            }, // end clear
        
            load: function(req){
                $(__MAIN__).innerHTML = req.responseText;
				// "run specials" <--- DO NOT roll this into the main newadminv2
				var specials = $D.getChildrenBy($(__MAIN__), function(el){ return el.rel == "specials";});
				if(DEBUG){
					console.log("specials: " + specials);
				}
				for (var i = specials.length - 1; i >= 0; i--){
					if(DEBUG){
						console.log("the onclick: " + specials[i].onclick);
					}
					specials[i].onclick();
				};
                // widget.maincontent.apply_tinymce();
				widget.maincontent.apply_editor();
            }, // end load            

            
			apply_editor: function(){
				if(DEBUG){
					console.log("applying editor");
				}
				
				// reset the editor
				widget.maincontent._EDITORS = {};
				
				function add_editor(id){
					if(DEBUG){
						console.log("in add_editor");
						console.log("want to add for id: " + id);
						console.log("currently, we have widget.maincontent._EDITORS[id]: " + widget.maincontent._EDITORS[id]);
						console.log("and the typeof widget.maincontent._EDITORS[id]: " + typeof(widget.maincontent._EDITORS[id]));
					}
					if(widget.maincontent._EDITORS[id]){
						if(DEBUG){
							console.log("already have an editor at that id...shoulnd't add");
						}
					} else {
					
						widget.maincontent._EDITORS[id] = new YAHOO.widget.Editor(id, EDITOR_CONFIG); 
					
						// if(widget.maincontent._VALUES[id]){
						// 	if(DEBUG){
						// 		console.log("setting editor html to...");
						// 		console.log(widget.maincontent._VALUES[id]);
						// 	}
						// 	widget.maincontent._EDITORS[id].setEditorHTML(widget.maincontent._VALUES[id]);
						// };
					
						widget.maincontent._EDITORS[id].render();			
						if(DEBUG){
							console.log("so...it should be added now");	
							console.log("currently, we have widget.maincontent._EDITORS[id]: " + widget.maincontent._EDITORS[id]);
							console.log("and the typeof widget.maincontent._EDITORS[id]: " + typeof(widget.maincontent._EDITORS[id]));
						}
					}
				};

				function save_editor(id){
					if(DEBUG){
						console.log("here are the contents of the editor when the remove is called");
						console.log(widget.maincontent._EDITORS[id].getEditorHTML());
					}					
					// widget.maincontent._VALUES[id] = widget.maincontent._EDITORS[id].getEditorHTML();
					
					
					if(DEBUG){
						console.log("saving the html");
					}
					widget.maincontent._EDITORS[id].saveHTML();


					// if(DEBUG){
					// 	console.log("destroying the editor");
					// }									
					// widget.maincontent._EDITORS[id].destroy();

					// if(DEBUG){
					// 	console.log("setting the id to undefined");						
					// }
					// widget.maincontent._EDITORS[id]	= null;
				};
				
				var forms = $(__MAIN__).getElementsByTagName('form');
				var textareas = $D.getElementsBy(function(el){
				    if(el.getAttribute('htmleditor')){
				        return (el.getAttribute('htmleditor').indexOf("true") != -1);
				    } else {
				       return false;
				    }                        
				},'textarea', __MAIN__);	


				
				if(forms.length && textareas.length) {
					for(var i = textareas.length - 1; i >= 0; i--){
						var current = textareas[i].getAttribute('id');
						try {
							add_editor(current);
						} catch(e) {
							// do nothing
							if(DEBUG){
								console.log("couldn't apply editor to " + current);
								console.log(e);
							}							
						}
					};
					// for (var i = forms.length - 1; i >= 0; i--){
					for (var i=0; i < forms.length; i++) (function(current_form){
						if(DEBUG){
							console.log("currently looking at...");
							console.log(current_form);
						};
						var fn = current_form.onsubmit; // cache the existing onsubmit (which should be the validation code)
						/*********************	
						*** BIG BAD BUG ***
						
						the _last_ value of i is being cached in this closure.
						and that means that the onsubmit isn't being stored properly
						
						*** BIG BAD BUG ***						
						**********************/
					
					
						// this is the loop that runs the validation
						current_form.onsubmit = function(){
							if(fn){
								for(var i = textareas.length - 1; i >= 0; i--){
									var current = textareas[i].getAttribute('id');
									try {
										if(DEBUG){
											console.log("removing the editor");
										};
										// rm_editor(current);
										save_editor(current);
										// widget.maincontent._EDITORS[current].saveHTML();
									} catch(e) {
										// do nothing
										if(DEBUG){											
											console.log(e);
										};
									}
								};
								if(DEBUG){
									console.log("about to call the form's onsubmit");
								};
								var return_val = fn();
								if(DEBUG){
									console.log("the return value = " + return_val);
								}
								
								if(!return_val){
									if(DEBUG){
										console.log("the return value must be false");
									};
									// for(var i = textareas.length - 1; i >= 0; i--){
									// 	var current = textareas[i].getAttribute('id');
									// 	try {
									// 		if(DEBUG){
									// 			console.log("adding it back...");
									// 		};
									// 		add_editor(current);
									// 	} catch(e) {
									// 		// do nothing
									// 	}
									// };
								}

								return return_val;
							} else {
								if(DEBUG){
									console.log("there's no onsubmit");
								}
							}
				
							return false;
					   }; // end onsubmit = function()
					})(forms[i]); // end for forms.length

				} // end if(forms && textareas)
				

				if(DEBUG){
					GLOBALS['editor'] = widget.maincontent._EDITORS;
					GLOBALS['values'] = widget.maincontent._VALUES;
				}
			}, // end apply_editor


            go_from_form: function(form_id){   
                // serialize the form
                $C.setForm($(form_id));                        
                try{                    
					var url = $(form_id).getAttribute("action")
                    $C.asyncRequest('POST', url, { success: function(o){
                        // put results in maincontent div
                        widget.maincontent.load(o);
                        // try to reset the form                        
                        try {
                            $C.setForm(null);
                        } catch(e) {
                            // do nothing.
                        }
                    }}); 
                } catch(e) {
                    // console.log(e);
                }                         
                return false;               
            }, // end go
            
            
            go: function(target_uri, extra_fn){
                // don't do this check. it breaks the update action on .jsp content
//                if(target_uri != widget.maincontent.NOW_LOADED()){
                    var new_callback = function(o){
                        // hide the search
                        dispatch.search.hide();
                    
                        widget.maincontent.clear();
                        if(extra_fn){
                            extra_fn();
                        }                        
                        widget.maincontent.load(o);
                        widget.maincontent.set_current(target_uri);
                    
                        var tabset = widget.maincontent.retrieve_tabset();
                        if(tabset){
                            // load the tabset
                           dispatch.load.tabset(tabset, widget.maincontent.retrieve_highlight());
                        }
                    
                    };               
                    util.ajax.get(target_uri, { success: new_callback });                
//                }
            } // end go
        
        } // end ADMIN.widget.maincontent

    }; // end ADMIN.widget
    

    /************************************************************************************************
    ADMIN.dispatch:
        "master controller" for the admin app, which:
            - sets up the UI, attaching js behaviors
            - receives signals from 
                - the publicly accessible methods sent by:
                    - the init method
                    - the UI
                - objects in ADMIN.widget
            - sends state change signals to the ADMIN.widget objects
    ************************************************************************************************/      
    var dispatch = {
        
        /************************************************************************************************
        ADMIN.dispatch.do_post_login:
        	defines self-invoking functions that initialize different parts of the admin, attaching
        	event handlers directly as anonymous functions. (No need for delegation. We're attaching
        	directly to a few items by their id.)
        ************************************************************************************************/
        do_post_login: function(){

            var init_modulemenu = function(){
                widget.modulemenu.init();
            }();            
            
            var init_submissionframe = function(){
                widget.submissionframe.init();
            }();
                                    
        }, // end ADMIN.dispatch.post_login        
        
        /************************************************************************************************
        ADMIN.dispatch.resize_win:
        	expose the fx.resize_win
        ************************************************************************************************/
        resize_win: fx.resize_win, // end ADMIN.dispatch.resize_win
        
        /************************************************************************************************
        ADMIN.dispatch.flash:
        	expose notifier eye-candy functions
        ************************************************************************************************/
        flash: {
           reset: fx.flash.reset // end reset
        }, // end ADMIN.dispatch.flash
        
        /************************************************************************************************
        ADMIN.util.validate:
            expose form validator
        ************************************************************************************************/
        util: {
           validate: util.validate
        }, // end ADMIN.util.validate
        
        /************************************************************************************************
        ADMIN.util.validate:
            expose form validator
        ************************************************************************************************/
        modulemenu: {
           init: widget.modulemenu.init 
        }, // end modulemenu
        
        
        /************************************************************************************************
        ADMIN.dispatch.search:
        	exposes search as public method        	
			go: does the search based on query string args
        ************************************************************************************************/
		search: {
           go: function(whereto){
//	           widget.searchbar.go_from_link(whereto); 
           },
           
           hide: function(){
//               widget.searchbar.hide_results();               
           }
        }, // end ADMIN.dispatch.search        
        
        /************************************************************************************************
        ADMIN.dispatch.load:
            sends signals to the various widgets to load data
        ************************************************************************************************/
        load: {
	
	        
	    	// dispatch.load.page
            page: function(target_uri, extra_fn){
                // alert(target_uri);
                // always reset the flash when we load a page                
                widget.maincontent.go(target_uri, function(){
                    fx.flash.reset();    
                    if(extra_fn){         
                        extra_fn();
                    }
                });
            },
            
			// dispatch.load.search
            search: widget.maincontent.go_from_form,
           
			// dispatch.load.tabset
            tabset: widget.tabset.go, 

            // dispatch.load.module_actions
            module_actions: widget.modulemenu.goto_actions,

			// dispatch.load.module
            module: function(target_uri, extra_fn){ /* empty function */},
           
			// dispatch.load.last
            last: util.ajax.reload

        } // end ADMIN.dispatch.load
        
    }; // end ADMIN.dispatch
    
    // END PRIVATE METHODS FOR THE ADMIN <-------------------------



    // return publicly accessible methods, mostly passthroughs to the ADMIN.dispatch
    return {    
		
		GLOBALS: GLOBALS,
		
        flash: {
           reset: dispatch.flash.reset
        }, // end flash
        
        util: {
            validate: dispatch.util.validate,

            // not tied to the dispatch. an actual "utility function" used by our custom JSP tag for submitting a form ("submit.tag")
            submit_via_link: function(obj) {
				if(DEBUG){
					console.log("called submit_via_link with arg...");
					console.log(obj);
					console.log("and its type is: " + typeof(obj));
					// console.log("is this the same as the window? " + (obj == window));
					console.log("and its parent form is...");
					console.log($D.getAncestorByTagName(obj, 'form'));
				};
                var form = $D.getAncestorByTagName(obj, 'form');
				if(form.onsubmit){
					if(DEBUG){
						console.log("we have an onsubmit...following");
					};
					form.onsubmit();                  
				} else {
					form.submit();
				}
                //return false;
            },
            
            submit_normal: function(form) {
				if(DEBUG){
					console.log("called submit_normal with arg " + form);
				};
	
                var form = $(form);
                if(ADMIN.util.validate(form)) {
                  form.submit();
                }
                //return false;
            },
            
            submit_self: function(form) {
				if(DEBUG){
					console.log("called submit_self");
				};
	
				// expects a form id or an object representing the form
				if(typeof(form) == "object"){
					form = $(form.name);
				}
                dispatch.load.search(form);										
                //return false;
            }
        },
        
        load: {            
            search: dispatch.load.search,            

            page: dispatch.load.page,

            reload: function(){
                    // reloads the parent
                    window.location.reload();
            },			

            parent_redirect: function(url){
                    window.location = url;
            },           

            last: dispatch.load.last

        }, // end load
        
        modulemenu: {
           init: dispatch.modulemenu.init 
        }, // end modulemenu
        
		search: {
           go: dispatch.search.go
        }, // end search

             
        /************************************************************************************************
        init:
        	page initialization        	
        	init_login_form: puts login form on the screen, otherwise, calls the post_login function
        	init_page_resize: resizes the height of the UI when the browser resizes
        ************************************************************************************************/
        init: function(){
            var init_login_form = function(){
                if($(__LOGIN_FORM__)){
                    //dispatch.load.page(__LOGIN_FORM_URL__);
                    dispatch.do_post_login();
                } else {
					if(DEBUG){
						console.log("doing post login");
					}
                    dispatch.do_post_login();
                }
            }();
            
			// var init_page_resize = function(){      
			// 	$E.addListener(window, "resize", dispatch.resize_win);
			// 	dispatch.resize_win();                
			// }();            
            
        } // end init
                
    }; // end return (of publicly accessible functions)
    
}(); // end ADMIN



// initialize my events when the DOM is available
YAHOO.util.Event.onDOMReady(ADMIN.init, ADMIN, true);
