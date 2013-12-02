package com.reeltrack.glossary;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import javax.servlet.jsp.PageContext;

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
}
