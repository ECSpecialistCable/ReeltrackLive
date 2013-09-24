package com.reeltrack.drivers;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.RTUser;

public class DriverMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}
	
	public int addDriver(Driver content) throws Exception {
		content.setCreated(new Date());
		content.setStatus(Driver.STATUS_ACTIVE);
		int toReturn = controller.add(content);
		return toReturn;
	}

	public void updateDriver(Driver content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}
	
	public Driver getDriver(Driver content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (Driver)controller.pullCompEntity(puller);
	}
	
	public CompEntities searchDriver(Driver content, String sort_by, boolean asc) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, 0, 0);
	}
	
	public CompEntities searchDriver(Driver content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanDriver(Driver content, String realRootContextPath) throws Exception {
	}
	
	public void deleteDriver(Driver content, String realRootContextPath) throws Exception {
		this.cleanDriver(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}
}
