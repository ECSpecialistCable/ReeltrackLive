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

	String invSumReportType = "Excel";
	if(request.getParameter("inv_summary_type")!=null) {
		invSumReportType = request.getParameter("inv_summary_type");
	}
	String invReportType = "Excel";
	if(request.getParameter("inv_type")!=null) {
		invReportType = request.getParameter("inv_type");
	}

	String dr = "";
	if(request.getParameter("dr")!=null) {
		dr = request.getParameter("dr");
	}
	String isr = "";
	if(request.getParameter("isr")!=null) {
		isr = request.getParameter("isr");
	}
	String ir = "";
	if(request.getParameter("ir")!=null) {
		ir = request.getParameter("ir");
	}
	String ctr = "";
	if(request.getParameter("ctr")!=null) {
		ctr = request.getParameter("ctr");
	}

	String zip_ctr = "";
	if(request.getParameter("zip_ctr")!=null) {
		zip_ctr = request.getParameter("zip_ctr");
	}

	String cir = "";
	if(request.getParameter("cir")!=null) {
		cir = request.getParameter("cir");
	}

	String pr = "";
	if(request.getParameter("pr")!=null) {
		pr = request.getParameter("pr");
	}
	String sr = "";
	if(request.getParameter("sr")!=null) {
		sr = request.getParameter("sr");
	}
	String alr = "";
	if(request.getParameter("alr")!=null) {
		alr = request.getParameter("alr");
	}
	String cdd = "";
	if(request.getParameter("cdd")!=null) {
		cdd = request.getParameter("cdd");
	}

%>

<% dbResources.close(); %>
<html:begin />
<admin:title heading="Reports" text="Generate"/>

<admin:subtitle text="Daily Report" />
<admin:box_begin text="Daily Report" name="Daily_Report" open="false" />
<form:begin name="daily_report" action="reports/process.jsp" />
	<form:date_picker label="Report Day:" name="daily_report_day" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
	<%if(dr.equals("true")) { %>
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
					<% String url = request.getContextPath() + "/reports/" + "daily_report.pdf"; %>
					<a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
			<form:buttonset_end />
		<form:row_end />
	<% } %>
	<form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="submit" action="daily_report" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="daily_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:subtitle text="Inventory Summary" />
<admin:box_begin text="Inventory Summary" name="Inventory_Summary" open="false" />
<form:begin_selfsubmit name="inventory_summary_type" action="reports/reports.jsp" />
	<form:row_begin />
        <form:label name="" label="Generate:" />
        <form:content_begin />
        <form:select_begin onchange="test" name="inv_summary_type" />
            <%--<form:option name="PDF" value="PDF" match="<%= invSumReportType %>" />--%>
            <form:option name="Excel" value="Excel" match="<%= invSumReportType %>" />
        <form:select_end />
        <form:content_end />
    <form:row_end />
<form:end />
<form:begin name="inventory_summary" action="reports/process.jsp" />
	<%if(isr.equals("true")) { %>
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
			    <% String fileName = "inventory_summary_report"; %>
				<% if(invSumReportType.equalsIgnoreCase("pdf")) { %>
					<% fileName+=".pdf"; %>
				<% } else if(invSumReportType.equalsIgnoreCase("Excel")) { %>
					<% fileName+=".xls"; %>
				<% } %>
					<% String url = request.getContextPath() + "/reports/" + fileName; %>
					<a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
			<form:buttonset_end />
		<form:row_end />
	<% } %>
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="submit" action="inventory_summary_report" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="inventory_summary" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
	<form:hidden name="whichReport" value="<%= invSumReportType %>" />
<form:end />
<admin:box_end />

<admin:subtitle text="Inventory Report" />
<admin:box_begin text="Inventory Report" name="Inventory_Report" open="false" />
<form:begin_selfsubmit name="inventory_type" action="reports/reports.jsp" />
	<form:row_begin />
        <form:label name="" label="Generate:" />
        <form:content_begin />
        <form:select_begin onchange="test" name="inv_type" />
            <%--<form:option name="PDF" value="PDF" match="<%= invReportType %>" />--%>
            <form:option name="Excel" value="Excel" match="<%= invReportType %>" />
        <form:select_end />
        <form:content_end />
    <form:row_end />
<form:end />

<form:begin name="inventory_report" action="reports/process.jsp" />
	<%if(ir.equals("true")) { %>
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
			    <% String fileName = "inventory_report"; %>
				<% if(invReportType.equalsIgnoreCase("pdf")) { %>
					<% fileName+=".pdf"; %>
				<% } else if(invReportType.equalsIgnoreCase("Excel")) { %>
					<% fileName+=".xls"; %>
				<% } %>
					<% String url = request.getContextPath() + "/reports/" + fileName; %>
					<a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
			<form:buttonset_end />
		<form:row_end />
	<% } %>
    <form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="submit" action="inventory_report" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="inventory_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
	<form:hidden name="whichReport" value="<%= invReportType %>" />
