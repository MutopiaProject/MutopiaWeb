package mutopia.core;

import java.beans.*;
import java.io.*;
import java.lang.reflect.*;
import java.util.*;
import java.awt.Dimension;

import org.apache.commons.imaging.ImageParser;
import org.apache.commons.imaging.ImageReadException;

/**
 * Class to store information about a Mutopia piece.
 *
 * @author Chris Sawer
 */
public class MutopiaPiece
{
   private String lyFilename = null;
   private String filenameBase = null;
   private Boolean multipleLyFiles = null;
   private Boolean multipleMidFiles = null;
   private Boolean multiplePdfFiles = null;

   private String lilyVersion = null;
   private Integer previewWidth = null;
   private Integer previewHeight = null;

   private String title = null;
   private String composer = null;
   private String opus = null;
   private String poet = null;
   private String instrument = null;
   private String date = null;
   private String style = null;
   private String meter = null;
   private String arranger = null;
   private String source = null;
   private String license = null;
   private String footer = null;
   private String moreInfo = null;
   private String maintainer = null;
   private String maintainerEmail = null;
   private String maintainerWeb = null;

   // Map from (eg.) "title" -> this.title property
   private Map<String, PropertyDescriptor> piecePropertyMap;

   /**
    * Creates a new MutopiaPiece object.  Populates {@code piecePropertyMap}, used to
    * set fields dynamically.
    *
    * @param lyFilename the name of the LilyPond file
    */
   public MutopiaPiece(String lyFilename)
   {
      this.lyFilename = lyFilename;

      try
      {
         BeanInfo mutopiaPieceInfo = Introspector.getBeanInfo(this.getClass());
         PropertyDescriptor[] pieceProperties = mutopiaPieceInfo.getPropertyDescriptors();
         piecePropertyMap = new HashMap<String, PropertyDescriptor>();
         for (int i = 0; i < pieceProperties.length; i++)
         {
            piecePropertyMap.put(pieceProperties[i].getName(), pieceProperties[i]);
         }
      }
      catch (IntrospectionException ex) { System.err.println("IntrospectionException caught: " + ex); }
   }

   /**
    * Set a field in this object based on a field name and value.  Field names that start with
    * "mutopia" will never have their values overwritten by a field name that does not.
    *
    * @param field the field name to set
    * @param value the value to set this field to
    */
   public void populateField(String field, String value)
   {
      if (piecePropertyMap.keySet().contains(field) ||
          (field.startsWith("mutopia") && piecePropertyMap.keySet().contains(field.substring(7))))
      {
         try
         {
            String fieldToSet = field;

            // If we are *NOT* setting a Mutopia field (eg. mutopiapiece), must check if property
            // is null before setting it - this is so Mutopia fields always take precedence
            if (field.startsWith("mutopia"))
            {
               fieldToSet = field.substring(7);
            }
            else
            {
               // Retrieve the appropriate getter
               Method getter = piecePropertyMap.get(fieldToSet).getReadMethod();
               Object property = getter.invoke(this);

               // If property is already set, set fieldToSet to null to prevent setting below
               if (property != null)
               {
                  fieldToSet = null;
               }
            }

            // Retrieve the appropriate setter and set property
            if (fieldToSet != null)
            {
               Method setter = piecePropertyMap.get(fieldToSet).getWriteMethod();
               setter.invoke(this, value);
            }
         }
         catch (Exception ex) { System.err.println("Exception caught while setting properties: " + ex); }
      }
      else
      {
         System.out.println("Warning: not found setter for field: " + field);
      }
   }

