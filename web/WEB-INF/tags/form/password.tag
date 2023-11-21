<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a text field for a form" pageEncoding="UTF-8"%>

<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="size" required="false" %>
<%@ attribute name="value" required="false" %>

<tr>
	<form:label name="${name}" label="${label}"/>
	<td valign="top">
		<input type="password" class="withborder" size="${size}" name="${name}" id="${name}" value="${value}" <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>/>	
	</td>
</tr>