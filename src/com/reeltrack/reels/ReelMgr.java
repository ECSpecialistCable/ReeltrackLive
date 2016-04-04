package com.reeltrack.reels;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import com.reeltrack.customers.Customer;
import com.reeltrack.customers.CustomerJob;
import java.util.Date;
import java.io.*;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.*;
import com.reeltrack.utilities.MediaManager;
import com.reeltrack.whlocations.*;
import com.reeltrack.picklists.*;
import com.monumental.trampoline.utilities.emails.EmailSender;
import com.monumental.trampoline.component.CompProperties;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;
import java.util.ArrayList;
import java.io.FileInputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
 
import net.glxn.qrgen.QRCode;
import net.glxn.qrgen.image.ImageType;
import org.apache.poi.xssf.usermodel.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.*;

public class ReelMgr extends CompWebManager {
	CompDbController controller;
	MediaManager mediaMgr;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
		mediaMgr = new MediaManager();
		mediaMgr.init(pageContext, resources);
	}

	public void updateReelData(Reel content, String basePath, File file) throws Exception {
		if(file!=null) {
			content.setCTRFile(mediaMgr.addMedia(file, content, basePath));	
		}
		controller.update(content);
	}

	public String[] getPnVolts() throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		Reel content = new Reel();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setGroupBy(content.getTableName(), Reel.PN_VOLT_COLUMN, "volts"); 
		puller.setSortBy(content.getTableName(), Reel.PN_VOLT_COLUMN, true);
		CompEntities volts = controller.pullCompEntities(puller, 0, 0);
		String[] results = new String[volts.howMany()];
		for (int x=0; x< volts.howMany(); x++) {
			Reel reel = (Reel)volts.get(x);
			results[x] = reel.getPnVolt();
		}
		return results;		
	}

	public String[] getPnGauges() throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		Reel content = new Reel();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setGroupBy(content.getTableName(), Reel.PN_GAUGE_COLUMN, "gauge"); 
		puller.setSortBy(content.getTableName(), Reel.PN_GAUGE_COLUMN, true);
		CompEntities volts = controller.pullCompEntities(puller, 0, 0);
		String[] results = new String[volts.howMany()];
		for (int x=0; x< volts.howMany(); x++) {
			Reel reel = (Reel)volts.get(x);
			results[x] = reel.getPnGauge();
		}
		return results;		
	}

	public String[] getPnConductors() throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		Reel content = new Reel();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setGroupBy(content.getTableName(), Reel.PN_CONDUCTOR_COLUMN, "conductor"); 
		puller.setSortBy(content.getTableName(), Reel.PN_CONDUCTOR_COLUMN, true);
		CompEntities volts = controller.pullCompEntities(puller, 0, 0);
		String[] results = new String[volts.howMany()];
		for (int x=0; x< volts.howMany(); x++) {
			Reel reel = (Reel)volts.get(x);
			results[x] = reel.getPnConductor();
		}
		return results;		
	}

	public String[] getCarriers() throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		Reel content = new Reel();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setGroupBy(content.getTableName(), Reel.CARRIER_COLUMN, "carriers"); 
		puller.setSortBy(content.getTableName(), Reel.CARRIER_COLUMN, true);
		CompEntities manufacturers = controller.pullCompEntities(puller, 0, 0);
		String[] results = new String[manufacturers.howMany()];
		for (int x=0; x< manufacturers.howMany(); x++) {
			Reel reel = (Reel)manufacturers.get(x);
			results[x] = reel.getCarrier();
		}
		return results;		
	}
	
	public String[] getManufacturers() throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		Reel content = new Reel();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setGroupBy(content.getTableName(), Reel.MANUFACTURER_COLUMN, "manufacturers"); 
		puller.setSortBy(content.getTableName(), Reel.MANUFACTURER_COLUMN, true);
		CompEntities manufacturers = controller.pullCompEntities(puller, 0, 0);
		String[] results = new String[manufacturers.howMany()];
		for (int x=0; x< manufacturers.howMany(); x++) {
			Reel reel = (Reel)manufacturers.get(x);
			results[x] = reel.getManufacturer();
		}
		return results;		
	}
	
    public void generateQrCode(Reel reel) throws Exception {
    	Reel theReel = new Reel();
    	theReel.setId(reel.getId());
    	CompEntityPuller puller = new CompEntityPuller(theReel);
		puller.addSearch(theReel);
		Reel pulledReel = (Reel)controller.pullCompEntity(puller);
		
		String domain = request.getServerName().toString();
		//String qrcode = "RT:" + pulledReel.getCustomerPN() + ":" + pulledReel.getId() + ":" + pulledReel.getReelTag() + ":" + pulledReel.getReelSerial() + ":" + pulledReel.getCableDescription();
		//String qrcode = "http://www.ecsreeltrack.com/trampoline/index.jsp?type=RT&id=" + pulledReel.getId() + "&job=" + pulledReel.getJobCode();
        String qrcode = "http://" + domain + "/trampoline/index.jsp?type=RT&id=" + pulledReel.getId() + "&job=" + pulledReel.getJobCode();
        ByteArrayOutputStream out = QRCode.from(qrcode).to(ImageType.PNG).withSize(500, 500).stream();
        
        String baseDir = this.pageContext.getServletContext().getRealPath("/") + pulledReel.getCompEntityDirectory();
	    File createDir = new File(baseDir);
	    if(!createDir.exists()) {
	        createDir.mkdirs();
	    }
	    String fileName = "rt_qrcode_" + pulledReel.getId() + ".png";
	    String filePath = baseDir + "/" + fileName;
        //System.out.println(filePath);
        
        try {
            FileOutputStream fout = new FileOutputStream(new File(filePath));
            fout.write(out.toByteArray());
            fout.flush();
            fout.close();
        } catch (FileNotFoundException e) {
        	e.printStackTrace();
        } catch (IOException e) {
        	e.printStackTrace();
        }
		
		theReel.setRtQrCodeFile(fileName);
		controller.update(theReel);
    }
	
	public int addReel(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		content.setCreated(new Date());
		content.setStatus(Reel.STATUS_ORDERED);
		int toReturn = controller.add(content);

		content.setId(toReturn);
		this.updateOnReelQuantity(content);

		return toReturn;
	}

	public void updateOnReelQuantity(Reel content) throws Exception {
		Reel reel = new Reel();
		reel.setId(content.getId());
		reel = this.getReel(reel);

		CableTechData techData = this.getCableTechData(reel);
		int weight = techData.getWeight();

		Reel reel2 = new Reel();
		reel2.setId(reel.getId());
		reel2.setOnReelQuantity(reel.calcOnReelQuantity(weight));
		controller.update(reel2);
	}

	public void updateReel(Reel content, boolean addLog) throws Exception {
		Reel currReel = new Reel();
		currReel.setId(content.getId());
		currReel = this.getReel(currReel);
		if(!currReel.getStatus().equals(content.getStatus())) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			if(addLog) {
			this.addReelLog(content, "Status changed from " + currReel.getStatus() + " to " + content.getStatus() + " by " + user.getName());
			}
		}

		if(!currReel.getWharehouseLocation().equals(content.getWharehouseLocation())) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			if(addLog) {
			this.addReelLog(content, "Warehouse location changed from " + currReel.getWharehouseLocation() + " to " + content.getWharehouseLocation() + " by " + user.getName());
			}
		}

		content.setUpdated(new Date());
		controller.update(content);

		this.updateOnReelQuantity(content);
	}

	public void updateReel(Reel content) throws Exception {
		this.updateReel(content,true);
	}

	public void updateReelsForCustPN(Reel content) throws Exception {
		Reel toGet = new Reel();
		toGet.setCableDescription(content.getCableDescription());
		toGet.setSearchOp(Reel.CABLE_DESCRIPTION_COLUMN, Reel.EQ);
		CompEntities contents = this.searchReels(toGet, Reel.ID_COLUMN, true, 0, 0);
		for(int i=0; i<contents.howMany();i++) {
			Reel currReel = (Reel)contents.get(i);

			Reel toUpdate = new Reel();
			toUpdate.setId(currReel.getId());
			toUpdate.setCustomerPN(content.getCustomerPN());
			
			toUpdate.setUpdated(new Date());
			controller.update(toUpdate);

			//this.updateOnReelQuantity(toUpdate);
		}
	}

	public void markReelShipped(Reel content) throws Exception {
		this.markReelShipped(content,true);
	}

	public void markReelShipped(Reel content, boolean shipped) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		
		if(shipped) {
			if(user.getUserType().equals(RTUser.USER_TYPE_VENDOR)) {
				this.addReelLog(Reel.STATUS_SHIPPED, content, "Vendor " + user.getName() + " marked reel as Shipped with shipped quantity of " + content.getShippedQuantity() + ", carrier " + content.getCarrier() + ", tracking #" + content.getTrackingPRO() + ", and packing list#" + content.getPackingList());
			} else {
				this.addReelLog(Reel.STATUS_SHIPPED, content, user.getName() + " marked reel as Shipped with shipped quantity of " + content.getShippedQuantity() + ", carrier " + content.getCarrier() + ", tracking #" + content.getTrackingPRO() + ", and packing list#" + content.getPackingList());
			}
			content.setStatus(Reel.STATUS_SHIPPED);
		}
		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);
	}

	public void markReelReceived(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		if(content.getReceivingDisposition().equals(Reel.RECEIVING_DISPOSITION_ACCEPTED)) {
			content.setStatus(Reel.STATUS_IN_WHAREHOUSE);
			content.setReceivedOnDate(new Date());
			if(!content.getReceivingIssue().equals(Reel.RECEIVING_ISSUE_NONE)) {
				//this.addReelLog(Reel.STATUS_RECEIVED, content, "Reel was received by " + user.getName() + " but was marked as damaged");
				CompEntityPuller puller = new CompEntityPuller(new Customer());
				Customer customer = new Customer();
				customer.setId(user.getCustomerId());
				puller.addSearch(customer);
				customer = (Customer)controller.pullCompEntity(puller);

				if(!customer.getIssueContactEmail().equals("")) {
					puller = new CompEntityPuller(new Reel());
					Reel reel = new Reel();
					reel.setId(content.getId());
					puller.addSearch(reel);
					reel = (Reel)controller.pullCompEntity(puller);

					CompProperties props = new CompProperties();
					String mailHost = props.getProperty("mailHost");
				    String mailFrom = customer.getIssueContactEmail();//props.getProperty("mailFrom");
					
					ArrayList emails = new ArrayList();
					emails.add(customer.getIssueContactEmail());
			        EmailSender emailer = new EmailSender();
					try {
						String subject = "Reel mark damaged by " + customer.getName() + " for reel CRID#:" + reel.getCrId();
						String message = reel.getEcsPN() + " manufactured by " + reel.getManufacturer()  + " on ECS PO " + reel.getOrdNo() + " with reel tag " + reel.getReelTag();
						message += "Customer Reel ID# " + reel.getCrId() + " - " + reel.getCableDescription() + " with reel tag " + reel.getReelTag() + " was accepted and marked as damaged by " + user.getFname() + " " + user.getLname() + " with " + customer.getName() + " on " + user.getJobName() + " Project - " + user.getJobCode();
						//String message = content.getDescription();
						emailer.sendEmail(mailHost, emails, mailFrom, mailFrom, subject, message, null,null);
			        } catch(Exception e) {
						System.out.println("Issue sending issue email." + e);
					}
				}
				content.setUpdated(new Date());
				controller.update(content);
				this.updateOnReelQuantity(content);
				this.addReelLog(Reel.STATUS_RECEIVED, content, "Reel was received by " + user.getName() + " but was marked as damaged");
			} else {
				content.setUpdated(new Date());
				controller.update(content);
				this.updateOnReelQuantity(content);
				this.addReelLog(Reel.STATUS_RECEIVED, content, "Reel was received by " + user.getName() + " with top foot marker =" + content.getOrigTopFoot() + ", received quantity=" + content.getReceivedQuantity() + ", and warehouse location as " + content.getWharehouseLocation());
			}
		} else {
			content.setStatus(Reel.STATUS_REFUSED);
			//this.addReelLog(Reel.STATUS_REFUSED, content, "Reel was refused by " + user.getName());

			CompEntityPuller puller = new CompEntityPuller(new Customer());
			Customer customer = new Customer();
			customer.setId(user.getCustomerId());
			puller.addSearch(customer);
			customer = (Customer)controller.pullCompEntity(puller);

			if(!customer.getIssueContactEmail().equals("")) {
				puller = new CompEntityPuller(new Reel());
				Reel reel = new Reel();
				reel.setId(content.getId());
				puller.addSearch(reel);
				reel = (Reel)controller.pullCompEntity(puller);

				CompProperties props = new CompProperties();
				String mailHost = props.getProperty("mailHost");
			    String mailFrom = customer.getIssueContactEmail();//props.getProperty("mailFrom");
				
				ArrayList emails = new ArrayList();
				emails.add(customer.getIssueContactEmail());
		        EmailSender emailer = new EmailSender();
				try {
					String subject = "Reel refused by " + customer.getName() + " for reel CRID#:" + reel.getCrId();
					String message = reel.getEcsPN() + " manufactured by " + reel.getManufacturer()  + " on ECS PO " + reel.getOrdNo() + " with reel tag " + reel.getReelTag();
					message += "Customer Reel ID# " + reel.getCrId() + " - " + reel.getCableDescription() + " with reel tag " + reel.getReelTag() + " was refused by " + user.getFname() + " " + user.getLname() + " with " + customer.getName() + " on " + user.getJobName() + " Project - " + user.getJobCode();
					//String message = content.getDescription();
					emailer.sendEmail(mailHost, emails, mailFrom, mailFrom, subject, message, null,null);
		        } catch(Exception e) {
					System.out.println("Issue sending issue email." + e);
				}
			}
			content.setUpdated(new Date());
			controller.update(content);
			this.updateOnReelQuantity(content);
			this.addReelLog(Reel.STATUS_REFUSED, content, "Reel was refused by " + user.getName());
		}
		//content.setUpdated(new Date());
		//controller.update(content);
		//this.updateOnReelQuantity(content);
	}

	public void markReelStaged(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setStatus(Reel.STATUS_STAGED);
		content.setWharehouseLocation(WhLocation.LOCATION_STAGED);
		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);

		Reel reel2 = new Reel();
		reel2.setId(content.getId());
		reel2 = this.getReel(reel2);
		if(reel2.getPickListId()!=0) {
			PickListMgr pickMgr = new PickListMgr();
			pickMgr.init(this.getPageContext(), this.getDbResources());
			PickList pickList = new PickList();
			pickList.setId(reel2.getPickListId());
			pickList = pickMgr.getPickList(pickList);
			CompEntities reels = pickMgr.getReelsOnPickList(pickList);
			int staged = 0;
			int checkedout = 0;
			for(int y=0; y<reels.howMany();y++) {
	            Reel reelnum = (Reel)reels.get(y);
	            if(reelnum.getStatus().equals(Reel.STATUS_STAGED)) staged++;
	            if(reelnum.getStatus().equals(Reel.STATUS_CHECKED_OUT)) checkedout++;
	        }
	        if(checkedout==0 && staged>0) {
	        	pickList.setStatus(PickList.STATUS_PARTIAL_STAGED);
	        }
	        if(checkedout==0 && staged==reels.howMany()) {
	        	pickList.setStatus(PickList.STATUS_STAGED);
	        }
	        if(!pickList.getStatus().equals("")) {
	        	controller.update(pickList);
	        }
	        //"Reel was staged by " + user.getName()
	        this.addReelLog(Reel.STATUS_STAGED, content, "Reel was staged by " + user.getName() + " for pick up by " + pickList.getDriver() + " for check out to " + pickList.getForeman() + ".");
    	} else {
    		this.addReelLog(Reel.STATUS_STAGED, content, "Reel was staged by " + user.getName());
    	}
	}

	public void updateCheckedOutInNum(Reel reel, boolean isOut) throws Exception {
		Reel newReel = new Reel();
		newReel.setId(reel.getId());
		newReel = this.getReel(newReel);
		if(isOut) {
			newReel.setTimesCheckedOut(newReel.getTimesCheckedOut() + 1);
		} else {
			newReel.setTimesCheckedIn(newReel.getTimesCheckedIn() + 1);
		}
		controller.update(newReel);
	}

	public void markReelCheckedOut(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setStatus(Reel.STATUS_CHECKED_OUT);
		content.setWharehouseLocation(WhLocation.LOCATION_NONE);
		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);
		this.updateCheckedOutInNum(content,true);

		Reel reel2 = new Reel();
		reel2.setId(content.getId());
		reel2 = this.getReel(reel2);
		PickListMgr pickMgr = new PickListMgr();
		pickMgr.init(this.getPageContext(), this.getDbResources());
		PickList pickList = new PickList();
		pickList.setId(reel2.getPickListId());
		pickList = pickMgr.getPickList(pickList);
		CompEntities reels = pickMgr.getReelsOnPickList(pickList);
		int staged = 0;
		int checkedout = 0;
		for(int y=0; y<reels.howMany();y++) {
            Reel reelnum = (Reel)reels.get(y);
            if(reelnum.getStatus().equals(Reel.STATUS_STAGED)) staged++;
            if(reelnum.getStatus().equals(Reel.STATUS_CHECKED_OUT)) checkedout++;
        }
        if(checkedout>0) pickList.setStatus(PickList.STATUS_PARTIAL_PICKED_UP);
        if(checkedout==reels.howMany()) pickList.setStatus(PickList.STATUS_PICKED_UP);
        if(!pickList.getStatus().equals("")) {
        	controller.update(pickList);
        }

        this.addReelLog(Reel.STATUS_CHECKED_OUT, content, "Reel was checked out by " + user.getName() + " to " + pickList.getDriver() + " for installation by " + pickList.getForeman() + ".");
	}


	public void markReelCheckedIn(Reel content, String driverName) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setStatus(Reel.STATUS_IN_WHAREHOUSE);
		content.setPickListId(0);
		this.addReelLog(Reel.STATUS_IN_WHAREHOUSE, content, "Reel was checked in by " + user.getName() + " from driver " + driverName + " with a new Top # of " + content.getTopFoot());
		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);
		this.updateCheckedOutInNum(content,false);
	}

	public void markReelComplete(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setStatus(Reel.STATUS_COMPLETE);
		content.setPickListId(0);
		this.addReelLog(Reel.STATUS_COMPLETE, content, "Reel was completed by " + user.getName());
		content.setUpdated(new Date());
		controller.update(content);
		//this.updateOnReelQuantity(content);
	}

	public void markReelScrapped(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setStatus(Reel.STATUS_SCRAPPED);
		content.setPickListId(0);
		this.addReelLog(Reel.STATUS_SCRAPPED, content, "Reel was scrapped by " + user.getName());
		content.setUpdated(new Date());
		controller.update(content);
		//this.updateOnReelQuantity(content);
	}

	public void updateReelShippingInfo(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		this.addReelLog(content, "Shipping info update to carrier " + content.getCarrier() + ", tracking #" + content.getTrackingPRO() + ", and packing list#" + content.getPackingList() + " by " + user.getName());

		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);
	}

	public void updateReelReceivingInfo(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		this.addReelLog(content, "Issue marked as " + content.getReceivingIssue() + ", disposition as " + content.getReceivingDisposition() + " by " + user.getName());

		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);
	}

	public void updateReelQuantity(Reel content) throws Exception {
		Reel currReel = new Reel();
		currReel.setId(content.getId());
		currReel = this.getReel(currReel);
		if(currReel.getShippedQuantity() != content.getShippedQuantity()) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Shipped Qty changed from " + currReel.getShippedQuantity() + " to " + content.getShippedQuantity() + " by " + user.getName());
		}

		if(currReel.getReceivedQuantity() != content.getReceivedQuantity()) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Received Qty changed from " + currReel.getReceivedQuantity() + " to " + content.getReceivedQuantity() + " by " + user.getName());
		}

		if(currReel.getTopFoot() != content.getTopFoot()) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Top # changed from " + currReel.getTopFoot() + " to " + content.getTopFoot() + " by " + user.getName());
		}

		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);
	}

	public void updateReelPull(Reel content) throws Exception {
		Reel currReel = new Reel();
		currReel.setId(content.getId());
		currReel = this.getReel(currReel);
		if(content.getTempPullAmount()!=0) {
			content.setCableUsedQuantity(currReel.getCableUsedQuantity() + content.getTempPullAmount());
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "" + content.getTempPullAmount() + " was pulled by " + user.getName());
			content.setUpdated(new Date());
			controller.update(content);
		}
		this.updateOnReelQuantity(content);
	}

	public void updateReelTop(Reel content) throws Exception {
		Reel currReel = new Reel();
		currReel.setId(content.getId());
		currReel = this.getReel(currReel);
		if(content.getTopFoot()!=0) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Top # changed from " + currReel.getTopFoot() + " to " + content.getTopFoot() + " by " + user.getName());
			content.setUpdated(new Date());
			controller.update(content);
		}
		this.updateOnReelQuantity(content);
	}

	public void updateReelWeight(Reel content) throws Exception {
		Reel currReel = new Reel();
		currReel.setId(content.getId());
		currReel = this.getReel(currReel);
		if(content.getCurrentWeight()!=0) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Current weight changed from " + currReel.getCurrentWeight() + " to " + content.getCurrentWeight() + " by " + user.getName());
			content.setUpdated(new Date());
			controller.update(content);
		}
		this.updateOnReelQuantity(content);
	}

	public CableTechData getCableTechData(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new CableTechData());
		Reel reel = new Reel();
		reel.setId(content.getId());
		reel = this.getReel(reel);

		CableTechData techData = new CableTechData();
		techData.setJobCode(reel.getJobCode());
		techData.setEcsPN(reel.getEcsPN());
		puller.addSearch(techData);
		return (CableTechData)controller.pullCompEntity(puller);
	}

	public void updateCableTechData(CableTechData content) throws Exception {
		controller.update(content);
	}

	public void updateCableTechData(CableTechData content, String basePath, File file) throws Exception {
		if(file!=null) {
			content.setDataSheetFile(mediaMgr.addMedia(file, content, basePath));	
		}
		controller.update(content);
	}
	
	public Reel getReel(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (Reel)controller.pullCompEntity(puller);
	}

	public Reel getReelByNextCrid(Reel content) throws Exception {
		Reel theReel = new Reel();
		theReel.setId(content.getId());
		theReel = this.getReel(theReel);

		CompEntityPuller puller = new CompEntityPuller(new Reel());
		Reel cridReel = new Reel();
		cridReel.setJobCode(theReel.getJobCode());
		cridReel.setCrId(theReel.getCrId());
		cridReel.setSearchOp(Reel.CR_ID_COLUMN,Reel.GT);
		puller.addSearch(cridReel);
		puller.setSortBy(cridReel.getTableName(), Reel.CR_ID_COLUMN, true);
		CompEntities reels = controller.pullCompEntities(puller,1,0);
		if(reels.howMany()>0) {
			return (Reel)reels.get(0);
		} else {
			return null;
		}
	}

	public Reel getReelByPreviousCrid(Reel content) throws Exception {
		Reel theReel = new Reel();
		theReel.setId(content.getId());
		theReel = this.getReel(theReel);

		CompEntityPuller puller = new CompEntityPuller(new Reel());
		Reel cridReel = new Reel();
		cridReel.setJobCode(theReel.getJobCode());
		cridReel.setCrId(theReel.getCrId());
		cridReel.setSearchOp(Reel.CR_ID_COLUMN,Reel.LT);
		puller.addSearch(cridReel);
		puller.setSortBy(cridReel.getTableName(), Reel.CR_ID_COLUMN, false);
		CompEntities reels = controller.pullCompEntities(puller,1,0);
		if(reels.howMany()>0) {
			return (Reel)reels.get(0);
		} else {
			return null;
		}
	}

	public Reel getReelByLastCrid(Reel content) throws Exception {
		Reel theReel = new Reel();
		theReel.setId(content.getId());
		theReel = this.getReel(theReel);

		CompEntityPuller puller = new CompEntityPuller(new Reel());
		Reel cridReel = new Reel();
		cridReel.setJobCode(theReel.getJobCode());
		puller.addSearch(cridReel);
		puller.setSortBy(cridReel.getTableName(), Reel.CR_ID_COLUMN, false);
		CompEntities reels = controller.pullCompEntities(puller,1,0);
		if(reels.howMany()>0) {
			return (Reel)reels.get(0);
		} else {
			return null;
		}
	}

	public void clearReelTags() throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new Reel());
		Reel toReset = new Reel();
		toReset.setHasReelTagFile("y");
		puller.addSearch(toReset);
		CompEntities resetAll = controller.pullCompEntities(puller, 0, 0);
		for(int i=0; i<resetAll.howMany(); i++) {
			Reel current = (Reel)resetAll.get(i);
			toReset = new Reel();
			toReset.setId(current.getId());
			toReset.setHasReelTagFile("n");
			controller.update(toReset);
		}
	}

	public CompEntities searchReels(Reel content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public int searchReelsCount(Reel content, String sort_by, boolean asc) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntitiesCount(puller);
	}

	public CompEntities searchReels2(Reel content, String circuitName, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		if(circuitName!=null && !circuitName.equals("")) {
			ReelCircuit circuit = new ReelCircuit();
			circuit.setName(circuitName);
			circuit.setSearchOp(ReelCircuit.NAME_COLUMN,ReelCircuit.PARTIAL);
			puller.addSearch(circuit);
			puller.addFKLink(new Reel(), new ReelCircuit(), ReelCircuit.REEL_ID_COLUMN);
		}
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public int searchReelsCount2(Reel content, String circuitName, String sort_by, boolean asc) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		if(circuitName!=null && !circuitName.equals("")) {
			ReelCircuit circuit = new ReelCircuit();
			circuit.setName(circuitName);
			circuit.setSearchOp(ReelCircuit.NAME_COLUMN,ReelCircuit.PARTIAL);
			puller.addSearch(circuit);
			puller.addFKLink(new Reel(), new ReelCircuit(), ReelCircuit.REEL_ID_COLUMN);
		}
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntitiesCount(puller);
	}

	public CompEntities searchOrderedAndShippedReels(Reel content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);

		Reel reel = new Reel();
		reel.setStatus(Reel.STATUS_ORDERED);
		puller.addInclusiveSearch(reel);
		Reel reel2 = new Reel();
		reel2.setStatus(Reel.STATUS_SHIPPED);
		puller.addInclusiveSearch(reel2);

		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public int searchOrderedAndShippedReelsCount(Reel content, String sort_by, boolean asc) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);

		Reel reel = new Reel();
		reel.setStatus(Reel.STATUS_ORDERED);
		puller.addInclusiveSearch(reel);
		Reel reel2 = new Reel();
		reel2.setStatus(Reel.STATUS_SHIPPED);
		puller.addInclusiveSearch(reel2);

		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntitiesCount(puller);
	}

	public CompEntities searchAllReceivedReels(Reel content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);

		Reel reel = new Reel();
		reel.setStatus(Reel.STATUS_IN_WHAREHOUSE);
		puller.addInclusiveSearch(reel);
		Reel reel2 = new Reel();
		reel2.setStatus(Reel.STATUS_STAGED);
		puller.addInclusiveSearch(reel2);
		Reel reel3 = new Reel();
		reel3.setStatus(Reel.STATUS_CHECKED_OUT);
		puller.addInclusiveSearch(reel3);
		Reel reel4 = new Reel();
		reel4.setStatus(Reel.STATUS_COMPLETE);
		puller.addInclusiveSearch(reel4);
		Reel reel5 = new Reel();
		reel5.setStatus(Reel.STATUS_SCRAPPED);
		puller.addInclusiveSearch(reel5);

		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public int searchAllReceivedReelsCount(Reel content, String sort_by, boolean asc) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);

		Reel reel = new Reel();
		reel.setStatus(Reel.STATUS_IN_WHAREHOUSE);
		puller.addInclusiveSearch(reel);
		Reel reel2 = new Reel();
		reel2.setStatus(Reel.STATUS_STAGED);
		puller.addInclusiveSearch(reel2);
		Reel reel3 = new Reel();
		reel3.setStatus(Reel.STATUS_CHECKED_OUT);
		puller.addInclusiveSearch(reel3);
		Reel reel4 = new Reel();
		reel4.setStatus(Reel.STATUS_COMPLETE);
		puller.addInclusiveSearch(reel4);
		Reel reel5 = new Reel();
		reel5.setStatus(Reel.STATUS_SCRAPPED);
		puller.addInclusiveSearch(reel5);

		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntitiesCount(puller);
	}

	public Customer getCustomerForReel(Reel content) throws Exception {
		Customer toReturn = new Customer();
		CompEntityPuller puller = new CompEntityPuller(new CustomerJob());

		CustomerJob job = new CustomerJob();
		job.setCode(content.getJobCode());
		job.setSearchOp(CustomerJob.CODE_COLUMN, CustomerJob.EQ);
		puller.addSearch(job);
		job = (CustomerJob)controller.pullCompEntity(puller);
		System.out.println("code:" + job.getCode());
		System.out.println("id:" + job.getId());

		puller = new CompEntityPuller(new Customer());
		Customer toGet = new Customer();
		toGet.setId(job.getCustomerId());
		puller.addSearch(toGet);
		System.out.println("cust-id:" + toGet.getId());

		toReturn = (Customer)controller.pullCompEntity(puller);
		System.out.println("cust-name:" + toReturn.getName());
		return toReturn;
	}

	public CompEntities getReelsDataForBOM(String jobCode) throws Exception {
		CompProperties props = new CompProperties();
		DbProcessor processor = new DbProcessor(resources.getConnection(props.getDatabase(this.getConfiguration())));
		String queryString = "select distinct *, count(reels.id) as reels_count, sum(ordered_quantity) as total_ordered from reels where job_code='" + jobCode + "' group by customer_pn;";
		EntityList datalist = processor.getRows(queryString);

		CompEntities toReturn = new CompEntities();
		while(datalist.hasNext()) {
			Entity entity = datalist.nextEntity();
			Reel centity = new Reel();
			centity.setData(entity);
            centity.setReelsCountForBOM(Integer.parseInt(entity.getEntityValue("reels_count").getColumnValue().toString()));
            centity.setReelsOrderedForBOM(Integer.parseInt(entity.getEntityValue("total_ordered").getColumnValue().toString()));

			CableTechData techData = this.getCableTechData(centity);
			centity.setCompEntity(CableTechData.PARAM, techData);
			toReturn.add(centity);
		}
		
		return toReturn;
	}

	public String zipDataSheets(String jobCode, String basePath) throws Exception {
		CableTechData techData = new CableTechData();
		CompEntityPuller puller = new CompEntityPuller(techData);
		techData.setJobCode(jobCode);
		puller.addSearch(techData);
		CompEntities techs = controller.pullCompEntities(puller, 0, 0);

		String zipFileName = "datasheets_" + jobCode + ".zip";
		try {
			File dir = new File(basePath + "/reports/");
			dir.mkdirs();

			FileOutputStream fos = new FileOutputStream(basePath + "/reports/" + zipFileName);
			ZipOutputStream zos = new ZipOutputStream(fos);

			for(int x=0;x<techs.howMany();x++) {
				techData = (CableTechData)techs.get(x);
				if(!techData.getDataSheetFile().equals("")) {
					File dataSheet = new File(basePath + techData.getCompEntityDirectory() + "/" + techData.getDataSheetFile());
					if(dataSheet.exists()) {
						FileInputStream fis = new FileInputStream(dataSheet);
						String filename = "datasheet" + (x+1) + "-" + techData.getDataSheetFile();
						ZipEntry zipEntry = new ZipEntry(filename);
						zos.putNextEntry(zipEntry);
						byte[] bytes = new byte[1024];
						int length;
						while ((length = fis.read(bytes)) >= 0) {
							zos.write(bytes, 0, length);
						}
						zos.closeEntry();
						fis.close();
					}
				}
			}

			zos.close();
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return zipFileName;
	}

	public String zipCtrFiles(String jobCode, String basePath) throws Exception {
		Reel reel = new Reel();
		CompEntityPuller puller = new CompEntityPuller(reel);
		reel.setJobCode(jobCode);
		puller.addSearch(reel);
		CompEntities reels = controller.pullCompEntities(puller, 0, 0);

		String zipFileName = "ctr_" + jobCode + ".zip";
		try {
			File dir = new File(basePath + "/reports/");
			dir.mkdirs();

			FileOutputStream fos = new FileOutputStream(basePath + "/reports/" + zipFileName);
			ZipOutputStream zos = new ZipOutputStream(fos);

			System.out.println("creating zip file:" + zipFileName);
			for(int x=0;x<reels.howMany();x++) {
				reel = (Reel)reels.get(x);
				if(!reel.getCTRFile().equals("")) {
					File dataSheet = new File(basePath + reel.getCompEntityDirectory() + "/" + reel.getCTRFile());
					if(dataSheet.exists()) {
						FileInputStream fis = new FileInputStream(dataSheet);
						String filename = "ctr" + (x+1) + "-" + reel.getCTRFile(); //.replaceAll(",","").replaceAll("#","").replaceAll("'","");
						System.out.println("adding file:" + filename);

						ZipEntry zipEntry = new ZipEntry(filename);
						zos.putNextEntry(zipEntry);
						byte[] bytes = new byte[1024];
						int length;
						while ((length = fis.read(bytes)) >= 0) {
							zos.write(bytes, 0, length);
						}
						zos.closeEntry();
						fis.close();
					}
				}
			}
			System.out.println("done adding files");

			zos.close();
			fos.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return zipFileName;
	}

	public CompEntities getReelsWithoutCustPN(Reel content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		puller.setGroupBy(new Reel().getTableName(), Reel.CABLE_DESCRIPTION_COLUMN, "reel_cable_description");
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanReel(Reel content, String realRootContextPath) throws Exception {
		CompEntities allLogs = this.getReelLogs(content);
		for(int i=0; i < allLogs.howMany(); ++i) {
			ReelLog currLog = (ReelLog) allLogs.get(i);
			this.deleteReelLog(currLog,realRootContextPath);
		}

		CompEntities allCircuits = this.getReelCircuits(content);
		for(int i=0; i < allCircuits.howMany(); ++i) {
			ReelCircuit currCircuit = (ReelCircuit) allCircuits.get(i);
			this.deleteReelCircuit(currCircuit,realRootContextPath);
		}

		CompEntities allNotes = this.getReelNotes(content);
		for(int i=0; i < allNotes.howMany(); ++i) {
			ReelNote currNote = (ReelNote) allNotes.get(i);
			this.deleteReelNote(currNote,realRootContextPath);
		}

		CompEntities allIssues = this.getReelIssues(content);
		for(int i=0; i < allIssues.howMany(); ++i) {
			ReelIssue currIssue = (ReelIssue) allIssues.get(i);
			this.deleteReelIssue(currIssue,realRootContextPath);
		}
	}

	public void deleteUnpulledCircuits(Reel content) throws Exception {
		CompEntities allCircuits = this.getReelCircuits(content);
		for(int i=0; i < allCircuits.howMany(); ++i) {
			ReelCircuit currCircuit = (ReelCircuit) allCircuits.get(i);
			if(!currCircuit.isPulled()) {
				this.deleteReelCircuit(currCircuit,null);
			}
		}
	}

	
	public void deleteReel(Reel content, String realRootContextPath) throws Exception {
		this.cleanReel(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}

	public int getCablesByStatus(Reel content, String status) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new Reel());
		Reel toSearch = new Reel();
		if(!status.equals("")) {
			toSearch.setStatus(status);
			toSearch.setSearchOp(Reel.STATUS_COLUMN, Reel.EQ);
		}
		toSearch.setEcsPN(content.getEcsPN());
		toSearch.setSearchOp(Reel.ECS_PN_COLUMN, Reel.EQ);
		puller.addSearch(toSearch);
		return controller.pullCompEntitiesCount(puller);
	}

	public int getCablesQuantityByStatus(Reel content, String status) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new Reel());
		Reel toSearch = new Reel();
		toSearch.setEcsPN(content.getEcsPN());
		toSearch.setJobCode(content.getJobCode());
		if(status.equals(Reel.STATUS_IN_WHAREHOUSE) || status.equals(Reel.STATUS_CHECKED_OUT)) {
			toSearch.setStatus(status);
		}
		puller.addSearch(toSearch);
		CompEntities reels = controller.pullCompEntities(puller,0,0);
		int amount = 0;
		for(int x=0; x<reels.howMany(); x++) {
			Reel theReel = (Reel)reels.get(x);
			if(status.equals(Reel.STATUS_ORDERED)) {
				amount += theReel.getOrderedQuantity();
			}
			if(status.equals(Reel.STATUS_RECEIVED)) {
				amount += theReel.getReceivedQuantity();
			}
			if(status.equals(Reel.STATUS_IN_WHAREHOUSE)) {
				amount += theReel.getOnReelQuantity();
			}
			if(status.equals(Reel.STATUS_CHECKED_OUT)) {
				amount += theReel.getOnReelQuantity();
			}
			if(status.equals("remaining")) {
				if(theReel.getStatus().equals(Reel.STATUS_ORDERED) || theReel.getStatus().equals(Reel.STATUS_SHIPPED)) {
					amount += theReel.getOrderedQuantity();
				} else if(theReel.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE) || theReel.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
					amount += theReel.getOnReelQuantity();
				}	
			}
		}

		return amount;
		//if(!status.equals("")) {
		//	toSearch.setStatus(status);
			//toSearch.setSearchOp(Reel.STATUS_COLUMN, Reel.EQ);
		//}
		
		//toSearch.setSearchOp(Reel.ECS_PN_COLUMN, Reel.EQ);
		
		
	}

	/*** Reel Logs ***/
	public int addReelLog(Reel content, String note) throws Exception {
		ReelLog log = new ReelLog();
		log.setReelId(content.getId());
		log.setNote(note);
		log.setCreated(new Date());
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		log.setCreatedBy(user.getName());
		return this.addReelLog(log);
	}

	public int addReelLog(String status, Reel content, String note) throws Exception {
		ReelLog log = new ReelLog();
		log.setReelId(content.getId());
		log.setNote(note);
		log.setCreated(new Date());
		log.setStatus(status);
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		log.setCreatedBy(user.getName());
		return this.addReelLog(log);
	}

	public int addReelLog(ReelLog content) throws Exception {
		content.setCreated(new Date());
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setCreatedBy(user.getName());

		Reel reel = new Reel();
		reel.setId(content.getReelId());
		reel = this.getReel(reel);
		content.setOnReelQuantity(reel.getOnReelQuantity());
		content.setTopFoot(reel.getTopFoot());
		return controller.add(content);
	}

	public CompEntities getReelLogs(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelLog());
		ReelLog search = new ReelLog();
		search.setReelId(content.getId());
		puller.addSearch(search);
		puller.setSortBy(search.getTableName(), ReelLog.CREATED_COLUMN, false);
		return controller.pullCompEntities(puller, 0, 0);
	}

	public void cleanReelLogs(ReelLog content, String realRootContextPath) throws Exception {
	}
		
	public void deleteReelLog(ReelLog content, String realRootContextPath) throws Exception {
		this.cleanReelLogs(content,realRootContextPath);
		controller.delete(null, content);
	}	
	/****************************/

	/*** Reel Circuits ***/
	public int addReelCircuit(ReelCircuit content) throws Exception {
		content.setCreated(new Date());
		int toReturn = controller.add(content);
		this.updateReelType(content);
		Reel currReel = new Reel();
		currReel.setId(content.getReelId());
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		this.addReelLog(currReel, user.getName() + " assigned circuit \"" + content.getTitle() + "\" " + content.getLength() + "' long to reel.");
		return toReturn;
	}

	public void addReelCircuits(Hashtable contents, int reelId) throws Exception {
		Enumeration keys = contents.keys();
		while(keys.hasMoreElements()) {
			String key = keys.nextElement().toString();
			Integer value = (Integer)contents.get(key);
			ReelCircuit content = new ReelCircuit();
			content.setCreated(new Date());
			content.setReelId(reelId);
			content.setLength(value);
			content.setName(key);
			controller.add(content);
			this.updateReelType(content);
		}
	}

	public void updateReelType(ReelCircuit content) throws Exception {
		Reel currReel = new Reel();
		currReel.setId(content.getReelId());
		CompEntities circuits = this.getReelCircuits(currReel);

		currReel.setReelType(Reel.REEL_TYPE_BULK);
		for(int x=0; x<circuits.howMany(); x++) {
			ReelCircuit tmpCircuit = (ReelCircuit)circuits.get(x);
			if(!tmpCircuit.isPulled()) {
				currReel.setReelType(Reel.REEL_TYPE_CIRCUIT);
				break;
			}
		}

		this.updateReel(currReel,false);
	}

	public void updateReelCircuit(ReelCircuit content) throws Exception {
		/*
		ReelCircuit rc = new ReelCircuit();
		rc.setId(content.getId());
		CompEntityPuller puller = new CompEntityPuller(rc);
		puller.addSearch(rc);
		rc = (ReelCircuit)controller.pullCompEntity(puller);

		Reel reel = new Reel();
		reel.setId(rc.getReelId());
		if(content.isPulled()) {
			reel.setTempPullAmount(rc.getLength());
		} else {
			reel.setTempPullAmount(-rc.getLength());
		}
		this.updateReelPull(reel);
		*/
		content.setUpdated(new Date());
		controller.update(content);
		this.updateReelType(content);

		Reel reel = new Reel();
		reel.setId(content.getReelId());
		reel = this.getReel(reel);

		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		this.addReelLog(reel, user.getName() + " updated circuit \"" + content.getTitle() + "\" to actual quantity pulled=" + content.getActLength() + "'.");
	}
	
	public void fillReelCircuits(CompEntities reels) throws Exception {
		for(int x=0; x<reels.howMany(); x++) {
			Reel reel = (Reel)reels.get(x);
			CompEntities circuits = this.getReelCircuits(reel);
			reel.setCompEntities(ReelCircuit.PARAM,circuits);
		}
	}

	public CompEntities getReelCircuits(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelCircuit());
		ReelCircuit search = new ReelCircuit();
		search.setReelId(content.getId());
		puller.addSearch(search);
		puller.setSortBy(search.getTableName(), ReelCircuit.CREATED_COLUMN, false);
		return controller.pullCompEntities(puller, 0, 0);
	}

	public void cleanReelCircuits(ReelCircuit content, String realRootContextPath) throws Exception {
	}
		
	public void deleteReelCircuit(ReelCircuit content, String realRootContextPath) throws Exception {
		this.cleanReelCircuits(content,realRootContextPath);
		controller.delete(null, content);
		this.updateReelType(content);
	}	
	/****************************/

	/*** Reel Notes ***/
	public int addReelNote(ReelNote content, boolean send_note) throws Exception {
		content.setCreated(new Date());
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setCreatedBy(user.getName());

		CompEntityPuller puller = new CompEntityPuller(new Customer());
		Customer customer = new Customer();
		customer.setId(user.getCustomerId());
		puller.addSearch(customer);
		customer = (Customer)controller.pullCompEntity(puller);

		if(!customer.getIssueContactEmail().equals("") && send_note) {
			puller = new CompEntityPuller(new Reel());
			Reel reel = new Reel();
			reel.setId(content.getReelId());
			puller.addSearch(reel);
			reel = (Reel)controller.pullCompEntity(puller);

			CompProperties props = new CompProperties();
			String mailHost = props.getProperty("mailHost");
		    String mailFrom = customer.getIssueContactEmail();//props.getProperty("mailFrom");
			
			ArrayList emails = new ArrayList();
			emails.add(customer.getIssueContactEmail());
	        EmailSender emailer = new EmailSender();
			try {
				String subject = "A note was added by " + customer.getName() + " for reel CRID#:" + reel.getCrId();
				String message = "A note was added by " + user.getFname() + " " + user.getLname() + " with " + customer.getName() + " on " + user.getJobName() + " Project - " + user.getJobCode() + " for " + reel.getEcsPN() + " manufactured by " + reel.getManufacturer()  + " on ECS PO " + reel.getOrdNo() + " with reel tag " + reel.getReelTag();
				message += "Customer Reel ID# " + reel.getCrId() + " - " + reel.getCableDescription() + " with reel tag " + reel.getReelTag();
				//String message = content.getDescription();
				emailer.sendEmail(mailHost, emails, mailFrom, mailFrom, subject, message, null,null);
	        } catch(Exception e) {
				System.out.println("Issue sending issue email." + e);
			}
		}

		return controller.add(content);
	}

	public CompEntities getReelNotes(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelNote());
		ReelNote search = new ReelNote();
		search.setReelId(content.getId());
		puller.addSearch(search);
		puller.setSortBy(search.getTableName(), ReelNote.CREATED_COLUMN, false);
		return controller.pullCompEntities(puller, 0, 0);
	}

	public void cleanReelNotes(ReelNote content, String realRootContextPath) throws Exception {
	}
		
	public void deleteReelNote(ReelNote content, String realRootContextPath) throws Exception {
		this.cleanReelNotes(content,realRootContextPath);
		controller.delete(null, content);
	}	
	/****************************/

	/*** Reel Issues ***/
	public int addReelIssue(ReelIssue content) throws Exception {
		content.setCreated(new Date());
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setCreatedBy(user.getName());
		if(!content.getIssueLog().equals("")) {
			content.setIssueLog(content.getIssueLog() + "\n");
		}

		CompEntityPuller puller = new CompEntityPuller(new Customer());
		Customer customer = new Customer();
		customer.setId(user.getCustomerId());
		puller.addSearch(customer);
		customer = (Customer)controller.pullCompEntity(puller);

		if(!customer.getIssueContactEmail().equals("")) {
			puller = new CompEntityPuller(new Reel());
			Reel reel = new Reel();
			reel.setId(content.getReelId());
			puller.addSearch(reel);
			reel = (Reel)controller.pullCompEntity(puller);

			CompProperties props = new CompProperties();
			String mailHost = props.getProperty("mailHost");
		    String mailFrom = customer.getIssueContactEmail();//props.getProperty("mailFrom");
			
			ArrayList emails = new ArrayList();
			emails.add(customer.getIssueContactEmail());
	        EmailSender emailer = new EmailSender();
			try {
				String subject = "An issue was added by " + customer.getName() + " for reel CRID#:" + reel.getCrId();
				String message = "A " + content.getDescription() + " issue was added by " + user.getFname() + " " + user.getLname() + " with " + customer.getName() + " on " + user.getJobName() + " Project - " + user.getJobCode() + " for " + reel.getEcsPN() + " manufactured by " + reel.getManufacturer()  + " on ECS PO " + reel.getOrdNo() + " with reel tag " + reel.getReelTag();
				message += "Customer Reel ID# " + reel.getCrId() + " - " + reel.getCableDescription() + " with reel tag " + reel.getReelTag();
				//String message = content.getDescription();
				emailer.sendEmail(mailHost, emails, mailFrom, mailFrom, subject, message, null,null);
	        } catch(Exception e) {
				System.out.println("Issue sending issue email." + e);
			}
		}

		Reel reel = new Reel();
		reel.setId(content.getReelId());
		this.addReelLog(reel, "Issue: " + content.getDescription() + " logged by " + user.getName());

		return controller.add(content);
	}

	public void updateReelIssue(ReelIssue content) throws Exception {
		ReelIssue currIssue = new ReelIssue();
		currIssue.setId(content.getId());
		CompEntityPuller puller = new CompEntityPuller(currIssue);
		puller.addSearch(currIssue);
		currIssue = (ReelIssue)controller.pullCompEntity(puller);

		content.setUpdated(new Date());

		String issueLog = currIssue.getIssueLog();
		if(!content.getIssueLog().equals("")) {
			issueLog = issueLog.concat("\n");
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			issueLog = issueLog.concat(user.getName() + " on " + content.getUpdatedDateText() + " at " + content.getUpdatedTime() + "\n");
			issueLog = issueLog.concat(content.getIssueLog());
		}

		content.setIssueLog(issueLog);
		controller.update(content);

		if(content.getIsResolved().equals("y")) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user2 = (RTUser)umgr.getUser();
			Reel reel = new Reel();
			reel.setId(currIssue.getReelId());
			this.addReelLog(reel, "Issue: " + currIssue.getDescription() + " resolved by " + user2.getName());

			puller = new CompEntityPuller(new Customer());
			Customer customer = new Customer();
			customer.setId(user2.getCustomerId());
			puller.addSearch(customer);
			customer = (Customer)controller.pullCompEntity(puller);

			if(!customer.getIssueContactEmail().equals("")) {
				puller = new CompEntityPuller(new Reel());
				reel = new Reel();
				reel.setId(content.getReelId());
				puller.addSearch(reel);
				reel = (Reel)controller.pullCompEntity(puller);

				CompProperties props = new CompProperties();
				String mailHost = props.getProperty("mailHost");
			    String mailFrom = customer.getIssueContactEmail();//props.getProperty("mailFrom");
				
				ArrayList emails = new ArrayList();
				emails.add(customer.getIssueContactEmail());
		        EmailSender emailer = new EmailSender();
				try {
				String subject = "An issue was resolved by " + customer.getName() + " for reel CRID#:" + reel.getCrId();
				String message = "The " + content.getDescription() + " issue was resolved by " + user2.getFname() + " " + user2.getLname() + " with " + customer.getName() + " on " + user2.getJobName() + " Project - " + user2.getJobCode() + " for " + reel.getEcsPN() + " manufactured by " + reel.getManufacturer()  + " on ECS PO " + reel.getOrdNo() + " with reel tag " + reel.getReelTag();
				message += "Customer Reel ID# " + reel.getCrId() + " - " + reel.getCableDescription() + " with reel tag " + reel.getReelTag();
				//String message = content.getDescription();
				emailer.sendEmail(mailHost, emails, mailFrom, mailFrom, subject, message, null,null);
	        } catch(Exception e) {
				System.out.println("Issue sending issue email." + e);
			}
			}
		}
	}

	public CompEntities getUnresolvedReelIssues(String jobCode) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelIssue());
		Reel reel = new Reel();
		reel.setJobCode(jobCode);
		puller.addSearch(reel);

		ReelIssue issue = new ReelIssue();
		issue.setIsResolved("n");
		puller.addSearch(issue);

		puller.addFKLink(reel, issue, ReelIssue.REEL_ID_COLUMN);

		puller.setSortBy(issue.getTableName(), ReelIssue.CREATED_COLUMN, false);
		CompEntities toReturns = controller.pullCompEntities(puller, 0, 0);
		this.fillReelIssuesWithReels(toReturns);
		return toReturns;
	}

	public CompEntities getResolvedReelIssues(String jobCode) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelIssue());
		Reel reel = new Reel();
		reel.setJobCode(jobCode);
		puller.addSearch(reel);

		ReelIssue issue = new ReelIssue();
		issue.setIsResolved("y");
		puller.addSearch(issue);

		puller.addFKLink(reel, issue, ReelIssue.REEL_ID_COLUMN);

		puller.setSortBy(issue.getTableName(), ReelIssue.CREATED_COLUMN, false);
		CompEntities toReturns =  controller.pullCompEntities(puller, 0, 0);
		this.fillReelIssuesWithReels(toReturns);
		return toReturns;
	}

	public void fillReelIssuesWithReels(CompEntities issues) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new Reel());
		puller.addSearchByIds(issues);
		puller.addLink(new ReelIssue(), ReelIssue.REEL_ID_COLUMN, new Reel(), Reel.ID_COLUMN);
		puller.setLinkTo(new ReelIssue());
		CompEntities reels = controller.pullCompEntities(puller,0,0);
		controller.fillSingleWithPulled(issues, reels, Reel.PARAM);
	}

	public CompEntities getReelIssues(Reel content, boolean isResolved) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelIssue());
		ReelIssue search = new ReelIssue();
		search.setReelId(content.getId());
		if(isResolved) {
			search.setIsResolved("y");	
		} else {
			search.setIsResolved("n");
		}
		puller.addSearch(search);
		puller.setSortBy(search.getTableName(), ReelIssue.CREATED_COLUMN, false);
		return controller.pullCompEntities(puller, 0, 0);
	}

	public CompEntities getReelIssues(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelIssue());
		ReelIssue search = new ReelIssue();
		search.setReelId(content.getId());
		puller.addSearch(search);
		puller.setSortBy(search.getTableName(), ReelIssue.CREATED_COLUMN, false);
		return controller.pullCompEntities(puller, 0, 0);
	}

	public void cleanReelIssues(ReelIssue content, String realRootContextPath) throws Exception {
	}
		
	public void deleteReelIssue(ReelIssue content, String realRootContextPath) throws Exception {
		this.cleanReelIssues(content,realRootContextPath);
		controller.delete(null, content);
	}	
	/****************************/

	public void importCircuitsFromExcel(String jobCode, File file, String basePath) throws Exception {

		if(file != null) {
            InputStream myxls = new FileInputStream(file.getAbsolutePath());
			Workbook wb = WorkbookFactory.create(myxls);

			Sheet sheet = wb.getSheetAt(0);//get first sheet, should only be one
			CompEntities myDataToAdd = new CompEntities();
			
			//loop through the sheet
			for(int i = 1; i <= sheet.getLastRowNum(); i++) {//i represents which row to start on, 0 assumes no header
				try {
					Row row = sheet.getRow(i);
					ReelCircuit circuit = new ReelCircuit();
					circuit.tmpReelTag = row.getCell(0).getStringCellValue(); //column a
					String name = "blank";
					try {
						name = row.getCell(1).getStringCellValue();
					} catch(Exception e) {
						int tmp = (int)row.getCell(1).getNumericCellValue();
						name = Integer.toString(tmp);
					}
					circuit.setName(name);
					double quant = row.getCell(2).getNumericCellValue();
					circuit.setLength((int)quant);
					myDataToAdd.add(circuit);
				}catch(Exception e) {
					e.printStackTrace(); System.out.println("exception for loop i "+ i + " for sheet "+ sheet.getSheetName());
				}
			}

			for(int x=0; x<myDataToAdd.howMany(); x++) {
				ReelCircuit circuit = (ReelCircuit)myDataToAdd.get(x);
				if(circuit.tmpReelTag==null || circuit.tmpReelTag.equals("")) continue;

				CompEntityPuller puller = new CompEntityPuller(new Reel());
				Reel searchReel = new Reel();
				searchReel.setReelTag(circuit.tmpReelTag);
				searchReel.setJobCode(jobCode);
				puller.addSearch(searchReel);
				Reel reel = (Reel)controller.pullCompEntity(puller);
				System.out.println("looking for reel:" + circuit.tmpReelTag);
				if(reel.getId()!=0) {
					System.out.println("found reel:" + reel.getCrId());
					System.out.println("looking for circuit:" + circuit.getName());
					CompEntityPuller puller2 = new CompEntityPuller(new ReelCircuit());
					ReelCircuit searchCircuit = new ReelCircuit();
					searchCircuit.setReelId(reel.getId());
					searchCircuit.setName(circuit.getName());
					puller2.addSearch(searchCircuit);
					searchCircuit = (ReelCircuit)controller.pullCompEntity(puller2);
					System.out.println("found circuit was:" + searchCircuit.getId());
					if(searchCircuit.getId()==0) {
						System.out.println("adding circuit");
						circuit.setReelId(reel.getId());
						controller.add(circuit);
					} 
				}
			}
		}
	}

}
