<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.monumental.trampoline.component.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="securityMgr" class="com.reeltrack.users.RTUserMgr" scope="request"/>
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>
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
%>
<% dbResources.close(); %>

<html:begin />
<admin:title text="<%= content.getName() %>" />
<notifier:show_message />

<admin:subtitle text="Edit User" />
<admin:box_begin />
    <form:begin submit="true" name="edit" action="users/process.jsp" />

			<form:row_begin />
				<form:label name="" label="User Type:" />
				<form:content_begin />
					<form:select_begin name="<%= RTUser.USER_TYPE_COLUMN %>" label="usertype" />
						<form:option match="<%= content.getUserType() %>" value="<%= RTUser.USER_TYPE_ECS %>" name="ECS"/>
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
				<form:buttonset_begin align="right" padding="0"/>
					<form:linkbutton button="cancel_off" name="Cancel" url="users/search.jsp" />
					<form:submit_inline button="save" waiting="true" name="save" action="update" />
				<form:buttonset_end />
			<form:row_end />

    <form:end />
<admin:box_end />

<admin:set_tabset url="users/_tabset_manage.jsp" thispage="edit.jsp" content_id_for_tabset="<%= contid %>"/>
<html:end />