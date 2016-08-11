<%@ tag body-content="empty" dynamic-attributes="attribs" %>
<%@ tag description="Outputs the beginning tag of the html form" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="table" tagdir="/WEB-INF/tags/table"%>

<%@ attribute name="name" required="true" %>
<%@ attribute name="action" required="true" %>
<%@ attribute name="cssClass" required="false"%>
<%@ attribute name="noTopPad" required="false" %>
<%@ attribute name="noBotPad" required="false" %>
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
<form class="form-horizontal selfSubmitForm" role="form" id="${name}" name="${name}" action="${action}">
