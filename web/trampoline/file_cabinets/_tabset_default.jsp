<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% String label = user.getCustomerName() + " File Cabinet"; %>

<admin:tab url="file_cabinets/search.jsp" text="ECS General" />
<admin:tab url="file_cabinets/customer.jsp" text="<%= label %>" />

<admin:set_moduleactions url="file_cabinets/_moduleactions.jsp" />
