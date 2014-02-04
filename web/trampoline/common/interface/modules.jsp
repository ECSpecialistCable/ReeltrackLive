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
<%
boolean isIpad = false;
String user_agent = request.getHeader("user-agent");
if(user_agent.contains("iPad")) {
	isIpad = true;
}
%>

<% if(userLoginMgr.isLoggedIn()) { %>
	<div>
	<a href="common/includes/process_login.jsp?submit_action=change_job" style="border-top:1px solid black;">Select Job</a>
	</div>

	<% if(user.getCustomerId()!=0 && !user.getJobCode().equals("") && (user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT) || user.isUserType(RTUser.USER_TYPE_STANDARD) || user.isUserType(RTUser.USER_TYPE_INVENTORY))) { %>
		<% if(!user.isUserType(RTUser.USER_TYPE_INVENTORY)) { %>
			<a class="module_bar_toggle" rel="common/interface/manage_reels">On-Site Reel Mgt</a>
		<% } %>
		<a class="module_bar_toggle" rel="common/interface/reel_inventory">Inventory Data</a>
		<% if(user.isUserType(RTUser.USER_TYPE_ECS) || user.isUserType(RTUser.USER_TYPE_MANAGEMENT) || user.isUserType(RTUser.USER_TYPE_INVENTORY) || user.isUserType(RTUser.USER_TYPE_STANDARD)) { %>
			<a class="module_bar_toggle" rel="common/interface/configuration">Job Data</a>
			<% if(!user.isUserType(RTUser.USER_TYPE_STANDARD)) { %>
				<a class="module_bar_toggle" rel="common/interface/reports">Reports</a>
			<% } %>
		<% } %>
	<% } %>
	<% if(user.isUserType(RTUser.USER_TYPE_ECS)) { %>
		<a class="module_bar_toggle" rel="common/interface/ecs_internal">ECS Internal</a>
	<% } %>
<% } %>
