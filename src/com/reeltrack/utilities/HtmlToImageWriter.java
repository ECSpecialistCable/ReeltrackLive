package com.reeltrack.utilities;

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
import java.awt.Graphics2D;
import javax.swing.JEditorPane;
import gui.ava.html.image.generator.HtmlImageGenerator;
import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.net.URLConnection;
import javax.imageio.ImageIO;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;

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

//	The other way of writing html to image
//	public void writeImage(String pageToGet, String basePath, String contentUrl) throws Exception {
//		String htmlcode="";
//		try {
//			URL urldemo = new URL(pageToGet);
//			URLConnection yc = urldemo.openConnection();
//			BufferedReader in = new BufferedReader(new InputStreamReader(yc.getInputStream()));
//			String inputLine;
//			while ((inputLine = in.readLine()) != null) {
//			   htmlcode += inputLine;
//			}
//			System.out.println(htmlcode);
//			in.close();
//        }catch(Exception e) {
//            System.out.println(e);
//        }
//
//		/*
//		* Setup a JEditorPane
//		*/
//		JEditorPane pane = new JEditorPane();
//		pane.setEditable(false);
//		pane.setContentType("text/html");
//		pane.setText(htmlcode);
//		pane.setSize(pane.getPreferredSize());
//		/*
//		* Create a BufferedImage
//		*/
//		BufferedImage image = new BufferedImage(pane.getWidth(), pane.getHeight(), BufferedImage.TYPE_INT_ARGB);
//		Graphics2D g = image.createGraphics();
//		/*
//		* Have the image painted by SwingUtilities
//		*/
//		JPanel container = new JPanel();
//		SwingUtilities.paintComponent(g, pane, container, 0, 0, image.getWidth(), image.getHeight());
//
//		File outputfile = new File(basePath+contentUrl+"qr_img_generated.png");
//		FileWriter fr = new FileWriter(outputfile);
//		BufferedWriter br  = new BufferedWriter(fr);
//		ImageIO.write(image, "png", outputfile);
//
//		g.dispose();
//
//	}
	
}
