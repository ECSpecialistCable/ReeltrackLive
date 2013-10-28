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
        <admin:ajax_load url="pick_lists/search.jsp" label="Pick Lists" />
        <admin:ajax_load url="checkout/search.jsp" label="Check OUT" />
        <admin:ajax_load url="checkin/search.jsp" label="Check IN" />
<% } %>