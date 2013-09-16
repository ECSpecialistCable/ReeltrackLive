<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.monumental.trampoline.security.SecurityMgr" />
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
if(request.getParameter(User.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(User.PARAM));
}


if(action.equals("create")) {
    User content = new User();
    content.setFname(request.getParameter(User.FIRSTNAME_COLUMN));
    content.setLname(request.getParameter(User.LASTNAME_COLUMN));
    content.setEmail(request.getParameter(User.EMAIL_COLUMN));
    content.setUsername(request.getParameter(User.USERNAME_COLUMN));
    content.setPassword(request.getParameter(User.PASSWORD_COLUMN));
    content.setStatus(User.STATUS_INACTIVE);
    
    contid = securityMgr.addUser(content);
    if(contid != 0) {
        //notifier = "The content has been created.";
    }
	
System.out.println("param: " + request.getParameter(Group.PARAM));
	content.setId(contid);

	Group group = new Group();
	group.setId(Integer.parseInt(request.getParameter(Group.PARAM)));
	securityMgr.linkGroupToUser(content, group);
    
    redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + User.PARAM + "=" + contid;
}


if(action.equals("update")) {
    User content = new User();
    if(request.getParameter(User.PARAM) != null) {
        contid = Integer.parseInt(request.getParameter(User.PARAM));
        if(contid != 0) {
            content.setFname(request.getParameter(User.FIRSTNAME_COLUMN));
            content.setLname(request.getParameter(User.LASTNAME_COLUMN));
            content.setEmail(request.getParameter(User.EMAIL_COLUMN));
            content.setUsername(request.getParameter(User.USERNAME_COLUMN));
            content.setPassword(request.getParameter(User.PASSWORD_COLUMN));
            content.setStatus(request.getParameter(User.STATUS_COLUMN));
            content.setId(contid);
            
            securityMgr.updateUser(content);
            
            if(request.getParameter(Group.NAME_COLUMN) != null && !request.getParameter(Group.NAME_COLUMN).equals("0")) {
                Group currentGroup = new Group();
                currentGroup.setId(Integer.parseInt(request.getParameter(Group.NAME_COLUMN)));
                securityMgr.linkGroupToUser(content, currentGroup);
            }
            
            //notifier = "The content has been updated.";
        }
    }
    redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + User.PARAM + "=" + contid ;
}


if(action.equals("delete")) {
    User content = new User();
    content.setId(contid);
    securityMgr.deleteUser(content, basePath);
    //notifier = "The content has been deleted.";
    redirect = request.getContextPath() + "/trampoline/" + "users/search.jsp";
} 

%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />