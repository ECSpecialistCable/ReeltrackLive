<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<% if (user!=null) { %>
	<% if(!user.isUserType(RTUser.USER_TYPE_INVENTORY) && !user.isUserType(RTUser.USER_TYPE_STANDARD) && !user.isUserType(RTUser.USER_TYPE_CPE)) { %>
		<admin:ajax_load url="users2/search.jsp" label="Manage Users" />
		<admin:ajax_load url="foremans/search.jsp" label="Manage Foremen" />
	<% } %>
	<% if(!user.isUserType(RTUser.USER_TYPE_INVENTORY) && !user.isUserType(RTUser.USER_TYPE_CPE)) { %>
		<admin:ajax_load url="drivers/search.jsp" label="Manage Drivers" />
		<admin:ajax_load url="whlocations/search.jsp" label="Manage Warehouse Locations" />
	<% } %>
		<%--<admin:ajax_load url="settings/search.jsp" label="Settings" />--%>
	<% } %>
<% } %>