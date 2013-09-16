	/*
	HUMANIZED MESSAGES 1.0
	idea - http://www.humanized.com/weblog/2006/09/11/monolog_boxes_and_transparent_messages
	home - http://humanmsg.googlecode.com
*/

var NOTIFICATION = {
	setup: function(appendTo, logName, msgOpacity) {
		
		NOTIFICATION.msgID = 'humanMsg';
		NOTIFICATION.logID = 'humanMsgLog';

		// appendTo is the element the msg is appended to
		if (appendTo == undefined)
			appendTo = 'body';

		// The text on the Log tab
		if (logName == undefined)
			logName = 'Message Log';

		// Opacity of the message
		NOTIFICATION.msgOpacity = .8;

		if (msgOpacity != undefined) 
			NOTIFICATION.msgOpacity = parseFloat(msgOpacity);

		// Inject the message structure
		jQuery(appendTo).append('<div id="'+NOTIFICATION.msgID+'" class="humanMsg"><div class="round"></div><p></p><div class="round"></div></div> <div id="'+NOTIFICATION.logID+'"><p>'+logName+'</p><ul></ul></div>')
		
		// jQuery('#'+humanmsg.logID+' p').click(
		// 			function() { jQuery(this).siblings('ul').slideToggle() }
		// 		)
	},

	displayMsg: function(msg, sticky, color) {
		//sticky is a boolean to be closed on click or fade out
		if (msg == '')
			return;

		clearTimeout(NOTIFICATION.t2);

		// Inject message
		
		jQuery('#'+NOTIFICATION.msgID+' p').html(msg)
	
		// Show message
		if(color){			
			jQuery('#'+NOTIFICATION.msgID+'').css("background-color", color);
		};
		
		jQuery('#'+NOTIFICATION.msgID+'').show().animate({ opacity: NOTIFICATION.msgOpacity}, 200, function() {
			// jQuery('#'+NOTIFICATION.logID)
			// 				.show().children('ul').prepend('<li>'+msg+'</li>')	// Prepend message to log
			// 				.children('li:first').slideDown(200)				// Slide it down
			// 		
			// if ( jQuery('#'+NOTIFICATION.logID+' ul').css('display') == 'none') {
			// 				jQuery('#'+NOTIFICATION.logID+' p').animate({ bottom: 40 }, 200, 'linear', function() {
			// 					jQuery(this).animate({ bottom: 0 }, 300, 'easeOutBounce', function() { jQuery(this).css({ bottom: 0 }) })
			// 				})
			// 			}
			
		});
		
		if(!sticky){
			// Watch for mouse & keyboard in .5s
			NOTIFICATION.t1 = setTimeout("NOTIFICATION.bindEvents()", 700)
			// Remove message after 5s
			NOTIFICATION.t2 = setTimeout("NOTIFICATION.removeMsg()", 5000)	
		}else{
			
			NOTIFICATION.t1 = setTimeout("NOTIFICATION.bindOnClickEvents()", 700)	
		}

		
	},

	bindEvents: function() {
	// Remove message if mouse is moved or key is pressed
		jQuery(window)
			.mousemove(NOTIFICATION.removeMsg)
			.click(NOTIFICATION.removeMsg)
			.keypress(NOTIFICATION.removeMsg)
	},
	bindOnClickEvents: function() {
		// Remove message if mouse is moved or key is pressed
		jQuery(window).click(NOTIFICATION.removeMsg)
	},

	removeMsg: function() {
		// Unbind mouse & keyboard
		jQuery(window)
			.unbind('mousemove', NOTIFICATION.removeMsg)
			.unbind('click', NOTIFICATION.removeMsg)
			.unbind('keypress', NOTIFICATION.removeMsg)

		// If message is fully transparent, fade it out
		if (jQuery('#'+NOTIFICATION.msgID).css('opacity') == NOTIFICATION.msgOpacity)
			jQuery('#'+NOTIFICATION.msgID).animate({ opacity: 0 }, 500, function() { jQuery(this).hide() })
	}
};

jQuery(document).ready(function(){
	// NOTIFICATION.setup();
})