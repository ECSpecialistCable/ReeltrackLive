package com.reeltrack.settings;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.RTUser;

public class SettingsMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}

	public void updateSettings(Settings content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}
	
	public Settings getSettings(int customer_id) throws Exception {
		Settings settings = new Settings();
		settings.setCustomerId(customer_id);
		CompEntityPuller puller = new CompEntityPuller(settings);
		puller.addSearch(settings);
		Settings toReturn = (Settings)controller.pullCompEntity(puller);
		if(toReturn == null || !toReturn.hasData()) {
			settings.setCreated(new Date());
			settings.setStatus(Settings.STATUS_ACTIVE);
			int newID = controller.add(settings);
			settings = new Settings();
			settings.setCustomerId(customer_id);
			puller = new CompEntityPuller(settings);
			puller.addSearch(settings);
			toReturn = (Settings)controller.pullCompEntity(puller);
		}
		return toReturn;
	}

	public void cleanSettings(Settings content, String realRootContextPath) throws Exception {
	}
	
	public void deleteSettings(Settings content, String realRootContextPath) throws Exception {
		this.cleanSettings(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}
}
