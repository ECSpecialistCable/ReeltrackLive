package com.reeltrack.reports;

import com.monumental.trampoline.component.CompEntities;
import com.monumental.trampoline.security.User;
import com.monumental.trampoline.security.UserLoginMgr;

import com.monumental.trampoline.datasources.DbResources;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.ss.usermodel.*;

import javax.servlet.jsp.PageContext;

import com.reeltrack.customers.CustomerJob;
import com.reeltrack.customers.CustomerMgr;
import com.reeltrack.reels.Reel;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Set;

public class InventorySummaryExcelReport {

	CustomerMgr customerMgr;
	ReportMgr reportMgr;
	UserLoginMgr umgr;
	CellStyle styleBold;
	CellStyle styleBoldRight;
	CellStyle styleHeader;
	    
    public InventorySummaryExcelReport(PageContext pageContext, DbResources resources) {
		customerMgr = new CustomerMgr();
		customerMgr.init(pageContext, resources);

		reportMgr = new ReportMgr();
		reportMgr.init(pageContext, resources);
		
		umgr = new UserLoginMgr();
		umgr.init(pageContext, resources);
	}
	
	public HSSFWorkbook writeUserExcel(String jobCode, String basePath) throws Exception {
		SimpleDateFormat generatedDtFmt = new SimpleDateFormat("EEEEE, MMMMM dd, yyyy");
		CustomerJob custJob = new CustomerJob();
		custJob.setCode(jobCode);
		custJob.setSearchOp(CustomerJob.CODE_COLUMN, CustomerJob.EQ);
		custJob = customerMgr.getCustomerJob(custJob);

		Reel reel = new Reel();
		reel.setJobCode(jobCode);
		reel.setSearchOp(Reel.JOB_CODE_COLUMN, Reel.EQ);
		LinkedHashMap<String, ArrayList<Integer>> contents = reportMgr.getPNInfoForInventorySummaryReport(reel);
		Set<String> keys = contents.keySet();

		int maxSearch = 200;
		int skip = 0;
		
		// Begin by setting up the headers 
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Inventory Summary");
		HSSFRow row;
		HSSFCell cell;
		
		// Set up Cell Styles
		HSSFCellStyle wrapStyle = wb.createCellStyle();
    	wrapStyle.setWrapText(true);
		this.setupStyles(wb);
		
		int rowNum = 0;
		int nextNum = 0;

		// Add the logo
		try {
			HSSFPatriarch patriarch = sheet.createDrawingPatriarch();
			File logoFile = new File(basePath + "trampoline/common/images/logo.png");
			long length = logoFile.length();
			byte[] picData = new byte[(int)length];

			FileInputStream picIn = new FileInputStream( logoFile );
			picIn.read( picData );

			int indx = wb.addPicture(picData,HSSFWorkbook.PICTURE_TYPE_JPEG);

			HSSFClientAnchor anchor = new HSSFClientAnchor(10, 0, 700, 170, (short)0, 1, (short)0, 2);
			anchor.setAnchorType( 2 );
			patriarch.createPicture( anchor, indx );

			picIn.close();
		} catch(Exception e) {
			e.printStackTrace();
		}

		nextNum=7;
		row = sheet.createRow((short) rowNum);
		row.setHeightInPoints(15);
		cell = row.createCell((short) nextNum);
		cell.setCellValue(generatedDtFmt.format(new Date()));
		cell.setCellStyle(styleBoldRight);
		CellRangeAddress addr = new CellRangeAddress(rowNum, rowNum, nextNum, nextNum+2);
		sheet.addMergedRegion(addr);
	
		rowNum++;
		row = sheet.createRow((short) rowNum);
		nextNum=7;
		row.setHeightInPoints(30);
		cell = row.createCell((short) nextNum);
		cell.setCellValue("Inventory Summary \n"+custJob.getName() + " (" + custJob.getCode() + ")");
		cell.setCellStyle(styleBoldRight);
		addr = new CellRangeAddress(rowNum, rowNum+1, nextNum, nextNum+2);
		sheet.addMergedRegion(addr);

		rowNum++; rowNum++;rowNum++;
		
		
		nextNum=0;
		row = sheet.createRow((short) rowNum);
		cell = row.createCell((short) nextNum+1);
		cell.setCellValue("Total Quantity");
		cell.setCellStyle(styleHeader);
		addr = new CellRangeAddress(rowNum, rowNum, nextNum+1, nextNum+7);
		sheet.addMergedRegion(addr);

		cell = row.createCell((short) nextNum+8);
		cell.setCellValue("Number of Reels");
		cell.setCellStyle(styleHeader);
		addr = new CellRangeAddress(rowNum, rowNum, nextNum+8, nextNum+9);
		sheet.addMergedRegion(addr);
		
		rowNum++;
		nextNum=0;
		row = sheet.createRow((short) rowNum++);
		cell = row.createCell((short) nextNum++);
		sheet.setColumnWidth(nextNum-1, 10000);
		cell.setCellValue("Cust P/N");
		cell.setCellStyle(styleHeader);

		/*
		nextNum++;
		cell = row.createCell((short) nextNum);
		cell.setCellValue("Total Quantity");
		cell.setCellStyle(styleHeader);
		addr = new CellRangeAddress(rowNum-1, rowNum-1, nextNum, nextNum+4);
		sheet.addMergedRegion(addr);
		*/
		/*
		nextNum=nextNum+4;
		cell = row.createCell((short) nextNum);
		cell.setCellValue("Number of Reels");
		cell.setCellStyle(styleHeader);
		addr = new CellRangeAddress(rowNum-1, rowNum-1, nextNum, nextNum+1);
		sheet.addMergedRegion(addr);
		*/

		//row = sheet.createRow((short) rowNum++);
		//row.setHeightInPoints(45);
		//ep scheduled header
		//nextNum = 1;
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Ordered");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Shipped");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Received");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Unreceived");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("In Inventory");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Checked OUT");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("On Complete Reels");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("In Inventory");
		cell.setCellStyle(styleHeader);

		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Checked OUT");
		cell.setCellStyle(styleHeader);
		
		for (String customerPN : keys) {
			ArrayList<Integer> values = contents.get(customerPN);
			row = sheet.createRow((short) rowNum++);
			nextNum=0;
			//sheet.setColumnWidth(0, 5000);
			row.createCell((short)nextNum++).setCellValue(customerPN);
			for (int k = 0; k < values.size(); k++) {
				row.createCell((short)nextNum++).setCellValue(values.get(k));
				sheet.setColumnWidth(nextNum-1, 2500);
			}
		}

		return wb;
		
	}

	public void setupStyles(Workbook wb) {
		// Bold style
		Font boldFont = wb.createFont();
    	boldFont.setBoldweight(Font.BOLDWEIGHT_BOLD);
		styleBold = wb.createCellStyle();
		styleBold.setFont(boldFont);
		
		styleHeader = wb.createCellStyle();
		styleHeader.setFillForegroundColor(new HSSFColor.GREY_25_PERCENT().getIndex());
		styleHeader.setFillPattern(CellStyle.SOLID_FOREGROUND);
		styleHeader.setFont(boldFont);
		styleHeader.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		styleHeader.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		styleHeader.setWrapText(true);
		/*styleHeader.setBorderBottom(CellStyle.BORDER_THIN);
    	styleHeader.setBottomBorderColor(new HSSFColor.BLACK().getIndex());
		styleHeader.setBorderTop(CellStyle.BORDER_THIN);
    	styleHeader.setTopBorderColor(new HSSFColor.BLACK().getIndex());
		styleHeader.setBorderLeft(CellStyle.BORDER_THIN);
    	styleHeader.setLeftBorderColor(new HSSFColor.BLACK().getIndex());
		styleHeader.setBorderRight(CellStyle.BORDER_THIN);
    	styleHeader.setRightBorderColor(new HSSFColor.BLACK().getIndex());
		*/
		styleBoldRight = wb.createCellStyle();
		styleBoldRight.setFont(boldFont);
		styleBoldRight.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	}
}