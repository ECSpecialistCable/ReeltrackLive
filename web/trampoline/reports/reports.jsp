<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Enumeration"%>
<%@ page language="java" %>
<%@ include file="../common/includes/only_users.jsp" %>

<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.reeltrack.users.*" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" tagdir="/WEB-INF/tags/form"%>
<%@ taglib prefix="html" tagdir="/WEB-INF/tags/html"%>
<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="listing" tagdir="/WEB-INF/tags/listing"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr" />
<jsp:useBean id="reelMgr" class="com.reeltrack.reels.ReelMgr" />
<% userLoginMgr.init(pageContext); %>
<% reelMgr.init(pageContext,dbResources); %>
<% 
	RTUser user = (RTUser)userLoginMgr.getUser();
	SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");

%>

<% dbResources.close(); %>
<html:begin />
<admin:title text="Reports" />

<admin:subtitle text="Daily Report" />
<admin:box_begin />
<form:begin name="daily_report" action="../DownloadReportServlet" />
	<form:date_picker label="Report Day:" name="daily_report_day" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="search" action="test" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="daily_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:subtitle text="Inventory Summary" />
<admin:box_begin />
<form:begin name="inventory_summary" action="../DownloadReportServlet" />
    <form:row_begin />
        <form:label name="" label="Generate:" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="search" action="test" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="inventory_summary" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:subtitle text="Inventory Report" />
<admin:box_begin />
<form:begin name="inventory_report" action="../DownloadReportServlet" />
    <form:row_begin />
        <form:label name="" label="Generate:" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="search" action="test" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="inventory_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:subtitle text="Period Report" />
<admin:box_begin />
<form:begin name="period_report" action="../DownloadReportServlet" />
	<form:date_picker label="Start Date:" name="period_report_start_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
	<form:date_picker label="End Date:" name="period_report_end_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="search" action="test" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="period_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:subtitle text="Steel Reel Report" />
<admin:box_begin />
<form:begin name="steel_reel_report" action="../DownloadReportServlet" />
	<form:date_picker label="Start Date:" name="steel_reel_report_start_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
	<form:date_picker label="End Date:" name="steel_reel_report_end_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="search" action="test" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="steel_reel_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:set_tabset url="reports/_tabset_default.jsp" thispage="reports.jsp" />
<html:end />    