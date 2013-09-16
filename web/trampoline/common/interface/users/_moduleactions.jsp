<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% User user = userLoginMgr.getUser(); %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<% if (user!=null) { %>
        <admin:ajax_load url="users/search.jsp" label="manage users" />
<% } %>