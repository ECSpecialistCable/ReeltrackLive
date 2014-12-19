package com.reeltrack.reports;

import com.monumental.trampoline.component.CompEntities;
import com.monumental.trampoline.datasources.DbResources;
import com.monumental.trampoline.security.UserLoginMgr;
import com.reeltrack.customers.CustomerJob;
import com.reeltrack.customers.CustomerMgr;
import com.reeltrack.reels.CableTechData;
import com.reeltrack.reels.Reel;
import com.reeltrack.reels.ReelMgr;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.CellRangeAddress;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.jsp.PageContext;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CableDataDownloadExcelReport {

	CustomerMgr customerMgr;
	ReportMgr reportMgr;
    ReelMgr reelMgr;
	UserLoginMgr umgr;
	CellStyle styleBold;
	CellStyle styleBoldRight;
	CellStyle styleHeader;

    public CableDataDownloadExcelReport(PageContext pageContext, DbResources resources) {
		customerMgr = new CustomerMgr();
		customerMgr.init(pageContext, resources);

		reportMgr = new ReportMgr();
		reportMgr.init(pageContext, resources);

        reelMgr = new ReelMgr();
        reelMgr.init(pageContext, resources);
		
		umgr = new UserLoginMgr();
		umgr.init(pageContext, resources);
	}
	
	public HSSFWorkbook writeExcel(String jobCode, String basePath) throws Exception {
		SimpleDateFormat generatedDtFmt = new SimpleDateFormat("EEEEE, MMMMM dd, yyyy");
	
		Reel reel = new Reel();
		reel.setJobCode(jobCode);
		reel.setSearchOp(Reel.JOB_CODE_COLUMN, Reel.EQ);
		CompEntities reels = reportMgr.getReelsForInventoryReport(reel);

		int maxSearch = 200;
		int skip = 0;
		
		// Begin by setting up the headers 
		HSSFWorkbook wb = new HSSFWorkbook();
		HSSFSheet sheet = wb.createSheet("Cable Data Download");
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

		nextNum=8;
		row = sheet.createRow((short) rowNum);
		row.setHeightInPoints(15);
		cell = row.createCell((short) 0);
		cell.setCellValue(generatedDtFmt.format(new Date()));
		cell.setCellStyle(styleBoldRight);
		CellRangeAddress addr = new CellRangeAddress(rowNum, rowNum, 0, 15);
		sheet.addMergedRegion(addr);
	
		rowNum++;
		row = sheet.createRow((short) rowNum);
		nextNum=9;
		row.setHeightInPoints(15);
		cell = row.createCell((short) 0);
		cell.setCellValue("Cable Data Download\nReport");
		cell.setCellStyle(styleBoldRight);
		addr = new CellRangeAddress(rowNum, rowNum+1, 0, 15);
		sheet.addMergedRegion(addr);

		rowNum++;rowNum++;rowNum++;
		row = sheet.createRow((short) rowNum++);
		row.setHeightInPoints(25);

		nextNum = 0;
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("ECS P/ N");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Area (Cir Mil)");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Ground Size");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Cu Weight/Kft");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Al Weight/Kft");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 6000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Insulation: Thick (Mils)");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 6000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Insulation: Compound");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 6000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Insulation: Color Code");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 6000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Jacket: Overall Shld Type");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 5000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Jacket: Thick (Mils)");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 5000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Jacket: Compound");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("O.D. (Inches)");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Weight/Kft");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 4000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("MBR (Inches)");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 6000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("X-Section (Sq Inches)");
		cell.setCellStyle(styleHeader);
		
		sheet.setColumnWidth(nextNum, 6000);
		cell = row.createCell((short) nextNum++);
		cell.setCellValue("Pull Tension Max (Lbs)");
		cell.setCellStyle(styleHeader);
		
		reels.sortByMethodName("getEcsPN", true, true);
		for (int i = 0; i < reels.howMany(); i++) {
			Reel current = (Reel) reels.get(i);			
			CableTechData techData = reelMgr.getCableTechData(current);
		
			row = sheet.createRow((short) rowNum++);
			nextNum=0;
			row.createCell((short)nextNum++).setCellValue(current.getEcsPN());
			row.createCell((short)nextNum++).setCellValue("" + techData.getConductorArea());
			row.createCell((short)nextNum++).setCellValue("" + techData.getConductorGroundSize());
			row.createCell((short)nextNum++).setCellValue("" + techData.getConCuWeight());
			row.createCell((short)nextNum++).setCellValue("" + techData.getConAlWeight());
			row.createCell((short)nextNum++).setCellValue("" + techData.getInsulationThickness());
			row.createCell((short)nextNum++).setCellValue("" + techData.getInsulationCompound());
			row.createCell((short)nextNum++).setCellValue("" + techData.getInsulationColor());
			row.createCell((short)nextNum++).setCellValue("" + techData.getShieldType());
			row.createCell((short)nextNum++).setCellValue("" + techData.getJacketThickness());
			row.createCell((short)nextNum++).setCellValue("" + techData.getJacketCompound());
			row.createCell((short)nextNum++).setCellValue("" + techData.getOD());
			row.createCell((short)nextNum++).setCellValue("" + techData.getWeight());
			String mbr = "N/A";
	        if(techData.getRadius()!=0) {
	            mbr = Double.toString(techData.getRadius());
	        }
			row.createCell((short)nextNum++).setCellValue("" + mbr);
			row.createCell((short)nextNum++).setCellValue("" + techData.getXSection());
			row.createCell((short)nextNum++).setCellValue("" + techData.getPullTension());
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