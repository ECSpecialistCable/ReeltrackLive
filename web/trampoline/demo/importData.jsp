<%@ page language="java" %>		
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="java.io.*" %>
<%@ page import="com.reeltrack.utilities.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<% userLoginMgr.init(pageContext, dbResources); %>

<% RTUser user = (RTUser)userLoginMgr.getUser(); %>	
<% dbResources.close(); %>

<%
	if(user!=null && user.getId()!=0) {
		Process runtimeProcess = Runtime.getRuntime().exec(new String[]{"/bin/sh","-c","/usr/bin/mysql -uwww -psleep499 demo < /www/new/web/trampoline/demo/export.sql"});
		BufferedReader in = new BufferedReader(new InputStreamReader(runtimeProcess.getInputStream()));
            String line;
		    while ((line = in.readLine()) != null) {
		        out.println(line); 
		    }
		    in.close();
		response.sendRedirect("/trampoline/common/includes/process_login.jsp?submit_action=logout");
	}
%>
