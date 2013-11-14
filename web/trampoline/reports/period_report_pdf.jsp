<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="reportMgr" class="com.reeltrack.reports.ReportMgr" />

<% userLoginMgr.init(pageContext, dbResources);%>
<% customerMgr.init(pageContext, dbResources);%>
<% reportMgr.init(pageContext, dbResources);%>

<%
	SimpleDateFormat generatedDtFmt = new SimpleDateFormat("EEEEE, MMMMM dd, yyyy");

	SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
	GregorianCalendar startDate = new GregorianCalendar();
	GregorianCalendar endDate = new GregorianCalendar();
	if(request.getParameter("period_report_start_date")!=null && !request.getParameter("period_report_start_date").equals("") &&
			request.getParameter("period_report_end_date")!=null && !request.getParameter("period_report_end_date").equals("")) {
		startDate.setTime(df.parse(request.getParameter("period_report_start_date")));
		endDate.setTime(df.parse(request.getParameter("period_report_end_date")));
		endDate.set(GregorianCalendar.HOUR, 23);
		endDate.set(GregorianCalendar.MINUTE, 59);
		endDate.set(GregorianCalendar.SECOND, 59);

	}

	String jobCode = request.getParameter("job_code");

	CustomerJob custJob = new CustomerJob();
	custJob.setCode(jobCode);
	custJob.setSearchOp(CustomerJob.CODE_COLUMN, CustomerJob.EQ);
	custJob = customerMgr.getCustomerJob(custJob);

	Reel reel = new Reel();
	reel.setJobCode(jobCode);
	reel.setSearchOp(Reel.JOB_CODE_COLUMN, Reel.EQ);
	ArrayList<Integer> reels = reportMgr.getReelTrackPeriodSummary(reel, startDate, endDate);

	CompEntities issuesResolved = reportMgr.getReelIssues(reel, startDate, endDate, true); // resolved
	CompEntities issuesPending = reportMgr.getReelIssues(reel, startDate, endDate, false); // pending
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
					<h3 style="margin-right:35px">ReelTrack Period Report</h3>
					<%--<h3 style="margin-right:35px; display: block; margin-top: -15px; text-align: center">Report</h3>--%>
				</div>
			</div>
		</div>

		<div id="footer">
			<span id="ph-no" style="margin-left:15px">770-446-2222</span>Electrical Cable Specialist    6680-C Jones Mill Court Norcross GA 30093
		</div>

		<div style="width:95%; padding:10px;">

			<h4 style="text-align: center">Data Summary from <%= df.format(startDate.getTime()) %> to <%= df.format(endDate.getTime()) %></h4>
			<table style="width:100%;align:center;" border="1px solid black" cellpadding="3px" cellspacing="0">
				<th colspan="7" class="center"><b>Reels</b></th>
				
				<tr>
					<th class="center">Received</th>
					<th class="center">Checked<br/>Out</th>
					<th class="center">Checked IN</th>
					<th class="center">Pending<br/>Delivery</th>
					<th class="center">Complete</th>
					<th class="center">Steel<br/>Reels On<br/>Site</th>
					<th class="center">Steel<br/>Reels On<br/>Returned</th>
				</tr>

				<tr style="background: #cccccc">
					<% for(int i=0; i<reels.size(); i++) { %>
						<td class="center"><%= reels.get(i).toString() %></td>
					<% } %>
					<td class="center"></td>
					<td class="center"></td>
				</tr>				
			</table>

			<br/><br/>
			<table style="width:100%;align:center;" border="1px solid black" cellpadding="3px" cellspacing="0">
				<th colspan="2" class="center"><b>Issues</b></th>

				<tr>
					<th class="center">Resolved</th>
					<th class="center">Pending</th>
				</tr>

				<tr style="background: #cccccc">
					<td class="center"><%= issuesResolved.howMany() %></td>
					<td class="center"><%= issuesPending.howMany() %></td>
				</tr>
			</table>
			<br/><br/>
			<h4>List of Pending issues</h4>
			<table style="width:100%;align:center;" border="1px solid black" cellpadding="3px" cellspacing="0">
				<tr>
					<th class="center">Date</th>
					<th class="center">Description</th>
					<th class="center">Issue Log</th>
				</tr>
				<% for(int i=0; i<issuesPending.howMany(); i++) { %>
					<% ReelIssue current = (ReelIssue)issuesPending.get(i); %>
					<tr style="background: #cccccc">
						<td class="center"><%= current.getCreatedString() %></td>
						<td class="center"><%= current.getDescription() %></td>
						<td class="center"><%= current.getIssueLog() %></td>
					</tr>
				<% } %>
			</table>
			<br/><br/>
			<h4>List of Resolved issues</h4>
			<table style="width:100%;align:center;" border="1px solid black" cellpadding="3px" cellspacing="0">
				<tr>
					<th class="center">Date</th>
					<th class="center">Description</th>
					<th class="center">Issue Log</th>
				</tr>
				<% for(int i=0; i<issuesResolved.howMany(); i++) { %>
					<% ReelIssue current = (ReelIssue)issuesResolved.get(i); %>
					<tr style="background: #cccccc">
						<td class="center"><%= current.getCreatedString() %></td>
						<td class="center"><%= current.getDescription() %></td>
						<td class="center"><%= current.getIssueLog() %></td>
					</tr>
				<% } %>
			</table>
		</div>
	</body>
</html>