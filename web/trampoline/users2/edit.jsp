<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
<% customerMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
int contid = 0;
if(request.getParameter(RTUser.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(RTUser.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
RTUser content = new RTUser();
content.setId(contid);
content = (RTUser)securityMgr.getUser(content, true, false);

//Get jobs
CustomerJob custJob = new CustomerJob();
custJob.setCustomerId(content.getCustomerId());
CompEntities custJobs = customerMgr.getCustomerJobs(custJob);
CompEntities jobsAssigned = customerMgr.getJobsAssignedToUser(content);

String tempUrl; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getName() %>" />
<notifier:show_message />

<admin:subtitle text="Edit User" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="users2/process.jsp" />

			<form:row_begin />
				<form:label name="" label="User Type:" />
				<form:content_begin />
					<form:select_begin name="<%= RTUser.USER_TYPE_COLUMN %>" label="usertype" />
						<form:option match="<%= content.getUserType() %>" value="<%= RTUser.USER_TYPE_MANAGEMENT %>" name="Management"/>
						<form:option match="<%= content.getUserType() %>" value="<%= RTUser.USER_TYPE_STANDARD %>" name="Warehouse"/>
						<form:option match="<%= content.getUserType() %>" value="<%= RTUser.USER_TYPE_INVENTORY %>" name="Foreman"/>
						<form:option match="<%= content.getUserType() %>" value="<%= RTUser.USER_TYPE_CPE %>" name="Cable Procurement / Expediting"/>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:textfield name="<%= RTUser.FIRSTNAME_COLUMN %>" label="first name:" value="<%= content.getFname() %>" />
			<form:textfield name="<%= RTUser.LASTNAME_COLUMN %>" label="last name:" value="<%= content.getLname() %>"/>
			<form:textfield name="<%= RTUser.EMAIL_COLUMN %>" label="email:" value="<%= content.getEmail() %>"/>
			<form:textfield name="<%= RTUser.USERNAME_COLUMN %>" label="username:" value="<%= content.getUsername() %>"/>
			<form:textfield name="<%= RTUser.PASSWORD_COLUMN %>" label="password:" value="<%= content.getPassword() %>"/>
			<form:row_begin />
				<form:label name="" label="Status:" />
				<form:content_begin />
					<form:select_begin name="<%= RTUser.STATUS_COLUMN %>" label="status" />
						<form:option match="<%= content.getStatus() %>" value="<%= RTUser.STATUS_ACTIVE %>" name="active"/>
						<form:option match="<%= content.getStatus() %>" value="<%= RTUser.STATUS_INACTIVE %>" name="inactive"/>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:hidden name="<%= RTUser.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update" />
				<form:buttonset_end />
			<form:row_end />

    <form:end />
<admin:box_end />

<admin:subtitle text="Assign Job" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="users2/process.jsp" />

			<form:row_begin />
				<form:label name="" label="Job:" />
				<form:content_begin />
					<form:select_begin name="<%= CustomerJob.PARAM %>" label="custjob" />
						<% for(int x=0; x<custJobs.howMany(); x++) { %>
						<% CustomerJob theJob = (CustomerJob)custJobs.get(x); %>
							<form:option value="<%= new Integer(theJob.getId()).toString() %>" name="<%= theJob.getName() %>"/>
						<% } %>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:hidden name="<%= RTUser.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="assign_job" />
				<form:buttonset_end />
			<form:row_end />

    <form:end />
<admin:box_end />

<% if(jobsAssigned.howMany() > 0) { %>
    <admin:subtitle text="Jobs Assigned" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="100" name="Job Code" />
                <listing:header_cell width="100" name="" />
            <listing:header_end />
            <% for(int i=0; i<jobsAssigned.howMany(); i++) { %>
            <% CustomerJob theJob = (CustomerJob)jobsAssigned.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= theJob.getName() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= theJob.getCode() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "users2/process.jsp?submit_action=unassign_job&" + RTUser.PARAM + "=" + content.getId() + "&" + CustomerJob.PARAM + "=" + theJob.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />	
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Jobs assigned to this User." />
<% } %>

<admin:set_tabset url="users2/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />