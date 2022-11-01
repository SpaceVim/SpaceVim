package kg.ash.javavi.output;

import kg.ash.javavi.Javavi;
import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.ClassNameMap;
import kg.ash.javavi.searchers.JavaClassMap;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;

public class OutputClassPackagesTest {

    private String target = "Bar";
    private HashMap<String, JavaClassMap> classPackages;

    @Before
    public void Init() {
        Javavi.system.put("sources", "");
        JavaClassMap classMap = new ClassNameMap(target);
        classMap.add("bar.baz", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE,
            null);
        classMap.add("foo.bar", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE,
            null);

        classPackages = new HashMap<>();
        classPackages.put(target, classMap);
    }

    @Test
    public void testCorrect() {
        Assert.assertEquals("['foo.bar.Bar','bar.baz.Bar',]",
            new OutputClassPackages(classPackages).get(target));
    }

    @Test
    public void testCorrectUknownTarget() {
        Assert.assertEquals("[]", new OutputClassPackages(classPackages).get("Baz"));
    }

    @Test
    public void testNullTarget() {
        Assert.assertEquals("[]", new OutputClassPackages(classPackages).get(null));
    }

    @Test
    public void testNullPackages() {
        Assert.assertEquals(Cache.PACKAGES_EMPTY_ERROR, new OutputClassPackages(null).get(target));
    }
}
