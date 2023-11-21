package com.reeltrack.file_cabinets;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.io.File;
import java.util.Date;
import javax.servlet.jsp.PageContext;

public class FileCabinetMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}

	public int addFileCabinet(FileCabinet content, File file, String basePath) throws Exception {
		content.setCreated(new Date());
		content.setStatus(FileCabinet.STATUS_NEW);
		int toReturn = controller.add(content);
		content.setId(toReturn);
		this.controller.saveFileToCompEntityDirectory(file, basePath, content, false);
		content.setFileName(file.getName());
		controller.update(content);
		return toReturn;
	}

	public void updateFileCabinet(FileCabinet content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}

	public void updateFileCabinet(FileCabinet content, File file, String basePath) throws Exception {
		content.setUpdated(new Date());
		this.controller.saveFileToCompEntityDirectory(file, basePath, content, false);
		content.setFileName(file.getName());
		controller.update(content);
	}
	
	public FileCabinet getFileCabinet(FileCabinet content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (FileCabinet)controller.pullCompEntity(puller);
	}

	public CompEntities searchFileCabinet(FileCabinet content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanFileCabinet(FileCabinet content, String realRootContextPath) throws Exception {
	}
	
	public void deleteFileCabinet(FileCabinet content, String realRootContextPath) throws Exception {
		this.cleanFileCabinet(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}
}
