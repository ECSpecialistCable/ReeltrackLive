<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<% if (user!=null) { %>
		<admin:ajax_load url="users2/search.jsp" label="Users" />
		<admin:ajax_load url="foremans/search.jsp" label="Foremen" />
		<admin:ajax_load url="drivers/search.jsp" label="Drivers" />
		<admin:ajax_load url="whlocations/search.jsp" label="Warehouse Locations" />
		<admin:ajax_load url="settings/search.jsp" label="Settings" />
<% } %>