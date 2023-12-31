package com.reeltrack.reels;

import com.monumental.trampoline.component.CompCMEntity;
import com.monumental.trampoline.component.Positionable;

public class ReelCircuit extends CompCMEntity implements Positionable {
	public static final String PARAM = "reel_log_param";
	public static final String REEL_ID_COLUMN = "reel_id";
	public static final String LENGTH_COLUMN = "length";
	public static final String ACT_LENGTH_COLUMN = "act_length";
	public static final String NAME_COLUMN = "name";
	public static final String IS_PULLED_COLUMN = "is_pulled";
	public static final String IS_SYNCED_COLUMN = "is_synced";
	public static final String MAX_TENSION_COLUMN = "max_tension";
	public static final String KIND_COLUMN = "kind";
	public static final String MARKER_COLUMN = "marker";

	public String tmpReelTag = "";
	public int tmpReelTop = 0;

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

	public String getKind() {
		return this.getData().getString(KIND_COLUMN, "");
	}

	public void setKind(String note) {
		this.getData().setString(KIND_COLUMN, note);
	}

	public int getPosition() {
		return this.getData().getInteger(POSITION_COLUMN, 0);
	}

	public void setPosition(int position) {
		this.getData().setInteger(POSITION_COLUMN, position);
	}

	public int getReelId() {
		return this.getData().getInteger(REEL_ID_COLUMN, 0);
	}

	public void setReelId(int id) {
		this.getData().setInteger(REEL_ID_COLUMN, id);
	}

	public int getMaxTension() {
		return this.getData().getInteger(MAX_TENSION_COLUMN, 0);
	}

	public void setMaxTension(int id) {
		this.getData().setInteger(MAX_TENSION_COLUMN, id);
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

	public int getMarker() {
		return this.getData().getInteger(MARKER_COLUMN, 0);
	}

	public void setMarker(int id) {
		this.getData().setInteger(MARKER_COLUMN, id);
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
