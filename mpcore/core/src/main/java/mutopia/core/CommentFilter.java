package mutopia.core;
import java.io.FilterReader;
import java.io.IOException;
import java.io.Reader;

/**
 * CommentFilter is a FilterReader that strips LilyPond comments
 * <p>
 * This is an attempt to reduce the complexity of LilyPond parsing by
 * filtering an input stream and removing everything in comments. Both
 * block and line comments are recognized by this filter.
 * Whitespace is not affected.</p>
 * <pre>{@code
 *    BufferedReader in =
 *       new BufferedReader(new CommentFilter(new FileReader(lyfile)));
 * }</pre>
 */
public class CommentFilter extends FilterReader {
    boolean inLineC = false;
    boolean inBlockC = false;
    boolean onPercent = false;
    boolean blockClose = false;

    public CommentFilter(Reader in) {
        super(in);
    }

    private boolean isEOL(char c) {
        if (c == '\r' || c == '\n')
            return true;
        else
            return false;
    }

    /**
     * Filter a stream buffer, removing LilyPond line and block comments.
     * @param buf  character buffer to filter
     * @param from offset into {@code buf}
     * @param len  number of characters in {@code buf} to process
     * @return number of character placed into buf
     * @throws IOException from FilterReader
     */
    @Override
    public int read(char[] buf, int from, int len) throws IOException {
        int numc = 0;
        while (numc == 0) {
            numc = super.read(buf, from, len);
            if (numc == -1) {
                return -1;
            }
            int last = from;
            for (int i = from; i < from + numc; i++) {
                if (onPercent) {
                    onPercent = false;
                    if (buf[i] == '{' ) {
                        inBlockC = true;
                    }
                    else if (buf[i] == '}') {
                        blockClose = true;
                    }
                    else {
                        inLineC = true;
                    }
                }
                if (inBlockC) {
                    if (buf[i] == '%') {
                        onPercent = true;
                    }
                    if (blockClose) {
                        blockClose = false;
                        inBlockC = false;
                    }
                    if (isEOL(buf[i])) {
                        buf[last++] = buf[i];
                    }
                }
                else if (inLineC) {
                    if (isEOL(buf[i])) {
                        inLineC = false;
                        buf[last++] = buf[i];
                    }
                }
                else {
                    if (buf[i] == '%' ) {
                        onPercent = true;
                    }
                    else {
                        buf[last++] = buf[i];
                    }
                }
            }
            numc = last - from;
        }
        return numc;
    }

}
