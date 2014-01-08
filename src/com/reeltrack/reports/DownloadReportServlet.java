package com.reeltrack.reports;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.*;

import com.monumental.trampoline.datasources.*;
import java.io.ByteArrayOutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.jsp.JspFactory;
import javax.servlet.jsp.PageContext;
import org.apache.poi.hssf.usermodel.*;

public class DownloadReportServlet extends HttpServlet {

	public void init() throws ServletException {
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) {
		String reportType = request.getParameter("reportType");

		if (reportType != null && reportType.equals("daily_report")) {
			this.downloadDailyReport(request, response, request.getParameter("daily_report_day"), request.getParameter("job_code"));

		} else if (reportType != null && reportType.equals("inventory_summary")) {
			if(request.getParameter("whichReport").equalsIgnoreCase("Pdf")) {
				this.downloadInventorySummary(request, response, request.getParameter("job_code"));
			} else if(request.getParameter("whichReport").equalsIgnoreCase("Excel")) {
				this.downloadInventorySummaryExcel(request, response, request.getParameter("job_code"));
			}

		} else if (reportType != null && reportType.equals("inventory_report")) {
			if(request.getParameter("whichReport").equalsIgnoreCase("Pdf")) {
				this.downloadInventoryReport(request, response, request.getParameter("job_code"));
			} else if(request.getParameter("whichReport").equalsIgnoreCase("Excel")) {
				this.downloadInventoryReportExcel(request, response, request.getParameter("job_code"));
			}

		} else if (reportType != null && reportType.equals("period_report")) {
			this.downloadPeriodReport(request, response, request.getParameter("period_report_start_date"), request.getParameter("period_report_end_date"), request.getParameter("job_code"));

		} else if (reportType != null && reportType.equals("steel_reel_report")) {
			this.downloadSteelReelReport(request, response, request.getParameter("steel_reel_report_start_date"), request.getParameter("steel_reel_report_end_date"), request.getParameter("job_code"));
			
		} else if (reportType != null && reportType.equals("action_log_report")) {
			this.downloadActionLogReportExcel(request, response, request.getParameter("action_log_report_start_date"), request.getParameter("action_log_report_end_date"), request.getParameter("job_code"));

		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) {
		this.doPost(request, response);
	}

	private void downloadDailyReport(HttpServletRequest request, HttpServletResponse response, String reportOn, String jobCode) {
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/daily_report_pdf.jsp?" + "daily_report_day=" + reportOn + "&job_code=" + jobCode;

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

	private void downloadInventorySummaryExcel(HttpServletRequest request, HttpServletResponse response, String jobCode) {
		Date today = new Date();
		SimpleDateFormat df = new SimpleDateFormat("MMddyyyy");
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		InventorySummaryExcelReport writer = new InventorySummaryExcelReport(pageContext, dbResources);

		try {
			HSSFWorkbook wb = writer.writeUserExcel(jobCode, getServletContext().getRealPath("/"));

	        ServletOutputStream op = response.getOutputStream();
	        ServletContext context  = getServletConfig().getServletContext();
	        //String mimetype = context.getMimeType(filename);

			// Set the Respnse
	        response.setContentType("application/octet-stream");
			response.setHeader( "Content-Disposition", "attachment; filename=\"inventory_summary_report_" + df.format(today) +".xls\"" );

	        // Stream
			try {
	        	wb.write(op);
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
	        	op.flush();
	        	op.close();
				wb = null;
			}
		} catch(Exception e) {
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

	private void downloadInventoryReportExcel(HttpServletRequest request, HttpServletResponse response, String jobCode) {
		Date today = new Date();
		SimpleDateFormat df = new SimpleDateFormat("MMddyyyy");
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		InventoryExcelReport writer = new InventoryExcelReport(pageContext, dbResources);

		try {
			HSSFWorkbook wb = writer.writeUserExcel(jobCode, getServletContext().getRealPath("/"));

	        ServletOutputStream op = response.getOutputStream();
	        ServletContext context  = getServletConfig().getServletContext();
	        //String mimetype = context.getMimeType(filename);

			// Set the Respnse
	        response.setContentType("application/octet-stream");
			response.setHeader( "Content-Disposition", "attachment; filename=\"inventory_report_" + df.format(today) +".xls\"" );

	        // Stream
			try {
	        	wb.write(op);
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
	        	op.flush();
	        	op.close();
				wb = null;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			dbResources.close();
		}	
	}

	private void downloadPeriodReport(HttpServletRequest request, HttpServletResponse response, String startDate, String endDate, String jobCode) {
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/period_report_pdf.jsp?" + "period_report_start_date=" + startDate + "&period_report_end_date=" + endDate + "&job_code=" + jobCode;

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

	private void downloadSteelReelReport(HttpServletRequest request, HttpServletResponse response, String startDate, String endDate, String jobCode) {
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, dbResources);
		try {
			String basePath = this.getServletContext().getRealPath("/");
			String url = "http://" + request.getServerName() + ":" + request.getServerPort() + this.getServletContext().getContextPath() + "/trampoline/reports/steel_reel_report_pdf.jsp?" + "steel_reel_report_start_date=" + startDate + "&steel_reel_report_end_date=" + endDate + "&job_code=" + jobCode;

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

	private void downloadActionLogReportExcel(HttpServletRequest request, HttpServletResponse response, String startDate, String endDate, String jobCode) {
		Date today = new Date();
		SimpleDateFormat df = new SimpleDateFormat("MMddyyyy");
		DbResources dbResources = new DbResources();
		JspFactory factory = JspFactory.getDefaultFactory();
		PageContext pageContext = factory.getPageContext(this, request, response, null, true, 0, true);
		ActionLogExcelReport writer = new ActionLogExcelReport(pageContext, dbResources);

		try {
			HSSFWorkbook wb = writer.writeUserExcel(jobCode, startDate, endDate, getServletContext().getRealPath("/"));

	        ServletOutputStream op = response.getOutputStream();
	        ServletContext context  = getServletConfig().getServletContext();
	        //String mimetype = context.getMimeType(filename);

			// Set the Respnse
	        response.setContentType("application/octet-stream");
			response.setHeader( "Content-Disposition", "attachment; filename=\"action_log_report_" + df.format(today) +".xls\"" );

	        // Stream
			try {
	        	wb.write(op);
			} catch(Exception e) {
				e.printStackTrace();
			} finally {
	        	op.flush();
	        	op.close();
				wb = null;
			}
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			dbResources.close();
		}
	}

	public void destroy() {
	}
}
