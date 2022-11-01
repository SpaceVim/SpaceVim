package kg.ash.javavi.searchers;

import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class PackagesLoaderTest {

    private PackagesLoader ps;
    private HashMap<String, JavaClassMap> result;
    private List<PackageSeacherIFace> searchers;

    @Before
    public void init() {
        result = new HashMap<>();
        ps = new PackagesLoader("");
        searchers = new ArrayList<>();
        ps.setSearchers(searchers);
    }

    @Test
    public void testCorrect() {
        PackageSeacherIFace searcher = () -> {
            List<PackageEntry> entries = new ArrayList<>();
            entries.add(
                new PackageEntry("java/util/List.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(
                new PackageEntry("java/util/ArrayList.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(new PackageEntry("foo.bar.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(
                new PackageEntry("kg/ash/javavi/Javavi.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            return entries;
        };

        searchers.add(searcher);
        ps.collectPackages(result);

        Assert.assertTrue(result.get("List").contains("java.util"));
        Assert.assertTrue(result.get("ArrayList").contains("java.util"));
        Assert.assertTrue(result.get("Javavi").contains("kg.ash.javavi"));
        Assert.assertNotEquals(null, result.get("java"));
        Assert.assertEquals(2, result.get("java.util").getPaths().size());
        Assert.assertEquals(1, result.get("kg.ash.javavi").getPaths().size());
        Assert.assertEquals(1, result.get("kg.ash").getPaths().size());
        Assert.assertEquals(null, result.get("foo.bar"));
    }

    @Test
    public void testHandleEmpty() {
        PackageSeacherIFace searcher = () -> {
            List<PackageEntry> entries = new ArrayList<>();
            entries.add(new PackageEntry("", JavaClassMap.SOURCETYPE_CLASSPATH));
            return entries;
        };

        searchers.add(searcher);
        ps.collectPackages(result);

        Assert.assertTrue(result.isEmpty());
    }

    @Test
    public void testHandleTooManySlashes() {
        PackageSeacherIFace searcher = () -> {
            List<PackageEntry> entries = new ArrayList<>();
            entries.add(new PackageEntry("/////", JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(new PackageEntry("/////.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(new PackageEntry("/////a.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            return entries;
        };

        searchers.add(searcher);
        ps.collectPackages(result);

        Assert.assertTrue(result.isEmpty());
    }

    @Test
    public void testNestedClasses() {
        PackageSeacherIFace searcher = () -> {
            List<PackageEntry> entries = new ArrayList<>();
            entries.add(new PackageEntry("java/util/HashMap$KeySet.class",
                JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(new PackageEntry("java/util/HashMap$TreeNode.class",
                JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(
                new PackageEntry("foo/bar/TreeNode.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            entries.add(
                new PackageEntry("java/util/ArrayList.class", JavaClassMap.SOURCETYPE_CLASSPATH));
            return entries;
        };

        searchers.add(searcher);
        ps.collectPackages(result);

        Assert.assertTrue(result.get("KeySet").contains("java.util.HashMap$"));
        Assert.assertTrue(result.get("TreeNode").contains("java.util.HashMap$"));
        Assert.assertTrue(result.get("TreeNode").contains("foo.bar"));
    }
}
