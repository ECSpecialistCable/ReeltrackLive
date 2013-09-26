package com.reeltrack.settings;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class Settings extends CompCMEntity {
	public static final String PARAM = "settings_param";
	public static final String AUTO_PRINT_REEL_TAG_COLUMN = "auto_print_reel_tags";
	public static final String CUSTOMER_ID_COLUMN = "customer_id";

	@Override
	public String getTableName() {
		return "settings";
	}

	@Override
	public String getTypeName() {
		return "Settings";
	}

	public String getSeqTableName() {
		return "settings_seq";
	}
	
	@Override
	public String getTitle() {
		return "Settings";
	}

	public int getCustomerId() {
		return this.getData().getInteger(CUSTOMER_ID_COLUMN, new Integer(0));
    }

    public void setCustomerId(int id) {
		this.getData().setInteger(CUSTOMER_ID_COLUMN, new Integer(id));
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
}
