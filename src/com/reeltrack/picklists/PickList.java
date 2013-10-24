package com.reeltrack.picklists;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class PickList extends CompCMEntity {
	public static final String PARAM = "foreman_param";
	public static final String NAME_COLUMN = "name";
	public static final String JOB_ID_COLUMN = "job_id";
	public static final String JOB_CODE_COLUMN = "job_code";
	public static final String FOREMAN_COLUMN = "foreman";
	public static final String DRIVER_COLUMN = "driver";

	//public static final String STATUS_NEW = "new";
	public static final String STATUS_PARTIAL_STAGED = "partial staged";
	public static final String STATUS_STAGED = "staged";
	public static final String STATUS_PARTIAL_PICKED_UP = "partial picked up";
	public static final String STATUS_PICKED_UP = "picked up";

	@Override
	public String getTableName() {
		return "picklists";
	}

	@Override
	public String getTypeName() {
		return "PickList";
	}

	public String getSeqTableName() {
		return "picklists_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getName();
	}

	public String getJobCode() {
		return this.getData().getString(JOB_CODE_COLUMN, "");
	}
	
	public void setJobCode(String name) {
		this.getData().setString(JOB_CODE_COLUMN, name);
	}
	
	public String getName() {
		return this.getData().getString(NAME_COLUMN, "");
	}
	
	public void setName(String name) {
		this.getData().setString(NAME_COLUMN, name);
	}

	public int getJobId() {
		return this.getData().getInteger(JOB_ID_COLUMN, new Integer(0));
    }

    public void setJobId(int id) {
		this.getData().setInteger(JOB_ID_COLUMN, new Integer(id));
    }

	public String getForeman() {
		return this.getData().getString(FOREMAN_COLUMN, "");
	}
	
	public void setForeman(String name) {
		this.getData().setString(FOREMAN_COLUMN, name);
	}

	public String getDriver() {
		return this.getData().getString(DRIVER_COLUMN, "");
	}
	
	public void setDriver(String name) {
		this.getData().setString(DRIVER_COLUMN, name);
	}
}
