package com.reeltrack.users;

import com.monumental.trampoline.security.*;

public class RTUser extends User {

	public static final String CUSTOMER_ID_COLUMN = "customer_id";

	// USER TYPE static strings
	public static final String USER_TYPE_ECS = "ecs";
    public static final String USER_TYPE_MANAGEMENT = "management";
    public static final String USER_TYPE_STANDARD = "standard";

    private int jobID = 0;

    public String getTableName() {
        return "users";
    }

    public String getSeqTableName() {
        return "users_seq";
    }

    public String getTypeName() {
        return "ECS User";
    }

	public int getCustomerId() {
		return this.getData().getInteger(CUSTOMER_ID_COLUMN, new Integer(0));
    }

    public void setCustomerId(int id) {
		this.getData().setInteger(CUSTOMER_ID_COLUMN, new Integer(id));
    }
	
	public String getCompEntityDirectory() {
		return this.getComponentDirectory() + "/" + this.getId();
	}

    public int getJobId() {
        return this.jobID;
    }

    public void setJobId(int jobID) {
        this.jobID = jobID;
    }
}
