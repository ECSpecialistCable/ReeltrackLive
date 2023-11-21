<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<% if(user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
	<admin:tab url="shipping/search.jsp" text="Mark As Shipped" />
	<admin:tab url="shipping/edit.jsp" text="Edit" />
<% } else { %>
	<admin:tab url="shipping/search.jsp" text="Mark As Shipped" />
<% } %>
<admin:set_moduleactions url="manage_reels/_moduleactions.jsp" />
