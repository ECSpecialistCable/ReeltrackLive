<?xml version="1.0" encoding="UTF-8"?>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.GregorianCalendar"%>
<%@ page language="java" %>

<%
	SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
	GregorianCalendar reportDay = new GregorianCalendar();
	if(request.getParameter("daily_report_day")!=null && !request.getParameter("daily_report_day").equals("")) {
		reportDay.setTime(df.parse(request.getParameter("daily_report_day")));

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
	 <h1>Daily Report on <%= df.format(reportDay.getTime()) %></h1>
 </body>
</html>
