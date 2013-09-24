package com.reeltrack.whlocations;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class WhLocation extends CompCMEntity {
	public static final String PARAM = "whlocation_param";
	public static final String NAME_COLUMN = "name";

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
}
