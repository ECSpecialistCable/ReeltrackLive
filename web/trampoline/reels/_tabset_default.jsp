<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="reels/search.jsp" text="Search" />
<admin:tab url="reels/create.jsp" text="Add Reel" />

<admin:set_moduleactions url="reel_inventory/_moduleactions.jsp" />
