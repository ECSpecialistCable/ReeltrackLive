<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.GregorianCalendar"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Date"%>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.reeltrack.reels.*" %>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>
<%@ page import="com.reeltrack.picklists.PickList"%>

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
	GregorianCalendar reportDay = new GregorianCalendar();
	if(request.getParameter("daily_report_day")!=null && !request.getParameter("daily_report_day").equals("")) {
		reportDay.setTime(df.parse(request.getParameter("daily_report_day")));
	}
	String jobCode = request.getParameter("job_code");

	CustomerJob custJob = new CustomerJob();
	custJob.setCode(jobCode);
	custJob.setSearchOp(CustomerJob.CODE_COLUMN, CustomerJob.EQ);
	custJob = customerMgr.getCustomerJob(custJob);

	Reel reel = new Reel();
	reel.setJobCode(jobCode);
	reel.setSearchOp(Reel.JOB_CODE_COLUMN, Reel.EQ);
	CompEntities recievedOnDate = reportMgr.getReelForDailyReport(reel, reportDay, Reel.STATUS_RECEIVED);
	CompEntities checkedOutOnDate = reportMgr.getReelForDailyReport(reel, reportDay, Reel.STATUS_CHECKED_OUT);
	checkedOutOnDate = reportMgr.fillReelWithPickLists(checkedOutOnDate);

	CompEntities checkedInOnDate = reportMgr.getReelForDailyReport(reel, reportDay, Reel.STATUS_IN_WHAREHOUSE);
	checkedInOnDate = reportMgr.fillReelWithReelIssue(checkedInOnDate, reportDay);

	ArrayList<Integer> reels = reportMgr.getReelsForInvSummary(reel, reportDay);
