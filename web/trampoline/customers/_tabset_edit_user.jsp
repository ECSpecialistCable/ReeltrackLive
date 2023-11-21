<%@ page language="java" %>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<% securityMgr.init(dbResources); %>

<%
String param = "content_id_for_tabset";
String paramstring = "";
if(request.getParameter(param) != null) {
	paramstring = "?" + param + "=" + request.getParameter(param);
}

RTUser content = new RTUser();
content.setId(Integer.parseInt(request.getParameter(param)));
content = (RTUser)securityMgr.getUser(content, true, false);
String back_params = "?" + Customer.PARAM + "=" + content.getCustomerId();
%>
<% dbResources.close(); %>

<admin:tab url="customers/users.jsp" text="<span class='glyphicon glyphicon-chevron-left'></span>" params="<%= back_params %>" />
<admin:tab url="customers/edit_user.jsp" text="Edit User" params="<%= paramstring %>"/>

<admin:set_moduleactions url="customers/_moduleactions.jsp" />
