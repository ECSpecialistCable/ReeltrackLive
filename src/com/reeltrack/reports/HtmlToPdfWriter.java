package com.reeltrack.reports;

//import com.itextpdf.text.Document;
//import com.itextpdf.text.pdf.PdfWriter;
import com.monumental.trampoline.datasources.DbResources;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringBufferInputStream;
import java.net.MalformedURLException;
import java.net.URL;
import javax.servlet.jsp.PageContext;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;

import org.xhtmlrenderer.pdf.ITextRenderer;
import org.xhtmlrenderer.resource.FSEntityResolver;

public class HtmlToPdfWriter {

	public HtmlToPdfWriter(PageContext pageContext, DbResources resources) {
		
	}

	public ByteArrayOutputStream writePdf(String basePath, String pageToGet) throws Exception {
		// buffering and reading
		URL urlToGet;
		InputStream is = null;
		BufferedReader br;
		String line;

		StringBuilder buf = new StringBuilder();
		try {
			urlToGet = new URL(pageToGet);
			is = urlToGet.openStream();  // throws an IOException
			br = new BufferedReader(new InputStreamReader(is,"UTF8"));            
							
			while ((line = br.readLine()) != null) {
				line = line.replace(" & ", " &amp; ");
				buf.append(line);
				//System.out.println(line);
			}
		} catch (MalformedURLException mue) {
			 mue.printStackTrace();
		} catch (IOException ioe) {
			 ioe.printStackTrace();
		} finally {
			try {
				if (is != null) is.close();
			} catch (IOException ioe) {
				// nothing to see here
			}
		}

		DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		builder.setEntityResolver(FSEntityResolver.instance());
		Document doc = builder.parse(new StringBufferInputStream(buf.toString()));

		ITextRenderer renderer = new ITextRenderer();
		renderer.setDocument(doc, null);

		ByteArrayOutputStream os = new ByteArrayOutputStream();

		
        //renderer.setDocumentFromString(content);
		
		renderer.layout();
		renderer.createPDF(os);

		os.close();
		return os;
	}
}
