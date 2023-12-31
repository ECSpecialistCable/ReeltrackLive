<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>

<%@ attribute name="action" required="true" %>
<%@ attribute name="name" required="true" %>
<%@ attribute name="submit" required="false" %>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="notify" required="false" %>
<%@ attribute name="target" required="false" %>
<%@ attribute name="noTopPad" required="false" %>
<%@ attribute name="noBotPad" required="false" %>
<%@ attribute name="confirm" required="false"%>

<%
String style = "";
if(noTopPad!=null && !noTopPad.equals("")) {
	style += "padding-top:0px;";
}
if(noBotPad!=null && !noBotPad.equals("")) {
	style += "padding-bottom:0px;";
}
%>

<div class="panel-body" style="<%= style %>">
<form class="form-horizontal <% if(confirm!=null) { %>submitFormConfirm<% } else { %>submitForm<% } %>" message="${confirm}" <% if(target!=null) { %>target="${target}"<% } %> role="form" id="${name}" name="${name}" action="${action}">
