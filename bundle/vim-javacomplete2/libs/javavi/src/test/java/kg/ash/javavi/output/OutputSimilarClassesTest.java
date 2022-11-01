package kg.ash.javavi.output;

import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.ClassNameMap;
import kg.ash.javavi.searchers.JavaClassMap;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;

public class OutputSimilarClassesTest {

    private String target = "Bar";
    private HashMap<String, JavaClassMap> classPackages;

    @Before
    public void Init() {
        classPackages = new HashMap<>();

        JavaClassMap classMap = new ClassNameMap("Barabaz");
        classMap.add("bar", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE, null);
        classPackages.put("Barabaz", classMap);

        classMap = new ClassNameMap("Bara");
        classMap.add("bar.bara", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE,
            null);
        classPackages.put("Bara", classMap);

        classMap = new ClassNameMap("Bazaraz");
        classMap.add("bar.baz", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE,
            null);
        classPackages.put("Bazaraz", classMap);

        classMap = new ClassNameMap("Foobar");
        classMap.add("bar.bas", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE,
            null);
        classPackages.put("Foobar", classMap);
    }

    @Test
    public void testCorrect() {
        String result = new OutputSimilarClasses(classPackages).get(target);

        Assert.assertEquals(
            "[{'word':'Bara', 'menu':'bar.bara', 'type': 'c'},{'word':'Barabaz', 'menu':'bar', "
                + "'type': 'c'},]", result);
    }

    @Test
    public void testCorrectUknownTarget() {
        Assert.assertEquals("[]", new OutputSimilarClasses(classPackages).get("Tar"));
    }

    @Test
    public void testNullTarget() {
        Assert.assertEquals("[]", new OutputSimilarClasses(classPackages).get(null));
    }

    @Test
    public void testNullPackages() {
        Assert.assertEquals(Cache.PACKAGES_EMPTY_ERROR, new OutputSimilarClasses(null).get(target));
    }
}
