<%@page import="com.monumental.trampoline.datasources.DbResources"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.picklists.*" %>
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
<admin:title heading="Pick Lists" text="Add"/>

<admin:subtitle text="Add Pick List" />
<admin:box_begin text="Add Pick List" name="Add_Pick_List" />
    <form:begin submit="true" name="create" action="pick_lists/process.jsp" />
			<form:textfield name="<%= PickList.NAME_COLUMN %>" label="Name:" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="left" padding="0"/>
						<form:submit_inline button="save" waiting="true" name="save" action="create" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="pick_lists/_tabset_default.jsp" thispage="create.jsp" />
<html:end />
