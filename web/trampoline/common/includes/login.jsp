<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" scope="request"/>
<% userLoginMgr.init(pageContext); %>
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

<html:begin />


<admin:title text="" />


<% if(!userLoginMgr.isLoggedIn()) { %>
<div style="padding-left:25px;padding-top:25px;position:absolute; top:108px; left:202px; width:776px;height:900px;background-color: #1c7f6b;">
<h2 style="color:white;">Please Log In</h2>
<admin:box_begin />
	<form:begin_selfsubmit submit="true" name="create" action="common/includes/process_login.jsp" />
		<form:textfield name="<%= RTUser.USERNAME_COLUMN %>" label="<%= RTUser.USERNAME_COLUMN %>" />
		<form:password name="<%= RTUser.PASSWORD_COLUMN %>" label="<%= RTUser.PASSWORD_COLUMN %>" />		
		<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="right" padding="0"/>
					<form:submit_inline button="login" waiting="true" name="login" action="login" />
					<%--<button type="button" class="btn btn-primary btn-sm loginButton">Primary</button>--%>
				<form:buttonset_end />
			<form:row_end />
	<form:end />
<admin:box_end />

<div style="text-align:center; position:relative; left:-30px; width:801px;">
<%--<h1 style="padding-top:20px; color:white; font-size:36px;font-weight:bold;">Welcome to ReelTrack</h1>--%>
<img src="common/images/home-image2.png" width="700">
</div>

</div>
<% } %>

<% if(userLoginMgr.isLoggedIn() && user.getJobCode().equals("")) { %>
<div style="padding-left:25px;padding-top:25px;position:absolute; top:108px; left:202px; width:776px;height:900px;background-color: #1c7f6b;">
<% if(user.isUserType(RTUser.USER_TYPE_ECS)) { %>
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
<% } %>

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
					<%--<form:option value="<%= custJob.getCode() %>" name="<%= custJob.getName() %>"/>--%>
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
<% } %>

<div style="text-align:center; position:relative; left:-30px; width:801px;">
<%--<h1 style="padding-top:20px; color:white; font-size:36px;font-weight:bold;">Welcome to ReelTrack</h1>--%>
<img src="common/images/home-image2.png" width="700">
</div>

</div>


<% } else if(userLoginMgr.isLoggedIn()) { %>
	<div style="text-align:center; position:absolute; top:108px; left:202px; width:801px;height:900px;background-color: #1c7f6b;">
	<%--<h1 style="padding-top:20px; color:white; font-size:36px;font-weight:bold;">Welcome to ReelTrack</h1>--%>
	<img src="common/images/home-image2.png" width="700">
	</div>
<% } %>

<html:end />

<% dbResources.close(); %>