   /**
    * Sets several values based on the LilyPond file name and executable.
    * <ul>
    * <li>{@code filenameBase} is the file name without directory or extension</li>
    * <li>{@code multipleLyFiles}, {@code multipleMidFiles}, and
    *     {@code multiplePdfFiles} are booleans set to true if there are ZIP files for .ly files,
    *     .mid files, and .pdf file respectively</li>
    * <li>{@code lilyVersion} is the LilyPond version</li>
    * <li>{@code previewWidth} and {@code previewHeight} are the dimensions of the preview PNG file</li>
    * </ul>
    *
    * @param lilyCommandLine the LilyPond executable, used to get the version
    * @throws IOException from {@link #getLilyVersion()}
    */
   public void deriveCompileStuff(String lilyCommandLine) throws IOException
   {
      String filenameBaseWithDir = lyFilename.substring(0, lyFilename.length() - 3);
      int lastSlash = filenameBaseWithDir.lastIndexOf(File.separatorChar);
      filenameBase = filenameBaseWithDir.substring(lastSlash + 1);

      multipleLyFiles = (new File(filenameBaseWithDir + "-lys.zip").exists());
      multipleMidFiles = (new File(filenameBaseWithDir + "-mids.zip").exists());
      multiplePdfFiles = (new File(filenameBaseWithDir + "-a4-pss.zip").exists());

      lilyVersion = getLilyVersion(lilyCommandLine);

      String previewFilename = filenameBaseWithDir + "-preview.png";
	  File previewFile = new File(previewFilename);
      if (previewFile.exists())
      {
         Dimension dim = getPngSize(previewFile);
         previewWidth = new Integer( (int) Math.round(dim.getWidth()) );
         previewHeight = new Integer( (int) Math.round(dim.getHeight()) );
      }
   }

   /**
    * Parses the LilyPond version number from the executable's output.
    *
    * @param lilyCommandLine the LilyPond executable
    * @return the LilyPond version
    * @throws IOException if it has problems executing LilyPond
    */
   public static String getLilyVersion(String lilyCommandLine) throws IOException
   {
      Process lilyProcess = Runtime.getRuntime().exec(lilyCommandLine + " -version");
      try { lilyProcess.waitFor(); } catch (Exception ex) {}
      BufferedReader lilyInput = new BufferedReader(new InputStreamReader(lilyProcess.getInputStream()));
      String longLilyVersion = lilyInput.readLine();
      lilyInput.close();
      return longLilyVersion.substring(longLilyVersion.lastIndexOf(' ') + 1);
   }

   /**
    * Checks whether mandatory fields have been set.
    *
    * @param checkFooter true if footer value is mandatory
    * @return true if all mandatory fields are set, false otherwise
    */
   public boolean checkFieldConsistency(boolean checkFooter)
   {
      boolean returnValue = true;

      // Title is mandatory
      if (getTitle() == null)
      {
         returnValue = false;
         System.err.println("Missing title");
      }

      // Composer is mandatory
      if (getComposer() == null)
      {
         returnValue = false;
         System.err.println("Missing composer");
      }
      else if (!MutopiaMaps.composerMap.keySet().contains(getComposer()))
      {
         returnValue = false;
         System.err.println("Invalid composer: " + getComposer());
      }

      // Instrument is mandatory
      if (getInstrument() == null)
      {
         returnValue = false;
         System.err.println("Missing instrument");
      }

      // Style is mandatory
      if (getStyle() == null)
      {
         returnValue = false;
         System.err.println("Missing style");
      }
      else if (!MutopiaMaps.styleMap.keySet().contains(getStyle()))
      {
         returnValue = false;
         System.err.println("Invalid style: " + getStyle());
      }

      // Source is mandatory
      if (getSource() == null)
      {
         returnValue = false;
         System.err.println("Missing source");
      }

      // License is mandatory
      if (getLicense() == null)
      {
         returnValue = false;
         System.err.println("Missing license");
      }
      else if (!MutopiaMaps.licenceMapNew.keySet().contains(getLicense()))
      {
         returnValue = false;
         System.err.println("Invalid license: " + getLicense());
      }

      // Footer is mandatory
      if (checkFooter && (getFooter() == null))
      {
         returnValue = false;
         System.err.println("Missing footer");
      }

      return returnValue;
   }

   /**
    * Checks whether mandatory fields from {@link #deriveCompileStuff(String)} have been set.
    *
    * @return true only if all mandatory fields are set, false otherwise
    */
   public boolean checkCompileConsistency()
   {
      boolean returnValue = true;

      // LilyPond version must have been looked up
      if (lilyVersion == null)
      {
         returnValue = false;
         System.err.println("LilyPond version not looked up");
      }

      // Preview width + height must have been looked up
      if ((previewWidth == null) || (previewHeight == null))
      {
         returnValue = false;
         System.err.println("Preview image size not looked up");
      }

      return returnValue;
   }

