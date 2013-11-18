package com.reeltrack.utilities;

//import com.itextpdf.text.Document;
//import com.itextpdf.text.pdf.PdfWriter;
import com.reeltrack.reports.*;
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
import gui.ava.html.image.generator.HtmlImageGenerator;
import java.io.File;

public class HtmlToImageWriter {

	public HtmlToImageWriter(PageContext pageContext, DbResources resources) {
		
	}

	public void writeImage(String pageToGet, String basePath, String contentUrl) throws Exception {
		URL urlToGet = new URL(pageToGet);
		
		HtmlImageGenerator imageGenerator = new HtmlImageGenerator();
		imageGenerator.loadUrl(pageToGet);

		File file = new File(basePath+contentUrl+"qr_img_generated.png");
		imageGenerator.saveAsImage(file);
		//imageGenerator.saveAsHtmlWithMap("hello-world.html", "hello-world.png");

	}
	
}
