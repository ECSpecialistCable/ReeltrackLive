package com.reeltrack.reels;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.io.*;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.*;
import com.reeltrack.utilities.MediaManager;
import com.reeltrack.whlocations.*;
import com.reeltrack.picklists.*;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
 
import net.glxn.qrgen.QRCode;
import net.glxn.qrgen.image.ImageType;

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
		
		String qrcode = "RT:" + pulledReel.getCustomerPN() + ":" + pulledReel.getId() + ":" + pulledReel.getReelTag() + ":" + pulledReel.getReelSerial() + ":" + pulledReel.getCableDescription();
		
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

		Reel reel2 = new Reel();
		reel2.setId(reel.getId());
		reel2.setOnReelQuantity(reel.calcOnReelQuantity());
		controller.update(reel2);
	}

	public void updateReel(Reel content) throws Exception {
		Reel currReel = new Reel();
		currReel.setId(content.getId());
		currReel = this.getReel(currReel);
		if(!currReel.getStatus().equals(content.getStatus())) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Status changed from " + currReel.getStatus() + " to " + content.getStatus() + " by " + user.getName());
		}

		if(!currReel.getWharehouseLocation().equals(content.getWharehouseLocation())) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Wharehouse location changed from " + currReel.getWharehouseLocation() + " to " + content.getWharehouseLocation() + " by " + user.getName());
		}

		content.setUpdated(new Date());
		controller.update(content);

		this.updateOnReelQuantity(content);
	}

	public void markReelShipped(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		this.addReelLog(Reel.STATUS_SHIPPED, content, "Shipping info update to carrier " + content.getCarrier() + ", tracking #" + content.getTrackingPRO() + ", and packing list#" + content.getPackingList() + " by " + user.getName());
		content.setStatus(Reel.STATUS_SHIPPED);
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
			this.addReelLog(Reel.STATUS_RECEIVED, content, "Reel was received by " + user.getName());
		} else {
			content.setStatus(Reel.STATUS_REFUSED);
			this.addReelLog(Reel.STATUS_REFUSED, content, "Reel was refused by " + user.getName());
		}
		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);
	}

	public void markReelStaged(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setStatus(Reel.STATUS_STAGED);
		content.setWharehouseLocation(WhLocation.LOCATION_STAGED);
		this.addReelLog(Reel.STATUS_STAGED, content, "Reel was staged by " + user.getName());
		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);

		Reel reel2 = new Reel();
		reel2.setId(content.getId());
		reel2 = this.getReel(reel2);
		PickListMgr pickMgr = new PickListMgr();
		pickMgr.init(this.getPageContext(), this.getDbResources());
		PickList pickList = new PickList();
		pickList.setId(reel2.getPickListId());
		CompEntities reels = pickMgr.getReelsOnPickList(pickList);
		int staged = 0;
		int checkedout = 0;
		for(int y=0; y<reels.howMany();y++) {
            Reel reelnum = (Reel)reels.get(y);
            if(reelnum.getStatus().equals(Reel.STATUS_STAGED)) staged++;
            if(reelnum.getStatus().equals(Reel.STATUS_CHECKED_OUT)) checkedout++;
        }
        if(checkedout==0 && staged>0) pickList.setStatus(PickList.STATUS_PARTIAL_STAGED);
        if(checkedout==0 && staged==reels.howMany()) pickList.setStatus(PickList.STATUS_STAGED);
        controller.update(pickList);
	}

	public void markReelCheckedOut(Reel content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setStatus(Reel.STATUS_CHECKED_OUT);
		content.setWharehouseLocation(WhLocation.LOCATION_NONE);
		this.addReelLog(Reel.STATUS_CHECKED_OUT, content, "Reel was checked out by " + user.getName());
		content.setUpdated(new Date());
		controller.update(content);
		this.updateOnReelQuantity(content);

		Reel reel2 = new Reel();
		reel2.setId(content.getId());
		reel2 = this.getReel(reel2);
		PickListMgr pickMgr = new PickListMgr();
		pickMgr.init(this.getPageContext(), this.getDbResources());
		PickList pickList = new PickList();
		pickList.setId(reel2.getPickListId());
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
        controller.update(pickList);
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
		} else if(content.getTopFoot()!=0) {
			RTUserLoginMgr umgr = new RTUserLoginMgr();
			umgr.init(this.getPageContext(), this.getDbResources());
			RTUser user = (RTUser)umgr.getUser();
			this.addReelLog(content, "Top # changed from " + currReel.getTopFoot() + " to " + content.getTopFoot() + " by " + user.getName());
			content.setUpdated(new Date());
			controller.update(content);
		}
		this.updateOnReelQuantity(content);
	}

	public CableTechData getCableTechData(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new CableTechData());
		Reel reel = new Reel();
		reel.setId(content.getId());
		this.getReel(reel);

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
	
	public void deleteReel(Reel content, String realRootContextPath) throws Exception {
		this.cleanReel(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
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
		return toReturn;
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

		this.updateReel(currReel);
	}

	public void updateReelCircuit(ReelCircuit content) throws Exception {
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

		content.setUpdated(new Date());
		controller.update(content);
		this.updateReelType(content);
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
	public int addReelNote(ReelNote content) throws Exception {
		content.setCreated(new Date());
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setCreatedBy(user.getName());
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
		return controller.pullCompEntities(puller, 0, 0);
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

}
