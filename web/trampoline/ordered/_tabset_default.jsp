<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="ordered/search.jsp" text="All" />
<admin:tab url="ordered/ordered.jsp" text="Not Shipped" />
<admin:tab url="ordered/shipped.jsp" text="Shipped" />
<admin:tab url="ordered/refused.jsp" text="Refused" />

<admin:set_moduleactions url="reel_inventory/_moduleactions.jsp" />
