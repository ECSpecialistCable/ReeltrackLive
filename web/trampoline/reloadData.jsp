<%@ page language="java" %>		
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.utilities.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext, dbResources); %>

<% RTUser user = (RTUser)userLoginMgr.getUser(); %>	
<% dbResources.close(); %>

<%
	if(user!=null && user.getId()!=0) {
		ReloadData.reloadData("/Users/tomkat/Development/clients/ECS/Source/trunk/reloadData.sh");
	}
%>