<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="issues/search.jsp" text="Unresolved Issues" />
<admin:tab url="issues/resolved.jsp" text="Resolved Issues" />

<admin:set_moduleactions url="manage_reels/_moduleactions.jsp" />
