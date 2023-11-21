<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ attribute name="action" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="submit" required="false" %>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="notify" required="false"%>
<%@ attribute name="confirm" required="false"%>

<form class="form-horizontal <% if(confirm!=null) { %>submitFormConfirm<% } else { %>submitForm<% } %>" message="${confirm}" role="form" id="${name}" name="${name}" action="${action}">
