package com.reeltrack.picklists;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import java.util.Date;
import java.util.GregorianCalendar;
import javax.servlet.jsp.PageContext;
import com.reeltrack.users.*;
import com.reeltrack.reels.*;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
 
import net.glxn.qrgen.QRCode;
import net.glxn.qrgen.image.ImageType;

public class PickListMgr extends CompWebManager {
	CompDbController controller;
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
	}
	
	public int addPickList(PickList content) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());

		content.setCreated(new Date());
		content.setStatus(PickList.STATUS_NEW);
		int toReturn = controller.add(content);
		return toReturn;
	}

	public void updatePickList(PickList content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}

	public void updateReelForPickList(Reel content) throws Exception {
		content.setUpdated(new Date());
		controller.update(content);
	}
	
	public PickList getPickList(PickList content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		return (PickList)controller.pullCompEntity(puller);
	}

	public CompEntities getReelCircuits() throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelCircuit());

		Reel reel = new Reel();
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		reel.setJobCode(user.getJobCode());
		puller.addSearch(reel);

		ReelCircuit circuit = new ReelCircuit();
		circuit.setIsPulled("n");
		puller.addSearch(circuit);

		puller.addFKLink(reel, circuit, ReelCircuit.REEL_ID_COLUMN);

		puller.setSortBy(circuit.getTableName(), ReelCircuit.NAME_COLUMN, true);
		return controller.pullCompEntities(puller, 0, 0);
	}

	public CompEntities getPickLists(PickList content, Reel reel, ReelCircuit circuit) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		content.setJobCode(user.getJobCode());

		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);

		PickList picklist = new PickList();
		picklist.setStatus(PickList.STATUS_PICKED_UP);
		picklist.setSearchOp(PickList.STATUS_COLUMN, PickList.NOT_EQUAL);
		puller.addSearch(picklist);

		if(!reel.getReelTag().equals("") || !reel.getCableDescription().equals("") || !reel.getCustomerPN().equals("")) {
			puller.addFKLink(content, reel, Reel.PICK_LIST_ID_COLUMN);
			puller.addSearch(reel);	
		} else if(circuit.getId()!=0) {
			puller.addFKLink(content, reel, Reel.PICK_LIST_ID_COLUMN);
			puller.addFKLink(reel, circuit, ReelCircuit.REEL_ID_COLUMN);
			puller.addSearch(circuit);	
		}

		puller.setDistinct(true);
		puller.setSortBy(content.getTableName(), PickList.NAME_COLUMN, true);
		CompEntities picks = controller.pullCompEntities(puller, 0, 0);
		this.fillPickListsWithReels(picks);
		return picks;
	}

	public CompEntities searchReelsForPickList(Reel reel, ReelCircuit circuit) throws Exception {
		RTUserLoginMgr umgr = new RTUserLoginMgr();
		umgr.init(this.getPageContext(), this.getDbResources());
		RTUser user = (RTUser)umgr.getUser();
		reel.setJobCode(user.getJobCode());
		reel.setPickListId(0);
		reel.setStatus(Reel.STATUS_IN_WHAREHOUSE);

		CompEntities toReturn = new CompEntities();

		if(circuit.getId()!=0) {
			CompEntityPuller puller = new CompEntityPuller(new Reel());
			puller.addSearch(reel);
			puller.addFKLink(reel, circuit, ReelCircuit.REEL_ID_COLUMN);
			puller.addSearch(circuit);
			puller.setSortBy(reel.getTableName(), Reel.ON_REEL_QUANTITY_COLUMN, false);
			toReturn = controller.pullCompEntities(puller, 25, 0);
		} else {
			CompEntityPuller puller = new CompEntityPuller(new Reel());
			puller.addSearch(reel);
			puller.setSortBy(reel.getTableName(), Reel.ON_REEL_QUANTITY_COLUMN, false);
			toReturn = controller.pullCompEntities(puller, 25, 0);
		}

		return toReturn;
	}

	public void fillPickListsWithReels(CompEntities picks) throws Exception {
		for(int x=0; x<picks.howMany(); x++) {
			PickList pick = (PickList)picks.get(x);
			CompEntities reels = this.getReelsOnPickList(pick);
			pick.setCompEntities(Reel.PARAM,reels);
		}
	}

	public CompEntities getReelsOnPickList(PickList content) throws Exception {
		Reel reel = new Reel();
		reel.setPickListId(content.getId());
		CompEntityPuller puller = new CompEntityPuller(new Reel());
		puller.addSearch(reel);
		return controller.pullCompEntities(puller, 0, 0);
	}
	
	public CompEntities searchPickList(PickList content, String sort_by, boolean asc, int howMany, int skip) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setSortBy(content.getTableName(), sort_by, asc);
		return controller.pullCompEntities(puller, howMany, skip);
	}

	public void cleanPickList(PickList content, String realRootContextPath) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new Reel());
		Reel reel = new Reel();
		reel.setPickListId(content.getId());
		puller.addSearch(reel);
		CompEntities reels = controller.pullCompEntities(puller, 0, 0);
		for(int x=0;x<reels.howMany(); x++) {
			reel = (Reel)reels.get(x);
			reel.setPickListId(0);
			controller.update(reel);
		}
	}
	
	public void deletePickList(PickList content, String realRootContextPath) throws Exception {
		this.cleanPickList(content, realRootContextPath);
		controller.delete(realRootContextPath, content);
	}
	
	public void generateQrCodesforPickList(PickList content) throws Exception {
		CompEntities reels = this.getReelsOnPickList(content);
		for(int x=0; x<reels.howMany(); x++) {
			Reel reel = (Reel)reels.get(x);
			this.generateQrCode(reel);
		}	
	}

    public void generateQrCode(Reel reel) throws Exception {
    	Reel theReel = new Reel();
    	theReel.setId(reel.getId());
    	CompEntityPuller puller = new CompEntityPuller(theReel);
		puller.addSearch(theReel);
		Reel pulledReel = (Reel)controller.pullCompEntity(puller);
		
		//String qrcode = "PL:" + pulledReel.getCustomerPN() + ":" + pulledReel.getId() + ":" + pulledReel.getReelTag() + ":" + pulledReel.getReelSerial() + ":" + pulledReel.getCableDescription();
		String qrcode = "http://reeltrack.monumental-i.com/trampoline/index.jsp?type=PL&id=" + pulledReel.getId() + "&job=" + pulledReel.getJobCode();
		System.out.println(qrcode);
        ByteArrayOutputStream out = QRCode.from(qrcode).to(ImageType.PNG).withSize(500, 500).stream();
        
        String baseDir = this.pageContext.getServletContext().getRealPath("/") + pulledReel.getCompEntityDirectory();
	    File createDir = new File(baseDir);
	    if(!createDir.exists()) {
	        createDir.mkdirs();
	    }
	    String fileName = "pl_qrcode_" + pulledReel.getId() + ".png";
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
		
		theReel.setPlQrCodeFile(fileName);
		controller.update(theReel);
    }
}
