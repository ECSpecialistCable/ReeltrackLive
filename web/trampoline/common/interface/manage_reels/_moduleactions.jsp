<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<% if (user!=null) { %>
	<% if(!user.isUserType(RTUser.USER_TYPE_CPE)) { %> 
		<admin:ajax_load url="bill_of_materials/search.jsp" label="Set Quantity Tracking" />
	<% } %>
		<admin:ajax_load url="import_circuits/search.jsp" label="Import Circuits" />
        <admin:ajax_load url="reeltags/search.jsp" label="Generate Reel Tags" />
        <admin:ajax_load url="shipping/search.jsp" label="Mark as Shipped" />
        <admin:ajax_load url="receive/search.jsp" label="Receive Reels" />
        <admin:ajax_load url="pick_lists/search.jsp" label="Manage Pick Lists" />
        <admin:ajax_load url="checkout/search.jsp" label="Check OUT Reels" />
        <admin:ajax_load url="checkin/search.jsp" label="Check IN Reels" />
        <admin:ajax_load url="complete/search.jsp" label="Mark as Complete" />
        <admin:ajax_load url="scrapped/search.jsp" label="Mark as Scrapped" />
        <admin:ajax_load url="issues/search.jsp" label="Manage Issues" />
<% } %>