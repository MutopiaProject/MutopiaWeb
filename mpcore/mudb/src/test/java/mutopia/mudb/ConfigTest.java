package mutopia.mudb;

import org.junit.*;

public class ConfigTest {

    @Test
    public void testCanGetProperty() {
        MuConfig config = MuConfig.getInstance();
        String dbfnm = config.getProperty("mutopia.dbpath");
        Assert.assertTrue(dbfnm != null && dbfnm.length() > 0);
    }
}
