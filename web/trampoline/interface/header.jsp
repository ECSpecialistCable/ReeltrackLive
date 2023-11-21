<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>

<% CompProperties props = new CompProperties(); %>

<%   
userLoginMgr.init(pageContext, dbResources);
RTUser user = (RTUser)userLoginMgr.getUser();
%>
<% dbResources.close(); %>

<% if(user!=null && user.getId()!=0) { %>

<% String welcomeStr = user.getFname() + " " + user.getLname(); %>
<%
if(!user.getJobName().equals("")) {
    welcomeStr = welcomeStr + " of " + user.getJobName() + " Project #" + user.getJobCode();
}
%>

<div style="margin-left:10px;border-bottom:1px solid gray;position:absolute;bottom:0px;padding:5px;padding-left:10px;padding-right:10px;background:black;color:silver;font-size:13px;border-top-left-radius:5px;border-top-right-radius:5px;">
<%= welcomeStr %><a href="#" onclick="logout();" style="padding-left:10px;"><span class="glyphicon glyphicon-remove" style="color:red;"></span></a>
</div>
<% } %>