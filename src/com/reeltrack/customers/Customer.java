package com.reeltrack.customers;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class Customer extends CompCMEntity {
	public static final String PARAM = "customer_param";
	public static final String NAME_COLUMN = "name";

	@Override
	public String getTableName() {
		return "customers";
	}

	@Override
	public String getTypeName() {
		return "Customer";
	}

	public String getSeqTableName() {
		return "customers_seq";
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
