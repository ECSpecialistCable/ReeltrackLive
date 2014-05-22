package com.reeltrack.users;

import com.monumental.trampoline.security.*;

public class RTUser extends User {

	public static final String CUSTOMER_ID_COLUMN = "customer_id";

	// USER TYPE static strings
	public static final String USER_TYPE_ECS = "ecs";
    public static final String USER_TYPE_MANAGEMENT = "management";
    public static final String USER_TYPE_STANDARD = "standard";
    public static final String USER_TYPE_INVENTORY = "CableTrac";
    public static final String USER_TYPE_CPE = "cpe";

    private int jobID = 0;
    private String jobCode = "";
    private String customer_name = "";
    private String jobName = "";

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

    public String getJobCode() {
        return this.jobCode;
    }

    public void setJobCode(String jobCode) {
        this.jobCode = jobCode;
    }

    public String getJobName() {
        return this.jobName;
    }

    public void setJobName(String jobName) {
        this.jobName = jobName;
    }

    public String getCustomerName() {
        return this.customer_name;
    }

    public void setCustomerName(String customer_name) {
        this.customer_name = customer_name;
    }
}
