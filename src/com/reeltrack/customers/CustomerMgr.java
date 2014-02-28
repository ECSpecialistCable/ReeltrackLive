package com.reeltrack.customers;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.RTUser;
import java.io.File;

public class CustomerMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}
	
	public int addCustomer(Customer content) throws Exception {
		content.setCreated(new Date());
		content.setStatus(Customer.STATUS_ACTIVE);
		int toReturn = controller.add(content);
		return toReturn;
	}

	public void updateCustomer(Customer content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}
	
	public Customer getCustomer(Customer content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (Customer)controller.pullCompEntity(puller);
	}
	
	public CompEntities searchCustomer(Customer content, String sort_by, boolean asc) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, 0, 0);
	}
	
	public CompEntities searchCustomer(Customer content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanCustomer(Customer content, String realRootContextPath) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new CustomerJob());
		CustomerJob customerJob = new CustomerJob();
		customerJob.setCustomerId(content.getId());
		puller.addSearch(customerJob);
		CompEntities customerJobs = controller.pullCompEntities(puller, 0, 0);
		for(int i=0; i < customerJobs.howMany(); ++i) {
			customerJob = (CustomerJob) customerJobs.get(i);
			this.deleteCustomerJob(customerJob, realRootContextPath);
		}
	}
	
	public void deleteCustomer(Customer content, String realRootContextPath) throws Exception {
		this.cleanCustomer(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}
	
	/*** Customer Jobs Section ***/
	public int addCustomerJob(CustomerJob content) throws Exception {
		content.setCreated(new Date());
		return controller.add(content);
	}
	
	public void updateCustomerJob(CustomerJob content) throws Exception {
		controller.update(content);
	}

	public void updateCustomerJob(CustomerJob content, File file, String basePath) throws Exception {
		content.setUpdated(new Date());
		this.controller.saveFileToCompEntityDirectory(file, basePath, content, false);
		content.setBOMPdf(file.getName());
		controller.update(content);
	}

	public CustomerJob getCustomerJob(CustomerJob content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), CustomerJob.NAME_COLUMN, true);
		return (CustomerJob)controller.pullCompEntity(puller);
	}
	
	public CompEntities getCustomerJobs(CustomerJob content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return controller.pullCompEntities(puller, 0, 0);
	}
		
	public void deleteCustomerJob(CustomerJob content, String realRootContextPath) throws Exception {
		CustomerJobToRTUser cTu = new CustomerJobToRTUser();
        cTu.setCompEntityId(content.getId());
        controller.deleteLinks(cTu);

		CustomerJob theJob = new CustomerJob();
		theJob.setId(content.getId());
		controller.delete(null, theJob);
	}

	/*** Customer Jobs To User Link ***/
	public void linkJobToUser(CustomerJob content, RTUser ref_content) throws Exception {
		CustomerJobToRTUser link = new CustomerJobToRTUser();
		link.setCompEntityId(content.getId());
		link.setRefCompEntityId(ref_content.getId());
		controller.addLink(link);
	}

	public void unlinkJobToUser(CustomerJob content, RTUser ref_content) throws Exception {
		CustomerJobToRTUser link = new CustomerJobToRTUser();
		link.setCompEntityId(content.getId());
		link.setRefCompEntityId(ref_content.getId());
		controller.deleteLink(link);
	}

    public CompEntities getJobsAssignedToUser(RTUser content) throws Exception {
        CompEntityPuller puller = new CompEntityPuller(new CustomerJob());
        CustomerJobToRTUser link = new CustomerJobToRTUser();
        link.setRefCompEntityId(content.getId());
        puller.addLink(link);
        CompEntities jobs = controller.pullCompEntities(puller, 0, 0);
        return jobs;
    }

}
