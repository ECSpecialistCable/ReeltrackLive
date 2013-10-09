<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<% if (user!=null) { %>
        <admin:ajax_load url="issues/search.jsp" label="Issues" />
        <admin:ajax_load url="shipping/search.jsp" label="Shipping" />
        <admin:ajax_load url="receive/search.jsp" label="Receive" />
<% } %>