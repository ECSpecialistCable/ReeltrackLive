package com.reeltrack.utilities;

import com.monumental.trampoline.component.CompWebManager;
import com.monumental.trampoline.component.CompDbController;
import com.monumental.trampoline.component.CompEntities;
import com.monumental.trampoline.datasources.DbResources;
import com.monumental.trampoline.component.CompEntityPuller;
import com.monumental.trampoline.component.CompCMEntity;

import javax.servlet.jsp.PageContext;
import com.monumental.trampoline.modules.history.*;
import com.monumental.trampoline.security.User;
import com.monumental.trampoline.security.UserLoginMgr;

import com.monumental.trampoline.utilities.images.ImageHelper;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.*;
import javax.swing.ImageIcon;
import java.awt.RenderingHints;


import javax.imageio.*;
import javax.media.jai.*;
import javax.media.jai.operator.*;
import javax.imageio.stream.*;
import java.awt.image.renderable.*;
import java.io.*;
import java.awt.image.*;

import java.io.File;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Hashtable;
import java.util.Iterator;

import org.apache.commons.codec.binary.Base64;

public class MediaManager extends CompWebManager {

    CompDbController controller = null;

    public MediaManager() {
    }
	
	public void init(Connection con) {
        this.controller = new CompDbController(con);
    }

    public void init(PageContext pageContext, DbResources resources) {
        super.init(pageContext, resources);
        this.controller = this.newCompController();
    }
	
	public String addMedia(File file, CompCMEntity entity, String basePath) throws Exception {
		if(file != null) {
            String newName = file.getName().replace(' ', '_');
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
            file.delete();
			return newName;
        }		

		return null;
	}

	public String addMediaWithTimeStamp(File file, CompCMEntity entity, String basePath) throws Exception {
		if(file != null) {
			SimpleDateFormat df = new SimpleDateFormat("MMddyyyy_HHmm");
			String extension = file.getName().substring(file.getName().indexOf("."));
			String fileName = file.getName().substring(0, file.getName().indexOf("."));
            String newName = fileName.replace(' ', '_') + "_" + df.format(new Date()) + extension;
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);
            file.delete();
			return newName;
        }

