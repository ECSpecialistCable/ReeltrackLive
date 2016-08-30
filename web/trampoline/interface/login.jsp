<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" scope="request"/>
<% userLoginMgr.init(pageContext,dbResources); %>
<% securityMgr.init(dbResources); %>
<% customerMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
Customer customer = new Customer();
CompEntities customers = customerMgr.searchCustomer(customer, Customer.NAME_COLUMN, true);

RTUser vendor = new RTUser();
vendor.setUserType(RTUser.USER_TYPE_VENDOR);
CompEntities vendors = securityMgr.getUsers(vendor, false);

String tempUrl; //var for url expression
%>

<%
String action = "";
if(request.getParameter("action") != null) {
    action = request.getParameter("action");
}
if(action.equals("login" )) {
    userLoginMgr.login(request.getParameter(RTUser.USERNAME_COLUMN), request.getParameter(RTUser.PASSWORD_COLUMN));
    user = (RTUser)userLoginMgr.getUser();
}
if(action.equals("logout")) {
    session.removeAttribute("RT");
    session.removeAttribute("PL");
    userLoginMgr.logout();
    user = null;
}
%>
<%  if(action.equals("vendor" )) { %>
<%
//userLoginMgr.logout();
vendor = new RTUser();
vendor.setId(Integer.parseInt(request.getParameter("vendor")));
vendor = (RTUser)securityMgr.getUser(vendor, true, false);
userLoginMgr.login(vendor.getUsername(), vendor.getPassword());
user = (RTUser)userLoginMgr.getUser();
%>
<% } %>

<%  if(action.equals("customer" )) { %>
<%
user.setCustomerId(Integer.parseInt(request.getParameter("customer")));
customer = new Customer();
customer.setId(user.getCustomerId());
customer = customerMgr.getCustomer(customer);
user.setCustomerName(customer.getName());
%>
<% } %>
<%  if(action.equals("job" )) { %>
<%
int jobId = Integer.parseInt(request.getParameter("job"));
session.setAttribute("LoggedInJobId", jobId);

CustomerJob job = new CustomerJob();
job.setId(jobId);
job = customerMgr.getCustomerJob(job);

user.setJobId(jobId);
user.setJobCode(job.getCode());
user.setJobName(job.getName());
System.out.println("logging in " + user.getJobName());

user.setCustomerId(job.getCustomerId());
customer = new Customer();
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
	//redirect = request.getContextPath() + "/trampoline/index.jsp?type=RT&id=" + rtReel.getId() + "&job=" + rtReel.getJobCode();
} else if(plReel!=null && plReel.getJobCode().equals(job.getCode())) {
	fowardToReelStatus = true;
	reelID = plReel.getId();
	//redirect = request.getContextPath() + "/trampoline/index.jsp?type=PL&id=" + plReel.getId() + "&job=" + plReel.getJobCode();
} else {
	//redirect = request.getContextPath() + "/trampoline/index.jsp";
}
%>
<% } %>

<% if(action.equals("change_job")) { %>
<%
session.removeAttribute("RT");
session.removeAttribute("PL");
session.removeAttribute("LoggedInJobId");
user.setJobId(0);
user.setJobCode("");
user.setJobName("");
%>
<% } %>

<% if(!userLoginMgr.isLoggedIn()) { %>
    <div class="panel panel-primary">
      <div class="panel-heading blue_bg">
        <h3 class="panel-title"><a data-toggle="collapse" href="#collapse1">Please Sign In</a></h3>
      </div>
      <div class="panel-body panel-collapse collapse in" id="collapse1">
        <form class="form-horizontal" role="form">
          <div class="form-group">
            <label style="padding-right:0;color:#333333;" for="textfield" class="col-sm-3 control-label">Username:</label>
            <div class="col-sm-9">
              <input type="email" class="form-control" name="username" id="username" placeholder="">
            </div>
          </div>
          <div class="form-group">
            <label style="padding-right:0;color:#333333;" for="textfield" class="col-sm-3 control-label">Password:</label>
            <div class="col-sm-9">
              <input type="password" class="form-control" name="password" id="password" placeholder="">
            </div>
          </div>
          <div class="form-group">
            <div class="col-sm-offset-3 col-sm-9">
              <button onclick="login();" class="btn btn-primary btn-sm">SIGN IN</button>
            </div>
          </div>
        </form>
      </div>
    </div>
<% } %>

<% if(userLoginMgr.isLoggedIn() && user.getJobCode().equals("") && !user.isUserType(RTUser.USER_TYPE_VENDOR)) { %>
    <% if(user.isUserType(RTUser.USER_TYPE_ECS)) { %>
    <div class="panel panel-primary">
      <div class="panel-heading blue_bg">
        <h3 class="panel-title"><a data-toggle="collapse" href="#collapse1">Select a Vendor</a></h3>
      </div>
      <div class="panel-body panel-collapse collapse in" id="collapse1">
        <form class="form-horizontal" role="form">
        <div class="form-group">
          <label style="padding-right:0;color:#333333;" for="vendor" class="col-sm-3 control-label">Vendor:</label>
          <div class="col-sm-9">
          <select class="form-control" id="vendor">
              <% for(int i=0; i<vendors.howMany(); i++) { %>
              <% vendor = (RTUser)vendors.get(i); %>
              <% String vendorName = vendor.getFname() + " " + vendor.getLname(); %>
              <option value="<%= new Integer(vendor.getId()).toString() %>"><%= vendorName %></option>
              <% } %>
          </select>
          </div>
        </div>
          <div class="form-group">
            <div class="col-sm-offset-3 col-sm-9">
              <button onclick="selectVendor();" class="btn btn-primary btn-sm">SUBMIT</button>
            </div>
          </div>
        </form>
      </div>
    </div>

    <div class="panel panel-primary">
      <div class="panel-heading blue_bg">
        <h3 class="panel-title"><a data-toggle="collapse" href="#collapse1">Select a Customer</a></h3>
      </div>
      <div class="panel-body panel-collapse collapse in" id="collapse1">
        <form class="form-horizontal" role="form">
            <div class="form-group">
              <label style="padding-right:0;color:#333333;" for="customer" class="col-sm-3 control-label">Customer:</label>
              <div class="col-sm-9">
              <select class="form-control" id="customer">
                  <% for(int i=0; i<customers.howMany(); i++) { %>
                  <% customer = (Customer)customers.get(i); %>
                  <option value="<%= new Integer(customer.getId()).toString() %>"><%= customer.getName() %></option>
                  <% } %>
              </select>
              </div>
            </div>
          <div class="form-group">
            <div class="col-sm-offset-3 col-sm-9">
              <button onclick="selectCustomer();" class="btn btn-primary btn-sm">SUBMIT</button>
            </div>
          </div>
        </form>
      </div>
    </div>
    <% } %>
<%--
    <h2 style="color:white;">Please Select a Vendor</h2>
    <admin:box_begin />
    	<form:begin_selfsubmit submit="true" name="create" action="common/includes/process_login.jsp" />
    		<form:row_begin />
    			<form:label name="" label="Vendor:" />
    			<form:content_begin />
    				<form:select_begin name="<%= RTUser.PARAM %>" label="" />
    					<% for(int i=0; i<vendors.howMany(); i++) { %>
                		<% vendor = (RTUser)vendors.get(i); %>
                		<% String vendorName = vendor.getFname() + " " + vendor.getLname(); %>
    					<form:option value="<%= new Integer(vendor.getId()).toString() %>" name="<%= vendorName %>"/>
    					<% } %>
    				<form:select_end />
    			<form:content_end />
    		<form:row_end />
    		<form:row_begin />
    				<form:label name="" label="" />
    				<form:buttonset_begin align="right" padding="0"/>
    					<form:submit_inline button="login" waiting="true" name="login" action="vendor" />
    				<form:buttonset_end />
    		<form:row_end />
    	<form:end />
    <admin:box_end />
    <br />

    <h2 style="color:white;">Please Select a Customer</h2>
    <admin:box_begin />
    	<form:begin_selfsubmit submit="true" name="create" action="common/includes/process_login.jsp" />
    		<form:row_begin />
    			<form:label name="" label="Customer:" />
    			<form:content_begin />
    				<form:select_begin name="<%= Customer.PARAM %>" label="customer" />
    					<% for(int i=0; i<customers.howMany(); i++) { %>
                		<% customer = (Customer)customers.get(i); %>
    					<form:option value="<%= new Integer(customer.getId()).toString() %>" match="<%= new Integer(user.getCustomerId()).toString() %>" name="<%= customer.getName() %>"/>
    					<% } %>
    				<form:select_end />
    			<form:content_end />
    		<form:row_end />
    		<form:row_begin />
    				<form:label name="" label="" />
    				<form:buttonset_begin align="right" padding="0"/>
    					<form:submit_inline button="login" waiting="true" name="login" action="customer" />
    				<form:buttonset_end />
    		<form:row_end />
    	<form:end />
    <admin:box_end />
    <br />
--%>

<% if(user.getCustomerId()!=0) { %>
<%
CompEntities custJobs = new CompEntities();
CustomerJob custJob = new CustomerJob();
if(user.isUserType(RTUser.USER_TYPE_ECS)) {
	custJob.setCustomerId(user.getCustomerId());
	custJobs = customerMgr.getCustomerJobs(custJob);
} else {
	custJobs = customerMgr.getJobsAssignedToUser(user);
}
%>
<div class="panel panel-primary">
  <div class="panel-heading blue_bg">
    <h3 class="panel-title"><a data-toggle="collapse" href="#collapse1">Select a Job</a></h3>
  </div>
  <div class="panel-body panel-collapse collapse in" id="collapse1">
    <form class="form-horizontal" role="form">
        <div class="form-group">
          <label style="padding-right:0;color:#333333;" for="job" class="col-sm-3 control-label">Job:</label>
          <div class="col-sm-9">
          <select class="form-control" id="job">
              <% for(int i=0; i<custJobs.howMany(); i++) { %>
              <% custJob = (CustomerJob)custJobs.get(i); %>
              <option value="<%= new Integer(custJob.getId()).toString() %>"><%= custJob.getName() %></option>
              <% } %>
          </select>
          </div>
        </div>
      <div class="form-group">
        <div class="col-sm-offset-3 col-sm-9">
          <button onclick="selectJob();" class="btn btn-primary btn-sm">SIGN IN</button>
        </div>
      </div>
    </form>
  </div>
</div>
<% } %>
<%--
<h2 style="color:white;">Please Select a Job</h2>
<admin:box_begin />
	<form:begin_selfsubmit submit="true" name="create" action="common/includes/process_login.jsp" />
		<form:row_begin />
			<form:label name="" label="Job:" />
			<form:content_begin />
				<form:select_begin name="<%= CustomerJob.PARAM %>" label="customer" />
					<% for(int i=0; i<custJobs.howMany(); i++) { %>
            		<% custJob = (CustomerJob)custJobs.get(i); %>
					<form:option value="<%= new Integer(custJob.getId()).toString() %>" name="<%= custJob.getName() %>"/>
					<% } %>
				<form:select_end />
			<form:content_end />
		<form:row_end />
		<% if(custJobs.howMany()>0) { %>
		<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="right" padding="0"/>
					<form:submit_inline button="login" waiting="true" name="login" action="job" />
				<form:buttonset_end />
		<form:row_end />
		<% } %>
	<form:end />
<admin:box_end />
--%>

<% } else if(userLoginMgr.isLoggedIn()) { %>
	<h2 style="margin-top:0;margin-bottom:20px;color:#016b8d;">Welcome to ECS ReelTrack, <%= user.getFname() %>.</h2>
<% } %>

<% dbResources.close(); %>
