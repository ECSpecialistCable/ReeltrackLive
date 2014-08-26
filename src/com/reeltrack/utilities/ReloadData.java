package com.reeltrack.utilities;

public class ReloadData {

	public static void reloadData(String command) throws Exception {
		Process runtimeProcess = Runtime.getRuntime().exec(new String[]{"/bin/sh","-c",command});
		int processComplete = runtimeProcess.waitFor();
		if(processComplete == 0){

		System.out.println("success");

		} else {

		System.out.println("restore failure");

		}
	}

}