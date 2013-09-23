<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>

<% CompProperties props = new CompProperties(); %>

<% 	 
userLoginMgr.init(pageContext, dbResources);

String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}
%>


<%  if(action.equals("login" )) { %>
<%  
userLoginMgr.login(request.getParameter(RTUser.USERNAME_COLUMN), request.getParameter(RTUser.PASSWORD_COLUMN));
redirect = request.getContextPath() + "/trampoline/index.jsp";
%>
<% } %>


<% if(action.equals("logout")) { %>
<%  
userLoginMgr.logout();
redirect = request.getContextPath() + "/trampoline/index.jsp";			
%>
<% } %>
<% dbResources.close(); %>
<% response.sendRedirect(redirect);%>