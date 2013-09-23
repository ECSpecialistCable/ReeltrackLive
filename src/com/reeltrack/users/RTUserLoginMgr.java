package com.reeltrack.users;

import com.monumental.trampoline.security.*;

public class RTUserLoginMgr extends UserLoginMgr {

    public RTUserLoginMgr() {}

    public User newUser() {
        return new RTUser();
    }

    public SecurityMgr newSecurityMgr() {
        return new RTUserMgr();
    }
	
}
	
