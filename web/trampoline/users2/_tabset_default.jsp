<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="users2/search.jsp" text="Users" />
<% if(user.isUserType(RTUser.USER_TYPE_ECS) || user.getCanAddUser().equals("y")) { %>
	<admin:tab url="users2/create.jsp" text="Add User" />
<% } %>

<admin:set_moduleactions url="users2/_moduleactions.jsp" />
