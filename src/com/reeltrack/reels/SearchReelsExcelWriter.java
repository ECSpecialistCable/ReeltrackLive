package com.reeltrack.reels;

import com.reeltrack.reports.*;
import com.monumental.trampoline.component.CompEntities;
import com.monumental.trampoline.security.User;
import com.monumental.trampoline.security.UserLoginMgr;

import com.monumental.trampoline.datasources.DbResources;
import com.monumental.trampoline.utilities.text.TextParser;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.ss.usermodel.*;

import javax.servlet.jsp.PageContext;

import com.reeltrack.customers.CustomerJob;
import com.reeltrack.customers.CustomerMgr;
import com.reeltrack.reels.Reel;
import com.reeltrack.reels.ReelLog;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.LinkedHashMap;
import java.util.Set;

public class SearchReelsExcelWriter {

	CustomerMgr customerMgr;
	UserLoginMgr umgr;
	ReelMgr reelMgr; 
	CellStyle styleBold;
	CellStyle styleBoldRight;
	CellStyle styleHeader;
	    
    public SearchReelsExcelWriter(PageContext pageContext, DbResources resources) {
		customerMgr = new CustomerMgr();
		customerMgr.init(pageContext, resources);

		umgr = new UserLoginMgr();
		umgr.init(pageContext, resources);

		reelMgr = new ReelMgr();
		reelMgr.init(pageContext, resources);
	}
	
	public HSSFWorkbook writeUserExcel(String jobCode, Reel content, String basePath) throws Exception {
		String column = Reel.REEL_TAG_COLUMN;
		boolean ascending = true;
		int count = reelMgr.searchReelsCount(content, column, ascending);
		CompEntities contents = reelMgr.searchReels(content, column, ascending, 0, 0);



		// Begin by setting up the headers
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Reels");
		HSSFRow row;
		HSSFCell cell;
		
		// Set up Cell Styles
		HSSFCellStyle wrapStyle = wb.createCellStyle();
    	wrapStyle.setWrapText(true);
		this.setupStyles(wb);
		
		int rowNum = 0;
		int nextNum = 0;

		row = sheet.createRow((short) rowNum);
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Customer P/N");
		cell.setCellStyle(styleHeader);

		sheet.setColumnWidth(nextNum, 5000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Cable Description");
		cell.setCellStyle(styleHeader);

		sheet.setColumnWidth(nextNum, 3000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("CRID#");
		cell.setCellStyle(styleHeader);

		sheet.setColumnWidth(nextNum, 5000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Reel Tag");
		cell.setCellStyle(styleHeader);

		sheet.setColumnWidth(nextNum, 5000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Unique ID");
		cell.setCellStyle(styleHeader);

		
		rowNum++;
		for (int i = 0; i < contents.howMany(); i++) {
			Reel current = (Reel) contents.get(i);
			row = sheet.createRow((short) rowNum++);
			nextNum=0;
			row.createCell((short)nextNum++).setCellValue(current.getCustomerPN());
			row.createCell((short)nextNum++).setCellValue(current.getCableDescription());
			row.createCell((short)nextNum++).setCellValue(new Integer(current.getCrId()).toString());
			row.createCell((short)nextNum++).setCellValue(current.getReelTag());
			row.createCell((short)nextNum++).setCellValue(new Integer(current.getUniqueId()).toString());
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
		styleHeader.setFillForegroundColor(new HSSFColor.GREY_50_PERCENT().getIndex());
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