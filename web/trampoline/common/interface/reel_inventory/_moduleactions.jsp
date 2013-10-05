<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<% if (user!=null) { %>
        <admin:ajax_load url="ordered/search.jsp" label="Ordered" />
        <admin:ajax_load url="received/search.jsp" label="Received" />
        <admin:ajax_load url="reels/search.jsp" label="Search" />
<% } %>