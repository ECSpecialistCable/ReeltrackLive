<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="pick_lists/search.jsp" text="Pick Lists" />
<admin:tab url="pick_lists/create.jsp" text="Add Pick List" />

<admin:set_moduleactions url="manage_reels/_moduleactions.jsp" />
