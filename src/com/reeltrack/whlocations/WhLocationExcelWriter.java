package com.reeltrack.whlocations;

import com.monumental.trampoline.component.CompEntities;
import com.monumental.trampoline.security.UserLoginMgr;

import com.monumental.trampoline.datasources.DbResources;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.ss.usermodel.*;

import javax.servlet.jsp.PageContext;

import com.reeltrack.customers.CustomerMgr;
import com.reeltrack.reels.Reel;

public class WhLocationExcelWriter {

	WhLocationMgr whLocationMgr;
	CellStyle styleBold;
	CellStyle styleBoldRight;
	CellStyle styleHeader;
	    
    public WhLocationExcelWriter(PageContext pageContext, DbResources resources) {
		whLocationMgr = new WhLocationMgr();
		whLocationMgr.init(pageContext, resources);
	}
	
	public HSSFWorkbook writeLocations(String customerId) throws Exception {
		WhLocation content = new WhLocation();
		CompEntities contents = new CompEntities();
		if(customerId!=null) {
			if(customerId.equals("")) {
				content.setCustomerId(0);
			} else {
				content.setCustomerId(Integer.parseInt(customerId));
			}
			contents = whLocationMgr.searchWhLocation(content, WhLocation.NAME_COLUMN, true);
		}

		// Begin by setting up the headers
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Warehouse Locations");
		HSSFRow row;
		HSSFCell cell;
		
		// Set up Cell Styles
		HSSFCellStyle wrapStyle = wb.createCellStyle();
    	wrapStyle.setWrapText(true);
		this.setupStyles(wb);
		
		int rowNum = 0;
		int nextNum = 0;

		row = sheet.createRow((short) rowNum);
		sheet.setColumnWidth(nextNum, 5000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Name");
		cell.setCellStyle(styleHeader);

		rowNum++;
		for (int i = 0; i < contents.howMany(); i++) {
			WhLocation current = (WhLocation) contents.get(i);
			row = sheet.createRow((short) rowNum++);
			nextNum=0;
			row.createCell((short)nextNum++).setCellValue(current.getName());
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