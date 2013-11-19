package com.reeltrack.utilities;

import com.monumental.trampoline.datasources.DbResources;
import com.reeltrack.reports.HtmlToPdfWriter;
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
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.net.URLConnection;
import java.util.Iterator;
import java.util.List;
import javax.imageio.ImageIO;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
public class HTMLToPdfToImageWriter {
	PageContext pageContext;
	DbResources resources;

	public HTMLToPdfToImageWriter(PageContext pageContext, DbResources resources) {
		this.pageContext = pageContext;
		this.resources = resources;
	}

	public void writeImage(String pageToGet, String basePath, String contentUrl) throws Exception {
		HtmlToPdfWriter writer = new HtmlToPdfWriter(pageContext, resources);
		ByteArrayOutputStream output = new ByteArrayOutputStream();
		output = writer.writePdf(basePath, pageToGet);

		byte[] bytes = output.toByteArray();

		File pdfFile = new File(basePath + contentUrl + "qr_img.pdf");
		FileOutputStream fos = new FileOutputStream(pdfFile);
		fos.write(bytes);


		PDDocument document = null;
		try {
			document = PDDocument.load(basePath + contentUrl + "qr_img.pdf");
		} catch (IOException ex) {
			System.out.println("" + ex);
		}

		List<PDPage> pages = document.getDocumentCatalog().getAllPages();
		PDPage page = (PDPage) pages.get(0);
		BufferedImage image = page.convertToImage();
		File file = new File(basePath + contentUrl + "qr_img_generated.png");
		ImageIO.write(image, "png", file);
		document.close();
	}
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
