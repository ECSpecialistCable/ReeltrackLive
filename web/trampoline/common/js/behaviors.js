// behaviors.js: for the Trampoline 5.x admin
// Built against jQuery 1.4.x
/*
@TODO: combine submission methods
@TODO: integrate form validation
*/
var BEHAVIORS = function(){
    
    /* begin private methods */

	var _STATES = {};
	
	// var _createUniqueKeyForState = function(pathToCurrentPage, elementToSaveSateFor){
	// 	return pathToCurrentPage + "---" + elementToSaveSateFor;
	// }
	
	var _saveState = function(elementToSaveSateFor, isOpen){
		if(!_STATES[window.location.hash]){
			_STATES[window.location.hash] = {};
		};
		DEBUG("BEHAVIORS._saveState: : " + elementToSaveSateFor + " :Boolean:" + isOpen);
		var elementsOnPage = _STATES[window.location.hash];
		var key = $(elementToSaveSateFor).attr("id");
		elementsOnPage[key] = isOpen;
		
		/* nice to have*/
		// @TODO: store _STATES object in cookie
		// restore the _STATES object from cookie if it exists
	
		
	}

	var _hasStateForCurrentPage = function(){
		DEBUG("BEHAVIORS._hasStateForCurrentPage: : " + window.location.hash);
		DEBUG("BEHAVIORS._hasStateForCurrentPage: : " + _STATES[window.location.hash])
		if(!_STATES[window.location.hash]){
			return false;
		} else {
			return true;
		};		
	}

	var _stateIsOpen= function(elementID){
		DEBUG("BEHAVIORS._stateIsOpen : " + elementID);
		var elementsOnPage = _STATES[window.location.hash];
		DEBUG("BEHAVIORS._stateIsOpen: " + elementsOnPage[elementID]);
		return elementsOnPage[elementID];
	}



    var availableBehaviors = {
        
        auto_open_module_action: function(obj){
            if(obj){                
                DEBUG("BEHAVIORS.availableBehaviors.auto_open_module_action: looking at: " + $(obj).html());
                if($(obj).attr("href") != ""){
                    DEBUG("BEHAVIORS.availableBehaviors.auto_open_module_action: have URL: " + $(obj).attr("href"));
                    CORE.loadPage($(obj).attr("href"));
                    DEBUG("BEHAVIORS.availableBehaviors.auto_open_module_action: auto loading: " + $(obj).attr("href"));
                }
            };
        },

		input_date_picker: function(obj){
			obj = $(obj);
			Date.firstDayOfWeek = 0;
			Date.format = 'mm/dd/yyyy';
			if(obj.attr("rel")){
				// rel will be used as the earliest date
				// var _month = obj.attr("rel").substring(0, obj.attr("rel").indexOf("/"));
				// if(parseInt(_month) < 10 && _month.length < 2){
				// 	_month = "0" + _month;
				// };
				// var _year = obj.attr("rel").substring(obj.attr("rel").lastIndexOf("/") + 1);
				// _year = "20" + _year;
				// 
				// var _startDate = _month + "/01/" + (_year);
				obj.datePicker({
					startDate: obj.attr("rel")
				});
				// this is the version if you want to set the 
				// initial month/year displayed
				// obj.datePicker({
				// 	startDate: _startDate,
				// 	month: _month-1, 
				// 	year: _year
				// });
			} else {
				obj.datePicker();
			};
		},

        ajax_loadable: function(obj){
            obj = $(obj);
            DEBUG("BEHAVIORS.availableBehaviors.ajax_loadable");
            
            if(obj.attr("href") != ""){         
                obj.click(function(){
					if($(obj).hasClass(__WARNING_MESSAGE__)){
						var ans = confirm(obj.attr('rel'));
						if(ans){
							if(IN_MAIN_ADMIN()){
								DEBUG("BEHAVIORS.availableBehaviors.ajax_loadable: we got confirmation after warning");
								CORE.loadPage(obj.attr("href"));
							} else {
								DEBUG("BEHAVIORS.availableBehaviors.ajax_loadable: we are not in the main admin");
								DEBUG("BEHAVIORS.availableBehaviors.ajax_loadable: assuming a delete...");

								// make sure we submit to an iframe
			                    if(!obj.attr("target")){ 
									obj.attr("target", __DEFAULT_SUBMISSION_FRAME__);
								}

								var framename = obj.attr("target");
								var frameobj = $('<iframe frameborder="0" id="' + framename + '" name="' + framename + '"> </iframe>');
								if($(__INVISIBLE_DIV__).length == 0){	
									DEBUG("BEHAVIORS.availableBehaviors.form...creating invisible div");						
									$('<div id="' + __INVISIBLE_DIV_ID__ + '" style="display: none;"></div>').appendTo(obj.parent());
								};
						
								frameobj.appendTo(__INVISIBLE_DIV__);
								frameobj.load(function(){
									closeColorBox();
								});
			
								return true;
							};
						} else {
							// they declined. don't do anything
						}
					} else {
						// no warning message, just do it.
						CORE.loadPage(obj.attr("href"));						
					}
					return false;
                });
            };
        },

		ajax_submitter: function(obj){
			var _nodeName = obj.nodeName.toLowerCase();
            var obj = $(obj);
            var the_FORM = obj.closest('form');			

			if(_nodeName == 'select'){
            	DEBUG("ajax_submitter: loaded Select ");
	            obj.change(function(){
	                //alert('Handler for .change() called.');
	                the_FORM.submit();
	            });
			} else if((_nodeName == 'input') && (obj.attr("type").toLowerCase() == 'checkbox')){
            	DEBUG("ajax_submitter: loaded checkbox ");
	            obj.change(function(){
	                //alert('Handler for .change() called.');
	                the_FORM.submit();
	            });
			} else {
            	var buttonLink = $($(obj).closest('a'));
	            DEBUG(buttonLink.html());
	            DEBUG("ajax_submitter : probably a linkbutton: " + the_FORM.attr('action'));

				if($(obj).hasClass(__WARNING_MESSAGE__)){
					var ans = confirm(obj.attr('rel'));
					if(ans){
						CORE.loadPage(obj.attr("href"));
					} else {
						
					}
				}else{
					
				}
			
	            buttonLink.click(function(){
	                DEBUG("ajax_submitable_button:" + the_FORM.attr('action'));
	                the_FORM.submit();
	            });
			}
		},
		
        // this used to be ajax_submitable
        form: function(obj){
            
            obj = $(obj);
            
            if(obj.attr("action") != ""){
                var url = obj.attr("action");
                
                $(obj.find("select, input")).each(function(){
                    
                    DEBUG("BEHAVIORS.availableBehaviors.form\nsetting inputFOCUS: ");
                    
                    $(this).focus(function(){
                        $(this).keypress(function(evt){
                            if (event.which == '13') {
                               obj.submit();
                            }
                        });
                    });

                    $(this).blur(function(){
                        $(this).unbind("keypress");
                    }); 
                });
                
                
                    
                obj.submit(function(){
                    //CORE.submitForm();
                    DEBUG("BEHAVIORS.availableBehaviors.form: " + obj.attr("action"));
					// make sure we know where this process page actually is
					if(!/trampoline/.test(obj.attr("action"))){
						obj.attr("action", __TRAMP_ROOT__ + obj.attr("action"));
						DEBUG("BEHAVIORS.availableBehaviors.form...rewriting form action to " + obj.attr("action"));						
					};

                    if(IN_MAIN_ADMIN()){
	                    //for TARGET going to the submissionFrame -- it is returning the entire page from process.jsp (a complete page reload).
	                    if(obj.attr("target")){ 						

							var framename = obj.attr("target");
							var frameobj = $('<iframe frameborder="0" id="' + framename + '" name="' + framename + '"> </iframe>');
							// if($(__INVISIBLE_DIV__).length == 0){	
							// 	DEBUG("BEHAVIORS.availableBehaviors.form...creating invisible div");						
							// 	$('<div id="' + __INVISIBLE_DIV_ID__ + '" style="display: none;"></div>').appendTo("#outer");
							// };
							if($(__INVISIBLE_DIV__).length == 0){	
								DEBUG("BEHAVIORS.availableBehaviors.form...creating invisible div");						
								$('<div id="' + __INVISIBLE_DIV_ID__ + '" style="display: none;"></div>').appendTo(obj.parent());
							};
						
							frameobj.appendTo(__INVISIBLE_DIV__);
							frameobj.load(function(){
								CORE.loadMainContentData(this.contentDocument.body.innerHTML, function(){
									frameobj.remove();
									// DEBUG("BEHAVIORS.availableBehaviors.form...callback is removing the frameobj");
								});
							});						
							return true;							

	                    } else {
							DEBUG("we're submtting a regular form, with no target");
	                        $.post(
	                            url,
	                            $(obj).serialize(),
	                            function(data){
	                                DEBUG("BEHAVIORS.availableBehaviors.form: got data : ");
	                                DEBUG(data);
	                                CORE.loadMainContentData(data);
	                            },
	                            function(){
	                                DEBUG("BEHAVIORS.availableBehaviors.form: error. didn't get data ");
	                            }
	                        );
                        
	                    };

	                    return false;                    
					} else {
						// we're in a lightbox, submit to an iframe and reload in place

						if(obj.hasClass("self_submit")){
							// we're self-submitting
							// are we also in an iframe?
							var isInIFrame = (window.location != window.parent.location) ? true : false;
							if(isInIFrame){
								return true;								
							};
						} else {
		                    if(!obj.attr("target")){ 
								obj.attr("target", __DEFAULT_SUBMISSION_FRAME__);
							}

							var framename = obj.attr("target");
							var frameobj = $('<iframe frameborder="0" id="' + framename + '" name="' + framename + '"> </iframe>');
							if($(__INVISIBLE_DIV__).length == 0){	
								DEBUG("BEHAVIORS.availableBehaviors.form...creating invisible div");						
								//$('<div id="' + __INVISIBLE_DIV_ID__ + '" style=""></div>').appendTo(obj.parent());
								$('<div id="' + __INVISIBLE_DIV_ID__ + '" style="display: none;"></div>').appendTo(obj.parent());
							};
						
							frameobj.appendTo(__INVISIBLE_DIV__);
							frameobj.load(function(){
								// do i want to close the colorbox?
								// closeColorBox();
								var data = null;
								$.get($("iframe").get(0).baseURI + "#cb_content_container", function(response, status, xhr) {
									if (status == "error") {
										DEBUG("error retrieving the contents of that url");
									} else {
										// data = $($(response).get(2)).html();
										data = response;
										// now, we should have some data to put back in our lightbox
										if(data){
											obj.parents("#cb_content_container").replaceWith(data);
											CORE.initColorBoxContents();
										} else {
											// handle the error
										};
									}
								});
							
							
								// the following code can't be used with the gantt chart
								// it's self-submitting, but loading it into the iframe first and then back into the lighbox second
								// created duplicate gantt charts, as the gantt chart creation code was running twice
								/*
								if(obj.hasClass("self_submit")){
									// a self_submit form submits to the same page it lives on
									// here, we want to submit to the iframe, get its contents, and 
									data = $("iframe").get(0).contentDocument.body.innerHTML;
									// now, we should have some data to put back in our lightbox
									if(data){
										// debugger;
										// obj.parents("#cb_content_container").replaceWith(data);
										// CORE.initColorBoxContents();
									} else {
										// handle the error
									};
								} else {
									// we're not self-submitting
									// we want to re-get whatever's url got loaded into the iframe
									// this content may be different from what's acutally in the iframe
									// due to redirects and whatnot
									$.get($("iframe").get(0).baseURI + "#cb_content_container", function(response, status, xhr) {
										if (status == "error") {
											DEBUG("error retrieving the contents of that url");
										} else {
											// data = $($(response).get(2)).html();
											data = response;
											// now, we should have some data to put back in our lightbox
											if(data){
												obj.parents("#cb_content_container").replaceWith(data);
												CORE.initColorBoxContents();
											} else {
												// handle the error
											};
										}
									});
								};
								*/

							
							});						
						}
						
						
						return true;
					};
                    

                });
            };
        },
    //  __end__: {}
    // };
    // 
    // var relBehaviors = {
	
		toggle_trigger: function(obj){
			obj = $(obj);
			
			if(!obj.data('loaded')){
				obj.data('loaded', true);
			
				//get obj pos
				//add a toggle set to the position
				//switch on obj type
			
				DEBUG("BEHAVIORS.availableBehaviors.TOGGLE_BTN: " + obj.get(0).tagName);
				var toggle_trigger_btn;
				var toggle_txt = false;
				var toggle_trigger;
				switch(obj.get(0).tagName){
					case "H2":
						obj.prepend(__TOGGLE_BTN_SET__);
						toggle_trigger = $(obj.find("#toggle_btn a"));
					break;
					case "DIV":
						obj.prepend(__TOGGLE_BTN_SET__);
						toggle_trigger = $(obj.find("#toggle_btn a"));
						toggle_trigger_btn = $(obj.find("#toggle_btn"));
						toggle_trigger_btn.addClass('boxPlacement');
					break;
					case "TD":
						obj.append(__TOGGLE_TXT_SET__);
						toggle_txt = true;
						toggle_trigger = $(obj.find("#toggle_txt a"));
						
					break;
					default:
						obj.prepend(__TOGGLE_BTN_SET__);
						toggle_trigger = $(obj.find("#toggle_btn a"));
						DEBUG("BEHAVIORS.availableBehaviors.TOGGLE_BTN: DEFAULT" + obj.get(0).tagName);
						
					break;
				}
				
				 // multilple targets
				 // var targets = $(the_toggler).attr("rel").split(" ");
				 // 				 var selectors = [];
				 // 				 for (var i=0; i < targets.length; i++) {
				 // 				  selectors.push("." + targets[i]);
				 // 				 };

				 
				
				var toggleTarget = $(obj.attr("rel"));
				
				DEBUG("BEHAVIORS.availableBehaviors.TOGGLE_BTN: TARGET" + obj.attr("rel"));
				
				
				//check against saved states on this page, for this element
				
				
				if(_hasStateForCurrentPage()){
					var savedState = _stateIsOpen($(obj).attr("id"));
				}
				
				
				if(savedState != null){
					if(savedState){
						//multiple selectors
						// $(selectors).each(function(){
						// 						  // do something awesome with these class selectors
						// 						
						// 						 });
						toggleTarget.show();
					}else{
						//multiple selectors
						// $(selectors).each(function(){
						// 						  // do something awesome with these class selectors
						// 						
						// 						 });
						toggleTarget.hide();
					}
				}else{
					if(obj.hasClass("toggleIsClosed")){
						//multiple selectors
						// $(selectors).each(function(){
						// 						  // do something awesome with these class selectors
						// 						
						// 						 });
						toggleTarget.hide();
					}else{
						//multiple selectors
						// $(selectors).each(function(){
						// 						  // do something awesome with these class selectors
						// 						
						// 						 });
						toggleTarget.show();
					}
				}	
				
				
				if(!toggle_txt){
					var togglePlus = toggle_trigger.find('img#toggle_plus');
					var toggleMinus = toggle_trigger.find('img#toggle_minus');
			
					if(toggleTarget.is(':visible')){
						togglePlus.hide();
						toggleMinus.show();
					}else{
						togglePlus.show();
						toggleMinus.hide();
					}
				}
				
				toggle_trigger.click(function(){
				
					if(toggleTarget.is(':visible')){
						//multiple selectors
						// $(selectors).each(function(){
						// 						  // do something awesome with these class selectors
						// 						
						// 						 });
						toggleTarget.slideUp(500, function(){
							_saveState(obj, false)
						});
						if(!toggle_txt){
							togglePlus.show();
							toggleMinus.hide();
						}
					}else{
						//multiple selectors
						// $(selectors).each(function(){
						// 						  // do something awesome with these class selectors
						// 						
						// 						 });
						toggleTarget.slideDown(500, function(){
							_saveState(obj, true)
						});
						if(!toggle_txt){
							togglePlus.hide();
							toggleMinus.show();
						}
					}
				});
				toggle_trigger.show();
			}
			//process toggle_btn -- to have click actions -- with targets from obj.attr('rel')
			
		},
		module_bar_toggle:function(obj){
			obj = $(obj);
			if(!obj.data('loaded')){
				obj.data('loaded', true);
				obj.click(function(){
					//check open or closed
					var nextObj = $(obj.next());
					var bool = nextObj.is(':visible');
					//slide up or down on click
					if(bool){
						//close
						nextObj.slideUp(400);
					}else{
						nextObj.slideDown(500)
					}
					return false;
				});
			}
		},
		
		// this opens an image, to image dimensions, in a lightbox -- images larger than the page will open bigger than the page,
        lightbox_img: function(obj){
            obj = $(obj);
            DEBUG("BEHAVIORS.availableBehaviors.LIGHTBOX: " + $(obj).attr('href') );
             obj.colorbox(); //add page size or attributes for size and shape       
        },
		// this opens the contents of the link in a iframe lightbox, 75% w x 75%h, img, url, etc.
        lightbox_page: function(obj){
            obj = $(obj);
            DEBUG("BEHAVIORS.availableBehaviors.LIGHTBOX: " + $(obj).attr('href') );
            $(".lb_page").colorbox({'iframe':true, 'width':'75%', 'height':'75%'}); //add page size or attributes for size and shape or iframe  
        },
		//this opens the contents in an iframe lightbox, 75% w x 75%h, img, url, etc. -- from link.tag
		lightbox_link: function(obj){
            obj = $(obj);
            DEBUG("BEHAVIORS.availableBehaviors.LIGHTBOX: " + $(obj).attr('href') );
            obj.colorbox({'iframe':true, 'width':'950px', 'height':'75%'}); //add page size or attributes for size and shape or iframe  
        },
		//this opens the contents in an iframe lightbox, 75% w x 75%h, img, url, etc. -- from link.tag
		lightbox_internal_link: function(obj){
            obj = $(obj);
            DEBUG("BEHAVIORS.availableBehaviors.LIGHTBOX: " + $(obj).attr('href') );
            obj.colorbox({
				'iframe':true, 
				'width':'860px', 
				'height':'545px', 
				onClosed: function(){
					DEBUG("you just closed the lightbox");
					CORE.reloadPage();
				}
			}); //add page size or attributes for size and shape or iframe  
        },
        list_sortable: function(obj){
            
            var mouseX, mouseY, lastX, lastY = 0;
            $('body').mousemove(function(e) { mouseX = e.pageX; mouseY = e.pageY; });

            //IE Doesn't stop selecting text when mousedown returns false we need to check
            // That onselectstart exists and return false if it does -- we won't check if the browser is IE
            // As thy may very well change this at some point
            var need_select_workaround = typeof $(document).attr('onselectstart') != 'undefined';

            var submit_positions = function(tr_obj){
                var position = 0;
                $(obj).find('tbody tr').each(function(){
                    position++;
                    if($($(this).find("form")[0]).attr("id") == $($(tr_obj).find("form")[0]).attr("id")){
                        DEBUG("BEHAVIORS.availableBehaviors.list_sortable.submit_positions: matching " + $($(this).find("form")[0]).attr("id") + " to " + $($(tr_obj).find("form")[0]).attr("id"));
                        var position_form = $($(tr_obj).find("[value=position]")).parents("form")[0];
                        $(position_form).find("[name=pos]").val(position);
                        $(position_form).submit();
                        $.post(
                            $(position_form).attr("action"),
                            $(position_form).serialize(),
                            function(data){
                                DEBUG("BEHAVIORS.availableBehaviors.list_sortable.submit_positions: got data : ");
                                // console.log($.strip(data));
                                DEBUG(data);
                            },
                            function(){
                                DEBUG("BEHAVIORS.availableBehaviors.list_sortable.submit_positions: error. didn't get data ");
                            }
                        );
                        
                        DEBUG("BEHAVIORS.availableBehaviors.list_sortable.submit_positions: we are trying to submit with this value: " + position);
                        return;
                    }
                });
                
            };

            var zebra_stripe = function(tr_obj){
                var position = 0;
                var that = this;
                $(obj).find('tbody tr').each(function(){
                    position += 1;

                    // Change the text of the first TD element inside this TR  
                    //$('td:first', $(this)).text(position);
                    //Now remove current row class and add the correct one
                    //$(this).removeClass('row1 row2').addClass( position % 2 ? 'row1' : 'row2');
                    if(position % 2 == 1){
                        DEBUG("over the line");
                        // stripe it even
                        $(that).removeClass("odd");
                        $(that).addClass("even");
                    } else {
                        DEBUG("mark it 8, dude");
                        // stripe it odd
                        $(that).removeClass("even");
                        $(that).addClass("odd");
                    };
                });
            }
            
            
            $(obj).find('tbody tr').live('mousedown', function (e) {
                    lastY = mouseY;
                    var tr = $(this);
            
                    DEBUG($(tr));
                    tr.fadeTo('fast', 0.2);
                    $('tr', tr.parent() ).not(this).mouseenter(function(){         
                        if (mouseY <= lastY) {
                            DEBUG("MOUSE DOWN: LESSTHAN" + mouseY + ":Mouse Y, lastY:" + lastY);
                            $(this).before(tr);
                        } else  {
                            DEBUG("MOUSE DOWN: MORETHAN" + mouseY + ":Mouse Y, lastY:" + lastY);
                            $(this).after(tr);
                        }
                        lastY = mouseY;
                    });
            
                    $('body').mouseup(function(){
                       //Fade the TR element back to full opacity
                       tr.fadeTo('fast', 1);
                       // Remove the mouseenter events from the tbody so that the TR element stops being moved
                       $('tr', tr.parent()).unbind('mouseenter');
                       // Remove this mouseup function until next time
                       $('body').unbind('mouseup');
                        if(need_select_workaround){
                            $(document).unbind('selectstart');
                        }
                        zebra_stripe(tr); // This function just renumbers the position and adjusts the zebra striping, not required at all
                        submit_positions(tr);
                    });
                    e.preventDefault();

                // The workaround for IE based browers
                if (need_select_workaround)
                    $(document).bind('selectstart', function () { return false; });
                    return false;

                }).css('cursor', 'move');
        },
        __end__: {}
    };
    /* end private methods */

    /* begin public methods */
    
    
    var _applyBehaviors = function(context, selector){
        var that = $(this);     

        // check the class or rel
        // then, we match it to one of the behaviors
        $(context).find(selector).each(function(idx_find, elm){
			var _names = "";

			// grab any rels
			if($(elm).attr("rel") != null && $.trim($(elm).attr("rel")) != ""){
				//console.log("-> found a rel. no longer using these for behaviors: \n\n" + $(elm).attr("rel") + "\n\n");
				// _names += " " + $(elm).attr("rel");
			}
			
			// grab any classes
			if($(elm).attr("class") != null){
				_names += " " + $(elm).attr("class");
			}
			
			// turn these names into an array
			_names = _names.split(" ");
			
			// apply behaviors specified by these names
            $(_names).each(function(idx_each, _name){
				if(_name && availableBehaviors[_name]){
	                DEBUG("BEHAVIORS.applyBehaviors: class: " + _name);
                    availableBehaviors[_name](elm);
				};
            });
			
			// and finally, apply any elementName based behaviors
			var _nodeName = elm.nodeName.toLowerCase();
			if(availableBehaviors[_nodeName]){
                DEBUG("BEHAVIORS.applyBehaviors: nodeName: " + _nodeName);
	            availableBehaviors[_nodeName](elm);
			};

		});
		
    };
    
    /* begin public methods */
    
    return {
        applyBehaviors: _applyBehaviors,
        __end__: {}
    };
}();

