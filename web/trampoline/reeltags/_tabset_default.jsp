<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<% if(user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
	<admin:tab url="reeltags/search_ordered.jsp" text="Ordered" />
	<admin:tab url="reeltags/search_shipped.jsp" text="Shipped" />
	<admin:tab url="reeltags/search_generated.jsp" text="Generated" />
<% } else { %>
	<admin:tab url="reeltags/search.jsp" text="Search" />
	<%--<admin:tab url="reels/create.jsp" text="Add Reel" />--%>
	<admin:tab url="reeltags/search_generated.jsp" text="Generated" />
<% } %>
<admin:set_moduleactions url="manage_reels/_moduleactions.jsp" />
