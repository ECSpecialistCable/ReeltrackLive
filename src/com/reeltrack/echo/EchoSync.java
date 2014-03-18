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
	Connection conTRANS;
	Connection conRT;
	CompDbController controllerECHO = null;
	CompDbController controllerRT = null;
	CompDbController controllerTRANS = null;
	
	public EchoSync() {
		try {
			props = new CompProperties();
			Class.forName(props.getProperty("databaseDriver"));
			conECHO = DriverManager.getConnection(props.getProperty("dbConnectionECHO"), props.getProperty("dbUserECHO"), props.getProperty("dbPasswordECHO"));
			this.controllerECHO = new CompDbController(conECHO);
			conRT = DriverManager.getConnection(props.getProperty("dbConnectionRT"), props.getProperty("dbUserRT"), props.getProperty("dbPasswordRT"));
			this.controllerRT = new CompDbController(conRT);
			conTRANS = DriverManager.getConnection(props.getProperty("dbConnectionTRANS"), props.getProperty("dbUserTRANS"), props.getProperty("dbPasswordTRANS"));
			this.controllerTRANS = new CompDbController(conTRANS);
	    } catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void pushReels() throws Exception {
		System.out.println("##### STARTING REEL PUSH: " + new Date().toString() + " #####");
		String queryString = "";
		DbProcessor processor = new DbProcessor(conTRANS);
		// alter table echo_reel_transactions add column notes varchar(255);
		//queryString = "alter table echo_reel_transactions modify synced_date datetime";
		//processor.runUpdate(queryString);
		queryString = "update echo_reel_transactions set reel_id=0 where synced_date='0000-00-00 00:00:00'";
		processor.runUpdate(queryString);
		queryString = "update echo_reel_transactions set synced_date=null where synced_date='0000-00-00 00:00:00'";
		processor.runUpdate(queryString);
		
		CompEntityPuller puller = new CompEntityPuller(new EchoTransaction());
		EchoTransaction echoTrans = new EchoTransaction();
		echoTrans.setReelId(0);
		puller.addSearch(echoTrans);
		puller.setSortBy(echoTrans.getTableName(), EchoTransaction.ID_COLUMN, true);
		CompEntities echoTranses = controllerTRANS.pullCompEntities(puller, 0, 0);
		System.out.println("Total transactions:" + echoTranses.howMany());
		for(int x=0; x<echoTranses.howMany(); x++) {
			echoTrans = (EchoTransaction)echoTranses.get(x);
			if(echoTrans.getUniqueId()==0) continue;
			if(echoTrans.getAction().equalsIgnoreCase("add")) {
				Reel reel = new Reel();
				reel.setUniqueId(echoTrans.getUniqueId());
				System.out.println("Reel to ADD:" + reel.getUniqueId());
				CompEntityPuller uPuller = new CompEntityPuller(reel);
				uPuller.addSearch(reel);
				Reel cloudReel = (Reel)controllerRT.pullCompEntity(uPuller);
				if(cloudReel.hasData() && cloudReel.getId()!=0) {
					echoTrans.setReelId(cloudReel.getId());
					echoTrans.setSyncedDateDate(new Date());
					echoTrans.setNote("Reel already exists in ReelTrack");
					this.updateTransaction(echoTrans);
					System.out.println("REEL ALREADY EXISTS ON REELTRACK:" + cloudReel.getUniqueId());
				} else {
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
						this.fillDescription(reel);
						CableTechData techData = this.getCableTech(reel);
						reel.setCrId(this.searchReelsCount(reel)+1);
						reel.setPnVolt(reel.getEcsPN().substring(0,2));
						reel.setPnGauge(reel.getEcsPN().substring(4,7));
						reel.setPnConductor(reel.getEcsPN().substring(7,9));
						this.addReel(echoTrans,reel,techData);
						System.out.println("Added reel:" + reel.getUniqueId());
					} else {
						echoTrans.setReelId(-1);
						echoTrans.setSyncedDateDate(new Date());
						echoTrans.setNote("Reel not found in ECHO");
						this.updateTransaction(echoTrans);
						System.out.println("COULDN'T GET ECHO REEL:" + reel.getUniqueId());
					}
				}
			} else if(echoTrans.getAction().equalsIgnoreCase("update")) {
				Reel reel = new Reel();
				reel.setUniqueId(echoTrans.getUniqueId());
				System.out.println("Reel to UPDATE:" + reel.getUniqueId());
				CompEntityPuller uPuller = new CompEntityPuller(reel);
				uPuller.addSearch(reel);
				Reel cloudReel = (Reel)controllerRT.pullCompEntity(uPuller);
				if(!cloudReel.hasData() || cloudReel.getId()==0) {
					System.out.println("Reel to UPDATE (no unique id, trying by old method):" + reel.getUniqueId());
					cloudReel = new Reel();
					cloudReel.setOrdNo(echoTrans.getOrdNo());
					cloudReel.setPORevision(echoTrans.getPORevision());
					cloudReel.setAbsoluteItem(echoTrans.getAbsoluteItem());
					cloudReel.setReelSerial(echoTrans.getReelSerial());
					uPuller = new CompEntityPuller(cloudReel);
					uPuller.addSearch(cloudReel);
					cloudReel = (Reel)controllerRT.pullCompEntity(uPuller);
				}
				if(cloudReel.hasData() && cloudReel.getId()!=0) {
					cloudReel.setUniqueId(echoTrans.getUniqueId());
					cloudReel.setOrdNo(echoTrans.getOrdNo());
					cloudReel.setPORevision(echoTrans.getPORevision());
					cloudReel.setAbsoluteItem(echoTrans.getAbsoluteItem());
					cloudReel.setReelSerial(echoTrans.getReelSerial());
					boolean ok = this.fillReelAllocation(cloudReel);
					if(ok) {
						this.fillCustomerOrderHdr(cloudReel);
						this.fillCustomerOrderDtl(cloudReel);
						this.fillManufacturer(cloudReel);
						this.fillCableTrac(cloudReel);
						this.fillDescription(cloudReel);
						cloudReel.setPnVolt(cloudReel.getEcsPN().substring(0,2));
						cloudReel.setPnGauge(cloudReel.getEcsPN().substring(4,7));
						cloudReel.setPnConductor(cloudReel.getEcsPN().substring(7,9));
						this.updateReel(echoTrans,cloudReel);
						System.out.println("Updated reel:" + cloudReel.getUniqueId());
					} else {
						echoTrans.setReelId(-1);
						echoTrans.setSyncedDateDate(new Date());
						echoTrans.setNote("Reel not found in ECHO");
						this.updateTransaction(echoTrans);
						System.out.println("COULDN'T GET ECHO REEL:" + reel.getUniqueId());
					}
				} else {
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
						this.fillDescription(reel);
						CableTechData techData = this.getCableTech(reel);
						reel.setCrId(this.searchReelsCount(reel)+1);
						reel.setPnVolt(reel.getEcsPN().substring(0,2));
						reel.setPnGauge(reel.getEcsPN().substring(4,7));
						reel.setPnConductor(reel.getEcsPN().substring(7,9));
						this.addReel(echoTrans,reel,techData);
						System.out.println("Added reel:" + reel.getUniqueId());
					} else {
						echoTrans.setReelId(-1);
						echoTrans.setSyncedDateDate(new Date());
						echoTrans.setNote("Reel not found in ECHO");
						this.updateTransaction(echoTrans);
						System.out.println("COULDN'T GET ECHO REEL:" + reel.getUniqueId());
					}
					//echoTrans.setReelId(-1);
					//echoTrans.setSyncedDateDate(new Date());
					//echoTrans.setNote("Reel not found in ReelTrack");
					//this.updateTransaction(echoTrans);
					//System.out.println("COULDN'T GET REELTRACK REEL");
				}
			} else if(echoTrans.getAction().equalsIgnoreCase("delete")) {
				Reel reel = new Reel();
				reel.setUniqueId(echoTrans.getUniqueId());
				System.out.println("Reel to DELETE:" + reel.getUniqueId());
				CompEntityPuller uPuller = new CompEntityPuller(reel);
				uPuller.addSearch(reel);
				reel = (Reel)controllerRT.pullCompEntity(uPuller);
				if(reel.hasData() && reel.getId()!=0) {
					this.deleteReel(echoTrans,reel);
					System.out.println("Deleted Reel:" + reel.getUniqueId());
				} else {
					echoTrans.setReelId(-1);
					echoTrans.setSyncedDateDate(new Date());
					echoTrans.setNote("Reel not found in ReelTrack");
					this.updateTransaction(echoTrans);
					System.out.println("COULDN'T GET REELTRACK REEL");
				}
			}
		}
		System.out.println("##### ENDING REEL PUSH: " + new Date().toString() + " #####\n\n\n");
	}

	public void pullCircuits() throws Exception {
		CompEntityPuller puller = new CompEntityPuller(new ReelCircuit());
		ReelCircuit circuit = new ReelCircuit();
		circuit.setIsSynced("n");
		puller.addSearch(circuit);
		CompEntities circuits = controllerRT.pullCompEntities(puller, 0, 0);
		for(int x=0; x<circuits.howMany(); x++) {
			circuit = (ReelCircuit)circuits.get(x);
			//see if exists
			boolean exists = false;
			EchoCircuit eCircuit = new EchoCircuit();
			eCircuit.setId(circuit.getId());
			puller = new CompEntityPuller(eCircuit);
			puller.addSearch(eCircuit);
			eCircuit = (EchoCircuit)controllerECHO.pullCompEntity(puller);
			if(eCircuit.hasData() && eCircuit.getId()!=0) {
				exists = true;
			}
			//fill the eCircuit with circuit data.
			eCircuit.setSyncedDate(new Date());
			eCircuit.setId(circuit.getId());
			eCircuit.setCreated(circuit.getCreated());
			eCircuit.setUpdated(circuit.getUpdated());
			eCircuit.setReelId(circuit.getReelId());
			eCircuit.setLength(circuit.getLength());
			eCircuit.setName(circuit.getName());
			eCircuit.setIsPulled(circuit.getIsPulled());
			//fill the eCurcuit reel info
			Reel reel = new Reel();
			reel.setId(circuit.getReelId());
			puller = new CompEntityPuller(reel);
			puller.addSearch(reel);
			reel = (Reel)controllerRT.pullCompEntity(puller);
			eCircuit.setOrdNo(reel.getOrdNo());
			eCircuit.setPORevision(reel.getPORevision());
			eCircuit.setAbsoluteItem(reel.getAbsoluteItem());
			eCircuit.setReelSerial(reel.getReelSerial());
			//add or update
			if(exists) {
				controllerECHO.update(eCircuit);
			} else {
				controllerECHO.add(eCircuit);
			}

			ReelCircuit circuit2 = new ReelCircuit();
			circuit2.setId(circuit.getId());
			circuit2.setIsSynced("y");
			controllerRT.update(circuit2);
		}
	}

	public void updateTransaction(EchoTransaction echoTrans) throws Exception {
		controllerTRANS.update(echoTrans);
	}

	public void addReel(EchoTransaction echoTrans, Reel reel, CableTechData techData) throws Exception {
		reel.setCreated(new Date());
		reel.setStatus(Reel.STATUS_ORDERED);
		if(reel.getShippedQuantity()>0) {
			reel.setStatus(Reel.STATUS_SHIPPED);
		}
		int toReturn = controllerRT.add(reel);

		CableTechData techData2 = new CableTechData();
		techData2.setJobCode(reel.getJobCode());
		techData2.setEcsPN(reel.getEcsPN());
		CompEntityPuller puller = new CompEntityPuller(new CableTechData());
		puller.addSearch(techData2);
		techData2 = (CableTechData)controllerRT.pullCompEntity(puller);

		if(techData2==null || !techData2.hasData()) {
			techData.setJobCode(reel.getJobCode());
			int toReturnTD = controllerRT.add(techData);
		}

		echoTrans.setSyncedDateDate(new Date());
		echoTrans.setReelId(toReturn);
		echoTrans.setNote("Reel Added");
		controllerTRANS.update(echoTrans);
	}

	public void updateReel(EchoTransaction echoTrans, Reel reel) throws Exception {
		reel.setUpdated(new Date());
		//reel.setStatus(Reel.STATUS_ORDERED);
		controllerRT.update(reel);

		echoTrans.setSyncedDateDate(new Date());
		echoTrans.setReelId(reel.getId());
		echoTrans.setNote("Reel Updated");
		controllerTRANS.update(echoTrans);
	}

	public void deleteReel(EchoTransaction echoTrans, Reel reel) throws Exception {
		Reel reel2 = new Reel();
		reel2.setId(reel.getId());
		controllerRT.delete(null,reel2);

		echoTrans.setSyncedDateDate(new Date());
		echoTrans.setReelId(reel.getId());
		echoTrans.setNote("Reel Deleted");
		controllerTRANS.update(echoTrans);
	}

	public int searchReelsCount(Reel content) throws Exception {
		Reel reel = new Reel();
		reel.setJobCode(content.getJobCode());
		CompEntityPuller puller = new CompEntityPuller(reel);
		puller.addSearch(reel);
		return controllerRT.pullCompEntitiesCount(puller);
	}

	public boolean fillReelAllocation(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from ReelAllocation where UniqueID=" + reel.getUniqueId();
		System.out.println(queryString);
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("--Allocation");
			Entity entity = datalist.nextEntity();
			reel.setReelTag(entity.getString("ReelTag",""));
			reel.setOrderedQuantity(entity.getInteger("ReelQuantity",new Integer("0")).intValue());
			reel.setShippedQuantity(entity.getInteger("ShipQuantity",new Integer("0")).intValue());
			reel.setShippingDate(entity.getDate("ShipDate",null));
			reel.setCarrier(entity.getString("Shipper",""));
			reel.setTrackingPRO(entity.getString("ProNumber",""));
			Boolean steel = (Boolean)entity.getValue("SteelReel",new Boolean(false));
			if(steel) {
				reel.setIsSteelReel("y");
			} else {
				reel.setIsSteelReel("n");
			}
			return true;
		} else {
			System.out.println("--NO Allocation");
			return false;
		}	
	}

	public boolean fillCustomerOrderHdr(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from CustomerOrderHdr where ordno='" + reel.getOrdNo() + "' and PORevision=" + reel.getPORevision();
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("--Order Header");
			Entity entity = datalist.nextEntity();
			reel.setJobCode(entity.getString("Job_ID",""));
			reel.setCustomerPO(entity.getString("CustomerPoNo",""));
			return true;
		} else {
			System.out.println("--NO Order Header");
			return false;
		}	
	}

	public boolean fillCustomerOrderDtl(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from CustomerOrderDtl where ordno='" + reel.getOrdNo() + "' and PORevision=" + reel.getPORevision() + " and absoluteitem=" + reel.getAbsoluteItem();
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("--Order Detail");
			Entity entity = datalist.nextEntity();
			reel.setCustomerPN(entity.getString("CustPartNo",""));
			reel.setEcsPN(entity.getString("ECSPartNo",""));
			reel.setProjectedShippingDate(entity.getDate("CurrentProjected",null));
			return true;
		} else {
			System.out.println("--NO Order Detail");
			return false;
		}	
	}

	public boolean fillManufacturer(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select MaintainVendor.* from CustomerOrderHdr,MaintainVendor where CustomerOrderHdr.ordno='" + reel.getOrdNo() + "' and CustomerOrderHdr.PORevision=" + reel.getPORevision() + " and CustomerOrderHdr.VendorCode=MaintainVendor.VendorCode";
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("--Manufacturer");
			Entity entity = datalist.nextEntity();
			reel.setManufacturer(entity.getString("VendorName",""));
			return true;
		} else {
			System.out.println("--NO Manufacturer");
			return false;
		}	
	}

	public boolean fillCableTrac(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from CableTrac where UniqueID=" + reel.getUniqueId();
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("--Cable Trac");
			Entity entity = datalist.nextEntity();
			reel.setCTRNumber(entity.getString("CTRNumber",""));
			reel.setCTRDate(entity.getDate("CTRDate",null));
			reel.setCTRSent(entity.getDate("CTRSentDate",null));
			reel.setInvoiceNum(entity.getString("ECSInvoice",""));
			reel.setInvoiceDate(entity.getDate("ECSInvoiceDate",null));
			return true;
		} else {
			System.out.println("--NO Cable Trac");
			return false;
		}	
	}

	public boolean fillDescription(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from WireMaster where ECSPartNo='" + reel.getEcsPN() + "'";
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("--Description");
			Entity entity = datalist.nextEntity();
			reel.setCableDescription(entity.getString("ShortDescription",""));
			return true;
		} else {
			System.out.println("--NO Description");
			return false;
		}	
	}

	public CableTechData getCableTech(Reel reel) throws Exception {
		DbProcessor processor = new DbProcessor(conECHO);
		String queryString = "select * from WireMaster where ECSPartNo='" + reel.getEcsPN() + "'";
		EntityList datalist = processor.getRows(queryString);
		if(datalist.hasNext()) {
			System.out.println("--Cable Tech");
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
			techData.setEstAlWeight(entity.getInteger("Estimated_AlWeight",new Integer("0")).intValue());
			techData.setEstCuWeight(entity.getInteger("Estimated_CuWeight",new Integer("0")).intValue());
			techData.setConAlWeight(entity.getInteger("Conductor_AlWeight",new Integer("0")).intValue());
			techData.setConCuWeight(entity.getInteger("Conductor_CuWeight",new Integer("0")).intValue());
			return techData;
		} else {
			System.out.println("--NO Cable Tech");
			return null;
		}	
	}

	
	
	public void closeConnections() throws Exception {
		conECHO.close();
		conRT.close();
		conTRANS.close();
	}
	
	public static void main(String[] args) {
		EchoSync echoSync = new EchoSync();
		//String directorToken = args[0];
		try {
			echoSync.pushReels();
			//echoSync.pullCircuits();
			echoSync.closeConnections();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
