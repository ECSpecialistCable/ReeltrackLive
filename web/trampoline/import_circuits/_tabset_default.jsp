<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% //String label = user.getCustomerName() + " File Cabinet"; %>

<admin:tab url="import_circuits/search.jsp" text="Import Circuits" />

<admin:set_moduleactions url="import_circuits/_moduleactions.jsp" />
