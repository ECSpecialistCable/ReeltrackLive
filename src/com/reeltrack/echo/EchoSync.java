package com.reeltrack.echo;

import java.io.*;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Date;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;

import com.reeltrack.reels.*;

public class EchoSync extends CompManager {
	private CompProperties props;
	Connection conECHO;
	Connection conRT;
	CompDbController controllerECHO = null;
	CompDbController controllerRT = null;
	
	public EchoSync() {
		try {
			props = new CompProperties();
			Class.forName(props.getProperty("databaseDriver"));
			conECHO = DriverManager.getConnection(props.getProperty("dbConnectionECHO"), props.getProperty("dbUserECHO"), props.getProperty("dbPasswordECHO"));
			this.controllerECHO = new CompDbController(conECHO);
			conRT = DriverManager.getConnection(props.getProperty("dbConnectionRT"), props.getProperty("dbUserRT"), props.getProperty("dbPasswordRT"));
			this.controllerRT = new CompDbController(conRT);
	    } catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void pushReels() throws Exception {
		System.out.println("Starting the reel push");
		CompEntityPuller puller = new CompEntityPuller(new EchoTransaction());
		EchoTransaction echoTrans = new EchoTransaction();
		puller.addSearch(echoTrans);
		puller.setSortBy(echoTrans.getTableName(), EchoTransaction.ID_COLUMN, true);
		CompEntities echoTranses = controllerECHO.pullCompEntities(puller, 0, 0);
		for(int x=0; x<echoTranses.howMany(); x++) {
			echoTrans = (EchoTransaction)echoTranses.get(x);
			if(echoTrans.getStatus().equalsIgnoreCase("add")) {
				Reel reel = new Reel();
				reel.setOrdNo(echoTrans.getOrdNo());
				reel.setPORevision(echoTrans.getPORevision());
				reel.setAbsoluteItem(echoTrans.getAbsoluteItem());
				reel.setReelSerial(echoTrans.getReelSerial());
				boolean ok = this.fillReelAllocation(reel);
				if(ok) {
					this.fillCustomerOrderHdr(reel);
					this.fillCustomerOrderDtl(reel);
					this.fillManufacturer(reel);
					this.fillCableTrac(reel);
					CableTechData techData = this.getCableTech(reel);
					this.addReel(reel,techData);
				}
			}
		}
	}

	public void addReel(Reel reel, CableTechData techData) throws Exception {
		//reel.setJobId(10);
		reel.setCreated(new Date());
		reel.setStatus(Reel.STATUS_ORDERED);
		int toReturn = controllerRT.add(reel);

		CableTechData techData2 = new CableTechData();
		techData2.setJobCode(reel.getJobCode());
		techData2.setEcsPN(reel.getEcsPN());
		CompEntityPuller puller = new CompEntityPuller(new CableTechData());
		puller.addSearch(techData2);
		techData2 = (CableTechData)controllerRT.pullCompEntity(puller);

		if(techData2==null || !techData2.hasData()) {
			techData.setJobCode(reel.getJobCode());
			toReturn = controllerRT.add(techData);
		}
	}

	public boolean fillReelAllocation(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from ReelAllocation where ordno='" + reel.getOrdNo() + "' and PORevision=" + reel.getPORevision() + " and absoluteitem=" + reel.getAbsoluteItem() + " and reelserial=" + reel.getReelSerial();
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("I got Reel Allocation");
			Entity entity = datalist.nextEntity();
			reel.setReelTag(entity.getString("ReelTag",""));
			reel.setOrderedQuantity(entity.getInteger("ReelQuantity",new Integer("0")).intValue());
			reel.setShippedQuantity(entity.getInteger("ShipQuantity",new Integer("0")).intValue());
			reel.setCarrier(entity.getString("Shipper",""));
			reel.setTrackingPRO(entity.getString("ProNumber",""));
			return true;
		} else {
			return false;
		}	
	}

