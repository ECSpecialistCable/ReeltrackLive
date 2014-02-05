package com.reeltrack.glossary;

import com.monumental.trampoline.component.CompWebManager;
import com.monumental.trampoline.datasources.DbResources;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import javax.servlet.jsp.PageContext;

public class GlossaryImporter extends CompWebManager {

	GlossaryMgr glossaryMgr;

	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
		glossaryMgr = new GlossaryMgr();
		glossaryMgr.init(pageContext, resources);
	}

	public void getContents(File aFile) throws Exception {
		try {
			BufferedReader input = new BufferedReader(new FileReader(aFile));
			try {
				String line = null; //not declared within while loop
				while ((line = input.readLine()) != null) {
					// replace all consicutive , to one ,
					//line = line.replaceAll("(,)(\\1{2,})", "$,");
					String splitted[] = line.split(",");
					StringBuffer sb = new StringBuffer();
					String retrieveData = "";
					for(int i =0; i<splitted.length; i++){
						retrieveData = splitted[i];
						if((retrieveData.trim()).length()>0){

							if(i!=0){
								sb.append(",");
							}
							sb.append(retrieveData);

						}
					}

					line = sb.toString();

					//System.out.println("line after replacing");
					//System.out.println("----" + line);

					String contents[] = line.split(",");
					if (contents.length >= 3) {
						String name = contents[0];
						String desc = contents[1];
						String type = contents[2];
						//System.out.println("----"+ name + " " + desc + " " + type);
						if(name.length()>0) {
							Glossary content = new Glossary();
							content.setJobId(0);
							content.setName(name);
							content.setDescription(desc);
							content.setGlossaryType(type);
							content.setStatus(Glossary.STATUS_ACTIVE);

							glossaryMgr.addGlossary(content);
						}
					}
				}
			} finally {
				input.close();
			}
		} catch (IOException ex) {
			ex.printStackTrace();
		}
	}
}
