<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs an option tag for a select box in a form" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="value" required="true" %>
<%@ attribute name="selected" required="false" %>
<%@ attribute name="match" required="false" %>

<option value="${value}" <c:if test="${(!empty selected) || ((!empty match) && (value == match)) }">selected="selected"</c:if>>${name}</option>