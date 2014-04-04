<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<% String label = user.getCustomerName() + " File Cabinet"; %>

<admin:tab url="bill_of_materials/search.jsp" text="Bill of Materials" />
<admin:tab url="bill_of_materials/cust_pn.jsp" text="Customer P/Ns" />

<admin:set_moduleactions url="bill_of_materials/_moduleactions.jsp" />
