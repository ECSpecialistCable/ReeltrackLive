package com.reeltrack.glossary;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class Glossary extends CompCMEntity {
	public static final String PARAM = "glossary_param";
	public static final String NAME_COLUMN = "name";
	public static final String JOB_ID_COLUMN = "job_id";
	public static final String DESCRIPTION_COLUMN = "description";
	public static final String GLOSSARY_TYPE_COLUMN = "glossary_type";

	public static final String[] GLOSSARY_TYPES = {"Check box", "Command Button", "Drop Down Menu", "Editable Field", "List", "Reel Status", "Report", "Scanable Document", "Tab", "Viewable field" };


	@Override
	public String getTableName() {
		return "glossary";
	}

	@Override
	public String getTypeName() {
		return "Glossary";
	}

	public String getSeqTableName() {
		return "glossary_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getName();
	}

	public String getDescription() {
		return this.getData().getString(DESCRIPTION_COLUMN, "");
	}
	
	public void setDescription(String name) {
		this.getData().setString(DESCRIPTION_COLUMN, name);
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

	public String getGlossaryType() {
		return this.getData().getString(GLOSSARY_TYPE_COLUMN, "");
	}

	public void setGlossaryType(String toSet) {
		this.getData().setString(GLOSSARY_TYPE_COLUMN, toSet);
	}
}