<form:end />
<admin:box_end />

    <admin:subtitle text="Circuit Report" />
    <admin:box_begin text="Circuit Report" name="Circuit_Report" open="false" />
    <form:begin name="circuit_report" action="reports/process.jsp" />
    <%if(cir.equals("true")) { %>
    <form:row_begin />
    <form:label name="" label="" />
    <form:buttonset_begin align="left" padding="0"/>
    <% String url = request.getContextPath() + "/reports/circuit_report.xls"; %>
    <a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
    <form:buttonset_end />
    <form:row_end />
    <% } %>
    <form:row_begin />
    <form:label name="" label="Generate:" />
    <form:buttonset_begin align="left" padding="0"/>
    <form:submit_inline button="submit" waiting="false" name="submit" action="circuit_report" />
    <form:buttonset_end />
    <form:row_end />
    <form:hidden name="reportType" value="circuit_report" />
    <form:hidden name="job_code" value="<%= user.getJobCode() %>" />
    <form:end />
    <admin:box_end />

    <admin:subtitle text="CTR Report" />
    <admin:box_begin text="CTR Report" name="CTR_Report" open="false" />
    <form:begin name="ctr_report" action="reports/process.jsp" />
    <%if(ctr.equals("true")) { %>
    <form:row_begin />
    <form:label name="" label="" />
    <form:buttonset_begin align="left" padding="0"/>
    <% String url = request.getContextPath() + "/reports/ctr_report.xls"; %>
    <a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
    <form:buttonset_end />
    <form:row_end />
    <% } %>
    <form:row_begin />
    <form:label name="" label="Generate:" />
    <form:buttonset_begin align="left" padding="0"/>
    <form:submit_inline button="submit" waiting="false" name="submit" action="ctr_report" />
    <form:buttonset_end />
    <form:row_end />
    <form:hidden name="reportType" value="ctr_report" />
    <form:hidden name="job_code" value="<%= user.getJobCode() %>" />
    <form:end />
    <admin:box_end />

    <admin:subtitle text="CTR Files" />
    <admin:box_begin text="CTR Files" name="CTR_Files" open="false" />
    <form:begin name="ctr_files" action="reports/process.jsp" />
    <%if(!zip_ctr.equals("")) { %>
	    <form:row_begin />
	    <form:label name="" label="" />
	    <form:buttonset_begin align="left" padding="0"/>
	    <% String url = request.getContextPath() + "/reports/" + zip_ctr; %>
	    <a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
	    <form:buttonset_end />
	    <form:row_end />
    <% } %>
	    <form:row_begin />
	    <form:label name="" label="Generate:" />
	    <form:buttonset_begin align="left" padding="0"/>
	    <form:submit_inline button="submit" waiting="false" name="submit" action="zip_ctr" />
	    <form:buttonset_end />
	    <form:row_end />
	    <form:hidden name="job_code" value="<%= user.getJobCode() %>" />

    <form:end />
    <admin:box_end />


<admin:subtitle text="Period Report" />
<admin:box_begin text="Period Report" name="Period_Report" open="false" />
<form:begin name="period_report" action="reports/process.jsp" />
	<form:date_picker label="Start Date:" name="period_report_start_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
	<form:date_picker label="End Date:" name="period_report_end_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
    <%if(pr.equals("true")) { %>
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
					<% String url = request.getContextPath() + "/reports/" + "period_report.pdf"; %>
					<a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
			<form:buttonset_end />
		<form:row_end />
	<% } %>
	<form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="submit" action="period_report" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="period_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<%--<admin:subtitle text="Steel Reel Report" />
<admin:box_begin />
<form:begin name="steel_reel_report" action="reports/process.jsp" />
	<form:date_picker label="Start Date:" name="steel_reel_report_start_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
	<form:date_picker label="End Date:" name="steel_reel_report_end_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
    <%if(sr.equals("true")) { %>
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
					<% String url = request.getContextPath() + "/reports/" + "steel_reel_report.pdf"; %>
					<a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
			<form:buttonset_end />
		<form:row_end />
	<% } %>
	<form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="search" action="steel_reel_report" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="steel_reel_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />
--%>
<admin:subtitle text="Action Log" />
<admin:box_begin text="Action Log" name="Action_Log" open="false" />
<form:begin name="action_log_report" action="reports/process.jsp" />
	<form:date_picker label="Start Date:" name="action_log_report_start_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
	<form:date_picker label="End Date:" name="action_log_report_end_date" required="true" value="<%= df.format(new Date()) %>" start="01/01/2012" />
    <%if(alr.equals("true")) { %>
		<form:row_begin />
			<form:label name="" label="" />
			<form:buttonset_begin align="left" padding="0"/>
					<% String url = request.getContextPath() + "/reports/" + "action_log_report.xls"; %>
					<a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
			<form:buttonset_end />
		<form:row_end />
	<% } %>
	<form:row_begin />
        <form:label name="" label="" />
        <form:buttonset_begin align="left" padding="0"/>
            <form:submit_inline button="submit" waiting="false" name="submit" action="action_log_report" />
        <form:buttonset_end />
    <form:row_end />
	<form:hidden name="reportType" value="action_log_report" />
	<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:subtitle text="Cable Data Download" />
<admin:box_begin text="Cable Data Download" name="Cable_Data_Download" open="false" />
<form:begin name="cdd_report" action="reports/process.jsp" />
<%if(cdd.equals("true")) { %>
<form:row_begin />
<form:label name="" label="" />
<form:buttonset_begin align="left" padding="0"/>
<% String url = request.getContextPath() + "/reports/cable_data_download.xls"; %>
<a target="_blank" href="<%= url %>"><%= "[Download]" %></a>
<form:buttonset_end />
<form:row_end />
<% } %>
<form:row_begin />
<form:label name="" label="Generate:" />
<form:buttonset_begin align="left" padding="0"/>
<form:submit_inline button="submit" waiting="false" name="submit" action="cable_data_download" />
<form:buttonset_end />
<form:row_end />
<form:hidden name="reportType" value="cable_data_download" />
<form:hidden name="job_code" value="<%= user.getJobCode() %>" />
<form:end />
<admin:box_end />

<admin:set_tabset url="reports/_tabset_default.jsp" thispage="reports.jsp" />
<html:end />
