<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.security.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% User user = userLoginMgr.getUser(); %>
<%
boolean canAdd = false;
try { canAdd = user.getGroup().getPermission(new User()).getAdd(); } catch (Exception e) {}
%>

<admin:tab url="users/search.jsp" text="users" />
<% if(canAdd) { %>
    <admin:tab url="users/create.jsp" text="create new user" />
<% } %>

<admin:set_moduleactions url="users/_moduleactions.jsp" />
