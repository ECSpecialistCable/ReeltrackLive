<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a set of fields for filling out a date on a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="label" required="true" %>
<%@ attribute name="name" required="false" %>

<%@ attribute name="value" required="false" %>
<%@ attribute name="start" required="false" %>
<%@ attribute name="required" required="false" %>


<div class="form-group">
	<label style="padding-right:0;color:#333333;" for="${name}" class="col-sm-3 control-label">${label}</label>
	<div class="col-sm-9">
	    <div class='input-group date' id='datetimepicker_${name}'>
	    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span>
	        </span>
	        <input type='text' class="form-control" name="${name}" id="${name}"/>        
	    </div>
	    <script type="text/javascript">
            $(function () {
                $('#datetimepicker_${name}').datetimepicker({
                	defaultDate: "${value}",
					pickTime: false
				});
            });
        </script>
    </div>
</div>