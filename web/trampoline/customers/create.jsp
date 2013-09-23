<%@page import="com.monumental.trampoline.datasources.DbResources"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
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
<admin:title text="Customers" />

<admin:subtitle text="Add Customer" />
<admin:box_begin />
    <form:begin submit="true" name="create" action="customers/process.jsp" />
			<form:textfield name="<%= Customer.NAME_COLUMN %>" label="name:" />
			<form:row_begin />
				<form:label name="" label="" />
				<form:buttonset_begin align="right" padding="0"/>
					<form:linkbutton button="cancel_off" name="Cancel" url="customers/search.jsp" />
						<form:submit_inline button="save" waiting="true" name="save" action="create" />
				<form:buttonset_end />
			<form:row_end />
    <form:end />
<admin:box_end />

<admin:set_tabset url="customers/_tabset_default.jsp" thispage="create.jsp" />
<html:end />