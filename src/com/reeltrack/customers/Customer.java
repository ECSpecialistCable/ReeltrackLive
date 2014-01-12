package com.reeltrack.customers;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class Customer extends CompCMEntity {
	public static final String PARAM = "customer_param";
	public static final String NAME_COLUMN = "name";
	public static final String ISSUE_CONTACT_EMAIL_COLUMN = "issue_contact_email";

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

	public String getIssueContactEmail() {
		return this.getData().getString(ISSUE_CONTACT_EMAIL_COLUMN, "");
	}
	
	public void setIssueContactEmail(String name) {
		this.getData().setString(ISSUE_CONTACT_EMAIL_COLUMN, name);
	}
}
