package com.reeltrack.users;

import com.monumental.trampoline.security.*;
import com.reeltrack.customers.*;
import com.monumental.trampoline.component.CompDbController;
import com.monumental.trampoline.datasources.DbResources;

public class RTUserMgr extends SecurityMgr {
    
    //CompDbController controller = null;

    public RTUserMgr() {}
    
    public User newUser() {
        return new RTUser();
    }

    public void init(DbResources resources, String configuration) {
        super.init(resources,configuration);
        //this.controller = this.newCompController();
    }

    protected void cleanupUser(User user, String realRootContextPath) throws Exception {
        CustomerJobToRTUser cTu = new CustomerJobToRTUser();
        cTu.setRefCompEntityId(user.getId());
        this.getCompController().deleteLinks(cTu);

        super.cleanupUser(user,realRootContextPath);
    }
	
}
	
