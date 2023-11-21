<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs a select box for a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="label" required="true" %>
<%@ attribute name="optionsattr" required="true" %>
<%@ attribute name="selected" required="false" %>

<tr>
	<td valign="top" class="labelcolumn"><label for="${name}">${label}:</label></td>
	<td valign="top">
		<select name="${name}" id="${name}">
		<c:forEach items="${requestScope[optionsattr]}" var="option">
				<option value="${option.key}">${option.value}</option>
		</c:forEach>
	</td>
</tr>