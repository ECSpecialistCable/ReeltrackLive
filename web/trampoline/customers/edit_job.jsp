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
if(request.getParameter(CustomerJob.PARAM) != null) {
    contid = Integer.parseInt(request.getParameter(CustomerJob.PARAM));
} else {
    String param = "content_id_for_tabset";
    if(request.getParameter(param) != null) {
        contid = Integer.parseInt(request.getParameter(param));
    }
}

// Get the piece of content
CustomerJob content = new CustomerJob();
content.setId(contid);
content = (CustomerJob)customerMgr.getCustomerJob(content);

String tempUrl; //var for url expression
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getName() %>" />
<notifier:show_message />

<admin:subtitle text="Edit Job" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="customers/process.jsp" />

			<form:row_begin />
			<form:textfield name="<%= CustomerJob.NAME_COLUMN %>" label="Name:" value="<%= content.getName() %>" />
			<form:textfield name="<%= CustomerJob.CODE_COLUMN %>" label="Code:" value="<%= content.getCode() %>"/>
            <form:row_begin />
                <form:label name="" label="QR Codes Must Match:" />
                <form:content_begin />
                    <form:select_begin name="<%= CustomerJob.SCANS_MUST_MATCH_COLUMN %>" label="mustmatch" />
                        <form:option match="<%= content.getScansMustMatch() %>" value="n" name="No"/>
                        <form:option match="<%= content.getScansMustMatch() %>" value="y" name="Yes"/>
                    <form:select_end />
                <form:content_end />
            <form:row_end />
			<form:row_begin />
                <form:label name="" label="Auto Print Reel Tags:" />
                <form:content_begin />
                    <form:select_begin name="<%= CustomerJob.AUTO_PRINT_REEL_TAG_COLUMN %>" label="auto_print" />
                        <form:option match="<%= content.getAutoPrintReelTags() %>" value="n" name="No"/>
                        <form:option match="<%= content.getAutoPrintReelTags() %>" value="y" name="Yes"/>
                    <form:select_end />
                <form:content_end />
            <form:row_end />
			<form:hidden name="<%= CustomerJob.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update_customer_job" />
				<form:buttonset_end />
			<form:row_end />

    <form:end />
<admin:box_end />

<admin:set_tabset url="customers/_tabset_edit_job.jsp" thispage="edit_job.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />