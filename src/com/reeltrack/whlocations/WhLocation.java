package com.reeltrack.whlocations;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class WhLocation extends CompCMEntity {
	public static final String PARAM = "whlocation_param";
	public static final String NAME_COLUMN = "name";
	public static final String CUSTOMER_ID_COLUMN = "customer_id";

	public static final String LOCATION_NONE = "N/A";
	public static final String LOCATION_STAGED = "Staged";

	@Override
	public String getTableName() {
		return "whlocations";
	}

	@Override
	public String getTypeName() {
		return "Warehouse Locations";
	}

	public String getSeqTableName() {
		return "whlocations_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getName();
	}
	
	public String getName() {
		return this.getData().getString(NAME_COLUMN, "");
	}
	
	public void setName(String name) {
		this.getData().setString(NAME_COLUMN, name);
	}

	public int getCustomerId() {
		return this.getData().getInteger(CUSTOMER_ID_COLUMN, new Integer(0));
    }

    public void setCustomerId(int id) {
		this.getData().setInteger(CUSTOMER_ID_COLUMN, new Integer(id));
    }
}
