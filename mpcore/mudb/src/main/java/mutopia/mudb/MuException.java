package mutopia.mudb;

/** MuDB package exceptions.
 *
 * A simple Exception derivative for exceptions specific to the mudb package.
 */
public class MuException extends Exception {
    /** Construct an MuException with a message string.
     * @param message the text to add to the exception.
     */
    MuException(String message) {
        super(message);
    }
}
