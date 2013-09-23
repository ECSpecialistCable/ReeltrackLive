package com.reeltrack.customers;

import com.reeltrack.users.RTUser;
import com.monumental.trampoline.component.CompEntity;
import com.monumental.trampoline.component.CompEntityLink;

public class CustomerJobToRTUser extends CompEntityLink {
    
	@Override
	public CompEntity newCompEntity() {
		return new CustomerJob();
	}

	@Override
	public CompEntity newRefCompEntity() {
		return new RTUser();
	}

	@Override
	public String getTableName() {
		return "customer_jobs_to_users";
	}

	@Override
	public String getTypeName() {
		return "Customer Jobs to Users Link";
	}

	public String getSeqTableName() {
		return "customerjobs_to_users_seq";
	}
	
}
