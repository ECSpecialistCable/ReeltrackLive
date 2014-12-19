<%@ page language="java" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.monumental.trampoline.component.*" %>
<%@ page import="com.monumental.trampoline.utilities.forms.multipart.*" %>
<%@ page import="com.monumental.trampoline.navigation.Navigation" %>
<%@ page import="com.monumental.trampoline.security.*" %>
<%@ page import="com.eps.reports.*" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import= "org.apache.poi.hssf.usermodel.*" %>
<%@ page import= "org.apache.poi.hssf.util.*" %>
<%@ page import="com.reeltrack.reports.ActionLogExcelReport"%>
<%@ page import="com.reeltrack.reports.CableDataDownloadExcelReport"%>
<%@ page import="com.reeltrack.reports.InventoryExcelReport"%>
<%@ page import="com.reeltrack.reports.CtrExcelReport"%>
<%@ page import="com.reeltrack.reports.InventorySummaryExcelReport"%>
<%@ page import="java.io.ByteArrayOutputStream"%>
<%@ page import="com.reeltrack.reports.HtmlToPdfWriter"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%@ taglib prefix="admin" tagdir="/WEB-INF/tags/admin"%>
<%@ taglib prefix="notifier" tagdir="/WEB-INF/tags/notifier"%>

<jsp:useBean id="dbResources" class="com.monumental.trampoline.datasources.DbResources" />
<jsp:useBean id="userLoginMgr" class="com.monumental.trampoline.security.UserLoginMgr" />

<% userLoginMgr.init(pageContext); %>
<% CompProperties props = new CompProperties(); %>
<%
String basePath = pageContext.getServletContext().getRealPath("/");
String contextPath = pageContext.getServletContext().getContextPath();
String notifier = "";
String redirect = request.getHeader("referer");
String action = "";

if(request.getParameter("submit_action") != null) {
    action = request.getParameter("submit_action");
}


if(action.equals("daily_report")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String reportOn = request.getParameter("daily_report_day");
		String jobCode = request.getParameter("job_code");

		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		String url = "http://" + request.getServerName() + ":" + request.getServerPort() + contextPath + "/trampoline/reports/daily_report_pdf.jsp?" + "daily_report_day=" + reportOn + "&job_code=" + jobCode;
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		output = writer.writePdf(basePath, url);

		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
		String fileName = "daily_report.pdf";
		saveFile += "/" + fileName;
		FileOutputStream fileOut = new FileOutputStream(saveFile);
		output.writeTo(fileOut);
		fileOut.flush();
		fileOut.close();
			    
    	param = "?dr=true";
	} catch(Exception e) {
		e.printStackTrace();
    }
	
	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}

if(action.equals("inventory_summary_report")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String reportType = request.getParameter("whichReport");
		String jobCode = request.getParameter("job_code");

		String fileName = "inventory_summary_report";
		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
		if(reportType.equalsIgnoreCase("Pdf")) {
			HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + contextPath + "/trampoline/reports/inventory_summary_report_pdf.jsp?job_code=" + jobCode;
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			output = writer.writePdf(basePath, url);
			fileName += ".pdf";
			saveFile += "/" + fileName;
			FileOutputStream fileOut = new FileOutputStream(saveFile);
			output.writeTo(fileOut);
			fileOut.flush();
			fileOut.close();
		} else if(reportType.equalsIgnoreCase("Excel")) {
			InventorySummaryExcelReport writer = new InventorySummaryExcelReport(pageContext, dbResources);
			HSSFWorkbook wb = writer.writeUserExcel(jobCode, basePath);
			fileName += ".xls";
			saveFile += "/" + fileName;
			FileOutputStream fileOut = new FileOutputStream(saveFile);
			wb.write(fileOut);
			fileOut.flush();
			fileOut.close();
		}

    	param = "?isr=true&inv_summary_type=" + reportType;
	} catch(Exception e) {
		e.printStackTrace();
    }

	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}

if(action.equals("inventory_report")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String reportType = request.getParameter("whichReport");
		String jobCode = request.getParameter("job_code");

		String fileName = "inventory_report";
		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
		if(reportType.equalsIgnoreCase("Pdf")) {
			HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + contextPath + "/trampoline/reports/inventory_report_pdf.jsp?job_code="+jobCode;
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			output = writer.writePdf(basePath, url);
			fileName += ".pdf";
			saveFile += "/" + fileName;
			FileOutputStream fileOut = new FileOutputStream(saveFile);
			output.writeTo(fileOut);
			fileOut.flush();
			fileOut.close();
		} else if(reportType.equalsIgnoreCase("Excel")) {
			InventoryExcelReport writer = new InventoryExcelReport(pageContext, dbResources);
			HSSFWorkbook wb = writer.writeUserExcel(jobCode, basePath);
			fileName += ".xls";
			saveFile += "/" + fileName;
			FileOutputStream fileOut = new FileOutputStream(saveFile);
			wb.write(fileOut);
			fileOut.flush();
			fileOut.close();
		}

    	param = "?ir=true&inv_type=" + reportType;
	} catch(Exception e) {
		e.printStackTrace();
    }

	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}

