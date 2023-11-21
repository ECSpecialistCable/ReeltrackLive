package com.reeltrack.drivers;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class Driver extends CompCMEntity {
	public static final String PARAM = "driver_param";
	public static final String NAME_COLUMN = "name";
	public static final String CUSTOMER_ID_COLUMN = "customer_id";

	@Override
	public String getTableName() {
		return "drivers";
	}

	@Override
	public String getTypeName() {
		return "Drivers";
	}

	public String getSeqTableName() {
		return "drivers_seq";
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
