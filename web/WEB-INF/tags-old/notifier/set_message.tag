<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the tag and script to set the notifier and reload the last request"  %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="text" required="true" %>
<%@ attribute name="color" required="false" %>

<c:if test="${!empty text}">
	<c:set var="flash" scope="session" value="${text}" />
	<c:set var="flash_color" scope="session" value="${color}" />
</c:if>
	