package com.reeltrack.drivers;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class Driver extends CompCMEntity {
	public static final String PARAM = "driver_param";
	public static final String NAME_COLUMN = "name";

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
}
