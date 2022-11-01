package kg.ash.javavi;

import org.junit.Assert;
import org.junit.Test;

public class DaemonTest {

    private Daemon daemon = new Daemon(0, -1);

    @Test
    public void testParseLine() {
        Assert.assertArrayEquals(new String[] { "-v" }, daemon.parseRequest("-v"));
        Assert.assertArrayEquals(new String[] { "-E", "java.util.List" },
            daemon.parseRequest("-E \"java.util.List\""));
        Assert.assertArrayEquals(new String[] { "-E", "java.util.List" },
            daemon.parseRequest("-E java.util.List"));
        Assert.assertArrayEquals(new String[] { "-E", "java.util.List<HashMap<String,Integer>>" },
            daemon.parseRequest("-E java.util.List<HashMap<String,Integer>>"));
        Assert.assertArrayEquals(new String[0], daemon.parseRequest(""));
        Assert.assertArrayEquals(new String[] { "-E", "" }, daemon.parseRequest("-E \"\""));
        Assert.assertEquals("\\n", daemon.parseRequest("\"\\\\n\"")[0]);
    }

    @Test
    public void testParseEmptyValue() {
        Assert.assertEquals(new String[] { "-sources", "" }, daemon.parseRequest("-sources \"\""));
    }

    @Test
    public void testWindowsDirectoryValue() {
        Assert.assertEquals(new String[] { "-base", "C:\\Documents and Settings\\directory\\" },
            daemon.parseRequest("-base \"C:\\\\Documents and Settings\\\\directory\\\\\""));
    }
}
