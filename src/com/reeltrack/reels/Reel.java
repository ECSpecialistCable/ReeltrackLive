package com.reeltrack.reels;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class Reel extends CompCMEntity {
	public static final String PARAM = "reel_param";
	public static final String JOB_ID_COLUMN = "job_id";
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
	public static final String RECEIVING_ISSUE_COLUMN = "receiving_issue";
	public static final String RECEIVING_NOTE_COLUMN = "receiving_note";
	public static final String RECEIVING_DISPOSITION_COLUMN = "receiving_disposition";
	public static final String ORDERED_QUANTITY_COLUMN = "ordered_quantity";
	public static final String SHIPPED_QUANTITY_COLUMN = "shipped_quantity";
	public static final String RECEIVED_QUANTITY_COLUMN = "received_quantity";
	public static final String BOTTOM_FOOT_COLUMN = "bottom_foot";
	public static final String TOP_FOOT_COLUMN = "top_foot";
	public static final String CABLE_USED_QUANTITY_COLUMN = "cable_used_quantity";

	public static final String STATUS_ORDERED = "ordered";
	public static final String STATUS_SHIPPED = "shipped";
	public static final String STATUS_REFUSED = "refused";
	public static final String STATUS_IN_WHAREHOUSE = "in_wharehouse";
	public static final String STATUS_STAGED = "staged";
	public static final String STATUS_CHECKED_OUT = "checked_out";
	public static final String STATUS_COMPLETE = "complete";
	public static final String STATUS_SCRAPPED = "scrapped";

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

	public static final String RECEIVING_DISPOSITION_ACCEPTED = "accepted";
	public static final String RECEIVING_DISPOSITION_REFUSED = "refused";

	private int temp_pull_amount = 0;

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

	public int getJobId() {
		return this.getData().getInteger(JOB_ID_COLUMN, new Integer(0));
    }

    public void setJobId(int id) {
		this.getData().setInteger(JOB_ID_COLUMN, new Integer(id));
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

   	public int getOnReelQuantity() {
   		if(this.getTopFoot()!=0) {
   			return this.getTopFoot() - this.getBottomFoot();
   		} else {
			return this.getReceivedQuantity() - this.getCableUsedQuantity();
		}
    }
}
