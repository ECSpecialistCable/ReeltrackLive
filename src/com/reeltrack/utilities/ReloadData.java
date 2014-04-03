package com.reeltrack.utilities;

public class ReloadData {

	public static void reloadData(String command) throws Exception {
		Process p = Runtime.getRuntime().exec(command);
	}

}