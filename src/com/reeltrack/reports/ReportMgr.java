package com.reeltrack.reports;

import com.reeltrack.reels.*;
import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;
import javax.servlet.jsp.PageContext;
import com.reeltrack.utilities.MediaManager;

import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.LinkedHashMap;
 

public class ReportMgr extends CompWebManager {
	CompDbController controller;
	MediaManager mediaMgr;
	CompProperties props = new CompProperties();
	
	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		this.controller = this.newCompController();
		mediaMgr = new MediaManager();
		mediaMgr.init(pageContext, resources);
	}	

	public CompEntities getReelsForInventoryReport(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		//puller.setGroupBy(content.getTableName(), Reel.CUSTOMER_PN_COLUMN, "customer_pn");
		puller.setSortBy(content.getTableName(), Reel.REEL_TAG_COLUMN, true);
		return controller.pullCompEntities(puller, 0, 0);
	}

	public LinkedHashMap<String, ArrayList<Integer>> getPNInfoForInventorySummaryReport(Reel content) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addSearch(content);
		puller.setGroupBy(content.getTableName(), Reel.CUSTOMER_PN_COLUMN, "customer_pn_no");
		puller.setSortBy(content.getTableName(), Reel.CUSTOMER_PN_COLUMN, true);
		puller.setDistinct(true);
		CompEntities reelsForPN = controller.pullCompEntities(puller, 0, 0);
		LinkedHashMap<String, ArrayList<Integer>> toReturn = new LinkedHashMap<String, ArrayList<Integer>>();
		for(int i=0; i<reelsForPN.howMany();i++) {
			Reel reel = (Reel)reelsForPN.get(i);
			String currentPN = reel.getCustomerPN();

			// get all reels for this pn with jobcode
			puller = new CompEntityPuller(content);
			content.setCustomerPN(currentPN);
			content.setSearchOp(Reel.CUSTOMER_PN_COLUMN, Reel.EQ);
			puller.addSearch(content);
			puller.setSortBy(content.getTableName(), Reel.REEL_TAG_COLUMN, true);
			CompEntities customerReels = controller.pullCompEntities(puller, 0, 0);

			int purchasedCount = 0, inInvCount = 0, checkedOutCount = 0, onCompReelCount = 0;
			int noOfReelsInInv = 0, noOfReelsCheckedOut = 0;
			for(int j=0; j<customerReels.howMany(); j++) {
				Reel current = (Reel)customerReels.get(j);
				if(current.getStatus().equals(Reel.STATUS_ORDERED) || current.getStatus().equals(Reel.STATUS_SHIPPED)) {
					purchasedCount+= reel.getOnReelQuantity();
				} else if(current.getStatus().equals(Reel.STATUS_IN_WHAREHOUSE)) {
					inInvCount+= reel.getOnReelQuantity();
					noOfReelsInInv++;
				} else if(current.getStatus().equals(Reel.STATUS_STAGED) || current.getStatus().equals(Reel.STATUS_CHECKED_OUT)) {
					checkedOutCount+= reel.getOnReelQuantity();
					noOfReelsCheckedOut++;
				} else if(current.getStatus().equals(Reel.STATUS_COMPLETE)) {
					onCompReelCount+= reel.getOnReelQuantity();
				}
			}

			ArrayList<Integer> values = new ArrayList<Integer>();
			values.add(purchasedCount);
			values.add(inInvCount);
			values.add(checkedOutCount);
			values.add(onCompReelCount);
			values.add(noOfReelsInInv);
			values.add(noOfReelsCheckedOut);

			toReturn.put(currentPN, values);

		}
		return toReturn;
	}

	public ArrayList<Integer> getReelTrackPeriodSummary(Reel content, GregorianCalendar startDate, GregorianCalendar endDate) throws Exception {
		ArrayList<Integer> toReturn = new ArrayList<Integer>();

		int recieved = getStatusCountReelTrackPeriod(content, startDate, endDate, Reel.STATUS_RECEIVED, Reel.STATUS_REFUSED);
		int checkedOut = getStatusCountReelTrackPeriod(content, startDate, endDate, Reel.STATUS_CHECKED_OUT);
		int chckedIn = getStatusCountReelTrackPeriod(content, startDate, endDate, Reel.STATUS_IN_WHAREHOUSE);
		int pending = getStatusCountReelTrackPeriod(content, startDate, endDate, Reel.STATUS_SHIPPED);
		int completed = getStatusCountReelTrackPeriod(content, startDate, endDate, Reel.STATUS_COMPLETE);		

		toReturn.add(Integer.valueOf(recieved));
		toReturn.add(Integer.valueOf(checkedOut));
		toReturn.add(Integer.valueOf(chckedIn));
		toReturn.add(Integer.valueOf(pending));
		toReturn.add(Integer.valueOf(completed));
		return toReturn;
	}

	private int getStatusCountReelTrackPeriod(Reel content, GregorianCalendar startDate, GregorianCalendar endDate, String status) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addFKLink(new Reel(), new ReelLog(), ReelLog.REEL_ID_COLUMN);
		puller.setDistinct(true);

		ReelLog log = new ReelLog();
		log.setCreated(startDate.getTime());
		log.setSearchOp(ReelLog.CREATED_COLUMN, ReelLog.GTEQ);
		puller.addSearch(log);

		log = new ReelLog();
		log.setCreated(endDate.getTime());
		log.setSearchOp(ReelLog.CREATED_COLUMN, ReelLog.LTEQ);
		puller.addSearch(log);

		log = new ReelLog();
		log.setStatus(status);
		log.setSearchOp(ReelLog.STATUS_COLUMN, ReelLog.EQ);
		puller.addSearch(log);

		return controller.pullCompEntitiesCount(puller);
	}

	private int getStatusCountReelTrackPeriod(Reel content, GregorianCalendar startDate, GregorianCalendar endDate, String status1, String status2) throws Exception {
		CompEntityPuller puller = new CompEntityPuller(content);
		puller.addFKLink(new Reel(), new ReelLog(), ReelLog.REEL_ID_COLUMN);
		puller.setDistinct(true);

		ReelLog log = new ReelLog();
		log.setCreated(startDate.getTime());
		log.setSearchOp(ReelLog.CREATED_COLUMN, ReelLog.GTEQ);
		puller.addSearch(log);

		log = new ReelLog();
		log.setCreated(endDate.getTime());
		log.setSearchOp(ReelLog.CREATED_COLUMN, ReelLog.LTEQ);
		puller.addSearch(log);

		log = new ReelLog();
		log.setStatus(status1);
		log.setSearchOp(ReelLog.STATUS_COLUMN, ReelLog.EQ);
		puller.addInclusiveSearch(log);
		log = new ReelLog();
		log.setStatus(status2);
		log.setSearchOp(ReelLog.STATUS_COLUMN, ReelLog.EQ);
		puller.addInclusiveSearch(log);

		return controller.pullCompEntitiesCount(puller);
	}

	public CompEntities getReelIssues(Reel content, GregorianCalendar startDate, GregorianCalendar endDate, boolean isResolved) throws Exception {
		CompEntities toReturn = new CompEntities();

		CompEntityPuller puller = new CompEntityPuller(new ReelIssue());
		puller.addSearch(content);
		puller.addFKLink(new Reel(), new ReelIssue(), ReelIssue.REEL_ID_COLUMN);
		puller.setDistinct(true);

		ReelIssue issue = new ReelIssue();
		issue.setCreated(startDate.getTime());
		issue.setSearchOp(ReelIssue.CREATED_COLUMN, ReelIssue.GTEQ);
		puller.addSearch(issue);

		issue = new ReelIssue();
		issue.setCreated(endDate.getTime());
		issue.setSearchOp(ReelIssue.CREATED_COLUMN, ReelIssue.LTEQ);
		puller.addSearch(issue);

		if(isResolved) {
			issue = new ReelIssue();
			issue.setIsResolved("y");
			puller.addSearch(issue);
		} else {
			issue = new ReelIssue();
			issue.setIsResolved("n");
			puller.addSearch(issue);
		}

		toReturn = controller.pullCompEntities(puller, 0, 0);
		return toReturn;
	}

}
