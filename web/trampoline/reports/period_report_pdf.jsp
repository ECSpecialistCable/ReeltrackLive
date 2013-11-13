<?xml version="1.0" encoding="UTF-8"?>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.GregorianCalendar"%>
<%@ page language="java" %>

<%
	SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
	GregorianCalendar startDate = new GregorianCalendar();
	GregorianCalendar endDate = new GregorianCalendar();
	if(request.getParameter("period_report_start_date")!=null && !request.getParameter("period_report_start_date").equals("") &&
			request.getParameter("period_report_end_date")!=null && !request.getParameter("period_report_end_date").equals("")) {
		startDate.setTime(df.parse(request.getParameter("period_report_start_date")));
		endDate.setTime(df.parse(request.getParameter("period_report_end_date")));

	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
 <head>
    <title>Reports</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
 </head>
 <body>
	 <h1>Period Report for <%= df.format(startDate.getTime()) %> -  <%= df.format(endDate.getTime()) %></h1>
 </body>
</html>
