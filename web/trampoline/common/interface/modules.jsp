<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.content.*" %>
<%@ page import="com.monumental.trampoline.navigation.*" %>

<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% User user = userLoginMgr.getUser(); %>

<% 

/************************************************************************************************
TO SET THE MODULE MENU STYLE:
Put a 0 or a 1 in the "USE_STYLE" line below.
You'll also need to update the index.jsp. search for "@option" for instructions
************************************************************************************************/

String[] MODULE_STYLE = {"option", "link"};
String USE_STYLE = MODULE_STYLE[1]; // 0 for option, 1 for link

/************************************************************************************************
TO SET THE MODULE MENU STYLE:
Put a 0 or a 1 in the "USE_STYLE" line above
************************************************************************************************/
%>

<!-- 

The rel attribute in each of the <a> tags refers to a folder containing a _moduleactions.jsp file.
The permissions are dealt with in the file itself.

-->

<% if(userLoginMgr.isLoggedIn()) { %>
	<%--<% if(user.getGroup().hasPermission(new Group()) || user.getGroup().hasPermission(new User())) { %>--%>
		<a class="module_bar_toggle" rel="common/interface/users">Permissions</a>
	<%--<% } %>--%>
<% } %>