%>
<% dbResources.close(); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

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
					<h3 style="margin-right:35px">ReelTrack Daily Report</h3>
					<%--<h4 style="margin-right:35px; margin-top: -15px;"><%= custJob.getName() + " (" + custJob.getCode() + ")"%></h4>--%>
				</div>
			</div>
		</div>

		<div id="footer">
			<span id="ph-no" style="margin-left:15px">770-446-2222</span>Electrical Cable Specialist    6680-C Jones Mill Court Norcross GA 30093
		</div>
		
		<div style="width:95%;">
			<h4>Received Shipments on <%= df.format(reportDay.getTime()) %></h4>
			<table style="width:100%;align:center;" cellpadding="3px" cellspacing="0">
				<th class="center">CRID #</th>
				<th class="center">Manufacturer</th>
				<th class="center">Reel Tag</th>
				<th class="center">Customer PN</th>
				<th class="center">ECS PO</th>
				<th class="center">Customer PO</th>
				<th class="center"># Reels Delivered</th>
				<th class="center"># Steel Reels Delivered</th>
				<th class="center">Description</th>

				<% for(int i=0; i<recievedOnDate.howMany(); i++) { %>
					<% Reel current = (Reel)recievedOnDate.get(i); %>
					<% if (i % 2 != 0) {%>
						<tr>
					<% } else { %>
						<tr style="background: #cccccc">
					<% } %>
						<td class="center"><%= current.getCrId() %></td>
						<td class="center"><%= current.getManufacturer() %></td>
						<td class="center"><%= current.getReelTag() %></td>
						<td class="center"><%= current.getCustomerPN() %></td>
						<td class="center"><%= current.getEcsPN() %></td>
						<td class="center"><%= current.getCustomerPO() %></td>
						<td class="center"><%= current.getReceivedQuantity() %></td>
						<td class="center"></td>
						<td class="center"><%= current.getCableDescription() %></td>
					</tr>
				<% } %>
			</table>
		</div>		

		<div style="width:95%;">
			<h4>Reel Checked OUT on <%= df.format(reportDay.getTime()) %></h4>
			<table style="width:100%;align:center;" cellpadding="3px" cellspacing="0">
				<th class="center">CRID #</th>
				<th class="center">Reel Tag</th>
				<th class="center">Customer P/N</th>
				<th class="center">Description</th>
				<th class="center">Top Ft. #</th>
				<th class="center">Foreman</th>

				<% for(int i=0; i<checkedOutOnDate.howMany(); i++) { %>
					<% Reel current = (Reel)checkedOutOnDate.get(i); %>
					<% PickList pickList = (PickList)current.getCompEntity(PickList.PARAM); %>
					<% ReelLog log = (ReelLog)current.getCompEntity(ReelLog.PARAM); %>
					<% if (i % 2 != 0) {%>
						<tr>
					<% } else { %>
						<tr style="background: #cccccc">
					<% } %>
						<td class="center"><%= current.getCrId() %></td>
						<td class="center"><%= current.getReelTag() %></td>
						<td class="center"><%= current.getCustomerPN() %></td>
						<td class="center"><%= current.getCableDescription() %></td>
						<td class="center"><%= log.getTopFoot() %></td>
						<td class="center"><% if(pickList!=null) { %><%= pickList.getForeman() %> <% } else { %>N/A<% } %></td>
					</tr>
				<% } %>
			</table>
		</div>

		<div style="width:95%;">
			<h4>Reel Checked IN on <%= df.format(reportDay.getTime()) %></h4>
			<table style="width:100%;align:center;" cellpadding="3px" cellspacing="0">
				<th style="border-bottom: none" class="center">CRID #</th>
				<th style="border-bottom: none" class="center">Reel Tag</th>
				<th style="border-bottom: none" class="center">Customer P/N</th>
				<th style="border-bottom: none" class="center">Description</th>
				<th class="center">Top Ft. #</th>
				<th style="border-bottom: none" class="center">Quantity</th>

				<tr>
					<th style="border-top: none" class="center"></th>
					<th style="border-top: none" class="center"></th>
					<th style="border-top: none" class="center"></th>
					<th class="center">New / Check Out</th>
					<th style="border-top: none" class="center"></th>
				</tr>
				<% for(int i=0; i<checkedInOnDate.howMany(); i++) { %>
					<% Reel current = (Reel)checkedInOnDate.get(i); %>
					<% ReelLog log = (ReelLog)current.getCompEntity(ReelLog.PARAM); %>
					<% CompEntities issues = current.getCompEntities(ReelIssue.PARAM); %>
					<% if (i % 2 != 0) {%>
						<tr>
					<% } else { %>
						<tr style="background: #cccccc">
					<% } %>
						<td class="center"><%= current.getCrId() %></td>
						<td class="center"><%= current.getReelTag() %></td>
						<td class="center"><%= current.getCustomerPN() %></td>
						<td class="center"><%= current.getCableDescription() %></td>
						<td class="center"><%= log.getTopFoot() %></td>
						<td class="center"><%= current.getOnReelQuantity() %></td>
					</tr>
					
					<% String notes = "Notes: "; %>
					<% for(int j=0; j<issues.howMany(); j++) { %>
						<% ReelIssue currentIssue = (ReelIssue)issues.get(j); %>
						<% if(j!=0) { %>
							<% notes+= "<br/>";%>
						<% } %>
						<% notes += currentIssue.getDescription() + ":" + currentIssue.getIssueLog(); %>
					<% } %>
					<% if(!notes.equals("Notes: ")) { %>
						<% if (i % 2 != 0) {%>
							<tr>
						<% } else { %>
							<tr style="background: #cccccc">
						<% } %>
							<td class="center"><%= notes %></td>
							</tr>
					<% } %>


				<% } %>
			</table>
		</div>

		<div style="width:95%;">
			<h4>Inventory Summary</h4>
			<table style="width:100%;align:center;" border="1px solid black" cellpadding="3px" cellspacing="0">
				<th colspan="7" class="center"><b>Reels</b></th>

				<tr>
					<th class="center">Delivered</th>
					<th class="center">In Warehouse<br/>Out</th>
					<th class="center">Checked OOUT</th>
					<th class="center">Steel Reels<br/>Delivery</th>
					<th class="center">Complete</th>
					<th class="center">Scrapped</th>
				</tr>

				<tr style="background: #cccccc">
					<% for(int i=0; i<reels.size(); i++) { %>
						<% if(i==3) { // kip steel reels blank for now %>
							<td class="center"></td>
						<% } else { %>
							<td class="center"><%= reels.get(i).toString() %></td>
						<% } %>
					<% } %>					
				</tr>
			</table>
		</div>
	</body>
</html>
