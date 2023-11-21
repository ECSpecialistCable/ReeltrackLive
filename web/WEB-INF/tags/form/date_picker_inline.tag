<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a set of fields for filling out a date on a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="name" required="false" %>
<%@ attribute name="value" required="false" %>

<div class="form-group">
	<div class="col-sm-12">
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
				}).on('change', function(e){
      				$(this).closest("form").submit();
    			});
            });
        </script>
    </div>
</div>