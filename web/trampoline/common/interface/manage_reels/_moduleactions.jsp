<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<% if (user!=null && !user.isUserType(RTUser.USER_TYPE_VENDOR)) { %> 
	<admin:ajax_load url="bill_of_materials/search.jsp" label="BOM / Qty Track / QRC Verify" />
	<% if(!user.isUserType(RTUser.USER_TYPE_STANDARD) && !user.isUserType(RTUser.USER_TYPE_CPE)) { %>	
		<admin:ajax_load url="import_circuits/search.jsp" label="Import Circuits" />
    <% } %>
        <admin:ajax_load url="reeltags/search.jsp" label="Generate Reel Tags" />
    <% if(!user.isUserType(RTUser.USER_TYPE_CPE)) { %>
        <admin:ajax_load url="pick_lists/search.jsp" label="Manage Pick Lists" />
    <% } %>
        <admin:ajax_load url="issues/search.jsp" label="Manage Issues" />
<% } %>

<% if (user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
    <admin:ajax_load url="shipping/search_vendor.jsp?clear=true" label="Mark as Shipped" />
	<admin:ajax_load url="reeltags/search_ordered.jsp" label="Generate Reel Tags" />    
<% } %>