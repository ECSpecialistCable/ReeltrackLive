package com.reeltrack.reels;

import com.monumental.trampoline.component.CompCMEntity;

public class ReelCircuit extends CompCMEntity {
	public static final String PARAM = "reel_log_param";
	public static final String REEL_ID_COLUMN = "reel_id";
	public static final String LENGTH_COLUMN = "length";
	public static final String ACT_LENGTH_COLUMN = "act_length";
	public static final String NAME_COLUMN = "name";
	public static final String IS_PULLED_COLUMN = "is_pulled";
	public static final String IS_SYNCED_COLUMN = "is_synced";

	public String tmpReelTag = "";

	@Override
	public String getTableName() {
		return "reel_circuits";
	}

	@Override
	public String getTypeName() {
		return "Reel Circuit";
	}

	public String getSeqTableName() {
		return "reel_circuits_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getName();
	}
	
	public int getReelId() {
		return this.getData().getInteger(REEL_ID_COLUMN, 0);
	}
	
	public void setReelId(int id) {
		this.getData().setInteger(REEL_ID_COLUMN, id);
	}
	
	public int getLength() {
		return this.getData().getInteger(LENGTH_COLUMN, 0);
	}
	
	public void setLength(int id) {
		this.getData().setInteger(LENGTH_COLUMN, id);
	}

	public int getActLength() {
		return this.getData().getInteger(ACT_LENGTH_COLUMN, 0);
	}
	
	public void setActLength(int id) {
		this.getData().setInteger(ACT_LENGTH_COLUMN, id);
	}

	public String getName() {
		return this.getData().getString(NAME_COLUMN, "");
	}
	
	public void setName(String note) {
		this.getData().setString(NAME_COLUMN, note);
	}

	public String getIsPulled() {
		return this.getData().getString(IS_PULLED_COLUMN, "");
	}
	
	public void setIsPulled(String note) {
		this.getData().setString(IS_PULLED_COLUMN, note);
	}

	public boolean isPulled() {
		if(this.getIsPulled().equalsIgnoreCase("y")) {
			return true;
		} else {
			return false;
		}
	}

	public String getIsSynced() {
		return this.getData().getString(IS_SYNCED_COLUMN, "");
	}
	
	public void setIsSynced(String note) {
		this.getData().setString(IS_SYNCED_COLUMN, note);
	}
}
