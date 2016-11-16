var tabHistory = [];

function tabInfo(info) {

}

function login() {
	var username = $('#username').val();
	var password = $('#password').val();
	$("#tabContent").load("interface/login.jsp?action=login&username=" + username + "&password=" + password,function() {
	 	loadNavigation();
	 	loadFooter();
		loadHeader(); 
	});
}

function changeJob() {
	var vendor = $('#vendor').val();
	$("#tabContent").load("interface/login.jsp?action=change_job",function() {
	 	loadNavigation();
	 	//loadFooter();
		 loadHeader();
	});
}

function selectVendor() {
	var vendor = $('#vendor').val();
	$("#tabContent").load("interface/login.jsp?action=vendor&vendor=" + vendor,function() {
	 	loadNavigation();
	 	loadHeader();
	});
}

function selectCustomer() {
	var customer = $('#customer').val();
	$("#tabContent").load("interface/login.jsp?action=customer&customer=" + customer,function() {
	 	loadNavigation();
	 	//loadFooter();
	});
}

function selectJob() {
	var job = $('#job').val();
	$("#tabContent").load("interface/login.jsp?action=job&job=" + job,function() {
	 	loadNavigation();
	 	//loadFooter();
		 loadHeader();
	});
}

function logout() {
	$("#tabContent").load("interface/login.jsp?action=logout",function() {
	 	loadNavigation();
	 	$("#tabsetContent").html('<li class="disabled"><a href="#home">&nbsp;</a></li>');
	 	loadLoginScreen();
	 	loadFooter();
		loadHeader();
	});
}

function loadHeader() {
	$("#headerContent").load("interface/header.jsp",function() {

	});
}

function loadFooter() {
	$("#footerContent").load("interface/footer.jsp",function() {

	});
}

function loadNavigation() {
	$("#navContent").load("interface/navigation.jsp",function() {

	});
}

function loadLoginScreen() {
	$("#tabContent").load("interface/login.jsp",function() {
	 	loadNavigation();
	 	loadFooter();
		loadHeader(); 
	});
}

function loadDirect(url) {
    $("#tabContent").load(url,function(response, status, xhr ) {
    	if ( status == "error" ) {
    		//var msg = "Sorry but there was an error: ";
    		//$( "#tabContent" ).html( msg + xhr.status + " " + xhr.statusText );
    		var myWindow = window.open("", "Error", "width=1024, height=768");
			myWindow.document.write(response);
  		} else {
	 		bindForms();
	 		loadNavigation();
	 		loadFooter();
			loadHeader(); 
	 	}
	});
	tabHistory.push(url);
}

function backButtonClicked() {
	tabHistory.pop();
	$("#tabContent").load(tabHistory[tabHistory.length-1],function() {
	 	bindForms();
	});
}

function loadModule(url) {
    $("#tabContent").load(url,function(response, status, xhr ) {
    	if ( status == "error" ) {
    		//var msg = "Sorry but there was an error: ";
    		//$( "#tabContent" ).html( msg + xhr.status + " " + xhr.statusText );
    		var myWindow = window.open("", "Error", "width=1024, height=768");
			myWindow.document.write(response);
  		} else {
	 		bindForms();
	 	}
	});
	tabHistory.push(url);
}

function loadProcess(url,theButton) {
	if(theButton) {
		waitingLinkButton(theButton);
	}
    $("#tabContent").load(url,function() {
	 	bindForms();
	});
}

/*
function loadProcessWithWarning(url,theButton) {
	//warningAlert = 'Are you sure you want to delete this item?';
	trampWarningAlert(warningAlert, function(result) {
		if (result) {
		    $("#tabContent").load(url,function() {
		 		bindForms();
			});
		} else {
			theButton.blur();
		}
	});
}
*/
function loadProcessWithWarning(url,theButton, warning) {
	//warningAlert = warning;
	//alert(warning);
	trampWarningAlert(warning, function(result) {
		if (result) {
			$("#tabContent").load(url,function() {
				bindForms();
			});
		} else {
			theButton.blur();
		}
	});
}

