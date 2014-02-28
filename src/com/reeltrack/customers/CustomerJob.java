package com.reeltrack.customers;

import com.monumental.trampoline.component.CompCMEntity;

public class CustomerJob extends CompCMEntity {
	public static final String PARAM = "customer_job_param";
	public static final String NAME_COLUMN = "name";
	public static final String CODE_COLUMN = "code";
	public static final String CUSTOMER_ID_COLUMN = "customer_id";
	public static final String AUTO_PRINT_REEL_TAG_COLUMN = "auto_print_reel_tags";
	public static final String BOM_PDF_COLUMN = "bom_pdf";

	@Override
	public String getTableName() {
		return "customer_jobs";
	}

	@Override
	public String getTypeName() {
		return "Customer Job";
	}

	public String getSeqTableName() {
		return "customer_jobs_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getName();
	}
	
	public int getCustomerId() {
		return this.getData().getInteger(CUSTOMER_ID_COLUMN, 0);
	}
	
	public void setCustomerId(int id) {
		this.getData().setInteger(CUSTOMER_ID_COLUMN, id);
	}
	
	public String getName() {
		return this.getData().getString(NAME_COLUMN, "");
	}
	
	public void setName(String note) {
		this.getData().setString(NAME_COLUMN, note);
	}

	public String getCode() {
		return this.getData().getString(CODE_COLUMN, "");
	}
	
	public void setCode(String note) {
		this.getData().setString(CODE_COLUMN, note);
	}

	public String getAutoPrintReelTags() {
		return this.getData().getString(AUTO_PRINT_REEL_TAG_COLUMN, "");
	}
	
	public void setAutoPrintReelTags(String name) {
		this.getData().setString(AUTO_PRINT_REEL_TAG_COLUMN, name);
	}

	public boolean shouldAutoPrintReelTags() {
		boolean toReturn = false;
		if(this.getAutoPrintReelTags().equalsIgnoreCase("y")) {
			toReturn = true;	
		}
		return toReturn;
	}

	public String getBOMPdf() {
		return this.getData().getString(BOM_PDF_COLUMN, "");
	}

	public void setBOMPdf(String note) {
		this.getData().setString(BOM_PDF_COLUMN, note);
	}
}