   // Return the dimensions of a PNG image
   private Dimension getPngSize(File file) {
	   Dimension dim = null;

	   for (ImageParser parser : ImageParser.getAllImageParsers()) {
			if (".png".equalsIgnoreCase(parser.getDefaultExtension())) {
    			try {
    				dim = parser.getImageSize(file);
    			} catch (ImageReadException | IOException e) {
    				e.printStackTrace();
    			}
    			break;
			}
		}

		return dim;
   }

   // Public getters

   public String getFilenameBase()
   {
      return filenameBase;
   }

   public void setMultipleLyFiles(boolean multipleLyFiles)
   {
      this.multipleLyFiles = multipleLyFiles;
   }

   public boolean getMultipleLyFiles()
   {
      return multipleLyFiles;
   }

   public void setMultipleMidFiles(boolean multipleMidFiles)
   {
      this.multipleMidFiles = multipleMidFiles;
   }

   public boolean getMultipleMidFiles()
   {
      return multipleMidFiles;
   }

   public void setMultiplePdfFiles(boolean multiplePdfFiles)
   {
      this.multiplePdfFiles = multiplePdfFiles;
   }

   public boolean getMultiplePdfFiles()
   {
      return multiplePdfFiles;
   }

   public void setLilyVersion(String lilyVersion)
   {
      this.lilyVersion = lilyVersion;
   }

   public String getLilyVersion()
   {
      return lilyVersion;
   }

   public void setPreviewWidth(String previewWidth)
   {
      this.previewWidth = new Integer(previewWidth);
   }

   public Integer getPreviewWidth()
   {
      return previewWidth;
   }

   public void setPreviewHeight(String previewHeight)
   {
      this.previewHeight = new Integer(previewHeight);
   }

   public Integer getPreviewHeight()
   {
      return previewHeight;
   }

   // Public getters and setters
   public void setTitle(String title)
   {
      this.title = title;
   }

   public String getTitle()
   {
      return title;
   }

   public void setComposer(String composer)
   {
      this.composer = composer;
   }

   public String getComposer()
   {
      return composer;
   }

   public void setOpus(String opus)
   {
      this.opus = opus;
   }

   public String getOpus()
   {
      return opus;
   }

   public void setPoet(String poet)
   {
      this.poet = poet;
   }

   public String getPoet()
   {
      return poet;
   }

   public void setInstrument(String instrument)
   {
      this.instrument = instrument;
   }

   public String getInstrument()
   {
      return instrument;
   }

   public void setDate(String date)
   {
      this.date = date;
   }

   public String getDate()
   {
      return date;
   }

   public void setStyle(String style)
   {
      this.style = style;
   }

   public String getStyle()
   {
      return style;
   }

   public void setMeter(String meter)
   {
      this.meter = meter;
   }

   public String getMeter()
   {
      return meter;
   }

   public void setArranger(String arranger)
   {
      this.arranger = arranger;
   }

   public String getArranger()
   {
      return arranger;
   }

   public void setSource(String source)
   {
      this.source = source;
   }

   public String getSource()
   {
      return source;
   }

   public void setLicense(String license)
   {
      this.license = license;
   }

   public String getLicense()
   {
      return license;
   }

   public void setFooter(String footer)
   {
      this.footer = footer;
   }

   public String getFooter()
   {
      return footer;
   }

   public void setMoreInfo(String moreInfo)
   {
      this.moreInfo = moreInfo;
   }

   public String getMoreInfo()
   {
      return moreInfo;
   }

   public void setMaintainer(String maintainer)
   {
      this.maintainer = maintainer;
   }

   public String getMaintainer()
   {
      return maintainer;
   }

   public void setMaintainerEmail(String maintainerEmail)
   {
      this.maintainerEmail = maintainerEmail;
   }

   public String getMaintainerEmail()
   {
      return maintainerEmail;
   }

   public void setMaintainerWeb(String maintainerWeb)
   {
      this.maintainerWeb = maintainerWeb;
   }

   public String getMaintainerWeb()
   {
      return maintainerWeb;
   }

   // For testing
   public Map<String, PropertyDescriptor> getPiecePropertyMap()
   {
	   return piecePropertyMap;
   }
}