function loadTab(url) {
    $("#tabContent").load(url,function(response, status, xhr ) {
    	if ( status == "error" ) {
    		//var msg = "Sorry but there was an error: ";
    		//$( "#tabContent" ).html( msg + xhr.status + " " + xhr.statusText );
    		var myWindow = window.open("", "Error", "width=1024, height=768");
			myWindow.document.write(response);
  		} else {
	 		bindForms();
	 	}
	});
	tabHistory.push(url);
}

function loadTabset(url,page) {
    $("#tabsetContent").load(url,function() {
    	$( "li" ).each(function( index ) {
    		console.log($(this).attr('id'));
  			if($(this).attr('id')!=null && $(this).attr('id').indexOf(page)!=-1) {
  				$(this).addClass('active');
  			}
		});
	});
}

function bindForms() {
	$('.selfSubmitForm').bind('submit',function() {
		var tempScrollTop = $(window).scrollTop();
		$.post($(this).attr("action"), $(this).serialize(), function(data) {
	  		//var tempScrollTop = $(window).scrollTop();
	  		$("#tabContent").html(data);
	  		$(window).scrollTop(tempScrollTop);
	    	bindForms();
		})
	  	.fail(function( jqXHR, textStatus, errorThrown)  {
	    	var myWindow = window.open("", "Error", "width=1024, height=768");
			myWindow.document.write(jqXHR.responseText);
	  	});
	  	return false;
	});

	$('.submitForm').bind('submit',function() {
		var tempScrollTop = $(window).scrollTop();
		$.post($(this).attr("action"), $(this).serialize(), function(data) {
	  		$("#tabContent").html(data);
	  		$(window).scrollTop(tempScrollTop);
	    	bindForms();
		})
	  	.fail(function( jqXHR, textStatus, errorThrown)  {
	    	var myWindow = window.open("", "Error", "width=1024, height=768");
			myWindow.document.write(jqXHR.responseText);
	  	});
	  	return false;
	});

	$('.submitFormConfirm').bind('submit',function(e) {
		var tempScrollTop = $(window).scrollTop();
		e.preventDefault();
		var form = this;
		var message = $(this).attr("message");
		trampWarningAlert(message,function(result) {
			if(result) {
				$.post($(form).attr("action"), $(form).serialize(), function(data) {
			  		$("#tabContent").html(data);
			  		$(window).scrollTop(tempScrollTop);
			    	bindForms();
				})
			  	.fail(function( jqXHR, textStatus, errorThrown)  {
			    	var myWindow = window.open("", "Error", "width=1024, height=768");
					myWindow.document.write(jqXHR.responseText);
			  	});
			  	return false;
			}
		});
	});

	$('.submitMultipartForm').bind('submit',function(e) {
			var tempScrollTop = $(window).scrollTop();
			e.preventDefault();
		    var formObj = $(this);
		    var formURL = formObj.attr("action");
		    var data = new FormData($(this)[0]);
		    $.ajax({
		        url: formURL,
		    	type: 'POST',
		        data:  data,
		    	mimeType:"multipart/form-data",
		    	contentType: false,
		        cache: false,
		        processData:false,
		    success: function(data, textStatus, jqXHR)
		    {
		 		$("#tabContent").html(data);
		 		$(window).scrollTop(tempScrollTop);
	    		bindForms();
		    },
		     error: function(jqXHR, textStatus, errorThrown)
		     {
		     	var myWindow = window.open("", "Error", "width=1024, height=768");
				myWindow.document.write(jqXHR.responseText);
		     }
		    });
		    return false;
	});

	$(".panel-collapse").each(function() {
	    var name = $(this).attr("id");
	    var divClass = $(this).attr("class");
	    var status = $.cookie(tabHistory[tabHistory.length-1] + "_" + name);
		//console.log(name + "admin box is currently " + status);
		/*if(status == null || status == 'shown') {
			$("#" + name).addClass('in');
		} else {
			$("#" + name).removeClass('in');
		}*/
		if(status != null || divClass.indexOf("in") == -1) {
			if(status == 'shown') {
				$("#" + name).addClass('in');
			} else {
				$("#" + name).removeClass('in');
			}
		}
	});

	/*tooltips */
	$('[data-toggle="tooltip"]').tooltip({'placement': 'bottom'});

}

