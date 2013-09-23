<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<admin:tab url="customers/search.jsp" text="Customers" />
<admin:tab url="customers/create.jsp" text="Add Customer" />

<admin:set_moduleactions url="customers/_moduleactions.jsp" />
