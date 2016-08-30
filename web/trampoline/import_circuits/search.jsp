<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.reels.*"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% RTUser user = (RTUser)userLoginMgr.getUser(); %>
<%
String tempUrl =""; //var for url expression
%>
<% dbResources.close(); %>


<html:begin />
<admin:title heading="Circuits" text="Import"/>

<admin:subtitle text="Upload File" />
<admin:box_begin text="Upload File" name="Upload_File" />
	<form:begin_multipart submit="true" name="create" action="import_circuits/process.jsp" />
			<form:file label="File:" name="circuit_file" />
            <form:hidden name="<%= Reel.JOB_CODE_COLUMN %>" value="<%= user.getJobCode()%>" />
            <form:row_begin />
                <form:label name="" label="" />
                <form:buttonset_begin align="left" padding="0"/>
                        <form:submit_inline button="save" waiting="true" name="save" action="import" />
                <form:buttonset_end />
            <form:row_end />

    <form:row_begin/>
    <form:label label="Excel Template:" name=""/>
    <form:content_begin />
        <a href="/excel_examples/circuits_import.xlsx">Download</a>
    <form:content_end />
    <form:row_end/>
    <form:end/>
<admin:box_end />

<admin:set_tabset url="import_circuits/_tabset_default.jsp" thispage="search.jsp" />
<html:end />
