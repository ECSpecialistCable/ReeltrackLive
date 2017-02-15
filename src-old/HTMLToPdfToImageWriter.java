package com.reeltrack.utilities;

import com.monumental.trampoline.datasources.DbResources;
import com.reeltrack.reports.HtmlToPdfWriter;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import javax.servlet.jsp.PageContext;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.util.List;
import javax.imageio.ImageIO;

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
