/*
 * Filename:         MutopiaMaps.java
 * Original author:  Chris Sawer
 *
 * Description:
 *   Class to set up licence, composer and style maps.
 */

package mutopia.core;
import java.io.*;
import java.util.*;

/** Container class for access to various maps.
 *
 *  Holds mappings for copyright licenses, composers, and styles.
 *
 * @author Chris Sawer
 */
public class MutopiaMaps
{
    /** Very old license map.
     * <p>Can be deprecated when the archive no longer has LilyPond
     * versions less than 2.11.57
     * </p>
     */
   public static Map<String, String> licenceMapVOld = new HashMap<String, String>();

    /** Old license map
     * <p>Can be deprecated when the archive no longer has LilyPond
     * versions less than 2.14.
     * </p>
     */
   public static Map<String, String> licenceMapOld = new HashMap<String, String>();

    /** New license map */
   public static Map<String, String> licenceMapNew = new HashMap<String, String>();

    /** Map of composers.
     *
     *  The key is the MutopiaProject composer tag; the value is
     *  the description associated with the author. This information
     *  is read from the <code>datafiles/composers.dat</code> file.
     */
   public static Map<String, String> composerMap = new HashMap<String, String>();

    /** Map of valid styles.
     *
     *  Read from the <code>datafiles/styles.dat</code> file.
     */
   public static Map<String, String> styleMap = new HashMap<String, String>();

   static
   {
      initialiseLicenceMap();
      readDatFileIntoMap("composers.dat", composerMap);
      readDatFileIntoMap("styles.dat", styleMap);
   }

