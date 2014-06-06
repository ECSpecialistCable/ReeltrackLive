<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<% customerMgr.init(pageContext,dbResources); %>
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
    content.setCustomerId(Integer.parseInt(request.getParameter(RTUser.CUSTOMER_ID_COLUMN)));
    content.setUserType(request.getParameter(RTUser.USER_TYPE_COLUMN));
    content.setFname(request.getParameter(RTUser.FIRSTNAME_COLUMN));
    content.setLname(request.getParameter(RTUser.LASTNAME_COLUMN));
    content.setEmail(request.getParameter(RTUser.EMAIL_COLUMN));
    content.setUsername(request.getParameter(RTUser.USERNAME_COLUMN));
    content.setPassword(request.getParameter(RTUser.PASSWORD_COLUMN));
    content.setStatus(RTUser.STATUS_ACTIVE);
    
    contid = securityMgr.addUser(content);
    if(contid!=0) {
        RTUser theUser = new RTUser();
        theUser.setId(contid);
        CustomerJob theJob = new CustomerJob();
        RTUser loggedIn = (RTUser)userLoginMgr.getUser();
        theJob.setId(loggedIn.getJobId());
        customerMgr.linkJobToUser(theJob, theUser);
    }
    //redirect = request.getContextPath() + "/trampoline/" + "users/edit.jsp?" + RTUser.PARAM + "=" + contid;
    redirect = request.getContextPath() + "/trampoline/" + "users2/search.jsp";
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
    redirect = request.getContextPath() + "/trampoline/" + "users2/edit.jsp?" + RTUser.PARAM + "=" + contid ;
}

if(action.equals("assign_job")) {
    RTUser content = new RTUser();
    content.setId(Integer.parseInt(request.getParameter(RTUser.PARAM)));

    CustomerJob job = new CustomerJob();
    job.setId(Integer.parseInt(request.getParameter(CustomerJob.PARAM)));
    
    customerMgr.linkJobToUser(job,content);
    redirect = request.getContextPath() + "/trampoline/" + "users2/edit.jsp?" + RTUser.PARAM + "=" + contid;
}

if(action.equals("unassign_job")) {
    RTUser content = new RTUser();
    content.setId(Integer.parseInt(request.getParameter(RTUser.PARAM)));

    CustomerJob job = new CustomerJob();
    job.setId(Integer.parseInt(request.getParameter(CustomerJob.PARAM)));
    
    customerMgr.unlinkJobToUser(job,content);
    redirect = request.getContextPath() + "/trampoline/" + "users2/edit.jsp?" + RTUser.PARAM + "=" + contid;
}

if(action.equals("delete")) {
    RTUser content = new RTUser();
    content.setId(contid);
    securityMgr.deleteUser(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "users2/search.jsp";
} 

%>
<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />