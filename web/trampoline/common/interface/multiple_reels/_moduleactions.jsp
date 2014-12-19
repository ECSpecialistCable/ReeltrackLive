<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<% if (user!=null) { %>
        <admin:ajax_load url="shipping/search.jsp?clear=true" label="Mark as Shipped" />
        <admin:ajax_load url="receive/search.jsp" label="Receive Reels" />       
        <admin:ajax_load url="checkout/search.jsp" label="Check OUT Reels" />
        <admin:ajax_load url="checkin/search.jsp" label="Check IN Reels" />
        <admin:ajax_load url="complete/search.jsp" label="Mark as Complete" />
        <admin:ajax_load url="scrapped/search.jsp" label="Mark as Scrapped" />
<% } %>