		return null;
	}
	
	public String addMediaNoDelete(File file, CompCMEntity entity, String basePath) throws Exception {
		if(file != null) {
            String newName = file.getName().replace(' ', '_');
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
			return newName;
        }		

		return null;
	}
	
	public String addMediaUniqueName(File file, CompCMEntity entity, String basePath) throws Exception {
		if(file != null) {
            Date date = new Date();
			String tempFileName = file.getName().substring(0, file.getName().lastIndexOf(".")).replaceAll(" ", "_") + "_";			
            String newName = tempFileName + date.getTime() + file.toString().substring(file.toString().lastIndexOf("."));
			System.out.println("Temp name: " + tempFileName);
			System.out.println("New Name:" + newName);
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
            file.delete();
			return newName;
        }		

		return null;
	}
	
	public String updateMedia(File file, CompCMEntity entity, String basePath, String currentFileName) throws Exception {
		if(file != null) {
            String newName = file.getName().replace(' ', '_');
            controller.deleteFileFromCompEntityDirectory(basePath, entity, currentFileName);
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
            file.delete();
			return newName;
        }		

		// If the file is null, just use the previous file name, because we aren't updating
		return currentFileName;
	}	
	
	public String updateMedia(File file, User entity, String basePath, String currentFileName) throws Exception {
		if(file != null) {
            String newName = "id" + entity.getId() + "_" + file.getName().replace(' ', '_');
            controller.deleteFileFromCompEntityDirectory(basePath, entity, currentFileName);
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
            file.delete();
			return newName;
        }		

		// If the file is null, just use the previous file name, because we aren't updating
		return currentFileName;
	}
		
	public String updateMedia(File file, CompCMEntity entity, String basePath, String currentFileName, String[] prefixesToRemove) throws Exception {
		if(file != null) {
            String newName = file.getName().replace(' ', '_');
            controller.deleteFileFromCompEntityDirectory(basePath, entity, currentFileName);

			for(int i = 0; prefixesToRemove != null && i < prefixesToRemove.length; i++) {
            	controller.deleteFileFromCompEntityDirectory(basePath, entity, prefixesToRemove[i] + currentFileName);				
			}

            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
            file.delete();
			return newName;
        }		

		// If the file is null, just use the previous file name, because we aren't updating
		return currentFileName;
	}
	
	public String updateMediaUniqueName(File file, CompCMEntity entity, String basePath, String currentFileName) throws Exception {
		if(file != null) {
			Date date = new Date();
			String tempFileName = file.getName().substring(0, file.getName().lastIndexOf(".")).replaceAll(" ", "_") + "_";			
            String newName = tempFileName + date.getTime() + file.toString().substring(file.toString().lastIndexOf("."));
			
			System.out.println("Temp name: " + tempFileName);
			System.out.println("New Name:" + newName);
            controller.deleteFileFromCompEntityDirectory(basePath, entity, currentFileName);
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
            file.delete();
			return newName;
        }		

		// If the file is null, just use the previous file name, because we aren't updating
		return currentFileName;
	}
	
	public String updateMediaUniqueNameNoDelete(File file, CompCMEntity entity, String basePath, String currentFileName) throws Exception {
		if(file != null) {
			Date date = new Date();
			String tempFileName = file.getName().substring(0, file.getName().lastIndexOf(".")).replaceAll(" ", "_") + "_";
            String newName = tempFileName + date.getTime() + file.toString().substring(file.toString().lastIndexOf("."));
            controller.deleteFileFromCompEntityDirectory(basePath, entity, currentFileName);
            controller.saveFileToCompEntityDirectory(file, basePath, entity, newName, true);            
			return newName;
        }		

		// If the file is null, just use the previous file name, because we aren't updating
		return currentFileName;
	}

	public boolean resizeUnnecessary(String basePath, String compEntityDirectory, String fileName, int width, int height) {
		ImageIcon icon = new ImageIcon(basePath + compEntityDirectory + "/" + fileName);
		
		int widthPercentage = icon.getIconWidth() / 10;
		
        if( Math.abs(icon.getIconWidth() - width) < widthPercentage) {
			return true;
		}
		
		return false;
	}
	
	// Check to see if the image is smaller than the specified pixel width.  This is used to see
	// if we need to resize an image down, or if it is small enough
	public boolean imageSmaller(String basePath, String compEntityDirectory, String fileName, int myWidth) {
		ImageIcon icon = new ImageIcon(basePath + compEntityDirectory + "/" + fileName);
		
		int widthPercentage = icon.getIconWidth();
		
        if(icon.getIconWidth() - myWidth >= 0) {
			return false;
		}
		
		return true;
	}
	
	public boolean imageSmallerWidth(String basePath, String compEntityDirectory, String fileName, int myWidth) {
		try {
			//ImageIcon icon = new ImageIcon(basePath + compEntityDirectory + "/" + fileName);
			File file = new File(basePath + compEntityDirectory + "/" + fileName);
			BufferedImage img = ImageIO.read(file);
		
	        if(img.getWidth() > myWidth) {
				return true;
			}
		
			return false;
		} catch(Exception e) { 
			e.printStackTrace();
			return false;
		}
	}
	
	public boolean imageSmallerHeight(String basePath, String compEntityDirectory, String fileName, int myHeight) {
		try {
			//ImageIcon icon = new ImageIcon(basePath + compEntityDirectory + "/" + fileName);
			File file = new File(basePath + compEntityDirectory + "/" + fileName);
			BufferedImage img = ImageIO.read(file);
				
	        if(img.getHeight() > myHeight) {
				return true;
			}
			return false;
		} catch(Exception e) { 
			e.printStackTrace();
			return false;
		}
	}
	
	public String getLargerWidthOrHeight(String basePath, String compEntityDirectory, String fileName) {
		ImageIcon icon = new ImageIcon(basePath + compEntityDirectory + "/" + fileName);
				
        if(icon.getIconHeight() > icon.getIconWidth()) {
			return "height";
		} else {
			return "width";
		}		
	}

	/*
	// Originally thought this would work with GIFs, but it will not due to patent issues
	public void compressImage(String basePath, String compentityDirectory, String fileName, String prefix, int width, int height) {
		ImageHelper helper = new ImageHelper();

		String[] breakFileName = fileName.split("\\.");
		
		try {
			if(breakFileName.length > 1) {
				String format = breakFileName[breakFileName.length - 1].toUpperCase();
			
				if(format.equals("PNG") || format.equals("JPG")) {	
					// for pngs, make sure we are using the alpha channel	
					if(format.equals("JPG")) {	
						BufferedImage bufImg2 = helper.scaleImage(basePath + compentityDirectory + "/" + fileName, width, height);
						System.out.println("Where are we looking for this: " + basePath + compentityDirectory.substring(1) + "/" + fileName);
						ImageIO.write(bufImg2, format, new File(basePath + compentityDirectory + "/" + prefix + fileName));			
					} else if(format.equals("PNG")) {
						BufferedImage bufImg2 = this.scaleImage(basePath + compentityDirectory + "/" + fileName, width, height);
						System.out.println("Where are we looking for this: " + basePath + compentityDirectory.substring(1) + "/" + fileName);
						ImageIO.write(bufImg2, format, new File(basePath + compentityDirectory + "/" + prefix + fileName));	
					}
				} else {
					System.out.println("Error: Image format not scaleable.  Format uploaded was: " + format);
				}
			} else {
				System.out.println("Error: File Format incorrect.  Filename: " + fileName);
			}	
		
		} catch(Exception e) {
			e.printStackTrace();
		}			
	} */
	
	public void compressImageNew(String basePath, String compentityDirectory, String fileName, String prefix, int width, int height) throws Exception {
		String formatName = fileName.substring(fileName.lastIndexOf('.')+1, fileName.length());

		File file = new File(basePath + compentityDirectory + "/" + fileName);
		BufferedImage img = ImageIO.read(file);
		
		if(width == 0) {
			double ratio = (double)height / (double)img.getHeight();
			width = (int)(img.getWidth() * ratio);
		}
		
		if(height == 0) {
			double ratio = (double)width / (double)img.getWidth();
			height = (int)(img.getHeight() * ratio);
		}
		
		BufferedImage newImage = this.getScaledInstance(img, width, height, RenderingHints.VALUE_INTERPOLATION_BICUBIC, true);
		ImageIO.write(newImage, formatName, new File(basePath + compentityDirectory + "/" + prefix + fileName));			
		
	}
	
	private static BufferedImage getScaledInstance(BufferedImage img, int targetWidth, int targetHeight, Object hint, boolean higherQuality) {
		int type = (img.getTransparency() == Transparency.OPAQUE) ? BufferedImage.TYPE_INT_RGB : BufferedImage.TYPE_INT_ARGB;
		BufferedImage ret = (BufferedImage)img;
		int w, h;
		if (higherQuality) {
			// Use multi-step technique: start with original size, then
			// scale down in multiple passes with drawImage()
			// until the target size is reached
			w = img.getWidth();
			h = img.getHeight();
		} else {
			// Use one-step technique: scale directly from original
			// size to target size with a single drawImage() call
			w = targetWidth;
			h = targetHeight;
		}
		
		do {
			if (higherQuality && w > targetWidth) {
				w /= 2;
				if (w < targetWidth) {
					w = targetWidth;
				}
			}

			if (higherQuality && h > targetHeight) {
				h /= 2;
				if (h < targetHeight) {
					h = targetHeight;
				}
			}

			BufferedImage tmp = new BufferedImage(w, h, type);
			Graphics2D g2 = tmp.createGraphics();
			g2.setRenderingHint(RenderingHints.KEY_INTERPOLATION, hint);
			g2.drawImage(ret, 0, 0, w, h, null);
			g2.dispose();

			ret = tmp;
		} while (w != targetWidth || h != targetHeight);

		return ret;
	}
	
	
	// THIS IS THE METHOD FROM IMAGEHELPER, JUST CHANGING FOR ALPHA
	private BufferedImage scaleImage(String in, int width, int height) {
        ImageIcon icon = new ImageIcon(in);
        //Image image = icon.getImage();
        double newWidth = new Integer(width).doubleValue();
        double newHeight = new Integer(height).doubleValue();
        double widthPer = 100;
        double heightPer = 100;
        if (width != 0 && height == 0) {
            widthPer = newWidth / icon.getIconWidth();
            heightPer = widthPer;
            height = -1;
        } else if (height != 0 && width == 0) {
            heightPer = newHeight / icon.getIconHeight();
            widthPer = heightPer;
            width=-1;
        } else {
            widthPer = newWidth / icon.getIconWidth();
            heightPer = newHeight / icon.getIconHeight();
        }

        //Image image = Toolkit.getDefaultToolkit().getImage(in);
        Image image = icon.getImage().getScaledInstance(width,height,Image.SCALE_SMOOTH);

        try {
            MediaTracker mt = new MediaTracker(new Canvas());
            mt.addImage(image, 0);
            mt.waitForID(0);
        } catch (InterruptedException e) {
        }

        //BufferedImage buffer = new BufferedImage(icon.getIconWidth(), icon.getIconHeight(), BufferedImage.TYPE_INT_RGB);
        ImageIcon icon2 = new ImageIcon(image);
        BufferedImage buffer = new BufferedImage(icon2.getIconWidth(), icon2.getIconHeight(), BufferedImage.TYPE_INT_ARGB);
        Graphics g = buffer.getGraphics();
        g.drawImage(image, 0, 0, null);
        //return buffer;

        //AffineTransformOp op = new AffineTransformOp(AffineTransform.getScaleInstance(widthPer, heightPer), null);
        //BufferedImage scaled = op.filter(buffer, null);
        //return scaled;
        return buffer;
    }


	/* ***** THE WAY IMAGE RESIZING SHOULD BE DONE ------------------- */

	// This is so we can scale an image, but write it so that the middle is shown in the image, the rest gets
	// cut off
	public void compressImageCutIntoBox(String basePath, String compentityDirectory, String fileName, String prefix, int maxWidth, int maxHeight) {
		ImageHelper helper = new ImageHelper();

		String[] breakFileName = fileName.split("\\.");
		
		try {
			if(breakFileName.length > 1) {
				String format = breakFileName[breakFileName.length-1].toUpperCase();
			
				//if(format.equals("PNG") || format.equals("JPG") || format.equals("JPEG")) {		
					//File file = new File(basePath + compentityDirectory + "/" + fileName);
					//RenderedImage renderedImage = JAI.create("fileload", basePath + compentityDirectory + "/" + fileName);
					ParameterBlock pb = (new ParameterBlock()).add(basePath + compentityDirectory + "/" + fileName);
 					RenderedOp renderedImage = new RenderedOp("fileload", pb, null);
					BufferedImage bufImg2 = renderedImage.getAsBufferedImage();
					
					//BufferedImage bufImg2 = ImageIO.read(file);			
					
					int currentWidth = bufImg2.getWidth();
					int currentHeight = bufImg2.getHeight();
					
					// Get the ratio with the most disparity, so its bigger than the box
					if((double)((double)maxWidth / (double)currentWidth) > (double)((double)maxHeight / (double)currentHeight)) {								
						//bufImg2 = helper.scaleImage(basePath + compentityDirectory + "/" + fileName, maxWidth, 0);
						bufImg2 = this.subsampleScaleImage(basePath,compentityDirectory, fileName, "", maxWidth, 0, true);
					} else {
						//bufImg2 = helper.scaleImage(basePath + compentityDirectory + "/" + fileName, 0, maxHeight);
						bufImg2 = this.subsampleScaleImage(basePath, compentityDirectory, fileName, "", 0, maxHeight, false);												
					}
										
					// Find the points to center the image, the image should be larger than the max image
					int startX = 0;
					if(bufImg2.getWidth() > maxWidth) {
						startX = (bufImg2.getWidth() - maxWidth) / 2;
					}
					
					int startY = 0;
					if(bufImg2.getHeight() > maxHeight) {
						startY = (bufImg2.getHeight() - maxHeight) / 2;
					}
															
					BufferedImage croppedImage = bufImg2.getSubimage(startX, startY, maxWidth, maxHeight);	
					
					this.writeImage(croppedImage, basePath + compentityDirectory + "/" + prefix + fileName, format);	
					//ImageIO.write(croppedImage, format, new File(basePath + compentityDirectory + "/" + prefix + fileName));			
				//} else {
				//	System.out.println("Error: Image format not scaleable.  Format uploaded was: " + format);
				// }
			} else {
				System.out.println("Error: File Format incorrect.  Filename: " + fileName);
			}	
		
		} catch(Exception e) {
			e.printStackTrace();
		}							
	}
	
	public void compressImage(String basePath, String compentityDirectory, String fileName, String prefix, int maxWidth, int maxHeight) {
		ImageHelper helper = new ImageHelper();

		String[] breakFileName = fileName.split("\\.");
		
		try {
			if(breakFileName.length > 1) {
				String format = breakFileName[breakFileName.length-1].toUpperCase();
			
				//File file = new File(basePath + compentityDirectory + "/" + fileName);
				ParameterBlock pb = (new ParameterBlock()).add(basePath + compentityDirectory + "/" + fileName);
 				RenderedOp renderedImage = new RenderedOp("fileload", pb, null);
				BufferedImage bufImg2 = renderedImage.getAsBufferedImage();
				//BufferedImage bufImg2 = ImageIO.read(file);			
				
				int currentWidth = bufImg2.getWidth();
				int currentHeight = bufImg2.getHeight();
				
				// Get the ratio with the most disparity, so its bigger than the box
				if(currentHeight >= maxHeight) {								
					//bufImg2 = helper.scaleImage(basePath + compentityDirectory + "/" + fileName, maxWidth, 0);
					bufImg2 = this.subsampleScaleImage(basePath,compentityDirectory, fileName, "", 0, maxHeight, false);
				}
									
				
				
				this.writeImage(bufImg2, basePath + compentityDirectory + "/" + prefix + fileName, format);	
			} else {
				System.out.println("Error: File Format incorrect.  Filename: " + fileName);
			}	
		
		} catch(Exception e) {
			e.printStackTrace();
		}							
	}
	
	// This method was used because ImageIO can have problems reading in files, most notably some JPEGs
	private BufferedImage convertRenderedImage(RenderedImage img) {
		if (img instanceof BufferedImage) {
			return (BufferedImage)img;	
		}	
		ColorModel cm = img.getColorModel();
		int width = img.getWidth();
		int height = img.getHeight();
		WritableRaster raster = cm.createCompatibleWritableRaster(width, height);
		boolean isAlphaPremultiplied = cm.isAlphaPremultiplied();
		Hashtable properties = new Hashtable();
		String[] keys = img.getPropertyNames();
		if (keys!=null) {
			for (int i = 0; i < keys.length; i++) {
				properties.put(keys[i], img.getProperty(keys[i]));
			}
		}
		BufferedImage result = new BufferedImage(cm, raster, isAlphaPremultiplied, properties);
		img.copyData(raster);
		return result;
	}
	
	// This is the method that creates the image with no fuzzies
	public BufferedImage subsampleScaleImage(String basePath, String compEntityDirectory, String fileName, String prefix, int maxWidth, int maxHeight, boolean byWidth) throws Exception {
		String saveFileName = basePath + compEntityDirectory + "/" + fileName;

		String[] breakFileName = fileName.split("\\.");
		String format = breakFileName[breakFileName.length-1].toUpperCase();

		try {
            PlanarImage image = JAI.create("fileload", saveFileName);
						
			double xScale = 0.0;
			double yScale = 0.0;
			
			if(byWidth) {
				xScale = (double) maxWidth / image.getWidth();
				yScale = xScale;
			} else {
				yScale = (double) maxHeight / image.getHeight();
				xScale = yScale;
			}
						
			RenderingHints hints = new RenderingHints(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
			hints.put(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
            hints.put(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_BICUBIC);

			ParameterBlock pb = new ParameterBlock();
			pb.addSource(image); // The source image
			pb.add(xScale);          // The xScale
			pb.add(yScale);          // The yScale
			
			RenderedOp renderedOp = JAI.create("SubsampleAverage", pb, hints);
           
			return renderedOp.getAsBufferedImage();		
        } catch (Exception e) {
            e.printStackTrace();
        }

		return null;
	}
	
	private static void writeImage(BufferedImage input, String filePath, String formatName) throws IOException {
        Iterator iter = ImageIO.getImageWritersByFormatName(formatName);
        if (iter.hasNext()) {
            ImageWriter writer = (ImageWriter) iter.next();
            ImageWriteParam iwp = writer.getDefaultWriteParam();            

            File outFile = new File(filePath);
            FileImageOutputStream output = new FileImageOutputStream(outFile);
            writer.setOutput(output);
            IIOImage image = new IIOImage(input, null, null);
            writer.write(null, image, iwp);
            output.close();
        } else {
			System.out.println("We have no writer for this format: " + formatName);
		}
    }

	public static void writeFileFromString(String fileData, String fileName) throws Exception {
		Base64 encode = new Base64();
		
		try {
			// need to trim out the web encoding stuff, which luckily ends at the first comma
			fileData = fileData.substring(fileData.indexOf(",")).trim();
			FileOutputStream outStream = new FileOutputStream(fileName);
			byte[] decoded = (byte[])encode.decode(fileData);
			outStream.write(decoded);
			outStream.close();
		} catch(Exception e) { 
			e.printStackTrace();
		}
	}

}
	