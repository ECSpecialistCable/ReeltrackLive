<%@page import="com.monumental.trampoline.datasources.DbResources"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />
<jsp:useBean id="securityMgr" class="com.monumental.trampoline.security.SecurityMgr" />
<% userLoginMgr.init(pageContext); %>
<% securityMgr.init(dbResources); %>

<%
User user = userLoginMgr.getUser();
boolean canAdd = false;
try { canAdd = user.getGroup().getPermission(new User()).getAdd(); } catch (Exception e) {}

CompEntities groups = securityMgr.getGroups(new Group(), true, false);
dbResources.close();
%>

<html:begin />
<admin:title text="Users" />

<admin:subtitle text="Create New User" />
<admin:box_begin />
    <form:begin submit="<%= new Boolean(canAdd).toString() %>" name="create" action="users/process.jsp" />
		<% if(groups.howMany() > 0) { %>
			<form:textfield name="<%= User.FIRSTNAME_COLUMN %>" label="first name:" />
			<form:textfield name="<%= User.LASTNAME_COLUMN %>" label="last name:" />
			<form:textfield name="<%= User.EMAIL_COLUMN %>" label="email:" />
			<form:textfield name="<%= User.USERNAME_COLUMN %>" label="username:" required="true" />
			<form:textfield name="<%= User.PASSWORD_COLUMN %>" label="password:" required="true" />
			<form:row_begin />
				<form:label name="group_select" label="Assign Group:" />
					<form:content_begin />
					<form:select_begin name="<%= Group.PARAM %>" />
						<% for(int i=0; i < groups.howMany(); i++) { %>
							<% Group currGroup = (Group) groups.get(i); %>
							<form:option name="<%= currGroup.getName() %>" value="<%= Integer.toString(currGroup.getId()) %>"/>
						<% } %>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="right" padding="0"/>
					<form:linkbutton button="cancel_off" name="Cancel" url="users/search.jsp" />
					<% if(canAdd) { %>
						<form:submit_inline button="save" waiting="true" name="save" action="create" />
					<% } %>
				<form:buttonset_end />
			<form:row_end />
		<% } else { %>
			<form:row_begin />
				&nbsp;<form:label_inline name="" label="There are no groups. A group is required in order to create a user." />
			<form:row_end />
		<% } %>
    <form:end />
<admin:box_end />

<admin:set_tabset url="users/_tabset_default.jsp" thispage="create.jsp" />
<html:end />