package com.reeltrack.whlocations;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.RTUser;

import java.io.*;

public class WhLocationMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}
	
	public int addWhLocation(WhLocation content) throws Exception {
		content.setCreated(new Date());
		content.setStatus(WhLocation.STATUS_ACTIVE);
		int toReturn = controller.add(content);
		return toReturn;
	}

	public void updateWhLocation(WhLocation content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}
	
	public WhLocation getWhLocation(WhLocation content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (WhLocation)controller.pullCompEntity(puller);
	}
	
	public CompEntities searchWhLocation(WhLocation content, String sort_by, boolean asc) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, 0, 0);
	}
	
	public CompEntities searchWhLocation(WhLocation content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanWhLocation(WhLocation content, String realRootContextPath) throws Exception {
	}
	
	public void deleteWhLocation(WhLocation content, String realRootContextPath) throws Exception {
		this.cleanWhLocation(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}

	public void importLocations(WhLocation content, File file) throws Exception {
		FileReader fileReader = new FileReader(file);
 		BufferedReader br = new BufferedReader(fileReader);
 		String line = null;
 		while ((line = br.readLine()) != null) {
 			if(line.equals("")) continue;
 			WhLocation search = new WhLocation();
 			search.setCustomerId(content.getCustomerId());
 			search.setName(line);
 			WhLocation result = this.getWhLocation(search);
 			if(!result.hasData() || result.getId()==0) {
 				search.setStatus(WhLocation.STATUS_ACTIVE);
 				this.addWhLocation(search);
 			}
 		}
	}
}
