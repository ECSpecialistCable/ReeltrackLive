// admin.js: main javascript functionality for the Trampoline 5.x admin
// Built against jQuery 1.4.x

/*
README:
We're not doing any namespacing in the admin.js module.
It's not really a module.
It's just a bunch of some very basic setup for the other modules
to interact with the DOM.

IMPORTANT:
With the exception of this module, the other modules (CORE, BEHAVIOR, etc.)
make use of the following pattern:

var MODULE_NAME = function(){
    ...some method definitions...

    return {
        publicMethodName1: someMethodName1,
        publicMethodName2: someMethodName2,
        publicMethodName3: someMethodName3,
        __end__: {}
    }
}();

Some things of note:

- each module object is actually a closure created by a self-executing
function. Technically, what this means is: 

The object returned by the execution of this function contains *only* 
the public methods for the module. 

What this means in practice is: when module A uses module B,
it only has access to module B's public methods.

The main reason this was done was to enforce some clean separation between the 
different modules. Different modules should *only* be communicating to 
each other via these public methods, and no module should ever refer 
to internal variables or functions of another module. That makes for a messy,
messy admin.

- if you want to add new methods to any module, you first define some methods, 
*and then* add an entry to the return statement. (The return statement returns
an object literal with named references to the methods you want to be public.)

- By convention, the last item in this object literal (or any object literal
we'll be creating) is a dummy object named "__end__. This was done because 
IE chokes when there's a comma after the last element of a collection.

@TODO: make sure behaviors don't get applied more than once to the same element
*/

$(document).ready(function(){
    var initializeAdmin = function(){
		DEBUG("initializing admin...");
		
		DEBUG("checking if we're in main admin or a colorbox");
		if(IN_MAIN_ADMIN()){
	        CORE.loadModules();
	        // chrisaquino: 20110114 -> removing url args. 
	        // won't be used until we implement the hashchange behaviors
	        // the intialize method's signature and first line used to be:
	        /*
	        var initializeAdmin = function(url){
	             CORE.loadModules(url);
	        */
        
        
        
	        /*
	        for both the login and logout buttons,
	        submit the containing form.
	        */
	
			
	        $(".loginButton").click(function(){
		
	            var obj = $(this);
	            var the_FORM = obj.closest('form'); 

	            //check fields
	            //if fields are filled -- change class to waiting
	            //BEHAVIORS.checkLoginFormFields(the_FORM);
	            //var validate_form_fields = true;
	            the_FORM.submit();
	        });
        	
			DEBUG("LOGOUT BUTTON :" + $(".logoutButton").html());

	        $(".logoutButton").click(function(){
	            var obj = $(this);
	            var the_FORM = obj.closest('form'); 
	            the_FORM.submit();
				return false;
	        });
        
        
	        /*
	        setup the login form
	        */
	        //traverse textfields -- add enter on focus, 
	        //on form.submit -- add validator
	        $($('form#login_form').find("input")).each(function(){
	            $(this).focus(function(){
	                $(this).keypress(function(event){
	                    if (event.which == '13') { // ENTER KEY was pressed
	                       $(".loginButton").click();
	                    }
	                });
	            });
            
	            $(this).blur(function(){
	                $(this).unbind("keypress");
	            }); 
	        });
        
	        $('form#login_form').submit(function(){
	            return CORE.submitNonAjaxForm($(this));
	        });
        } else {
			CORE.initColorBoxContents();
		};
    }(); // end initializeAdmin
    
    
    
    // chrisaquino: 20110114 -> disabling this for the moment
    /*

    var checkURLHash = function(){
        var page = location.hash;
        console.log(page.indexOf("#"));
        if(page.indexOf("#") != -1){
            var split_array = page.split("#");
            var pageValue;
            if(split_array){ 
               pageValue = split_array[1];                  
            }   
			
            DEBUG("ADMIN.READY URL from HASH: " + split_array);
            DEBUG("ADMIN.READY URL from HASH: " + pageValue);
            initializeAdmin(pageValue);
        }else{
            initializeAdmin();      
        }
    }();
    */
    
}); // end $(document).ready






///////// 
/*
    old ADMIN object.
    created to help hunt down explicit javascript calls in the tags
*/
var ADMIN = {
    load: {
        page: function(url){
            console.log("*** got an old call to ADMIN.load.page");
            CORE.loadPage(url);
        }
    },  
    util: {
        submit_normal: function(){
            console.log("*** got an old call to ADMIN.util.submit_normal");
        },
        submit_via_link: function(){
            console.log("*** got an old call to ADMIN.util.submit_via_link");
        },
        submit_self: function(){
            console.log("*** got an old call to ADMIN.util.submit_self");
        }
    },
    __end__: {}
};

