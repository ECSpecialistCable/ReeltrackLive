<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs html for a search result table cell" pageEncoding="UTF-8"%>
<%@ attribute name="data" required="true"%>
<%@ attribute name="link" required="false"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<td valign="top">
	<c:if test="${!empty link}">
		<a href="javascript:;" onclick="javascript:ADMIN.load.page('${link}');">
	</c:if>
		${data}
	<c:if test="${!empty link}">		
		</a>
	</c:if>
</td>