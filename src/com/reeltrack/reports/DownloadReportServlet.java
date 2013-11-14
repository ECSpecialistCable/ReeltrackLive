package com.reeltrack.reports;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.*;

import com.monumental.trampoline.datasources.*;
import com.reeltrack.users.RTUser;
import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.PageContext;

public class DownloadReportServlet extends HttpServlet {

	public void init() throws ServletException {
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		String reportType = request.getParameter("reportType");

		if (reportType != null && reportType.equals("daily_report")) {
			this.downloadDailyReport(request, response, request.getParameter("daily_report_day"));

		} else if (reportType != null && reportType.equals("inventory_summary")) {
			this.downloadInventorySummary(request, response, request.getParameter("job_code"));

		} else if (reportType != null && reportType.equals("inventory_report")) {
			this.downloadInventoryReport(request, response, request.getParameter("job_code"));

		} else if (reportType != null && reportType.equals("period_report")) {
			this.downloadPeriodReport(request, response, request.getParameter("period_report_start_date"), request.getParameter("period_report_end_date"));

		} else if (reportType != null && reportType.equals("steel_reel_report")) {
			this.downloadSteelReelReport(request, response, request.getParameter("steel_reel_report_start_date"), request.getParameter("steel_reel_report_end_date"));
			
		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) {
		this.doPost(request, response);
	}

	private void downloadDailyReport(HttpServletRequest request, HttpServletResponse response, String reportOn) {
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/daily_report_pdf.jsp?" + "daily_report_day=" + reportOn;

			ByteArrayOutputStream output = new ByteArrayOutputStream();
			output = writer.writePdf(basePath, url);

			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "attachment; filename=\"daily_report_"  + reportOn.replaceAll("/", "") + ".pdf\"");

			ServletOutputStream os = response.getOutputStream();
			try {

				output.writeTo(os);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				output.flush();
				os.flush();
				output.close();
				os.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbResources.close();
		}
	}

	private void downloadInventorySummary(HttpServletRequest request, HttpServletResponse response, String jobCode) {
		Date today = new Date();
		SimpleDateFormat df = new SimpleDateFormat("MMddyyyy");
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);

		
		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/inventory_summary_report_pdf.jsp?job_code=" + jobCode;

			ByteArrayOutputStream output = new ByteArrayOutputStream();
			output = writer.writePdf(basePath, url);

			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "attachment; filename=\"inventory_summary_report_" + df.format(today) + ".pdf\"");

			ServletOutputStream os = response.getOutputStream();
			try {

				output.writeTo(os);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				output.flush();
				os.flush();
				output.close();
				os.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbResources.close();
		}
	}

	private void downloadInventoryReport(HttpServletRequest request, HttpServletResponse response, String jobCode) {
		Date today = new Date();
		SimpleDateFormat df = new SimpleDateFormat("MMddyyyy");
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);

		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/inventory_report_pdf.jsp?job_code="+jobCode;

			ByteArrayOutputStream output = new ByteArrayOutputStream();
			output = writer.writePdf(basePath, url);

			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "attachment; filename=\"inventory_report_" + df.format(today) + ".pdf\"");

			ServletOutputStream os = response.getOutputStream();
			try {

				output.writeTo(os);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				output.flush();
				os.flush();
				output.close();
				os.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbResources.close();
		}
	}

	private void downloadPeriodReport(HttpServletRequest request, HttpServletResponse response, String startDate, String endDate) {
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/period_report_pdf.jsp?" + "period_report_start_date=" + startDate + "&period_report_end_date=" + endDate;

			ByteArrayOutputStream output = new ByteArrayOutputStream();
			output = writer.writePdf(basePath, url);

			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "attachment; filename=\"period_report_"  + startDate.replaceAll("/", "") + "_" + endDate.replaceAll("/", "") + ".pdf\"");

			ServletOutputStream os = response.getOutputStream();
			try {

				output.writeTo(os);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				output.flush();
				os.flush();
				output.close();
				os.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbResources.close();
		}
	}

	private void downloadSteelReelReport(HttpServletRequest request, HttpServletResponse response, String startDate, String endDate) {
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/steel_reel_report_pdf.jsp?" + "steel_reel_report_start_date=" + startDate + "&steel_reel_report_end_date=" + endDate;

			ByteArrayOutputStream output = new ByteArrayOutputStream();
			output = writer.writePdf(basePath, url);

			response.setContentType("application/pdf");
			response.setHeader("Content-Disposition", "attachment; filename=\"steel_reel_report_"  + startDate.replaceAll("/", "") + "_" + endDate.replaceAll("/", "") + ".pdf\"");

			ServletOutputStream os = response.getOutputStream();
			try {

				output.writeTo(os);
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				output.flush();
				os.flush();
				output.close();
				os.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			dbResources.close();
		}
	}

	public void destroy() {
	}
}