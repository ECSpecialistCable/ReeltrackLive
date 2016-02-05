<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr"/>
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>

<% CompProperties props = new CompProperties(); %>
<% customerMgr.init(pageContext,dbResources); %>
<% securityMgr.init(dbResources); %>

<% 	 
userLoginMgr.init(pageContext, dbResources);

String redirect = request.getHeader("referer");
String action = "";
if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}
%>


<%  if(action.equals("login" )) { %>
<%  
userLoginMgr.login(request.getParameter(RTUser.USERNAME_COLUMN), request.getParameter(RTUser.PASSWORD_COLUMN));
redirect = request.getContextPath() + "/trampoline/index.jsp";
%>
<% } %>

<%  if(action.equals("vendor" )) { %>
<%  
RTUser vendor = new RTUser();
vendor.setId(Integer.parseInt(request.getParameter(RTUser.PARAM)));
vendor = (RTUser)securityMgr.getUser(vendor, true, false);
userLoginMgr.login(vendor.getUsername(), vendor.getPassword());
redirect = request.getContextPath() + "/trampoline/index.jsp";
%>
<% } %>

<%  if(action.equals("customer" )) { %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%  
user.setCustomerId(Integer.parseInt(request.getParameter(Customer.PARAM)));
Customer customer = new Customer();
customer.setId(user.getCustomerId());
customer = customerMgr.getCustomer(customer);
user.setCustomerName(customer.getName());
redirect = request.getContextPath() + "/trampoline/index.jsp";
%>
<% } %>

<%  if(action.equals("job" )) { %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
int jobId = Integer.parseInt(request.getParameter(CustomerJob.PARAM));
session.setAttribute("LoggedInJobId", jobId);

CustomerJob job = new CustomerJob();
job.setId(jobId);
job = customerMgr.getCustomerJob(job);

user.setJobId(jobId);
user.setJobCode(job.getCode());
user.setJobName(job.getName());
System.out.println("logging in " + user.getJobName());

user.setCustomerId(job.getCustomerId());
Customer customer = new Customer();
customer.setId(job.getCustomerId());
customer = customerMgr.getCustomer(customer);
user.setCustomerName(customer.getName());


Reel rtReel = (Reel)session.getAttribute("RT");
Reel plReel = (Reel)session.getAttribute("PL");
boolean fowardToReelStatus = false;
int reelID = 0;
if(rtReel!=null && rtReel.getJobCode().equals(job.getCode())) {
	fowardToReelStatus = true;
	reelID = rtReel.getId();
	redirect = request.getContextPath() + "/trampoline/index.jsp?type=RT&id=" + rtReel.getId() + "&job=" + rtReel.getJobCode();
} else if(plReel!=null && plReel.getJobCode().equals(job.getCode())) {
	fowardToReelStatus = true;
	reelID = plReel.getId();
	redirect = request.getContextPath() + "/trampoline/index.jsp?type=PL&id=" + plReel.getId() + "&job=" + plReel.getJobCode();
} else {
	redirect = request.getContextPath() + "/trampoline/index.jsp";
}
%>
<% } %>

<% if(action.equals("change_job")) { %>
<%
session.removeAttribute("RT");
session.removeAttribute("PL");  
session.removeAttribute("LoggedInJobId");
RTUser user = (RTUser)userLoginMgr.getUser();
user.setJobId(0);
user.setJobCode("");
user.setJobName("");
redirect = request.getContextPath() + "/trampoline/index.jsp";			
%>
<% } %>

<% if(action.equals("logout")) { %>
<%
session.removeAttribute("RT");
session.removeAttribute("PL");  
userLoginMgr.logout();
redirect = request.getContextPath() + "/trampoline/index.jsp";			
%>
<% } %>
<% dbResources.close(); %>
<% response.sendRedirect(redirect);%>