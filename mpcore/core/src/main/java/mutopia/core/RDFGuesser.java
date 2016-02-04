package mutopia.core;

import java.nio.file.FileSystems;
import java.nio.file.PathMatcher;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.FileVisitResult;
import java.io.IOException;
import java.nio.file.attribute.BasicFileAttributes;
import static java.nio.file.FileVisitResult.*;
import java.util.Iterator;
import java.util.Set;
import java.util.HashSet;
import java.util.Map;
import java.util.HashMap;

/**
 * Build a set of possible RDF files from a folder hierarchy.
 * The hierarchy is assumed to be a MutopiaProject ftp folder. After
 * using this visitor to walk the path it will contain candidate RDF
 * file specs relative to the folder you give it.
 * <pre>{@code
 *     String mtop = getenv("MUTOPIA_BASE");
 *     Path p = FileSystems.getDefault().getPath(mtop, "ftp");
 *     RDFGuesser sb = new RDFGuesser(p);
 *     for (Iterator<String> i = sb.iterator(); i.hasNext(); ) {
 *         String rdfPath = i.next();
 *         // do something with the path
 *     }
 * }</pre>
 *
 * <p>It was necessary to make an adjustment for the few instances of
 * mis-named rdf files. See the {@link #makeAnomalieMap()
 * makeAnomalieMap} method for these instances.</p>
 */
public class RDFGuesser extends SimpleFileVisitor<Path> {
    private final PathMatcher lymatcher;
    private final PathMatcher lysmatcher;
    private final Path top;
    private int anomalies;
    private Set<String> rdfSet;
    private Map<String,String> anomalie_map;

    /** Construct an RDFGuesser.
     *  @param p_top - The path to the top of the folder hierarchy to search.
     *  @param useAnomalieMap - true to adjust guesses with a map of
     *         discovered anomalies, false to skip those checks.
     */
    public RDFGuesser(Path p_top, boolean useAnomalieMap) {
        top = p_top;
        rdfSet = new HashSet<String>();
        anomalies = 0;
        lymatcher = FileSystems.getDefault().getPathMatcher("glob:*\\.ly");
        lysmatcher = FileSystems.getDefault().getPathMatcher("glob:*-lys");
        if (useAnomalieMap) {
            anomalie_map = makeAnomalieMap();
        }
        else {
            // an empty map
            anomalie_map = new HashMap<String,String>();
        }
    }


    /** Make an anomalie map.
     *  The heuristic for finding the RDF's in the ftp hierarchy is
     *  not perfect and requires a few tweaks. These map the failures
     *  to the precise path needed for later lookup.
     *  <p>Stuff happens.</p>
     */
    private Map<String,String> makeAnomalieMap() {
        Map<String,String> map = new HashMap<String,String>();
        // Cases don't match:
        map.put("BachJS/BWV636", "BachJS/BWV636/bwv636.rdf");
        map.put("BachJS/BWV727", "BachJS/BWV727/bwv727.rdf");
        map.put("SorF/O35/sorf_op35_no23/sorf_op35_no23.rdf", "SorF/O35/sorf_op35_no23/sorf_op35_No23.rdf");
        // altered name:
        map.put("BeethovenLv/O17", "BeethovenLv/O17/BeethovenHornSonata.rdf");
        map.put("PorporaN/Semiramide", "PorporaN/Semiramide/Semiramide_riconosciuta.rdf");
        // Underscore to dash translation
        map.put("SatieE/Trois_Valses/Sa_Taille", "SatieE/Trois_Valses/Sa_Taille/Sa-Taille.rdf");
        // n1 is found but the others are links that just confuse things
        map.put("HaydnFJ/O76/op76-n2", "HaydnFJ/O76/op76-n2/op76-n2.rdf");
        map.put("HaydnFJ/O76/op76-n3", "HaydnFJ/O76/op76-n2/op76-n3.rdf");
        map.put("HaydnFJ/O76/op76-n4", "HaydnFJ/O76/op76-n2/op76-n4.rdf");
        map.put("HaydnFJ/O76/op76-n5", "HaydnFJ/O76/op76-n2/op76-n5.rdf");
        map.put("HaydnFJ/O76/op76-n6", "HaydnFJ/O76/op76-n2/op76-n6.rdf");
        return map;
    }

    /** Accessor to iterator over the contained set.
     *  @returns an iterator of Strings
     */
    public Iterator<String> iterator() {
        return rdfSet.iterator();
    }

    /** Add the RDF name to the set.
     *
     *  @param p the path to process and add.
     */
    private void addRDFName(Path p) {
        if (p == null) {
            return;
        }
        String anomalie = anomalie_map.get(p.toString());
        if (anomalie != null) {
            rdfSet.add(anomalie);
            anomalies += 1;
        }
        else {
            // The normal case
            String fn = p.getFileName().toString();
            rdfSet.add(p.resolve(fn + ".rdf").toString());
        }
    }

    /** Access to the number of anomalies applied during the visits.
     * @return int count of anomalies applied from the map.
     */
    public int getAnomalies() {
        return anomalies;
    }

    /** Act if we are about to enter a folder ending in -lys.
     *  @param path  The file path candidate to process
     *  @param attrs The file attributes of the given path
     *  @return SKIP_SUBTREE after processing an -lys folder
     *  @return CONTINUE if no processing necessary for this folder
     */
    @Override
    public FileVisitResult preVisitDirectory(Path dir,
                                             BasicFileAttributes attrs) {
        if (lysmatcher.matches(dir.getFileName())) {
            Path parent = dir.getParent();
            if (parent != null) {
                addRDFName(top.relativize(parent));
            }
            return SKIP_SUBTREE;
        }
        return CONTINUE;
    }

    /** Act on a lilypond file match.
     *  @param path  The file path candidate to process
     *  @param attrs The file attributes of the given path
     *  @return SKIP_SIBLINGS after processing a LilyPond file
     *  @return CONTINUE if no processing was necessary
     */
    @Override
    public FileVisitResult visitFile(Path path,
                                     BasicFileAttributes attrs) {
        if (lymatcher.matches(path.getFileName())) {
            Path parent = path.getParent();
            if (parent != null) {
                addRDFName(top.relativize(parent));
            }
            return SKIP_SIBLINGS;
        }
        return CONTINUE;
    }

    /** Act on a file visit exception.
     *  The exception message is printed to STDERR.
     *  @param path The file path candidate to process
     *  @param exc  The exception to process.
     *  @return CONTINUE Ignore the error
     */
    @Override
    public FileVisitResult visitFileFailed(Path file,
                                           IOException exc) {
        System.err.println(exc.getMessage());
        return CONTINUE;
    }

}
