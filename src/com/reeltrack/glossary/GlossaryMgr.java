package com.reeltrack.glossary;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import javax.servlet.jsp.PageContext;

import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.*;
import java.io.*;

public class GlossaryMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}
	
	public int addGlossary(Glossary content) throws Exception {
		content.setCreated(new Date());
		content.setStatus(Glossary.STATUS_NEW);
		int toReturn = controller.add(content);
		return toReturn;
	}

	public void updateGlossary(Glossary content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}	
	
	public Glossary getGlossary(Glossary content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (Glossary)controller.pullCompEntity(puller);
	}

	public CompEntities searchGlossary(Glossary content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanGlossary(Glossary content, String realRootContextPath) throws Exception {
	}
	
	public void deleteGlossary(Glossary content, String realRootContextPath) throws Exception {
		this.cleanGlossary(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}
	
	//Excel Importer for Matrix Items
	public void addJobGlossaryFromExcel(File file, String basePath) throws Exception {
		if(file != null) {
			InputStream myxls = new FileInputStream(file.getAbsolutePath());
			Workbook wb = WorkbookFactory.create(myxls);

			Sheet sheet = wb.getSheetAt(0);//get first sheet, should only be one
			CompEntities myDataToAdd = new CompEntities();
			
			//loop through the sheet
			for(int i = 1; i <= sheet.getLastRowNum(); i++) {//i represents which row to start on, 0 assumes no header
				try {
					Row row = sheet.getRow(i);
					Glossary item = new Glossary();
					item.setJobId(0);
					item.setIsVideo("n");
				    item.setName(row.getCell(0).getStringCellValue());
					item.setDescription(row.getCell(1).getStringCellValue());
					item.setGlossaryType(row.getCell(2).getStringCellValue());
				
					if(!item.getName().equals("")) {//make sure token has a value or don't add
						myDataToAdd.add(item);
					}
			
				}catch(Exception e) {
					e.printStackTrace(); System.out.println("exception for loop i "+ i + " for sheet "+ sheet.getSheetName());
				}
			}
			//actually save newly formed compentities into the db
			for(int i=0; i<myDataToAdd.howMany(); i++) {
				Glossary current = (Glossary)myDataToAdd.get(i);
				this.addGlossary(current);
			}
			file.delete();
		}
	}
}