if(action.equals("ctr_report")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String jobCode = request.getParameter("job_code");

		String fileName = "ctr_report";
		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
        CtrExcelReport writer = new CtrExcelReport(pageContext, dbResources);
        HSSFWorkbook wb = writer.writeUserExcel(jobCode, basePath);
        fileName += ".xls";
        saveFile += "/" + fileName;
        FileOutputStream fileOut = new FileOutputStream(saveFile);
        wb.write(fileOut);
        fileOut.flush();
        fileOut.close();

    	param = "?ctr=true";
	} catch(Exception e) {
		e.printStackTrace();
    }

	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}

if(action.equals("period_report")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String startDate = request.getParameter("period_report_start_date");
		String endDate = request.getParameter("period_report_end_date");
		String jobCode = request.getParameter("job_code");

		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		String url = "http://" + request.getServerName() + ":" + request.getServerPort() + contextPath + "/trampoline/reports/period_report_pdf.jsp?" + "period_report_start_date=" + startDate + "&period_report_end_date=" + endDate + "&job_code=" + jobCode;
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		output = writer.writePdf(basePath, url);

		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
		String fileName = "period_report.pdf";
		saveFile += "/" + fileName;
		FileOutputStream fileOut = new FileOutputStream(saveFile);
		output.writeTo(fileOut);
		fileOut.flush();
		fileOut.close();

    	param = "?pr=true";
	} catch(Exception e) {
		e.printStackTrace();
    }

	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}

if(action.equals("steel_reel_report")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String startDate = request.getParameter("steel_reel_report_start_date");
		String endDate = request.getParameter("steel_reel_report_end_date");
		String jobCode = request.getParameter("job_code");

		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		String url = "http://" + request.getServerName() + ":" + request.getServerPort() + contextPath + "/trampoline/reports/steel_reel_report_pdf.jsp?" + "steel_reel_report_start_date=" + startDate + "&steel_reel_report_end_date=" + endDate + "&job_code=" + jobCode;
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		output = writer.writePdf(basePath, url);

		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
		String fileName = "steel_reel_report.pdf";
		saveFile += "/" + fileName;
		FileOutputStream fileOut = new FileOutputStream(saveFile);
		output.writeTo(fileOut);
		fileOut.flush();
		fileOut.close();

    	param = "?sr=true";
	} catch(Exception e) {
		e.printStackTrace();
    }

	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}

if(action.equals("action_log_report")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String startDate = request.getParameter("action_log_report_start_date");
		String endDate = request.getParameter("action_log_report_end_date");
		String jobCode = request.getParameter("job_code");

		ActionLogExcelReport writer = new ActionLogExcelReport(pageContext, dbResources);
		HSSFWorkbook wb = writer.writeUserExcel(jobCode, startDate, endDate, basePath);
		String fileName = "action_log_report.xls";
		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
		saveFile += "/" + fileName;
		FileOutputStream fileOut = new FileOutputStream(saveFile);
		wb.write(fileOut);
		fileOut.flush();
		fileOut.close();

    	param = "?alr=true";
	} catch(Exception e) {
		e.printStackTrace();
    }

	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}

if(action.equals("cable_data_download")){
    String param = "";
	try {
		//change functionality show we could download and view excel on ipad
		String jobCode = request.getParameter("job_code");
		String fileName = "cable_data_download";
		String saveFile = basePath + "/reports";
		File file = new File(saveFile);
		file.mkdirs();
        CableDataDownloadExcelReport writer = new CableDataDownloadExcelReport(pageContext, dbResources);
        HSSFWorkbook wb = writer.writeExcel(jobCode, basePath);
        fileName += ".xls";
        saveFile += "/" + fileName;
        FileOutputStream fileOut = new FileOutputStream(saveFile);
        wb.write(fileOut);
        fileOut.flush();
        fileOut.close();

    	param = "?cdd=true";
	} catch(Exception e) {
		e.printStackTrace();
    }

	redirect = request.getContextPath() + "/trampoline/" + "reports/reports.jsp" + param;
}
%>
<% dbResources.close(); %>
<admin:ajax_redirect redirect="<%= redirect %>" />
