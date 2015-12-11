package mutopia.mudb;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * Container for the configuration and various methods for accessing.
 *
 * <p>MuConfig is a singleton that when first accessed will load
 * resources from its property file and store them for later access by
 * the application. It is considered that the resource file is a
 * default property set that can be overridden with environment
 * variables.</p>
 *
 * <p>For example, if the following property is defined,
 * <pre>{@code
 *   mutopia.dbpath=/home/glenl/devo/data/mutopia.db
 * }</pre>
 * An environment variable can be assigned to {@code MUTOPIA_DBPATH}
 * to override the default property at runtime.
 *
 */
public class MuConfig {
    /** When the resource is read and parsed, the properties are held here. */
    private final Properties properties;

    /** Privately construct this class (for the singleton) */
    private MuConfig() {
        properties = new Properties();
        InputStream is;
        try {
            /* Where to find the properties */
            String CONFIG_PROPERTIES = "/mudb.properties";
            is = getClass().getResourceAsStream(CONFIG_PROPERTIES);
            if (is != null) {
                properties.load(is);
            }
            // Expect property keys to have names like
            //    mutopia.keyname
            // Any environment variable that matches with name upcased
            // and the '.' translated to an underscore ('_') can
            // override the property.
            for (String prop_name : properties.stringPropertyNames()) {
                String env_name = prop_name.toUpperCase().replaceAll("\\.", "_");
                String env_value = System.getenv(env_name);
                if (env_value != null) {
                    properties.setProperty(prop_name, env_value);
                }
            }
        }
        catch (IOException ex) {
            ex.printStackTrace();
        }
    }

    public void dump() {
        properties.list(System.out);
    }

    /**
     * MuConfigHolder initializes the singleton on instantiation
     */
    private static class MuConfigHolder {
        private static final MuConfig INSTANCE = new MuConfig();
    }

    /** Access to the singleton
     * @return The single MuDB instance from the internal holder
     */
    public static MuConfig getInstance() {
        return MuConfigHolder.INSTANCE;
    }

    /** Get a property of this configuration.
     *
     *  <p>Once loaded at singleton construction, the properties do
     *  not change. Returns {@code null} if the value is not found.</p>
     *
     *  @param prop the property to lookup
     *  @return The value associated with the property
     */
    public String getProperty(String prop) {
        return this.properties.getProperty(prop);
    }
}
