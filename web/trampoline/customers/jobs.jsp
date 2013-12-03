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
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% customerMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>

<%
int contid = 0;
if(request.getParameter(Customer.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(Customer.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
Customer content = new Customer();
content.setId(contid);
content = (Customer)customerMgr.getCustomer(content);

//Get jobs
CustomerJob custJob = new CustomerJob();
custJob.setCustomerId(content.getId());
CompEntities custJobs = customerMgr.getCustomerJobs(custJob);

String tempUrl; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />

<admin:title text="<%= content.getTitle()%>" />
	<notifier:show_message />
	<admin:subtitle text="Add Job" />
	
	<admin:box_begin />
		<form:begin name="add_note" action="customers/process.jsp" />
			<form:textfield name="<%= CustomerJob.NAME_COLUMN %>" label="Name:" />        		
			<form:textfield name="<%= CustomerJob.CODE_COLUMN %>" label="Job Code:" />        			
			
			<form:hidden name="<%= Customer.PARAM %>" value="<%= content.getId() %>" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="add_customer_job" />
				<form:buttonset_end />
			<form:row_end />
		<form:end />
	<admin:box_end />
	
<% if(custJobs.howMany() > 0) { %>
    <admin:subtitle text="Jobs" />
    <admin:box_begin color="false" />
        <listing:begin />
            <listing:header_begin />
                <listing:header_cell first="true" name="Name" />
                <listing:header_cell width="100" name="Job Code" />
                <listing:header_cell width="110" name="" />
            <listing:header_end />
            <% for(int i=0; i<custJobs.howMany(); i++) { %>
            <% custJob = (CustomerJob)custJobs.get(i); %>
            <listing:row_begin row="<%= new Integer(i).toString() %>" />
                <listing:cell_begin />
                    <%= custJob.getName() %>
                <listing:cell_end />
                <listing:cell_begin />
                    <%= custJob.getCode() %>
                <listing:cell_end />
                <listing:cell_begin align="right"/>
                <% tempUrl = "customers/edit_job.jsp?" +  CustomerJob.PARAM + "=" + custJob.getId();%>
                <form:linkbutton url="<%= tempUrl %>" name="EDIT" />
                <% tempUrl = "customers/process.jsp?submit_action=delete_customer_job&" + Customer.PARAM + "=" + content.getId() + "&" + CustomerJob.PARAM + "=" + custJob.getId(); %>
                <form:linkbutton warning="true" url="<%= tempUrl %>" process="true" name="DELETE" />
                <listing:cell_end />
            <listing:row_end />	
            <% } %>
        <listing:end />
    <admin:box_end />
<% } else { %>
    <admin:subtitle text="There are no Jobs assigned to this Customer." />
<% } %>
		
	<admin:set_tabset url="customers/_tabset_manage.jsp" thispage="jobs.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />