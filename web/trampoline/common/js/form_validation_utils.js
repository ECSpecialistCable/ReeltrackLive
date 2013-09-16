var isValidURL = function(value){
    return /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(value);
};

var isValidEmailAddress = function(emailAddress) {
    // console.log("checking");
    var pattern = new RegExp(/^(("[\w-\s]+")|([\w-]+(?:\.[\w-]+)*)|("[\w-\s]+")([\w-]+(?:\.[\w-]+)*))(@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$)|(@\[?((25[0-5]\.|2[0-4][0-9]\.|1[0-9]{2}\.|[0-9]{1,2}\.))((25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\.){2}(25[0-5]|2[0-4][0-9]|1[0-9]{2}|[0-9]{1,2})\]?$)/i);
    return pattern.test(emailAddress);
}

var passwordsDoMatch = function(sel1, sel2){
    var __LONG_ENOUGH__ = 5;
    var notmatch = $(sel1).val() != $(sel2).val();
    var tooshort = $(sel1).val().length < __LONG_ENOUGH__;
    
    var msg = "";
    if(notmatch && tooshort){
        msg = "Please make sure the passwords match and are at least 5 characters long.";
    } else if(notmatch) {
        msg = "Please make sure the passwords match."
    } else if(tooshort) {
        msg = "Please make sure the passwords are at least 5 characters long.";
    }
    
    if(notmatch || tooshort){
        $("<p class='error'>" + msg + "</p>").insertAfter($(sel1));
        $(sel1).focus();
        return false;
    }
    return true;
}   
    
var atLeastOneIsChecked = function(obj){
    if($(obj).attr("type") == "radio" || $(obj).attr("type") == "checkbox"){
        var name = $(obj).attr("name");
        var nameSEL = "[name='" + name + "']:checked"
        var blank = true;
        if($($(obj).parents()[0]).find(nameSEL).length > 0){
            // if at least one is checked, then all will return the same answer
            // console.log("at least one is checked");
            blank = false;
        };
        // console.log("returning: " + blank);
        return blank;
    } else {
        // console.log("returning: " + $(obj).val() == "");
        return ($(obj).val() == "");
    };
};


var checkAndMarkRequirementsOnFormWithMessage = function(formobj, msg){ 
    // console.log("checking and returning false");
    // return false;
    var __BAD_BORDER__ = "1px solid #f00";
    var __GOOD_BORDER__ = "1px solid #ccc";
    
    var first = false;
    var okgo = true;
    $(formobj).find(".error").remove();
    $(formobj).find(".required").each(function(){
        if(check(this)){
            $(this).css("border", __BAD_BORDER__);
            okgo = false;
            if(!first){             
                first = true;
                $(this).focus();
            };
            
            if(msg){
                $("<p class='error'>" + msg + "</p>").insertAfter(this);                
            };
            
        } else {
            $(this).css("border", __GOOD_BORDER__);         
            // console.log("applying good border");
        }
    });
    return okgo;
    // return false;
};
