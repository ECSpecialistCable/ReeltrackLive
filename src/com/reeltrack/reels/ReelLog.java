package com.reeltrack.reels;

import com.monumental.trampoline.component.CompCMEntity;

public class ReelLog extends CompCMEntity {
	public static final String PARAM = "reel_log_param";
	public static final String REEL_ID_COLUMN = "reel_id";
	public static final String CREATED_BY_COLUMN = "created_by";
	public static final String NOTE_COLUMN = "note";
	public static final String ON_REEL_QUANTITY_COLUMN = "on_reel_quantity";
	public static final String TOP_FOOT_COLUMN = "top_foot";

	@Override
	public String getTableName() {
		return "reel_logs";
	}

	@Override
	public String getTypeName() {
		return "Reel Log";
	}

	public String getSeqTableName() {
		return "reel_logs_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getNote();
	}

   	public int getOnReelQuantity() {
		return this.getData().getInteger(ON_REEL_QUANTITY_COLUMN, new Integer(0));
    }

    public void setOnReelQuantity(int id) {
		this.getData().setInteger(ON_REEL_QUANTITY_COLUMN, new Integer(id));
    }

   	public int getTopFoot() {
		return this.getData().getInteger(TOP_FOOT_COLUMN, new Integer(0));
    }

    public void setTopFoot(int id) {
		this.getData().setInteger(TOP_FOOT_COLUMN, new Integer(id));
    }
	
	public int getReelId() {
		return this.getData().getInteger(REEL_ID_COLUMN, 0);
	}
	
	public void setReelId(int id) {
		this.getData().setInteger(REEL_ID_COLUMN, id);
	}
	
	public String getCreatedBy() {
		return this.getData().getString(CREATED_BY_COLUMN, "");
	}
	
	public void setCreatedBy(String createdBy) {
		this.getData().setString(CREATED_BY_COLUMN, createdBy);
	}

	public String getNote() {
		return this.getData().getString(NOTE_COLUMN, "");
	}
	
	public void setNote(String note) {
		this.getData().setString(NOTE_COLUMN, note);
	}
}
