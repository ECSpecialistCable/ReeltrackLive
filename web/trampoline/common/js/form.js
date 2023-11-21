var FORM = function(){
    /* begin private methods */
    /* end private methods */
    
    /* begin public methods */
    var isValid = function(the_form){
        var VALID_FORM = true;
    
        
        $(the_form).find(":input").each(function(i){
            var selType;
            
            //set selType value to switch on
            if($(this).is("input[type=text]")){
                
                if($(this).not('input[type=hidden]', 'input[type=submit]')){
                    selType = "input";
                }else{
                    selType = "hidden or button";
                }
            };
            if($(this).is("select")){selType = "select"};
            if($(this).is("textarea")){selType = "textarea"};
            
            switch(selType){
                
                case "input":
                
                break;
                case "select":
                
                break;
                case "textarea":
                
                break;
                default:
                
                ;
                
            }
            
        });
        
        return VALID_FORM;
    };
    
    return {
        isValid: isValid,
        __end__: {}     
    };
}();
