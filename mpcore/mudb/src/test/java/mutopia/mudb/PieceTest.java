package mutopia.mudb;

import org.junit.*;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.FileSystems;
import java.nio.file.StandardOpenOption;
import java.nio.charset.StandardCharsets;
import org.apache.jena.util.FileManager;
import org.apache.jena.rdf.model.Model;
import java.sql.Connection;
import java.sql.SQLException;

public class PieceTest {
    private static final String[] RDFDATA = {
        "<?xml version=\"1.0\"?>",
        "<rdf:RDF xmlns:rdf=\"http://www.w3.org/1999/02/22-rdf-syntax-ns#\"",
        "xmlns:mp=\"http://www.mutopiaproject.org/piece-data/0.1/\">",
        "",
        "<rdf:Description rdf:about=\".\">",
        "  <mp:title>Für Elise</mp:title>",
        "  <mp:composer>BeethovenLv</mp:composer>",
        "  <mp:opus>WoO 59</mp:opus>",
        "  <mp:lyricist/>",
        "  <mp:for>Piano</mp:for>",
        "  <mp:date>1810</mp:date>",
        "  <mp:style>Classical</mp:style>",
        "  <mp:metre/>",
        "  <mp:arranger/>",
        "  <mp:source>Breitkopf &amp;amp; Härtel, 1888</mp:source>",
        "  <mp:licence>Public Domain</mp:licence>",
        "",
        "  <mp:id>Mutopia-2015/08/18-9999</mp:id>",
        "  <mp:maintainer>Stelios Samelis</mp:maintainer>",
        "  <mp:maintainerEmail/>",
        "  <mp:maintainerWeb/>",
        "  <mp:moreInfo>keywords: fur elise, bagatelle no.25</mp:moreInfo>",
        "  <mp:lilypondVersion>2.18.2</mp:lilypondVersion>",
        "</rdf:Description>",
        "",
        "</rdf:RDF>"
    };
    private static final String RDFTEST_FN = "rdf-test.rdf";

    @Before
    public void makeTestFile() throws IOException {
		Path path = FileSystems.getDefault().getPath(".", RDFTEST_FN);
        Files.deleteIfExists(path);
		BufferedWriter wr = Files.newBufferedWriter(path,
                                                    StandardCharsets.UTF_8,
                                                    StandardOpenOption.CREATE);
        for (String line : RDFDATA) {
            wr.write(line);
            wr.newLine();
        }
        wr.close();
    }

    @Test
    public void canLoadRDF() throws IOException, MuException {
        Model m = FileManager.get().loadModel(RDFTEST_FN);
        MuPiece p = MuPiece.fromLoadedModel(m);
        Assert.assertEquals("2.18.2", p.get("lilypondVersion") );
        Assert.assertEquals("Classical", p.get("style") );
        /*
        Model m = ModelFactory.createDefaultModel();
        m.read(RDFTEST_FN); //RDFDataMgr.loadModel();
                MuRDFMap rdfmap = new MuRDFMap(RDFTEST_FN);
                MuPiece p = MuPiece.fromRDF(rdfmap);
        */
        m.close();
    }

    @Test
    public void canSave() throws IOException {
        Model m = FileManager.get().loadModel(RDFTEST_FN);
        try {
            Connection conn = MuDB.getInstance().getConnection();
            MuPiece p = MuPiece.fromLoadedModel(m);
            p.save(conn);
        } catch (SQLException | IOException e) {
            Assert.fail(e.getMessage());
        } catch (MuException mue) {
            Assert.fail(mue.getMessage());
        }
        finally {
            m.close();
        }
    }

}
