package kg.ash.javavi.output;

import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.ClassNameMap;
import kg.ash.javavi.searchers.JavaClassMap;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.HashMap;

public class OutputPackageInfoTest {

    private String target = "foo.bar";
    private HashMap<String, JavaClassMap> classPackages;

    @Before
    public void Init() {
        JavaClassMap classMap = new ClassNameMap(target);
        classMap.add("baz", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE, null);
        classMap.add("bax", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE, null);
        classMap.add("Bat", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_CLASS, null);

        classPackages = new HashMap<>();
        classPackages.put(target, classMap);
    }

    @Test
    public void testCorrect() {
        OutputPackageInfo opi = new OutputPackageInfo(classPackages);
        String result = opi.get(target);

        Assert.assertEquals(String.format(
            "{'%s':{'tag':'PACKAGE','subpackages':['bax','baz',],'classes':['Bat',]},}", target),
            result);
    }

    @Test
    public void testCorrectUknownTarget() {
        Assert.assertEquals("{}", new OutputPackageInfo(classPackages).get("foo.baa"));
    }

    @Test
    public void testNullTarget() {
        Assert.assertEquals("{}", new OutputPackageInfo(classPackages).get(null));
    }

    @Test
    public void testNullPackages() {
        Assert.assertEquals(Cache.PACKAGES_EMPTY_ERROR, new OutputPackageInfo(null).get(target));
    }
}
