<%@page import="com.monumental.trampoline.datasources.DbResources"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>

<%
RTUser user = (RTUser)userLoginMgr.getUser();
dbResources.close();
%>

<html:begin />
<admin:title text="Users" />

<admin:subtitle text="Add User" />
<admin:box_begin />
    <form:begin submit="true" name="create" action="users/process.jsp" />

    		<form:row_begin />
				<form:label name="" label="User Type:" />
				<form:content_begin />
					<form:select_begin name="<%= RTUser.USER_TYPE_COLUMN %>" label="usertype" />
						<form:option value="<%= RTUser.USER_TYPE_ECS %>" name="ECS"/>
					<form:select_end />
				<form:content_end />
			<form:row_end />
			<form:textfield name="<%= RTUser.FIRSTNAME_COLUMN %>" label="first name:" />
			<form:textfield name="<%= RTUser.LASTNAME_COLUMN %>" label="last name:" />
			<form:textfield name="<%= RTUser.EMAIL_COLUMN %>" label="email:" />
			<form:textfield name="<%= RTUser.USERNAME_COLUMN %>" label="username:" required="true" />
			<form:textfield name="<%= RTUser.PASSWORD_COLUMN %>" label="password:" required="true" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
						<form:submit_inline button="save" waiting="true" name="save" action="create" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="users/_tabset_default.jsp" thispage="create.jsp" />
<html:end />