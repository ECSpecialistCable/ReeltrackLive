<%@ page language="java" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.content.*" %>
<%@ page import="com.monumental.trampoline.navigation.*" %>

<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

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
	<% if(user.getCustomerId()!=0 && !user.getJobCode().equals("") && (user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT) || user.isUserType(RTUser.USER_TYPE_STANDARD))) { %>
		<a class="module_bar_toggle" rel="common/interface/manage_reels">On-Site Reel Mgt</a>
		<a class="module_bar_toggle" rel="common/interface/reel_inventory">Inventory Data</a>
		<% if(user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT)) { %>
			<a class="module_bar_toggle" rel="common/interface/configuration">Job Data</a>
			<a class="module_bar_toggle" rel="common/interface/reports">Reports</a>
		<% } %>
	<% } %>
	<% if(user.isUserType(RTUser.USER_TYPE_ECS)) { %>
		<a class="module_bar_toggle" rel="common/interface/ecs_internal">ECS Internal</a>
	<% } %>
<% } %>
