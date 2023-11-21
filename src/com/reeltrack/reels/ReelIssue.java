package com.reeltrack.reels;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;

public class ReelIssue extends CompCMEntity {
	public static final String PARAM = "reel_log_param";
	public static final String REEL_ID_COLUMN = "reel_id";
	public static final String CREATED_BY_COLUMN = "created_by";
	public static final String DESCRIPTION_COLUMN = "description";
	public static final String ISSUE_LOG_COLUMN = "issue_log";
	public static final String IS_RESOLVED_COLUMN = "is_resolved";

	@Override
	public String getTableName() {
		return "reel_issues";
	}

	@Override
	public String getTypeName() {
		return "Reel Issue";
	}

	public String getSeqTableName() {
		return "reel_issues_seq";
	}
	
	@Override
	public String getTitle() {
		return this.getDescription();
	}
	
	public int getReelId() {
		return this.getData().getInteger(REEL_ID_COLUMN, 0);
	}
	
	public void setReelId(int id) {
		this.getData().setInteger(REEL_ID_COLUMN, id);
	}

	public String getCreatedString() {
		Date created = this.getCreated();
		if(created!=null) {
			return new SimpleDateFormat("MM/dd/yyyy").format(created);
		} else {
			return "";
		}
	}

	public String getCreatedBy() {
		return this.getData().getString(CREATED_BY_COLUMN, "");
	}
	
	public void setCreatedBy(String createdBy) {
		this.getData().setString(CREATED_BY_COLUMN, createdBy);
	}

	public String getDescription() {
		return this.getData().getString(DESCRIPTION_COLUMN, "");
	}
	
	public void setDescription(String note) {
		this.getData().setString(DESCRIPTION_COLUMN, note);
	}

	public String getIssueLog() {
		return this.getData().getString(ISSUE_LOG_COLUMN, "");
	}
	
	public void setIssueLog(String note) {
		this.getData().setString(ISSUE_LOG_COLUMN, note);
	}

	public String getIsResolved() {
		return this.getData().getString(IS_RESOLVED_COLUMN, "");
	}
	
	public void setIsResolved(String note) {
		this.getData().setString(IS_RESOLVED_COLUMN, note);
	}

	public boolean isResolved() {
		if(this.getIsResolved().equalsIgnoreCase("y")) {
			return true;
		} else {
			return false;
		}
	}
}
