package com.reeltrack.file_cabinets;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class FileCabinet extends CompCMEntity {
	public static final String PARAM = "file_cabinet_param";
	public static final String TITLE_COLUMN = "title";
	public static final String JOB_ID_COLUMN = "job_id";
	public static final String FILE_NAME_COLUMN = "file_name";
	public static final String CUSTOMER_ID_COLUMN = "customer_id";

	@Override
	public String getTableName() {
		return "file_cabinet";
	}

	@Override
	public String getTypeName() {
		return "File Cabinet";
	}

	public String getSeqTableName() {
		return "file_cabinet_seq";
	}

	public int getCustomerId() {
		return this.getData().getInteger(CUSTOMER_ID_COLUMN, new Integer(0));
    }

    public void setCustomerId(int id) {
		this.getData().setInteger(CUSTOMER_ID_COLUMN, new Integer(id));
    }

	public String getFileName() {
		return this.getData().getString(FILE_NAME_COLUMN, "");
	}
	
	public void setFileName(String name) {
		this.getData().setString(FILE_NAME_COLUMN, name);
	}
	
	public String getTitle() {
		return this.getData().getString(TITLE_COLUMN, "");
	}
	
	public void setTitle(String title) {
		this.getData().setString(TITLE_COLUMN, title);
	}

	public int getJobId() {
		return this.getData().getInteger(JOB_ID_COLUMN, new Integer(0));
    }

    public void setJobId(int id) {
		this.getData().setInteger(JOB_ID_COLUMN, new Integer(id));
    }	
}
