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
if(request.getParameter(Customer.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Customer.PARAM));
}

if(action.equals("create")) {
    Customer content = new Customer();
    content.setName(request.getParameter(Customer.NAME_COLUMN));
    content.setStatus(Customer.STATUS_ACTIVE);
    contid = customerMgr.addCustomer(content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/search.jsp";
}

if(action.equals("update")) {
    Customer content = new Customer();
    content.setId(contid);
    content.setName(request.getParameter(Customer.NAME_COLUMN));
    content.setIssueContactEmail(request.getParameter(Customer.ISSUE_CONTACT_EMAIL_COLUMN));
    content.setStatus(request.getParameter(Customer.STATUS_COLUMN));
    customerMgr.updateCustomer(content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/edit.jsp?" + Customer.PARAM + "=" + contid ;
}

if(action.equals("delete")) {
    Customer content = new Customer();
    content.setId(contid);
    customerMgr.deleteCustomer(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "customers/search.jsp";
} 

if(action.equals("add_customer_job")) {
    CustomerJob content = new CustomerJob();
    content.setCustomerId(contid);
    content.setName(request.getParameter(CustomerJob.NAME_COLUMN));
    content.setCode(request.getParameter(CustomerJob.CODE_COLUMN));
    int newId = customerMgr.addCustomerJob(content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/jobs.jsp?" + Customer.PARAM + "=" + contid ;
}

if(action.equals("update_customer_job")) {
    CustomerJob content = new CustomerJob();
    content.setId(Integer.parseInt(request.getParameter(CustomerJob.PARAM)));
    content.setName(request.getParameter(CustomerJob.NAME_COLUMN));
    content.setCode(request.getParameter(CustomerJob.CODE_COLUMN));
    content.setAutoPrintReelTags(request.getParameter(CustomerJob.AUTO_PRINT_REEL_TAG_COLUMN));
    customerMgr.updateCustomerJob(content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/edit_job.jsp?" + CustomerJob.PARAM + "=" + content.getId();
}

if(action.equals("delete_customer_job")) {
    CustomerJob content = new CustomerJob();
    content.setId(Integer.parseInt(request.getParameter(CustomerJob.PARAM)));
    customerMgr.deleteCustomerJob(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "customers/jobs.jsp?" + Customer.PARAM + "=" + contid;
}

if(action.equals("add_user")) {
    RTUser content = new RTUser();
    content.setCustomerId(contid);
    content.setUserType(request.getParameter(RTUser.USER_TYPE_COLUMN));
    content.setFname(request.getParameter(RTUser.FIRSTNAME_COLUMN));
    content.setLname(request.getParameter(RTUser.LASTNAME_COLUMN));
    content.setEmail(request.getParameter(RTUser.EMAIL_COLUMN));
    content.setUsername(request.getParameter(RTUser.USERNAME_COLUMN));
    content.setPassword(request.getParameter(RTUser.PASSWORD_COLUMN));
    content.setStatus(RTUser.STATUS_ACTIVE);
    
    int userId = securityMgr.addUser(content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/users.jsp?" + Customer.PARAM + "=" + contid;
}

if(action.equals("update_user")) {
    RTUser content = new RTUser();
    content.setId(Integer.parseInt(request.getParameter(RTUser.PARAM)));
    content.setUserType(request.getParameter(RTUser.USER_TYPE_COLUMN));
    content.setFname(request.getParameter(RTUser.FIRSTNAME_COLUMN));
    content.setLname(request.getParameter(RTUser.LASTNAME_COLUMN));
    content.setEmail(request.getParameter(RTUser.EMAIL_COLUMN));
    content.setUsername(request.getParameter(RTUser.USERNAME_COLUMN));
    content.setPassword(request.getParameter(RTUser.PASSWORD_COLUMN));
    content.setStatus(request.getParameter(RTUser.STATUS_COLUMN));
    
    securityMgr.updateUser(content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/edit_user.jsp?" + RTUser.PARAM + "=" + content.getId();
}

if(action.equals("assign_job")) {
    RTUser content = new RTUser();
    content.setId(Integer.parseInt(request.getParameter(RTUser.PARAM)));

    CustomerJob job = new CustomerJob();
    job.setId(Integer.parseInt(request.getParameter(CustomerJob.PARAM)));
    
    customerMgr.linkJobToUser(job,content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/edit_user.jsp?" + RTUser.PARAM + "=" + content.getId();
}

if(action.equals("unassign_job")) {
    RTUser content = new RTUser();
    content.setId(Integer.parseInt(request.getParameter(RTUser.PARAM)));

    CustomerJob job = new CustomerJob();
    job.setId(Integer.parseInt(request.getParameter(CustomerJob.PARAM)));
    
    customerMgr.unlinkJobToUser(job,content);
    redirect = request.getContextPath() + "/trampoline/" + "customers/edit_user.jsp?" + RTUser.PARAM + "=" + content.getId();
}

if(action.equals("delete_user")) {
    RTUser content = new RTUser();
    content.setId(Integer.parseInt(request.getParameter(RTUser.PARAM)));
    securityMgr.deleteUser(content, basePath);
    redirect = request.getContextPath() + "/trampoline/" + "customers/users.jsp?" + Customer.PARAM + "=" + contid;
}
%>

<% dbResources.close(); %>
<notifier:set_message text="<%= notifier %>" />		
<admin:ajax_redirect redirect="<%= redirect %>" />