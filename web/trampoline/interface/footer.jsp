<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />

<% CompProperties props = new CompProperties(); %>

<%   
userLoginMgr.init(pageContext, dbResources);
User user = userLoginMgr.getUser();
%>
<% dbResources.close(); %>

<% if(user!=null && user.getId()!=0) { %>
You are logged in as: <%= user.getFname() %> <%= user.getLname() %><a href="#" onclick="logout();" style="padding-left:10px;"><span class="glyphicon glyphicon-remove" style="color:red;"></span></a>
<% } %>