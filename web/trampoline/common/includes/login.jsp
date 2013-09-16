<%@ page language="java" %>
<%@ page import="com.monumental.trampoline.security.*" %>
	
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%--
<html:begin />
	<admin:title text="Trampoline 4" />
        <admin:subtitle text="Please login" />
	<admin:box_begin />
	<form:begin_login name="login" action="common/includes/process_login.jsp" target="_top" />
		<form:textfield name="<%= User.USERNAME_COLUMN %>" label="<%= User.USERNAME_COLUMN %>" />
		<form:password name="<%= User.PASSWORD_COLUMN %>" label="<%= User.PASSWORD_COLUMN %>" />		
		<form:submit name="login" action="login" />
	<form:end />
	<admin:box_end />
<html:end />
--%>