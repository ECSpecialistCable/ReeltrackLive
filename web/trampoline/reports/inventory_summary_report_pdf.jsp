<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" %>
<%@ page language="java" %>

<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>
<%@ page import="java.util.LinkedHashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Set"%>
<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="reportMgr" class="com.reeltrack.reports.ReportMgr" />

<% userLoginMgr.init(pageContext, dbResources);%>
<% customerMgr.init(pageContext, dbResources);%>
<% reportMgr.init(pageContext, dbResources);%>

<%
		SimpleDateFormat generatedDtFmt = new SimpleDateFormat("EEEEE, MMMMM dd, yyyy");
		String jobCode = request.getParameter("job_code");

		CustomerJob custJob = new CustomerJob();
		custJob.setCode(jobCode);
		custJob.setSearchOp(CustomerJob.CODE_COLUMN, CustomerJob.EQ);
		custJob = customerMgr.getCustomerJob(custJob);

		Reel reel = new Reel();
		reel.setJobCode(jobCode);
		reel.setSearchOp(Reel.JOB_CODE_COLUMN, Reel.EQ);
		LinkedHashMap<String, ArrayList<Integer>> contents = reportMgr.getPNInfoForInventorySummaryReport(reel);
		Set<String> keys = contents.keySet();

%>

<% dbResources.close();%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
	<head>
		<title>Reports</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		<link href="<%= this.getServletContext().getRealPath("/trampoline/reports/pdfStyle.css")%>" rel="stylesheet" type="text/css" />
		<link rel="stylesheet" type="text/css" href="<%= this.getServletContext().getRealPath("/trampoline/reports/alice.css")%>" media="print"/>
	</head>
	<body>
		<div id="header">
			<div id="date" style="margin-right:35px"><%= generatedDtFmt.format(new Date()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page# "%><span id="pagenumber"></span></div>
			<div>
				<div id="logo" style="margin-left:15px; margin-right: 15px"><img alt="logo"   src="<%= this.getServletContext().getRealPath("/trampoline/common/images/logo.png")%>" />
				</div>
				<div id="jobName">
					<h3 style="margin-right:35px">Inventory Summary</h3>
					<h4 style="margin-right:35px; display: block; margin-top: -15px;"><%= custJob.getName() + " (" + custJob.getCode() + ")"%></h4>
				</div>
			</div>
		</div>

		<div id="footer">
			<span id="ph-no" style="margin-left:15px">770-446-2222</span>Electrical Cable Specialist    6680-C Jones Mill Court Norcross GA 30093
		</div>

		<div style="width:95%; padding:10px;">

			<h4>Inventory Summary</h4>
			<table style="width:100%;align:center;" border="1px solid red" cellpadding="3px" cellspacing="0">
				<th style="border-bottom: none" class="center">Cust P/N</th>
				<th colspan="4" class="center">Total Quantity</th>
				<th colspan="2" class="center">Number of Reels</th>

				<tr>
					<th style="border-top: none" class="center"></th>
					<th class="center">Unreceived</th>
					<th class="center">In<br/>Inventory</th>
					<th class="center">Checked<br/>OUT</th>
					<th class="center">On Complete<br/>Reels</th>
					<th class="center">In Inventory</th>
					<th class="center">Checked OUT</th>
				</tr>

				<% for (String customerPN : keys) {%>
				<% ArrayList<Integer> values = contents.get(customerPN);%>
				<tr>
					<td class="center"><%= customerPN%></td>
					<% for (int k = 0; k < values.size(); k++) {%>
					<td class="center"><%= values.get(k)%></td>
					<% }%>
				</tr>
				<% }%>
			</table>
		</div>
	</body>
</html>
