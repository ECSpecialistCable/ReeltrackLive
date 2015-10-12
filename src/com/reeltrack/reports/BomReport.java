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
import com.reeltrack.reels.*;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Set;

public class BomReport {

	CustomerMgr customerMgr;
	ReportMgr reportMgr;
	ReelMgr reelMgr;
	UserLoginMgr umgr;
	CellStyle styleBold;
	CellStyle styleBoldRight;
	CellStyle styleHeader;
	    
    public BomReport(PageContext pageContext, DbResources resources) {
		customerMgr = new CustomerMgr();
		customerMgr.init(pageContext, resources);

		reportMgr = new ReportMgr();
		reportMgr.init(pageContext, resources);

		reelMgr = new ReelMgr();
		reelMgr.init(pageContext, resources);
		
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
		CompEntities reels = reelMgr.getReelsDataForBOM(jobCode);
		
		// Begin by setting up the headers 
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Bill of Materials");
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

			HSSFClientAnchor anchor = new HSSFClientAnchor(10, 0, 500, 170, (short)0, 1, (short)0, 2);
			anchor.setAnchorType( 2 );
			patriarch.createPicture( anchor, indx );

			picIn.close();
		} catch(Exception e) {
			e.printStackTrace();
		}

		nextNum=1;
		row = sheet.createRow((short) rowNum);
		row.setHeightInPoints(15);
		cell = row.createCell((short) nextNum);
		cell.setCellValue(generatedDtFmt.format(new Date()));
		cell.setCellStyle(styleBoldRight);
		CellRangeAddress addr = new CellRangeAddress(rowNum, rowNum, nextNum, nextNum+2);
		sheet.addMergedRegion(addr);
	
		rowNum++;
		row = sheet.createRow((short) rowNum);
		nextNum=1;
		row.setHeightInPoints(15);
		cell = row.createCell((short) nextNum);
		cell.setCellValue("Bill of Materials \n"+custJob.getName() + " (" + custJob.getCode() + ")");
		cell.setCellStyle(styleBoldRight);
		addr = new CellRangeAddress(rowNum, rowNum+1, nextNum, nextNum+2);
		sheet.addMergedRegion(addr);

		rowNum++;rowNum++;rowNum++;
		row = sheet.createRow((short) rowNum++);
		row.setHeightInPoints(45);
		//ep scheduled header
		nextNum = 0;
		sheet.setColumnWidth(nextNum, 9000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Cust P/N");
		cell.setCellStyle(styleHeader);

		sheet.setColumnWidth(nextNum, 9000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Description");
		cell.setCellStyle(styleHeader);

		sheet.setColumnWidth(nextNum, 3000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Qty Ordered");
		cell.setCellStyle(styleHeader);

		sheet.setColumnWidth(nextNum, 3000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("# Reels");
		cell.setCellStyle(styleHeader);
		
		for (int i = 0; i < reels.howMany(); i++) {
			Reel current = (Reel) reels.get(i);
			row = sheet.createRow((short) rowNum++);
			nextNum=0;
			row.createCell((short)nextNum++).setCellValue(current.getCustomerPN());
			row.createCell((short)nextNum++).setCellValue(current.getCableDescription());
			row.createCell((short)nextNum++).setCellValue(current.getReelsOrderedForBOM());
			row.createCell((short)nextNum++).setCellValue(current.getReelsCountForBOM());
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