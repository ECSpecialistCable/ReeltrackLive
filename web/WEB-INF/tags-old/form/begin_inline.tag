<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="action" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="submit" required="false" %>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="notify" required="false"%>

<form class="${cssClass} " <% if(notify!=null) { %>title="${notify}"<% } %> onsubmit="" action="${action}" target="_submissionFrame" method="post" name="${name}" id="${name}" <c:forEach items="${attribs}" var="attrib"> ${attrib.key}="${attrib.value}"</c:forEach>>
