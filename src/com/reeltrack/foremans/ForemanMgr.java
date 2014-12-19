package com.reeltrack.foremans;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.RTUser;

import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.*;
import java.io.*;

public class ForemanMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}
	
	public int addForeman(Foreman content) throws Exception {
		content.setCreated(new Date());
		content.setStatus(Foreman.STATUS_ACTIVE);
		int toReturn = controller.add(content);
		return toReturn;
	}

	public void updateForeman(Foreman content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}
	
	public Foreman getForeman(Foreman content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (Foreman)controller.pullCompEntity(puller);
	}
	
	public CompEntities searchForeman(Foreman content, String sort_by, boolean asc) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, 0, 0);
	}
	
	public CompEntities searchForeman(Foreman content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanForeman(Foreman content, String realRootContextPath) throws Exception {
	}
	
	public void deleteForeman(Foreman content, String realRootContextPath) throws Exception {
		this.cleanForeman(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}
	
	//Excel Importer for Matrix Items
	public void addForemansFromExcel(int customerId, File file, String basePath) throws Exception {
		if(file != null) {
			InputStream myxls = new FileInputStream(file.getAbsolutePath());
			Workbook wb = WorkbookFactory.create(myxls);

			Sheet sheet = wb.getSheetAt(0);//get first sheet, should only be one
			CompEntities myDataToAdd = new CompEntities();
			
			//loop through the sheet
			for(int i = 1; i <= sheet.getLastRowNum(); i++) {//i represents which row to start on, 0 assumes no header
				try {
					Row row = sheet.getRow(i);
					Foreman item = new Foreman();
					item.setName(row.getCell(0).getStringCellValue());
					item.setCustomerId(customerId); //column a
				
					if(!item.getName().equals("")) {//make sure token has a value or don't add
						myDataToAdd.add(item);
					}
			
				}catch(Exception e) {
					e.printStackTrace(); System.out.println("exception for loop i "+ i + " for sheet "+ sheet.getSheetName());
				}
			}
			//actually save newly formed compentities into the db
			for(int i=0; i<myDataToAdd.howMany(); i++) {
				Foreman current = (Foreman)myDataToAdd.get(i);
				this.addForeman(current);
			}
			file.delete();
		}
	}
}
