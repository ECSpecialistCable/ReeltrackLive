<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<% securityMgr.init(dbResources); %>
<% CompProperties props = new CompProperties(); %>

<% 
String basePath = pageContext.getServletContext().getRealPath("/");
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}

int contid = 0;
if(request.getParameter(RTUser.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(RTUser.PARAM));
}


if(action.equals("create")) {
    RTUser content = new RTUser();
    content.setUserType(request.getParameter(RTUser.USER_TYPE_COLUMN));
    content.setFname(request.getParameter(RTUser.FIRSTNAME_COLUMN));
    content.setLname(request.getParameter(RTUser.LASTNAME_COLUMN));
    content.setEmail(request.getParameter(RTUser.EMAIL_COLUMN));
    content.setUsername(request.getParameter(RTUser.USERNAME_COLUMN));
    content.setPassword(request.getParameter(RTUser.PASSWORD_COLUMN));
    content.setStatus(RTUser.STATUS_ACTIVE);
    
    contid = securityMgr.addUser(content);
    //redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid;
    redirect = request.getContextPath() + "/trampoline/" + "users/search.jsp";
}


if(action.equals("update")) {
    RTUser content = new RTUser();
    if(request.getParameter(RTUser.PARAM) != null) {
        contid = Integer.parseInt(request.getParameter(RTUser.PARAM));
        if(contid != 0) {
            content.setUserType(request.getParameter(RTUser.USER_TYPE_COLUMN));
            content.setFname(request.getParameter(RTUser.FIRSTNAME_COLUMN));
            content.setLname(request.getParameter(RTUser.LASTNAME_COLUMN));
            content.setEmail(request.getParameter(RTUser.EMAIL_COLUMN));
            content.setUsername(request.getParameter(RTUser.USERNAME_COLUMN));
            content.setPassword(request.getParameter(RTUser.PASSWORD_COLUMN));
            content.setStatus(request.getParameter(RTUser.STATUS_COLUMN));
            content.setId(contid);
            
            securityMgr.updateUser(content);
        }
    }
    redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid ;
}


if(action.equals("delete")) {
    RTUser content = new RTUser();
    content.setId(contid);
    securityMgr.deleteUser(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "users/search.jsp";
} 

%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />