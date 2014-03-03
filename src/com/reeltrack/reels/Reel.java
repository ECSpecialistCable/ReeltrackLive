package com.reeltrack.reels;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.*;
import com.monumental.trampoline.component.Positionable;
import com.reeltrack.utilities.ContentPositionable;

public class Reel extends ContentPositionable implements Positionable {
	public static final String PARAM = "reel_param";
	public static final String CR_ID_COLUMN = "cr_id";
	public static final String JOB_ID_COLUMN = "job_id";
	public static final String JOB_CODE_COLUMN = "job_code";
	public static final String WHAREHOUSE_LOCATION_COLUMN = "wharehouse_location";
	public static final String REEL_TYPE_COLUMN = "reel_type";
	public static final String REEL_TAG_COLUMN = "reel_tag";
	public static final String CABLE_DESCRIPTION_COLUMN = "cable_description";
	public static final String CUSTOMER_PO_COLUMN = "customer_po";
	public static final String CUSTOMER_PN_COLUMN = "customer_pn";
	public static final String ECS_PN_COLUMN = "ecs_pn";
	public static final String MANUFACTURER_COLUMN = "manufacturer";
	public static final String STEEL_REEL_SERIAL_COLUMN = "steel_reel_serial";
	public static final String RECEIVED_ON_COLUMN = "received_on";
	public static final String TIMES_CHECKED_OUT_COLUMN = "times_checked_out";
	public static final String TIMES_CHECKED_IN_COLUMN = "times_checked_in";
	public static final String CARRIER_COLUMN = "carrier";
	public static final String TRACKING_PRO_COLUMN = "tracking_pro";
	public static final String PACKING_LIST_COLUMN = "packing_list";
	public static final String PROJECTED_SHIPPING_DATE_COLUMN = "projected_shipping_date";
	public static final String SHIPPING_DATE_COLUMN = "shipping_date";
	public static final String RECEIVING_ISSUE_COLUMN = "receiving_issue";
	public static final String RECEIVING_NOTE_COLUMN = "receiving_note";
	public static final String RECEIVING_DISPOSITION_COLUMN = "receiving_disposition";
	public static final String ORDERED_QUANTITY_COLUMN = "ordered_quantity";
	public static final String SHIPPED_QUANTITY_COLUMN = "shipped_quantity";
	public static final String RECEIVED_QUANTITY_COLUMN = "received_quantity";
	public static final String BOTTOM_FOOT_COLUMN = "bottom_foot";
	public static final String TOP_FOOT_COLUMN = "top_foot";
	public static final String CABLE_USED_QUANTITY_COLUMN = "cable_used_quantity";
	public static final String PICK_LIST_ID_COLUMN = "pick_list_id";
	public static final String ON_REEL_QUANTITY_COLUMN = "on_reel_quantity";
	public static final String CTR_NUMBER_COLUMN = "ctr_number";
	public static final String CTR_DATE_COLUMN = "ctr_date";
	public static final String CTR_SENT_COLUMN = "ctr_sent";
	public static final String CTR_FILE_COLUMN = "ctr_file";
	public static final String RT_QRCODE_FILE_COLUMN = "rt_qrcode_file";
	public static final String PL_QRCODE_FILE_COLUMN = "pl_qrcode_file";
	public static final String REEL_TAG_FILE_COLUMN = "reel_tag_file";
	public static final String HAS_REEL_TAG_FILE_COLUMN = "has_reel_tag_file";
	public static final String HAS_REEL_MARKERS_COLUMN = "has_reel_markers";
	public static final String RECEIVED_WEIGHT_COLUMN = "received_weight";
	public static final String CURRENT_WEIGHT_COLUMN = "current_weight";
	public static final String INVOICE_NUM_COLUMN = "ECSInvoice";
	public static final String INVOICE_DATE_COLUMN = "ECSInvoiceDate";
	public static final String IS_STEEL_REEL_COLUMN = "is_steel_reel";
	public static final String BOTTOM_FOOT_NOT_VISIBLE_COLUMN = "bottom_foot_not_visible";
	public static final String UNIQUE_ID_COLUMN = "UniqueID";

	public static final String PN_VOLT_COLUMN = "pn_volt";
	public static final String PN_GAUGE_COLUMN = "pn_gauge";
	public static final String PN_CONDUCTOR_COLUMN = "pn_conductor";

	public static final String ORDNO_COLUMN = "OrdNo";
	public static final String POREVISION_COLUMN = "PORevision";
	public static final String ABSOLUTEITEM_COLUMN = "AbsoluteItem";
	public static final String REELSERIAL_COLUMN = "ReelSerial";

	public static final String STATUS_ORDERED = "ordered";
	public static final String STATUS_SHIPPED = "shipped";
	public static final String STATUS_REFUSED = "refused";
	public static final String STATUS_IN_WHAREHOUSE = "in warehouse";
	public static final String STATUS_STAGED = "staged";
	public static final String STATUS_CHECKED_OUT = "checked out";
	public static final String STATUS_COMPLETE = "complete";
	public static final String STATUS_SCRAPPED = "scrapped";
	public static final String STATUS_RECEIVED = "received";

	public static final String CARRIER_UPS = "UPS";
	public static final String CARRIER_DHL = "DHL";
	public static final String CARRIER_FEDEX = "FEDEX";

	public static final String RECEIVING_ISSUE_NONE = "none";
	public static final String RECEIVING_ISSUE_DAMAGED = "damaged";
	public static final String RECEIVING_ISSUE_INCORRECT_TOLERANCE = "incorrect tolerance";
	public static final String RECEIVING_ISSUE_INCORRECT_REEL_MARK = "incorrect reel mark";

	public static final String MANUFACTURER_ONE = "Manufacturer One";
	public static final String MANUFACTURER_TWO = "Manufacturer Two";

	public static final String REEL_TYPE_BULK = "bulk";
	public static final String REEL_TYPE_CIRCUIT = "circuits assigned";

	public static final String CALC_TYPE_MARKER = "marker";
	public static final String CALC_TYPE_WEIGHT = "weight";
	public static final String CALC_TYPE_LENGTH = "length";

	public static final String RECEIVING_DISPOSITION_ACCEPTED = "accepted";
	public static final String RECEIVING_DISPOSITION_REFUSED = "refused";

	private int temp_pull_amount = 0;

	private int reelsCountBOM = 0;
	private int reelsOrderedBOM = 0;

	@Override
	public String getTableName() {
		return "reels";
	}

	@Override
	public String getTypeName() {
		return "Reels";
	}

	public String getSeqTableName() {
		return "reels_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getReelTag();
	}

	public int getPosition() {
        return this.getData().getInteger(POSITION_COLUMN, new Integer(0));
    }

    public void setPosition(int i) {
        this.getData().setInteger(POSITION_COLUMN, new Integer(i));
    }

    public void setForeignKeyId(int fkID) {
        this.setPickListId(fkID);
    }

    public int getForeignKeyId() {
        return this.getPickListId();
    }

	public int getId() {
        return this.getData().getInteger(ID_COLUMN, new Integer(0));
    }

    public void setId(int id) {
        this.getData().setInteger(ID_COLUMN, new Integer(id));
    }

	public int getEstimatedOnReelQty() {
		int quantity = 0;
		if(this.getStatus().equals(STATUS_ORDERED)) {
			quantity = this.getOrderedQuantity();	
		} else if(this.getStatus().equals(STATUS_SHIPPED)) {
			quantity = this.getShippedQuantity();
		} else {
			quantity = this.getOnReelQuantity();
		}
		return quantity;
	}

	public boolean isCalcType(String calcType) {
		boolean matches = false;
		String tmpType = CALC_TYPE_LENGTH;
		if(this.hasReelMarkers()) {
			tmpType = CALC_TYPE_MARKER;
		} else if(this.getReceivedWeight()>0) {
			tmpType = CALC_TYPE_WEIGHT;
		}
		if(calcType.equals(tmpType)) {
			matches = true;
		}
		return matches;
	}

	public String getReelTagDirectory() {
		String directory = "";
		directory = this.getCompProperties().getComponentDirectory(this.getConfiguration());
		directory += "/reeltags/";
		directory += this.getJobCode();
		return directory;
	}

	public String getIsSteelReel() {
		return this.getData().getString(IS_STEEL_REEL_COLUMN, "");
	}
	
	public void setIsSteelReel(String name) {
		this.getData().setString(IS_STEEL_REEL_COLUMN, name);
	}

	public String getInvoiceNum() {
		return this.getData().getString(INVOICE_NUM_COLUMN, "");
	}
	
	public void setInvoiceNum(String name) {
		this.getData().setString(INVOICE_NUM_COLUMN, name);
	}

	public Date getInvoiceDate() {
        return (Date) this.getData().getValue(INVOICE_DATE_COLUMN, null);
    }

    public void setInvoiceDate(Date toSet) {
        this.getData().setTimestamp(INVOICE_DATE_COLUMN, toSet);
    }

	public void setInvoiceDateString(String toSet) {
		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        try {
            Date date = df.parse(toSet);
			this.setInvoiceDate(date);
       	} catch (Exception e) {
       		System.out.print(e.toString());
       	}
    }

    public String getInvoiceDateString() {
		if(this.getInvoiceDate() == null) {
			return "";
		} else {
			SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        	return df.format(this.getInvoiceDate());
		}
    }

	public String getPnVolt() {
		return this.getData().getString(PN_VOLT_COLUMN, "");
	}
	
	public void setPnVolt(String name) {
		this.getData().setString(PN_VOLT_COLUMN, name);
	}

	public String getPnGauge() {
		return this.getData().getString(PN_GAUGE_COLUMN, "");
	}
	
	public void setPnGauge(String name) {
		this.getData().setString(PN_GAUGE_COLUMN, name);
	}

	public String getPnConductor() {
		return this.getData().getString(PN_CONDUCTOR_COLUMN, "");
	}
	
	public void setPnConductor(String name) {
		this.getData().setString(PN_CONDUCTOR_COLUMN, name);
	}

	public String getCTRFile() {
		return this.getData().getString(CTR_FILE_COLUMN, "");
	}
	
	public void setCTRFile(String name) {
		this.getData().setString(CTR_FILE_COLUMN, name);
	}

	public String getCTRNumber() {
		return this.getData().getString(CTR_NUMBER_COLUMN, "");
	}
	
	public void setCTRNumber(String name) {
		this.getData().setString(CTR_NUMBER_COLUMN, name);
	}

	public Date getCTRDate() {
        return (Date) this.getData().getValue(CTR_DATE_COLUMN, null);
    }

    public void setCTRDate(Date toSet) {
        this.getData().setTimestamp(CTR_DATE_COLUMN, toSet);
    }

    public String getCTRDateString() {
		if(this.getCTRDate() == null) {
			return "";
		} else {
			SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        	return df.format(this.getCTRDate());
		}
    }

   	public Date getCTRSent() {
        return (Date) this.getData().getValue(CTR_SENT_COLUMN, null);
    }

    public void setCTRSent(Date toSet) {
        this.getData().setTimestamp(CTR_SENT_COLUMN, toSet);
    }

    public String getCTRSentString() {
		if(this.getCTRSent() == null) {
			return "";
		} else {
			SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        	return df.format(this.getCTRSent());
		}
    }

	public String getOrdNo() {
		return this.getData().getString(ORDNO_COLUMN, "");
	}
	
	public void setOrdNo(String name) {
		this.getData().setString(ORDNO_COLUMN, name);
	}

	public int getPORevision() {
		return this.getData().getInteger(POREVISION_COLUMN, new Integer(0));
    }

    public void setPORevision(int id) {
		this.getData().setInteger(POREVISION_COLUMN, new Integer(id));
    }

	public int getAbsoluteItem() {
		return this.getData().getInteger(ABSOLUTEITEM_COLUMN, new Integer(0));
    }

    public void setAbsoluteItem(int id) {
		this.getData().setInteger(ABSOLUTEITEM_COLUMN, new Integer(id));
    }

	public int getReelSerial() {
		return this.getData().getInteger(REELSERIAL_COLUMN, new Integer(0));
    }

    public void setReelSerial(int id) {
		this.getData().setInteger(REELSERIAL_COLUMN, new Integer(id));
    }



	public void setTempPullAmount(int amount) {
		this.temp_pull_amount = amount;	
	}

	public int getTempPullAmount() {
		return this.temp_pull_amount;
	}

	public String[] getDispositionList() {
		String[] statuses = {RECEIVING_DISPOSITION_ACCEPTED,RECEIVING_DISPOSITION_REFUSED};
		return statuses;
	}

	public String[] getManufacturerList() {
		String[] statuses = {MANUFACTURER_ONE,MANUFACTURER_TWO};
		return statuses;
	}

	public String[] getReceivingIssueList() {
		String[] statuses = {RECEIVING_ISSUE_DAMAGED,RECEIVING_ISSUE_INCORRECT_TOLERANCE,RECEIVING_ISSUE_INCORRECT_REEL_MARK};
		return statuses;
	}

	public String[] getCarrierList() {
		String[] statuses = {CARRIER_UPS,CARRIER_DHL,CARRIER_FEDEX};
		return statuses;
	}

	public String[] getStatusList() {
		String[] statuses = {STATUS_ORDERED,STATUS_SHIPPED,STATUS_REFUSED,STATUS_IN_WHAREHOUSE,STATUS_STAGED,STATUS_CHECKED_OUT,STATUS_COMPLETE,STATUS_SCRAPPED};
		return statuses;
	}

	public int getCrId() {
		return this.getData().getInteger(CR_ID_COLUMN, new Integer(0));
    }

    public void setCrId(int id) {
		this.getData().setInteger(CR_ID_COLUMN, new Integer(id));
    }

	public int getJobId() {
		return this.getData().getInteger(JOB_ID_COLUMN, new Integer(0));
    }

    public void setJobId(int id) {
		this.getData().setInteger(JOB_ID_COLUMN, new Integer(id));
    }

	public String getJobCode() {
		return this.getData().getString(JOB_CODE_COLUMN, "");
	}
	
	public void setJobCode(String name) {
		this.getData().setString(JOB_CODE_COLUMN, name);
	}

	public String getWharehouseLocation() {
		return this.getData().getString(WHAREHOUSE_LOCATION_COLUMN, "");
	}
	
	public void setWharehouseLocation(String name) {
		this.getData().setString(WHAREHOUSE_LOCATION_COLUMN, name);
	}
	
	public String getReelType() {
		return this.getData().getString(REEL_TYPE_COLUMN, "");
	}
	
	public void setReelType(String name) {
		this.getData().setString(REEL_TYPE_COLUMN, name);
	}

	public String getReelTag() {
		return this.getData().getString(REEL_TAG_COLUMN, "");
	}
	
	public void setReelTag(String name) {
		this.getData().setString(REEL_TAG_COLUMN, name);
	}

	public String getCableDescription() {
		return this.getData().getString(CABLE_DESCRIPTION_COLUMN, "");
	}

	public String getCableDescriptionEscaped() {
		if(this.getCableDescription().contains(" & ")) {
			return (this.getCableDescription().replaceAll(" & ", " "));
		}
		return this.getCableDescription();
	}
	
	public void setCableDescription(String name) {
		this.getData().setString(CABLE_DESCRIPTION_COLUMN, name);
	}

	public String getCustomerPO() {
		return this.getData().getString(CUSTOMER_PO_COLUMN, "");
	}
	
	public void setCustomerPO(String name) {
		this.getData().setString(CUSTOMER_PO_COLUMN, name);
	}

	public String getCustomerPN() {
		return this.getData().getString(CUSTOMER_PN_COLUMN, "");
	}
	
	public void setCustomerPN(String name) {
		this.getData().setString(CUSTOMER_PN_COLUMN, name);
	}

	public String getEcsPN() {
		return this.getData().getString(ECS_PN_COLUMN, "");
	}
	
	public void setEcsPN(String name) {
		this.getData().setString(ECS_PN_COLUMN, name);
	}

	public String getManufacturerEscaped() {
		if(this.getManufacturer().contains(" & ")) {
			return (this.getManufacturer().replaceAll(" & ", " "));
		}
		return this.getCableDescription();
	}

	public String getManufacturer() {
		return this.getData().getString(MANUFACTURER_COLUMN, "");
	}
	
	public void setManufacturer(String name) {
		this.getData().setString(MANUFACTURER_COLUMN, name);
	}

	public String getSteelReelSerial() {
		return this.getData().getString(STEEL_REEL_SERIAL_COLUMN, "");
	}
	
	public void setSteelReelSerial(String name) {
		this.getData().setString(STEEL_REEL_SERIAL_COLUMN, name);
	}

	public Date getReceivedOnDate() {
        return (Date) this.getData().getValue(RECEIVED_ON_COLUMN, null);
    }

    public void setReceivedOnDate(Date toSet) {
        this.getData().setTimestamp(RECEIVED_ON_COLUMN, toSet);
    }

    public String getReceivedOnDateString() {
		if(this.getReceivedOnDate() == null) {
			return "";
		} else {
			SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        	return df.format(this.getReceivedOnDate());
		}
    }

	public int getTimesCheckedOut() {
		return this.getData().getInteger(TIMES_CHECKED_OUT_COLUMN, new Integer(0));
    }

    public void setTimesCheckedOut(int id) {
		this.getData().setInteger(TIMES_CHECKED_OUT_COLUMN, new Integer(id));
    }

	public int getTimesCheckedIn() {
		return this.getData().getInteger(TIMES_CHECKED_IN_COLUMN, new Integer(0));
    }

    public void setTimesCheckedIn(int id) {
		this.getData().setInteger(TIMES_CHECKED_IN_COLUMN, new Integer(id));
    }

	public String getCarrier() {
		return this.getData().getString(CARRIER_COLUMN, "");
	}
	
	public void setCarrier(String name) {
		this.getData().setString(CARRIER_COLUMN, name);
	}

	public String getTrackingPRO() {
		return this.getData().getString(TRACKING_PRO_COLUMN, "");
	}
	
	public void setTrackingPRO(String name) {
		this.getData().setString(TRACKING_PRO_COLUMN, name);
	}

	public String getPackingList() {
		return this.getData().getString(PACKING_LIST_COLUMN, "");
	}
	
	public void setPackingList(String name) {
		this.getData().setString(PACKING_LIST_COLUMN, name);
	}

	public Date getProjectedShippingDate() {
        return (Date) this.getData().getValue(PROJECTED_SHIPPING_DATE_COLUMN, null);
    }

    public void setProjectedShippingDate(Date toSet) {
        this.getData().setTimestamp(PROJECTED_SHIPPING_DATE_COLUMN, toSet);
    }

    public String getProjectedShippingDateString() {
		if(this.getProjectedShippingDate() == null) {
			return "";
		} else {
			SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        	return df.format(this.getProjectedShippingDate());
		}
    }

	public void setProjectedShippingDateString(String toSet) {
		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        try {
            Date date = df.parse(toSet);
			this.setProjectedShippingDate(date);
       	} catch (Exception e) {
       		System.out.print(e.toString());
       	}
    }

	public Date getShippingDate() {
        return (Date) this.getData().getValue(SHIPPING_DATE_COLUMN, null);
    }

    public void setShippingDate(Date toSet) {
        this.getData().setTimestamp(SHIPPING_DATE_COLUMN, toSet);
    }

    public String getShippingDateString() {
		if(this.getShippingDate() == null) {
			return "";
		} else {
			SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        	return df.format(this.getShippingDate());
		}
    }

	public void setShippingDateString(String toSet) {
		SimpleDateFormat df = new SimpleDateFormat("MM/dd/yyyy");
        try {
            Date date = df.parse(toSet);
			this.setShippingDate(date);
       	} catch (Exception e) {
       		System.out.print(e.toString());
       	}
    }

	public String getReceivingIssue() {
		return this.getData().getString(RECEIVING_ISSUE_COLUMN, "");
	}
	
	public void setReceivingIssue(String name) {
		this.getData().setString(RECEIVING_ISSUE_COLUMN, name);
	}

	public String getReceivingNote() {
		return this.getData().getString(RECEIVING_NOTE_COLUMN, "");
	}
	
	public void setReceivingNote(String name) {
		this.getData().setString(RECEIVING_NOTE_COLUMN, name);
	}

	public String getReceivingDisposition() {
		return this.getData().getString(RECEIVING_DISPOSITION_COLUMN, "");
	}
	
	public void setReceivingDisposition(String name) {
		this.getData().setString(RECEIVING_DISPOSITION_COLUMN, name);
	}

	public int getOrderedQuantity() {
		return this.getData().getInteger(ORDERED_QUANTITY_COLUMN, new Integer(0));
    }

    public void setOrderedQuantity(int id) {
		this.getData().setInteger(ORDERED_QUANTITY_COLUMN, new Integer(id));
    }

   	public int getShippedQuantity() {
		return this.getData().getInteger(SHIPPED_QUANTITY_COLUMN, new Integer(0));
    }

    public void setShippedQuantity(int id) {
		this.getData().setInteger(SHIPPED_QUANTITY_COLUMN, new Integer(id));
    }

   	public int getReceivedQuantity() {
		return this.getData().getInteger(RECEIVED_QUANTITY_COLUMN, new Integer(0));
    }

    public void setReceivedQuantity(int id) {
		this.getData().setInteger(RECEIVED_QUANTITY_COLUMN, new Integer(id));
    }

   	public int getReceivedWeight() {
		return this.getData().getInteger(RECEIVED_WEIGHT_COLUMN, new Integer(0));
    }

    public void setReceivedWeight(int id) {
		this.getData().setInteger(RECEIVED_WEIGHT_COLUMN, new Integer(id));
    }

   	public int getCurrentWeight() {
		return this.getData().getInteger(CURRENT_WEIGHT_COLUMN, new Integer(0));
    }

    public void setCurrentWeight(int id) {
		this.getData().setInteger(CURRENT_WEIGHT_COLUMN, new Integer(id));
    }

   	public int getBottomFoot() {
		return this.getData().getInteger(BOTTOM_FOOT_COLUMN, new Integer(0));
    }

    public void setBottomFoot(int id) {
		this.getData().setInteger(BOTTOM_FOOT_COLUMN, new Integer(id));
    }

   	public int getTopFoot() {
		return this.getData().getInteger(TOP_FOOT_COLUMN, new Integer(0));
    }

    public void setTopFoot(int id) {
		this.getData().setInteger(TOP_FOOT_COLUMN, new Integer(id));
    }

   	public int getCableUsedQuantity() {
		return this.getData().getInteger(CABLE_USED_QUANTITY_COLUMN, new Integer(0));
    }

    public void setCableUsedQuantity(int id) {
		this.getData().setInteger(CABLE_USED_QUANTITY_COLUMN, new Integer(id));
    }

   	public int calcOnReelQuantity(int weight) {
   		if(this.hasReelMarkers()) {
   			System.out.println("setting qnty by markers");
   			if(this.getTopFoot()==0) {
   				return 0;
   			} else if(this.getTopFoot() > this.getBottomFoot()) {
   				return this.getTopFoot() - this.getBottomFoot();
   			} else {
   				return this.getBottomFoot() - this.getTopFoot();
   			}
   		} else if(this.getReceivedWeight()!=0) {
   			if(weight==0) weight=1;
   			System.out.println("setting qnty by weight: " + this.getReceivedWeight() + "-" + this.getCurrentWeight() + "/" +  weight);
			return (this.getReceivedWeight() - this.getCurrentWeight()) * 1000 / weight;
		} else {
			System.out.println("setting qnty by manual");
			return this.getReceivedQuantity() - this.getCableUsedQuantity();
		}
    }

   	public int getUniqueId() {
		return this.getData().getInteger(UNIQUE_ID_COLUMN, new Integer(0));
    }

    public void setUniqueId(int id) {
		this.getData().setInteger(UNIQUE_ID_COLUMN, new Integer(id));
    }

   	public int getOnReelQuantity() {
		return this.getData().getInteger(ON_REEL_QUANTITY_COLUMN, new Integer(0));
    }

    public void setOnReelQuantity(int id) {
		this.getData().setInteger(ON_REEL_QUANTITY_COLUMN, new Integer(id));
    }

	public int getPickListId() {
		return this.getData().getInteger(PICK_LIST_ID_COLUMN, new Integer(0));
    }

    public void setPickListId(int id) {
		this.getData().setInteger(PICK_LIST_ID_COLUMN, new Integer(id));
    }
    
	public String getRtQrCodeFile() {
		return this.getData().getString(RT_QRCODE_FILE_COLUMN, "");
	}
	
	public void setRtQrCodeFile(String name) {
		this.getData().setString(RT_QRCODE_FILE_COLUMN, name);
	}
	
	public String getPlQrCodeFile() {
		return this.getData().getString(PL_QRCODE_FILE_COLUMN, "");
	}
	
	public void setPlQrCodeFile(String name) {
		this.getData().setString(PL_QRCODE_FILE_COLUMN, name);
	}

	public String getReelTagFile() {
		return this.getData().getString(REEL_TAG_FILE_COLUMN, "");
	}
	
	public void setReelTagFile(String name) {
		this.getData().setString(REEL_TAG_FILE_COLUMN, name);
	}

	public String getHasReelTagFile() {
		return this.getData().getString(HAS_REEL_TAG_FILE_COLUMN, "");
	}
	
	public void setHasReelTagFile(String name) {
		this.getData().setString(HAS_REEL_TAG_FILE_COLUMN, name);
	}

	public boolean hasReelTagFile() {
		if(this.getHasReelTagFile().equals("y")) {
			return true;
		} else {
			return false;
		}
	}

	public String getHasReelMarkers() {
		return this.getData().getString(HAS_REEL_MARKERS_COLUMN, "");
	}
	
	public void setHasReelMarkers(String name) {
		this.getData().setString(HAS_REEL_MARKERS_COLUMN, name);
	}

	public boolean hasReelMarkers() {
		if(this.getHasReelMarkers().equals("y")) {
			return true;
		} else {
			return false;
		}
	}

	public String getBottomFootNotVisible() {
		return this.getData().getString(BOTTOM_FOOT_NOT_VISIBLE_COLUMN, "");
	}
	
	public void setBottomFootNotVisible(String name) {
		this.getData().setString(BOTTOM_FOOT_NOT_VISIBLE_COLUMN, name);
	}

	public boolean hasBottomFootNotVisible() {
		if(this.getBottomFootNotVisible().equals("y")) {
			return true;
		} else {
			return false;
		}
	}

	public static String convertPnVolt(String volt) {
		HashMap theMap = new HashMap();
		theMap.put("16","161 KV Cable");
		theMap.put("69","69KV Cable");
		theMap.put("46","46KV Cable");
		theMap.put("35","35KV Cable");
		theMap.put("28","28KV Cable");
		theMap.put("25","25KV Cable");
		theMap.put("15","15KV Cable");
		theMap.put("08","8KV Cable");
		theMap.put("05","5KV Cable");
		theMap.put("24","2.4KV Cable");
		theMap.put("01","1KV Cable");
		theMap.put("02","601V - 2KV Cable");
		theMap.put("06","600V Cable");
		theMap.put("03","300V Cable");
		theMap.put("04","Communication Cable");
		theMap.put("00","Bare Conductor");
		theMap.put("80","Electronic");
		theMap.put("90","Cable Specials");
		theMap.put("94","Non-Cable Items");
		theMap.put("CS","Cable Service");
		theMap.put("C6","Composite 600V");
		theMap.put("C1","Composite 1KV");
		theMap.put("C2","Composite 2KV");
		return (String)theMap.get(volt);
	}

	public static String convertPnGauge(String gauge) {
		HashMap theMap = new HashMap();
		theMap.put("200","2000 kcmil");
		theMap.put("175","1750 kcmil");
		theMap.put("155","1550 kcmil");
		theMap.put("150","1500 kcmil");
		theMap.put("125","1250/1252 kcmil");
		theMap.put("100","1000 kcmil");
		theMap.put("777","777 kcmil");
		theMap.put("750","750 kcmil");
		theMap.put("646=","DLO 646 kcmil");
		theMap.put("600","600 kcmil");
		theMap.put("535","DLO 535 kcmil");
		theMap.put("500","500 kcmil");
		theMap.put("400","400 kcmil");
		theMap.put("444","DLO 444 kcmil");
		theMap.put("350","350 kcmil");
		theMap.put("300","300 kcmil");
		theMap.put("250","250 kcmil");
		theMap.put("4/0","4/0 Gauge");
		theMap.put("3/0","3/0 Gauge");
		theMap.put("2/0","2/0 Gauge");
		theMap.put("1/0","1/0 Gauge");
		theMap.put("001","1 Gauge");
		theMap.put("002","2 Gauge");
		theMap.put("003","3 Gauge");
		theMap.put("004","4 Gauge");
		theMap.put("006","6 Gauge");
		theMap.put("008","8 Gauge");
		theMap.put("010","10 Gauge");
		theMap.put("012","12 Gauge");
		theMap.put("014","14 Gauge");
		theMap.put("016","16 Gauge");
		theMap.put("018","18 Gauge");
		theMap.put("019","19 Gauge");
		theMap.put("020","20 Gauge");
		theMap.put("022","22 Gauge");
		theMap.put("024","24 Gauge");
		theMap.put("MM","Multimode Fiber Optic");
		theMap.put("SM","Single Mode Fiber Optic");
		theMap.put("CP","Composite Fiber");
		theMap.put("023","Cat 6");
		String toReturn = (String)theMap.get(gauge);
		if(toReturn != null) {
			return toReturn;
		} else {
			return "";
		}
	}

	public void setReelsCountForBOM(int count) {
		this.reelsCountBOM = count;
	}

	public int getReelsCountForBOM() {
		return this.reelsCountBOM;
	}

	public void setReelsOrderedForBOM(int count) {
		this.reelsOrderedBOM = count;
	}

	public int getReelsOrderedForBOM() {
		return this.reelsOrderedBOM;
	}
}