	public boolean fillCustomerOrderHdr(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from CustomerOrderHdr where ordno='" + reel.getOrdNo() + "' and PORevision=" + reel.getPORevision();
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("I got Customer Order Hdr");
			Entity entity = datalist.nextEntity();
			reel.setJobCode(entity.getString("Job_ID",""));
			reel.setCustomerPO(entity.getString("CustomerPoNo",""));
			return true;
		} else {
			return false;
		}	
	}

	public boolean fillCustomerOrderDtl(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from CustomerOrderDtl where ordno='" + reel.getOrdNo() + "' and PORevision=" + reel.getPORevision() + " and absoluteitem=" + reel.getAbsoluteItem();
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("I got Customer Order Dtl");
			Entity entity = datalist.nextEntity();
			reel.setCustomerPN(entity.getString("CustPartNo",""));
			reel.setEcsPN(entity.getString("ECSPartNo",""));
			reel.setProjectedShippingDate(entity.getDate("CurrentProjected",null));
			return true;
		} else {
			return false;
		}	
	}

	public boolean fillManufacturer(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select MaintainVendor.* from CustomerOrderHdr,MaintainVendor where CustomerOrderHdr.ordno='" + reel.getOrdNo() + "' and CustomerOrderHdr.PORevision=" + reel.getPORevision() + " and CustomerOrderHdr.VendorCode=MaintainVendor.VendorCode";
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			Entity entity = datalist.nextEntity();
			System.out.println("I got Manufacturer");
			reel.setManufacturer(entity.getString("VendorName",""));
			return true;
		} else {
			return false;
		}	
	}

	public boolean fillCableTrac(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from CableTrac where ECSOrder='" + reel.getOrdNo() + "' and PORevision=" + reel.getPORevision() + " and absoluteitem=" + reel.getAbsoluteItem() + " and reelserial=" + reel.getReelSerial();
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("I got Cable Trac");
			Entity entity = datalist.nextEntity();
			reel.setCTRNumber(entity.getString("CTRNumber",""));
			reel.setCTRDate(entity.getDate("CTRDate",null));
			reel.setCTRSent(entity.getDate("CTRSentDate",null));
			return true;
		} else {
			return false;
		}	
	}

	public CableTechData getCableTech(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from WireMaster where ECSPartNo='" + reel.getEcsPN() + "'";
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("I got Cable Tech");
			Entity entity = datalist.nextEntity();
			CableTechData techData = new CableTechData();
			techData.setEcsPN(entity.getString("ECSPartNo",""));
			techData.setPullTension(entity.getInteger("Cable_PullTension",new Integer("0")).intValue());
			techData.setXSection(entity.getDouble("Cable_XSection",new Double("0")).doubleValue());
			techData.setRadius(entity.getDouble("Cable_Radius",new Double("0")).doubleValue());
			techData.setWeight(entity.getInteger("Cable_Weight",new Integer("0")).intValue());
			techData.setOD(entity.getDouble("Cable_OD",new Double("0")).doubleValue());
			techData.setJacketCompound(entity.getString("Jacket_Compound",""));
			techData.setJacketThickness(entity.getInteger("Jacket_Thickness",new Integer("0")).intValue());
			techData.setShieldType(entity.getString("ShieldType",""));
			techData.setInsulationColor(entity.getString("Insulation_Colorcode",""));
			techData.setInsulationCompound(entity.getString("Insulation_Compound",""));
			techData.setInsulationThickness(entity.getInteger("Insulation_Thickness",new Integer("0")).intValue());
			techData.setConductorGroundSize(entity.getString("Conductor_GroundSize",""));
			techData.setConductorArea(entity.getInteger("Conductor_Area",new Integer("0")).intValue());
			return techData;
		} else {
			return null;
		}	
	}

	
	
	public void closeConnections() throws Exception {
		conECHO.close();
		conRT.close();
	}
	
	public static void main(String[] args) {
		EchoSync echoSync = new EchoSync();
		//String directorToken = args[0];
		try {
			echoSync.pushReels();
			echoSync.closeConnections();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
