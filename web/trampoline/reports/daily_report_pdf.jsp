<?xml version="1.0" encoding="UTF-8"?>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.GregorianCalendar"%>
<%@ page language="java" %>

<%
SimpleDateFormat generatedDtFmt = new SimpleDateFormat("EEEEE, MMMMM dd, yyyy");

	SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
	GregorianCalendar reportDay = new GregorianCalendar();
	if(request.getParameter("daily_report_day")!=null && !request.getParameter("daily_report_day").equals("")) {
		reportDay.setTime(df.parse(request.getParameter("daily_report_day")));
	}

%>
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
					<h3 style="margin-right:35px">Daily Report</h3>
					<h4 style="margin-right:35px; margin-top: -15px;"><%= custJob.getName() + " (" + custJob.getCode() + ")"%></h4>
				</div>
			</div>
		</div>

		<div id="footer">
			<span id="ph-no" style="margin-left:15px">770-446-2222</span>Electrical Cable Specialist    6680-C Jones Mill Court Norcross GA 30093
		</div>

		<div style="width:95%;">
			<h4>Received Shipments on <%= generatedDtFmt.format(new Date()) %></h4>
			<table style="width:100%;align:center;" cellpadding="3px" cellspacing="0">
				<th class="center">Manufacturer</th>
				<th class="center">ECS PO</th>
				<th class="center">Customer PO</th>
				<th class="center"># Reels Delivered</th>
				<th class="center"># Steel Reels Delivered</th>

				<% reels.sortByMethodName("getCustomerPN", true, true);%>
				<% reels.sortByMethodName("getReelTag", true, false);%>
				<% String preCustPN = "prevCustPN";%>
				<% for (int i = 0; i < reels.howMany(); i++) {%>
				<% Reel current = (Reel) reels.get(i);%>
				<% if (!preCustPN.equals(current.getCustomerPN())) {%>
				<% System.out.println("new customer pn " + current.getCustomerPN());%>
				<% preCustPN = current.getCustomerPN();%>
				<% }%>
				<% if (i % 2 != 0) {%>
				<tr align="middle">
					<% } else {%>
					<tr align="middle" style="background-color: #cccccc">
						<% }%>
						<td class="center"><%= current.getReelTag()%></td>
						<td class="center"><%= current.getStatus()%></td>
						<td class="center"><%= current.getWharehouseLocation()%></td>
						<td class="center"><%= current.getOnReelQuantity()%></td>
						<td class="center"><%= current.getSteelReelSerial()%></td>
						<td class="center"><%= current.getManufacturer()%></td>
					</tr>
					<% }%>
			</table>
		</div>
	</body>
</html>