function submitInline(theForm) {
	var tempScrollTop = $(window).scrollTop();
	$.post($(theForm).attr("action"), $(theForm).serialize(), function(data) {
  		$("#tabContent").html(data);
  		$(window).scrollTop(tempScrollTop);
    	bindForms();
	})
  	.fail(function( jqXHR, textStatus, errorThrown)  {
    	var myWindow = window.open("", "Error", "width=1024, height=768");
		myWindow.document.write(jqXHR.responseText);
  	});
  	return false;
}

function waitingSubmit(theButton) {
	$(theButton).html('<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate"></span>&nbsp;' + $(theButton).html());
}

function waitingLinkButton(theButton) {
	$(theButton).html('<span class="glyphicon glyphicon-refresh glyphicon-refresh-animate" style="color:#069ad4;font-size:24px;"></span>');
}

/* 1/8/15 SAVE ADMIN BOX STATE*/
function saveCollapseState(name) {
	$("#" + name).on('hidden.bs.collapse', function () {
     	$.removeCookie(tabHistory[tabHistory.length-1] + "_" + name);
        $.cookie(tabHistory[tabHistory.length-1] + "_" + name, 'hidden');
    });

	$("#" + name).on('shown.bs.collapse', function () {
        $.removeCookie(tabHistory[tabHistory.length-1] + "_" + name);
     	$.cookie(tabHistory[tabHistory.length-1] + "_" + name, 'shown');
    });
}
/* 1/8/15 SAVE ADMIN BOX STATE*/


// ALERTS & DIALOGS
/*
BootstrapDialog.TYPE_DEFAULT,
BootstrapDialog.TYPE_INFO,
BootstrapDialog.TYPE_PRIMARY,
BootstrapDialog.TYPE_SUCCESS,
BootstrapDialog.TYPE_WARNING,
BootstrapDialog.TYPE_DANGER
*/
function trampErrorAlert(theCopy) {
	BootstrapDialog.show({
        type: BootstrapDialog.TYPE_DANGER,
        title: '<span class="glyphicon glyphicon-thumbs-down" style="color:white;font-size:24px;"></span>&nbsp;&nbsp;Error',
        message: theCopy,
        buttons: [{
	        label: 'OK',
			hotkey: 13,
	        action: function(dialog){
	        	dialog.close();
	        }
        }]
    });
}

function trampInfoAlert(theCopy) {
	BootstrapDialog.show({
        type: BootstrapDialog.TYPE_INFO,
        title: '<span class="glyphicon glyphicon-info-sign" style="color:white;font-size:24px;"></span>&nbsp;&nbsp;Info',
        message: theCopy,
        buttons: [{
	        label: 'OK',
			hotkey: 13,
	        action: function(dialog){
	        	dialog.close();
	        }
        }]
    });
}

function trampConfirm(theCopy) {
	BootstrapDialog.confirm({
        type: BootstrapDialog.TYPE_INFO,
        title: '<span class="glyphicon glyphicon-info-sign" style="color:white;font-size:24px;"></span>&nbsp;&nbsp;Info',
        message: theCopy,
    });
}

function trampWarningAlert(theCopy, callback) {
	//alert(warningAlert);
    new BootstrapDialog({
    	type: BootstrapDialog.TYPE_WARNING,
        title: '<span class="glyphicon glyphicon-warning-sign" style="color:white;font-size:24px;"></span>&nbsp;&nbsp;Warning',
        message: theCopy,
        closable: false,
        data: {
            'callback': callback
        },
        buttons: [{
                label: 'Cancel',
                action: function(dialog) {
                    typeof dialog.getData('callback') === 'function' && dialog.getData('callback')(false);
                    dialog.close();
                }
            }, {
                label: 'OK',
                cssClass: 'btn-primary',
				hotkey: 13,
                action: function(dialog) {
                    typeof dialog.getData('callback') === 'function' && dialog.getData('callback')(true);
                    dialog.close();
                }
            }]
    }).open();
};
