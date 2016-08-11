<%@ tag body-content="empty" %>
<%@ tag description="Outputs a submit button for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%@ attribute name="name" required="true" %>

<button type="button" class="btn btn-primary btn-xs"
	onclick="
	var clearForm = document.getElementById('${name}');
	var inputs = clearForm.getElementsByTagName('input');
	for (index = 0; index < inputs.length; ++index) {
	   var input = inputs[index];
	   input.value='';
	}
	var selectTags = clearForm.getElementsByTagName('select');
	for(var i = 0; i < selectTags.length; i++) {
	  selectTags[i].selectedIndex=0;
	}"
>CLEAR</button>