   private static void initialiseLicenceMap()
   {
      Calendar now = Calendar.getInstance();

      licenceMapVOld.put("Public Domain",
                     "tagline = \\markup { \\override #'(box-padding . 1.0) \\override #'(baseline-skip . 2.7) \\box \\center-align { \\small \\line { " +
                     "Sheet music from \\with-url #\"http://www.MutopiaProject.org\" \\line { \\teeny www. \\hspace #-1.0 MutopiaProject \\hspace #-1.0 " +
                     "\\teeny .org \\hspace #0.5 } \u2022 \\hspace #0.5 \\italic Free to download, with the \\italic freedom to distribute, modify and perform. " +
                     "} \\line { \\small \\line { Typeset using \\with-url #\"http://www.LilyPond.org\" \\line { \\teeny www. \\hspace #-1.0 LilyPond " +
                     "\\hspace #-1.0 \\teeny .org } by \\maintainer \\hspace #-1.0 . \\hspace #0.5 Reference: \\footer } } \\line { \\teeny \\line { This sheet " +
                     "music has been placed in the public domain by the typesetter, for details see: \\hspace #-0.5 \\with-url " +
                     "#\"http://creativecommons.org/licenses/publicdomain\" http://creativecommons.org/licenses/publicdomain } } } }");
      licenceMapVOld.put("Creative Commons Attribution 3.0",
                     "tagline = \\markup { \\override #'(box-padding . 1.0) \\override #'(baseline-skip . 2.7) \\box \\center-align { \\small \\line { " +
                     "Sheet music from \\with-url #\"http://www.MutopiaProject.org\" \\line { \\teeny www. \\hspace #-1.0 MutopiaProject \\hspace #-1.0 " +
                     "\\teeny .org \\hspace #0.5 } \u2022 \\hspace #0.5 \\italic Free to download, with the \\italic freedom to distribute, modify and perform. " +
                     "} \\line { \\small \\line { Typeset using \\with-url #\"http://www.LilyPond.org\" \\line { \\teeny www. \\hspace #-1.0 LilyPond " +
                     "\\hspace #-1.0 \\teeny .org } by \\maintainer \\hspace #-1.0 . \\hspace #0.5 Copyright \u00A9 " + now.get(Calendar.YEAR) + ". \\hspace " +
                     "#0.5 Reference: \\footer } } \\line { \\teeny \\line { Licensed under the Creative Commons Attribution 3.0 (Unported) License, for details see: " +
                     "\\hspace #-0.5 \\with-url #\"http://creativecommons.org/licenses/by/3.0\" http://creativecommons.org/licenses/by/3.0 } } } }");
      licenceMapVOld.put("Creative Commons Attribution-ShareAlike 3.0",
                     "tagline = \\markup { \\override #'(box-padding . 1.0) \\override #'(baseline-skip . 2.7) \\box \\center-align { \\small \\line { " +
                     "Sheet music from \\with-url #\"http://www.MutopiaProject.org\" \\line { \\teeny www. \\hspace #-1.0 MutopiaProject \\hspace #-1.0 " +
                     "\\teeny .org \\hspace #0.5 } \u2022 \\hspace #0.5 \\italic Free to download, with the \\italic freedom to distribute, modify and perform. " +
                     "} \\line { \\small \\line { Typeset using \\with-url #\"http://www.LilyPond.org\" \\line { \\teeny www. \\hspace #-1.0 LilyPond " +
                     "\\hspace #-1.0 \\teeny .org } by \\maintainer \\hspace #-1.0 . \\hspace #0.5 Copyright \u00A9 " + now.get(Calendar.YEAR) + ". \\hspace " +
                     "#0.5 Reference: \\footer } } \\line { \\teeny \\line { Licensed under the Creative Commons Attribution-ShareAlike 3.0 (Unported) License, for details " +
                     "see: \\hspace #-0.5 \\with-url #\"http://creativecommons.org/licenses/by-sa/3.0\" http://creativecommons.org/licenses/by-sa/3.0 } } } }");

      licenceMapOld.put("Public Domain",
                     "tagline = \\markup { \\override #'(box-padding . 1.0) \\override #'(baseline-skip . 2.7) \\box \\center-column { \\small \\line { " +
                     "Sheet music from \\with-url #\"http://www.MutopiaProject.org\" \\line { \\teeny www. \\hspace #-1.0 MutopiaProject \\hspace #-1.0 " +
                     "\\teeny .org \\hspace #0.5 } \u2022 \\hspace #0.5 \\italic Free to download, with the \\italic freedom to distribute, modify and perform. " +
                     "} \\line { \\small \\line { Typeset using \\with-url #\"http://www.LilyPond.org\" \\line { \\teeny www. \\hspace #-1.0 LilyPond " +
                     "\\hspace #-1.0 \\teeny .org } by \\maintainer \\hspace #-1.0 . \\hspace #0.5 Reference: \\footer } } \\line { \\teeny \\line { This sheet " +
                     "music has been placed in the public domain by the typesetter, for details see: \\hspace #-0.5 \\with-url " +
                     "#\"http://creativecommons.org/licenses/publicdomain\" http://creativecommons.org/licenses/publicdomain } } } }");
      licenceMapOld.put("Creative Commons Attribution 3.0",
                     "tagline = \\markup { \\override #'(box-padding . 1.0) \\override #'(baseline-skip . 2.7) \\box \\center-column { \\small \\line { " +
                     "Sheet music from \\with-url #\"http://www.MutopiaProject.org\" \\line { \\teeny www. \\hspace #-1.0 MutopiaProject \\hspace #-1.0 " +
                     "\\teeny .org \\hspace #0.5 } \u2022 \\hspace #0.5 \\italic Free to download, with the \\italic freedom to distribute, modify and perform. " +
                     "} \\line { \\small \\line { Typeset using \\with-url #\"http://www.LilyPond.org\" \\line { \\teeny www. \\hspace #-1.0 LilyPond " +
                     "\\hspace #-1.0 \\teeny .org } by \\maintainer \\hspace #-1.0 . \\hspace #0.5 Copyright \u00A9 " + now.get(Calendar.YEAR) + ". \\hspace " +
                     "#0.5 Reference: \\footer } } \\line { \\teeny \\line { Licensed under the Creative Commons Attribution 3.0 (Unported) License, for details see: " +
                     "\\hspace #-0.5 \\with-url #\"http://creativecommons.org/licenses/by/3.0\" http://creativecommons.org/licenses/by/3.0 } } } }");
      licenceMapOld.put("Creative Commons Attribution-ShareAlike 3.0",
                     "tagline = \\markup { \\override #'(box-padding . 1.0) \\override #'(baseline-skip . 2.7) \\box \\center-column { \\small \\line { " +
                     "Sheet music from \\with-url #\"http://www.MutopiaProject.org\" \\line { \\teeny www. \\hspace #-1.0 MutopiaProject \\hspace #-1.0 " +
                     "\\teeny .org \\hspace #0.5 } \u2022 \\hspace #0.5 \\italic Free to download, with the \\italic freedom to distribute, modify and perform. " +
                     "} \\line { \\small \\line { Typeset using \\with-url #\"http://www.LilyPond.org\" \\line { \\teeny www. \\hspace #-1.0 LilyPond " +
                     "\\hspace #-1.0 \\teeny .org } by \\maintainer \\hspace #-1.0 . \\hspace #0.5 Copyright \u00A9 " + now.get(Calendar.YEAR) + ". \\hspace " +
                     "#0.5 Reference: \\footer } } \\line { \\teeny \\line { Licensed under the Creative Commons Attribution-ShareAlike 3.0 (Unported) License, for details " +
                     "see: \\hspace #-0.5 \\with-url #\"http://creativecommons.org/licenses/by-sa/3.0\" http://creativecommons.org/licenses/by-sa/3.0 } } } }");

      // The new map is populated by using copyrights generated by
      // the LicenseMap singleton object. Once old and very old
      // licenses are deprecated, the new map can be replaced with a
      // simple call to LicenseMap.getCopyright().
      LicenseMap lm = LicenseMap.getInstance();
      for (String k: lm.keySet()) {
          licenceMapNew.put(k, lm.getCopyright(k));
      }
   }

   private static void readDatFileIntoMap(String datFile, Map<String, String> map)
   {
      // Get directory
      String mutopiaDir = System.getenv("MUTOPIA_BASE");
      if (mutopiaDir == null)
      {
         throw new RuntimeException("MUTOPIA_BASE not set");
      }
      String filename = mutopiaDir + "/datafiles/" + datFile;

      try
      {
         // Open file
         BufferedReader dataFile = new BufferedReader(new InputStreamReader(new FileInputStream(filename), "UTF-8"));

         // Read key/value pairs
         String key = dataFile.readLine();
         String value = dataFile.readLine();
         while (key != null) // key == null at end of file
         {
            // Check value and put into map
            if (value != null)
            {
               map.put(key, value);
            }
            else
            {
               System.err.println("Inconsistency in data file: " + filename);
            }

            key = dataFile.readLine();
            value = dataFile.readLine();
         }

         dataFile.close();
      }
      catch (FileNotFoundException ex)
      {
         System.err.println("Data file " + filename + " not found");
      }
      catch (IOException ex)
      {
         System.err.println(ex);
      }
   }
}
