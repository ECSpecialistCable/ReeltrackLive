<?xml version="1.0" encoding="UTF-8"?>
<%@ page language="java" %>

<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.monumental.trampoline.component.CompEntities"%>

<%@ page import="com.reeltrack.users.*" %>
<%@ page import="com.reeltrack.customers.*" %>
<%@ page import="com.reeltrack.reels.*" %>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.reeltrack.users.RTUserLoginMgr"/>
<jsp:useBean id="customerMgr" class="com.reeltrack.customers.CustomerMgr" />
<jsp:useBean id="reportMgr" class="com.reeltrack.reports.ReportMgr" />

<% userLoginMgr.init(pageContext, dbResources); %>
<% customerMgr.init(pageContext,dbResources); %>
<% reportMgr.init(pageContext,dbResources); %>
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
	CompEntities reels = reportMgr.getReelsForInventoryReport(reel);
%>
<% dbResources.close(); %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
 <head>
    <title>Reports</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
	<link href="<%= this.getServletContext().getRealPath("/trampoline/reports/pdfStyle.css") %>" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" type="text/css" href="<%= this.getServletContext().getRealPath("/trampoline/reports/alice.css") %>" media="print"/>
 </head>
 <body>

	  <div id="header">
		<div id="date" style="margin-right:35px"><%= generatedDtFmt.format(new Date()) + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Page# " %><span id="pagenumber"></span></div>
		<div>
		  <div id="logo" style="margin-left:15px; margin-right: 15px"><img alt="logo"   src="<%= this.getServletContext().getRealPath("/trampoline/common/images/logo.png") %>" />
		  </div>
		  <div id="jobName">
				<h3 style="margin-right:35px">Inventory Report</h3>
				<h4 style="margin-right:35px; margin-top: -15px;"><%= custJob.getName() + " (" + custJob.getCode() + ")" %></h4>
		  </div>
		</div>
	  </div>

	  <div id="footer">
		 <span id="ph-no" style="margin-left:15px">770-446-2222</span>Electrical Cable Specialist    6680-C Jones Mill Court Norcross GA 30093
	 </div>
		  
	  <div style="width:95%;">		
		<h4>Inventory Summary</h4>
		<table style="width:100%;align:center;" cellpadding="3px" cellspacing="0">
			<th class="center">Reel Tag</th>
			<th class="center">Status</th>
			<th class="center">WH<br/>Location</th>
			<th class="center">Current Qty</th>
			<th class="center">Steel Reel<br/>Serial #</th>
			<th class="center">Manufacturer</th>

			<% reels.sortByMethodName("getCustomerPN", true, true); %>
			<% reels.sortByMethodName("getReelTag", true, false); %>
			<% String preCustPN = "prevCustPN";%>
			<% for(int i=0;i<reels.howMany();i++) { %>
				<% Reel current = (Reel)reels.get(i); %>
				<% if(!preCustPN.equals(current.getCustomerPN())) { %>
					<% System.out.println("new customer pn "+current.getCustomerPN()); %>
					<% preCustPN = current.getCustomerPN(); %>
					<tr align="middle">
						<td class="center" colspan="6">Customer P/N - <%= current.getCustomerPN() %></td>
					</tr>
				<% } %>
				<% if(i%2!=0) { %>
					<tr align="middle">
				<% } else { %>
					<tr align="middle" style="background-color: #cccccc">
				<% } %>
						<td class="center"><%= current.getReelTag() %></td>
						<td class="center"><%= current.getStatus() %></td>
						<td class="center"><%= current.getWharehouseLocation() %></td>
						<td class="center"><%= current.getOnReelQuantity() %></td>
						<td class="center"><%= current.getSteelReelSerial() %></td>
						<td class="center"><%= current.getManufacturer() %></td>
					</tr>
			<% } %>
		</table>				 		
	 </div>
 </body>
</html>
