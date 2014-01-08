package com.reeltrack.reels;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.Hashtable;

public class CircuitReader {

	Hashtable toReturn = new Hashtable();
	public Hashtable getContents(File aFile) {
		try {
			BufferedReader input = new BufferedReader(new FileReader(aFile));
			try {
				String line = null; //not declared within while loop
				while ((line = input.readLine()) != null) {
					String contents[] = line.split(",");
					if (contents.length >= 2) {
						String name = contents[0];
						String length = contents[1];
						try {
							System.out.println(name + " " + length);							
							toReturn.put(name, Integer.parseInt(length));
						} catch(Exception e) {
							System.out.println("length is not integer "+length);
						}
					}
				}
			} finally {
				input.close();
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}
		return toReturn;
	}
}
