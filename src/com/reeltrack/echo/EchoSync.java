package com.reeltrack.echo;

import java.io.*;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.Date;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.*;

public class EchoSync extends CompManager {
	private CompProperties props;
	Connection conECHO;
	Connection conRT;
	CompDbController controllerECHO = null;
	CompDbController controllerRT = null;
	
	public EchoSync() {
		try {
			props = new CompProperties();
			Class.forName(props.getProperty("databaseDriver"));
			conECHO = DriverManager.getConnection(props.getProperty("dbConnectionECHO"), props.getProperty("dbUserECHO"), props.getProperty("dbPasswordECHO"));
			this.controllerECHO = new CompDbController(conECHO);
			conRT = DriverManager.getConnection(props.getProperty("dbConnectionRT"), props.getProperty("dbUserRT"), props.getProperty("dbPasswordRT"));
			this.controllerRT = new CompDbController(conRT);
	    } catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public void pushReels() throws Exception {
		System.out.println("Starting the reel push");
	}
	
	public void closeConnections() throws Exception {
		conECHO.close();
		conRT.close();
	}
	
	public static void main(String[] args) {
		EchoSync echoSync = new EchoSync();
		//String directorToken = args[0];
		try {
			echoSync.pushReels();
			echoSync.closeConnections();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
}
