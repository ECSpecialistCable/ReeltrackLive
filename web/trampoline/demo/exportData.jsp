<%@ page language="java" %>		
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.utilities.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext, dbResources); %>

<% RTUser user = (RTUser)userLoginMgr.getUser(); %>	
<% dbResources.close(); %>

<%
	if(user!=null && user.getId()!=0) {
		//ReloadData.reloadData("/usr/bin/mysqldump -uwww -psleep499 demo > export.sql");
		Process runtimeProcess = Runtime.getRuntime().exec(new String[]{"/bin/sh","-c","/usr/bin/mysqldump -uwww -psleep499 demo > /www/new/web/trampoline/demo/export.sql"});
		int processComplete = runtimeProcess.waitFor();
		if(processComplete == 0){

		out.println("success");

		} else {

		out.println("restore failure");

		}
		response.sendRedirect("/trampoline/index.jsp");
	}
%>
