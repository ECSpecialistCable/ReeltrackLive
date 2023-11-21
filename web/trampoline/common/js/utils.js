// utils.js: for the Trampoline 5.x admin
// Built against jQuery 1.4.x

// UTIL #####################################################
var cacheBustedURL = function(url){
    var delim = "?";
    if(url.indexOf(delim) != -1){
        delim = "&"
    };
    return url + delim + (new Date()).getHours() + (new Date()).getMinutes() + (new Date()).getSeconds() + (new Date()).getMilliseconds();
};

/*
	new and improved DEBUG function.
	will log strings or call an anonymous function if debugging is on.
	(_DEBUG is in constants.js)
*/

var closeColorBox = function(){
	try{
		$.fn.colorbox.close();
	} catch(err) {
		parent.$.fn.colorbox.close();
	}
}

var enable_waiting_button = function(obj){
	return;
	if(obj.attr("onclick") && /waitingButton/.test(obj.attr("onclick"))){
		DEBUG("Removing the waitingButton onclick");
		obj.removeAttr("onclick");

	};
	obj.addClass("waitingButton");
};
		
var disable_waiting_button = function(form){
	return;
	form.find(".waitingButton").removeClass("waitingButton");
};


var DEBUG = function(){
	if(_DEBUG){
		var args = Array.prototype.slice.call(arguments);
		for (var i=0; i < args.length; i++) {
			if(typeof(args[i]) == "string"){
				console.log(args[i]);
			} else if(typeof(args[i]) == "function"){
				args[i]();
			};
		};
	};
}

// ERROR HANDLING
var lastErr;
var lastErrURL;
var showError = function(){
    // with help from http://stackoverflow.com/questions/95600/jquery-error-option-in-ajax-utility
    var errorWindow = window.open(lastErrURL);
    // $(errorWindow).html(lastErr);
	if(errorWindow){	
	    errorWindow.document.open();
	    errorWindow.document.write(lastErr);
	    errorWindow.document.close();   
	    DEBUG($(errorWindow));
	} else {
		DEBUG("couldn't show error window...safari must be blocking");
		jQuery("#errA").remove();
		var errA = jQuery("<a id='errA' href='" + lastErrURL +"' target='_blank'></a>)");
		errA.appendTo("body");
		//jQuery("#errA").trigger(); // this doesn't work.
		var anchorObj = errA.get(0);
		if (anchorObj.click) {
			anchorObj.click()
		} else if(document.createEvent) {
			if(event.target !== anchorObj) {
				var evt = document.createEvent("MouseEvents"); 
				evt.initMouseEvent("click", true, true, window, 
				   0, 0, 0, 0, 0, false, false, false, false, 0, null); 
				var allowDefault = anchorObj.dispatchEvent(evt);
				// you can check allowDefault for false to see if
				// any handler called evt.preventDefault().
				// Firefox will *not* redirect to anchorObj.href
				// for you. However every other browser will.
			}
		}		
	};
    return false;
}

$("#err_log").ajaxError(function(evt, req, settings){
    lastErr = req.responseText;
    lastErrURL = settings.url;

    // $(this).html(__DEFAULT_ERROR_MESSAGE__ + " <a href='' onclick='showError()'>(click here to view error)</a>");
    NOTIFICATION.displayMsg(__DEFAULT_ERROR_MESSAGE__ + " <a href='' onclick='showError()'>(click here to view error)</a>", true);  

});

//Modified AJAX GET
var AJAX_GET = function(url, callback){

    url = cacheBustedURL(url);
    
    DEBUG("AJAX_GET - get URL:  " + url);
	$.ajax({
		url: url,
		cache: false,
		success: function(response){
	        if(callback){
	            callback(response);
	        }			
		},
		error: function(response){
			if(confirm("An error occured. Would you like to view the error?")){
			    lastErr = response.responseText;
			    lastErrURL = url;					
				showError();
			};
		},
        __end__: {}		
	});
	/*
    $.get(url, function(response){
        if(callback){
            callback(response);
        }
    });
	*/
} // end AJAX_GET

var IN_MAIN_ADMIN = function(){
	return $(__COLORBOX_CONTENT__).length == 0;
}

// do *not* namespace these into an object

String.prototype.startsWith = function(t, i){ 
    if(i == false) { 
        return (t == this.substring(0, t.length)); 
    } else {
         return (t.toLowerCase() == this.substring(0, t.length).toLowerCase()); 
    } 
};

String.prototype.endsWith = function(t, i){ 
    if (i == false) { 
        return (t == this.substring(this.length - t.length)); 
    } else { 
        return (t.toLowerCase() == this.substring(this.length - t.length).toLowerCase()); 
    } 
};
