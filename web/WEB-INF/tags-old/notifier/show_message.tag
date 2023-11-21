<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the tag and script for the notifier"  %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${!empty(sessionScope.flash)}">
	<%-- show the flash, then remove it from the session --%>
	<div id="flash" class="notifier" style="display: none;">${sessionScope.flash}</div>
	<div id="flash_color" style="display: none;">${sessionScope.flash_color}</div>
	<c:remove var="flash" />				
	<c:remove var="flash_color" />				
</c:if>	
