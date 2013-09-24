package com.reeltrack.foremans;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.RTUser;

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
}
