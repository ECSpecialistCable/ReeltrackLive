
// core.js: for the Trampoline 5.x admin
// Built against jQuery 1.4.x


var CORE = function(){

    /* begin private methods */
	var _HISTORY = [];

    /* end private methods */
    
    /* begin public methods */
    
    /*
    _loadMainContentData: takes some raw html, inserts it into the 
    main content area and applies behaviors to these newly added elements
    */
    var _loadMainContentData = function(data, callback){
        
		
		
        DEBUG("CORE.loadMainContentData: started");
        
        $(__MAIN_CONTENT__).html(data);

        window.location.hash = $(__TABSET_FOR_PAGE__).html();
		DEBUG("CORE.HASH_LOCATION: added : " + window.location.hash);


		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "form");
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "input");
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "select");				
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "a");	
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "table");
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "img");
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "h2");
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "div");	
		BEHAVIORS.applyBehaviors(__MAIN_CONTENT__, "td");	
		
		
        // check for notification div, then show it
        DEBUG("CORE.loadMainContentData: checking for notification on load");
        if($("#flash").length > 0){
			alert($("#flash").html());
           	// NOTIFICATION.displayMsg($("#flash").html(), false, $("#flash_color").html()); 
        } else {
            DEBUG("CORE.loadMainContentData: you ain't got no notification");
        };
        
        
        //check for tabs and trigger tab load               
        
        loadTabSet(__TABSET_FOR_PAGE__);                    
		if(callback){
			callback();
		};
                    
    }; // end loadMainContentData
    
    
    /*
    _loadPage: uses an AJAX GET to retrieve data at a URL, executes a callback
    function on successful retrieval, and also loads a tabset associated
    with the retrieved page.
    */
    var _loadPage = function(url, callback){
		var success = false;

        DEBUG("CORE.loadPage: " + url);
        /*
            ajax load the #main element
        */
        
		

  		
        AJAX_GET(url, 
            
            // if the GET was successful
            function(response)  {
                response = $.trim(response);
                if(response){
					// stash the url in the _HISTORY
					if(!url.startsWith(__PROCESS_PAGE__)){
						DEBUG("CORE._loadPage recorded url: " + url);
						_HISTORY.push(url);
					} else {
						DEBUG("CORE._loadPage is not recording process url: " + url);
					};
                    DEBUG("CORE.loadPage: we have some actions for this module");
                    DEBUG("CORE.loadPage: " + __TABSET_FOR_PAGE__);
                    _loadMainContentData(response);
                    //  execute the callback if the ajax call is successful and if the callback is not undefined
                    //  the callback won't exist for most links.
                    //  it'll be used internally though, to register activity in the admin
                    //  and to do a little sump'n sump'n extra, such as animation transitions.
                
                    if(callback){
                        callback();
                    }

					success = true;
                
                }
                
            }, 
            // and...if it wasn't
            function(errorMSG){
            //do some error reporting if the ajax call fails. an alert is fine
                if(errorMSG){
                    alert(errorMSG);
                }
            }
        );

		return success;
        
    }; // end loadPage
    
    
    /*
    loadTabSet
    */
	
    var loadTabSet = function(tabset){
        var currentURL = $(tabset).html();
		
        if($(tabset) && $(tabset).attr("href") && currentURL){
            DEBUG("CORE.loadTabSet");

            //set the url for the AJAX load of the tabs
            var tabSetURL = $(tabset).attr("href");
            
            //load the tabs through AJAX
            AJAX_GET(tabSetURL, function(tabResponse){
                $(__TABS__).html(tabResponse);
				
				//SAVE TABSET for comparison
				if(__TAB_SET_DATA__ != undefined){
					
					if(__TAB_SET_DATA__ == tabResponse){
						DEBUG("CORE.loadTabSet: tabs are the same");
						__TAB_SET_SAME_FLAG__ = true;
					}else{
						__TAB_SET_SAME_FLAG__ = false;
					}
				}
				__TAB_SET_DATA__ = tabResponse;
				
                DEBUG("CORE.loadTabSet: got some tabs");
                
                var container = $(__TABS__);

                // set the behaviors
                // tabsets should only have <a> tags
                BEHAVIORS.applyBehaviors(container, "a");

                //set active tab
				DEBUG("CORE.loadTabSet: got some tabs");

                $(__TABS__).find("a[href*='" + currentURL + "']").addClass(__TAB_ACTIVE_CLASS__);
                
				
               	//get width and set arrows
			
                var tabsLength = 0;
                var curTabPos = 0;
               
                $(__TABS__).find("a").each(function(index){
                    var tempWidth = $(this).width();
                    tabsLength = tabsLength + tempWidth + 2;
                });
               
                $(__TABS__).css({"width": tabsLength});
               
                if(tabsLength > __MAIN_AREA_WIDTH__){
	
					if(!__TAB_SET_SAME_FLAG__){
                    DEBUG("CORE.loadTabSet: tabs need arrows");
                   
                    var tabsArrowRightArray = [];
                    var tabsArrowLeftArray = [];
                    var curPos = 0;
                    var curWidth = 0;
                    var tempPosWidth = 0;
                   
                    $(__TABS__).find("a").each(function(j){
                        curWidth = $(this).width();
                        DEBUG("CORE.TAB_ARROW: " + curPos);
                        if(j != 0){
                            tempPosWidth = curPos + 2 + curWidth;
                        }
                       
                        if(tempPosWidth < __MAIN_AREA_WIDTH__){
                            if(j != 0){
                                tempPosWidth = curPos *  -1;
                            }
                            tabsArrowLeftArray.unshift(tempPosWidth);   
                        }else{
                            tempPosWidth = -1 * (tempPosWidth - 757);
                            tabsArrowRightArray.push(tempPosWidth);
                        }
                        curPos = curPos + curWidth + 2;
                    });
                   
                   
                    $(__TABS_ARROWS__).show();
                    $(__TABS_ARROW_LEFT__).unbind("click");
                    $(__TABS_ARROW_LEFT__).click(function(){
                        var tabPos = $(__TABS__).position();
                        DEBUG("CORE.TAB_ARROW_LEFT Mouseover: " + tabPos.left + ", " + curTabPos);
                        if(tabPos.left < 0){
                            for(i in tabsArrowLeftArray){
                                DEBUG("CORE.TAB_ARROW_LEFT Mouseover: " + tabsArrowLeftArray[i] + ", " + curTabPos);
                                if(tabsArrowLeftArray[i] > curTabPos){
                                    curTabPos = tabsArrowLeftArray[i];
                                    break;
                                }
                            }
                            $(__TABS__).animate({
                                'left' : curTabPos
                            });
                        }
                       
                        return false;
                    });
                    $(__TABS_ARROW_RIGHT__).unbind("click");
                    $(__TABS_ARROW_RIGHT__).click(function(){
                        var tabPos = $(__TABS__).position();
                        DEBUG("CORE.TAB_ARROW_LEFT Mouseover: " + tabPos.left);
                        var maxRightMove = -1 * ($(__TABS__).width() - 757);
                        if(tabPos.left > maxRightMove){
                            for(i in tabsArrowRightArray){
                                if(tabsArrowRightArray[i] < curTabPos){
                                    curTabPos = tabsArrowRightArray[i];
                                    break;
                                }
                            }
                           
                           
                            //$(__TABS__).css({"left": curTabPos});
                           
                            $(__TABS__).animate({
                                'left' : curTabPos
                            });
                           
                        }
                        return false;
                    });
 					}
                }else{
					$(__TABS__).css({
                        'left' : 0
                    });
					$(__TABS_ARROWS__).hide();	
				}
               
                
                // that line should replace this iterator
                // $(containerLinks).each(function(){
                //  if($(this).attr('href').indexOf(currentURL) != -1){ 
                //      $(this).addClass(__TAB_ACTIVE_CLASS__);
                //      console.log("CORE.loadTabSet: highlighting tab...");
                //  } else {
            //          DEBUG("CORE.loadTabSet: " + $(this).attr('href') + " does not contain " + currentURL);
                //  }
                // });
                
            }, function(tabErrorResponse){
                if(tabErroResponse){
                    alert(tabErroResponse);
                }
            });
        }
        
    }
    
    // chrisaquino: 20110114 -> removing url arg from method signature
    //var _loadModules = function(url){
    var _loadModules = function(){
		BEHAVIORS.applyBehaviors(__MODULES__, "a");
		
        $(__TOP_LEVEL_MODULE_NAV__).each(function(){
            // cache "this"
            var that = $(this);
            // load the subnavs
            // ajax get the subnavs from the server, 
            // add them below the current nav
        	
            var url = $(this).attr("rel") + __MODULE_ACTIONS_PAGE__;
            DEBUG("loading a module action from url " + url);
            
            $.get(url, function(response){
                response = $.trim(response);
                if(response){   
					var container;
					if(that.hasClass(_MODULE_TOGGLE_)){
                    	container = $("<div style='display:none;'></div>");
					}else{
						container = $("<div></div>");
					}
                    var payload = $(response);
                    payload.appendTo(container);
                    container.insertAfter(that);
                	if(that.hasClass(_OPEN_NAV)){
		                // open it up

						var that_module = $(that.next('div'));
						DEBUG("_loadModules " + that_module.html());
						that_module.slideDown(1000);
		                that.addClass(_ACTIVE_MODULE);                
		                // @TODO: auto-load any default module action

		            } else {
		                // keep it closed
		                that.removeClass(_ACTIVE_MODULE);
		            };
                    // attach any extra behaviors, but limit to the current 
                    // context for performance reasons
                    DEBUG("applying behaviors");
                    BEHAVIORS.applyBehaviors(container, "a");
                
                };
            });
        
            // set modules to be visually opened or closed
		
            if(that.hasClass(_OPEN_NAV)){
                // open it up
				             
                // @TODO: auto-load any default module action
                
            } else {
                // keep it closed
                that.removeClass(_ACTIVE_MODULE);
            };
        });
        
        // chrisaquino: 20110114 -> commenting out
        // the following chunk, as we're not doing this yet
        
        // if(url != ""){
        //  //loadPage(url);
        // }
    };  
    

    var _submitNonAjaxForm = function(obj){
        var the_FORM = $(obj);
        if(the_FORM.attr("action") != ""){
            var url = the_FORM.attr("action");
            DEBUG("BEHAVIORS.availableBehaviors.submitNonAjaxForm: " + obj.attr("action"));
            //check if needs to be Validated
           return FORM.isValid(the_FORM);
        }else{
             return false;
        }
        
    };

	var _reloadPage = function(){
		var lastURL = _HISTORY.pop();
		DEBUG("CORE._reloadPage is reloading: " + lastURL);
		_loadPage(lastURL);
	};
    
	var _initColorBoxContents = function(){
		DEBUG("we are in the colorbox");
		DEBUG("applying behaviors for colorbox");
		
		// hmmm...
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "form");
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "input");
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "select");				
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "a");	
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "table");
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "img");
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "h2");
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "div");	
		BEHAVIORS.applyBehaviors(__COLORBOX_CONTENT__, "td");	
	}

    /* end public methods */
    
    return {
        loadMainContentData: _loadMainContentData,
        loadPage: _loadPage,
        loadModules: _loadModules,
        submitNonAjaxForm: _submitNonAjaxForm,
		reloadPage: _reloadPage,
		initColorBoxContents: _initColorBoxContents,
        __end__: {}
    };
}();


