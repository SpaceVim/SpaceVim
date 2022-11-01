package kg.ash.javavi.searchers;

import kg.ash.javavi.clazz.ClassImport;
import kg.ash.javavi.clazz.SourceClass;
import org.junit.Assert;
import org.junit.Test;

public class FqnSeacherTest {

    @Test
    public void testGetFqn() {
        SourceClass clazz = new SourceClass();
        clazz.getImports().add(new ClassImport("kg.ash.javavi.clazz.SourceClass", false, false));
        clazz.getImports().add(new ClassImport("java.util.List", false, false));

        String sourcesDirectory = System.getProperty("user.dir") + "/src/main/java/";
        FqnSearcher seacher = new FqnSearcher(sourcesDirectory);

        Assert.assertEquals("FakeClass", seacher.getFqn(new SourceClass(), "FakeClass"));
        Assert.assertEquals("kg.ash.javavi.clazz.SourceClass",
            seacher.getFqn(clazz, "SourceClass"));
        Assert.assertEquals("java.util.List", seacher.getFqn(clazz, "List"));
        Assert.assertEquals("java.util.List<kg.ash.javavi.clazz.SourceClass>",
            seacher.getFqn(clazz, "List<SourceClass>"));

        clazz = new SourceClass();
        clazz.setPackage("kg.ash.javavi.clazz");
        clazz.getImports().add(new ClassImport("java.util.*", false, true));

        Assert.assertEquals("kg.ash.javavi.clazz.SourceClass",
            seacher.getFqn(clazz, "SourceClass"));
        Assert.assertEquals("java.util.List", seacher.getFqn(clazz, "List"));
        Assert.assertEquals("java.util.List<kg.ash.javavi.clazz.SourceClass>",
            seacher.getFqn(clazz, "List<SourceClass>"));
    }
}
