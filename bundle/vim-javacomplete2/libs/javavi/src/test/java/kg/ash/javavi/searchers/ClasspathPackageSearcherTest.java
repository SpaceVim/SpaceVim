package kg.ash.javavi.searchers;

import mockit.Mock;
import mockit.MockUp;
import mockit.integration.junit4.JMockit;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.Arrays;
import java.util.List;

@RunWith(JMockit.class)
public class ClasspathPackageSearcherTest {

    @Test
    public void testLoadClassFileEntries() {
        new MockUp<ClasspathCollector>() {
            @Mock
            private List<String> collectClassPath() {
                return Arrays.asList("/directory/foo/bar/Classname.class",
                    "/directory/foo/bar/Classname2.class", "/directory/foo/baz/Classname.class",
                    "");
            }

        };

        new MockUp<ClasspathPackageSearcher>() {
            @Mock
            private String getPackageByFile(String path) {
                if (path.split("\\.").length > 2) {
                    return path.substring(0, path.lastIndexOf('.'));
                }
                return null;
            }
        };

        List<PackageEntry> entries = new ClasspathPackageSearcher().loadEntries();
        Assert.assertEquals(3, entries.size());
    }
}
