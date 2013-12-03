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

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% customerMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
// Get the id
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
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getName() %>" />
<notifier:show_message />

<admin:subtitle text="Edit Customer" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="customers/process.jsp" />

			<form:textfield name="<%= Customer.NAME_COLUMN %>" label="Name:" value="<%= content.getName() %>" />
			<form:row_begin />
				<form:label name="" label="Status:" />
				<form:content_begin />
					<form:select_begin name="<%= Customer.STATUS_COLUMN %>" label="status" />
						<form:option match="<%= content.getStatus() %>" value="<%= Customer.STATUS_ACTIVE %>" name="active"/>
						<form:option match="<%= content.getStatus() %>" value="<%= Customer.STATUS_INACTIVE %>" name="inactive"/>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:hidden name="<%= Customer.PARAM %>" value="<%= new Integer(contid).toString() %>" />			
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
					<form:submit_inline button="save" waiting="true" name="save" action="update" />
				<form:buttonset_end />
			<form:row_end />

    <form:end />
<admin:box_end />

<admin:set_tabset url="customers/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />