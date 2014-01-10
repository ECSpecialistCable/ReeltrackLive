package com.reeltrack.utilities;

import com.monumental.trampoline.component.*;
import com.monumental.trampoline.datasources.DbResources;
import com.reeltrack.reels.*;

import java.io.*;
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
import java.awt.Color;
import java.awt.Dimension;
import java.awt.geom.AffineTransform;
import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.OutputStream;
import java.io.StringReader;
import java.net.URLConnection;
import javax.imageio.ImageIO;
import javax.swing.JPanel;
import javax.swing.SwingUtilities;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import java.io.StringBufferInputStream;

import java.awt.*;
import org.xhtmlrenderer.pdf.ITextRenderer;
import org.xhtmlrenderer.resource.FSEntityResolver;
import org.xhtmlrenderer.simple.Graphics2DRenderer;
import org.xhtmlrenderer.simple.ImageRenderer;
import org.xhtmlrenderer.util.FSImageWriter;
import org.xhtmlrenderer.util.ImageUtil;
import org.xhtmlrenderer.util.ScalingOptions;
import org.xhtmlrenderer.pdf.ITextRenderer;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;

public class HtmlToImageWriter extends CompWebManager {

	public void init(PageContext pageContext, DbResources resources) {
		super.init(pageContext, resources);
	}

	public String writeImage(Reel theReel, String pageToGet, String basePath, String contentUrl, boolean isRotate, int width, int height) throws Exception {
		URL urlToGet = new URL(pageToGet);

		InputStream is = null;
		BufferedReader br;
		String line;

		StringBuilder buf = new StringBuilder();
		try {
			urlToGet = new URL(pageToGet);
			is = urlToGet.openStream();  // throws an IOException
			br = new BufferedReader(new InputStreamReader(is, "UTF8"));

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
				if (is != null) {
					is.close();
				}
			} catch (IOException ioe) {
				// nothing to see here
			}
		}

		DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		builder.setEntityResolver(FSEntityResolver.instance());
		Document doc = builder.parse(new StringBufferInputStream(buf.toString()));

		Graphics2DRenderer renderer = new Graphics2DRenderer();
		renderer.setDocument(doc, "");


		BufferedImage image = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_RGB);
		if (isRotate) {
			image = createRotatedCopy(image);
		}
		Graphics2D imageGraphics = (Graphics2D) image.getGraphics();
		imageGraphics.setColor(Color.white);
		if (isRotate) {
			imageGraphics.translate(0.5 * height, 0.5 * width);
			imageGraphics.rotate(Math.PI / 2);
			imageGraphics.translate(-0.5 * width, -0.5 * height);
		}
		imageGraphics.fillRect(0, 0, width, height);
		renderer.layout(imageGraphics, new Dimension(width, height));
		renderer.render(imageGraphics);

		String tagFileName = theReel.getReelTag() + "_" + theReel.getCrId() + ".pdf";
		tagFileName = tagFileName.replace(" ", "_");
		tagFileName = tagFileName.replace("#", "-");
		tagFileName = tagFileName.replace("/", "-");

		String uploadDir = basePath + contentUrl;
		File createDir = new File(uploadDir);
		if (!createDir.exists()) {
			createDir.mkdirs();
		}

		/*
		BufferedImage buff = null;
		buff = ImageRenderer.renderToImage(pageToGet, basePath + contentUrl + tagFileName, width, height);
		BufferedImage scaled = ImageUtil.getScaledInstance(buff,width*2,height*2);
		FSImageWriter imageWriter = new FSImageWriter();
		imageWriter.write(scaled, basePath + contentUrl + tagFileName);
		 */

		OutputStream os = new FileOutputStream(basePath + contentUrl + tagFileName);
		ITextRenderer irenderer = new ITextRenderer();
		irenderer.setDocument(pageToGet);
		irenderer.layout();
		irenderer.createPDF(os);
		os.close();

		PDDocument document = null;
		try {
			document = PDDocument.load(basePath + contentUrl + tagFileName);
		} catch (IOException ex) {
			System.out.println("" + ex);
		}

		tagFileName = tagFileName + ".png";
		java.util.List<PDPage> pages = document.getDocumentCatalog().getAllPages();
		PDPage page = (PDPage) pages.get(0);
		BufferedImage image2 = new BufferedImage(width*2, height*2,
				BufferedImage.TYPE_INT_RGB);
		image2 = page.convertToImage();
		if(isRotate) {
			image2 = this.createRotatedCopy(image2);
		}
		File file = new File(basePath + contentUrl + tagFileName);
		//ImageIO.write(image2, "jpg", file);
		FSImageWriter imageWriter = new FSImageWriter();
		imageWriter.write(image2, basePath + contentUrl + tagFileName);
		document.close();
		
		//File fileToWrite = new File(basePath + contentUrl + tagFileName);
		//ImageIO.write(image, "jpg", fileToWrite);
		theReel.setReelTagFile(tagFileName);
		theReel.setHasReelTagFile("y");
		this.getCompController().update(theReel);
		return tagFileName;
	}

	private BufferedImage createRotatedCopy(BufferedImage img) {
		int w = img.getWidth();
		int h = img.getHeight();

		BufferedImage rot = new BufferedImage(h, w, BufferedImage.TYPE_INT_RGB);

		double theta = Math.PI / 2;

		AffineTransform xform = new AffineTransform();
		xform.translate(0.5 * h, 0.5 * w);
		xform.rotate(theta);
		xform.translate(-0.5 * w, -0.5 * h);

		Graphics2D g = (Graphics2D) rot.createGraphics();
		g.drawImage(img, xform, null);
		g.dispose();

		return rot;
	}
//  Using HtmlImageGenerator
//	public void writeImage(String pageToGet, String basePath, String contentUrl) throws Exception {
//		URL urlToGet = new URL(pageToGet);
//
//		HtmlImageGenerator imageGenerator = new HtmlImageGenerator();
//		imageGenerator.loadUrl(pageToGet);
//
//		File file = new File(basePath+contentUrl+"qr_img_generated.png");
//		imageGenerator.saveAsImage(file);
//		//imageGenerator.saveAsHtmlWithMap("hello-world.html", "hello-world.png");
//		;
//	}
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
