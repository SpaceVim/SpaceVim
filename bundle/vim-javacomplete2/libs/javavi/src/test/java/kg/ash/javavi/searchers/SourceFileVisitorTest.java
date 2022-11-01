package kg.ash.javavi.searchers;

import org.junit.Assert;
import org.junit.Test;

import java.io.File;

public class SourceFileVisitorTest {

    @Test
    public void testCorrectPackageClass() {
        SourceFileVisitor visitor = new SourceFileVisitor("foo.bar.Baz");
        visitor.visitFile(new File("src/foo/bar/Baz.java").toPath(), null);

        Assert.assertEquals("src/foo/bar/Baz.java", visitor.getTargetFile());
    }

    @Test
    public void testCorrectClass() {
        SourceFileVisitor visitor = new SourceFileVisitor("Baz");
        visitor.visitFile(new File("/root/src/foo/bar/Baz.java").toPath(), null);

        Assert.assertEquals("/root/src/foo/bar/Baz.java", visitor.getTargetFile());
    }

    @Test
    public void testEmptyClassname() {
        SourceFileVisitor visitor = new SourceFileVisitor("");
        visitor.visitFile(new File("src/foo/bar/Baz.java").toPath(), null);

        Assert.assertEquals(null, visitor.getTargetFile());
    }

    @Test
    public void testSimilarPackageShouldNotBeFound() {
        SourceFileVisitor visitor = new SourceFileVisitor("foo.baz.Baz");
        visitor.visitFile(new File("src/foo/bar/Baz.java").toPath(), null);

        Assert.assertEquals(null, visitor.getTargetFile());
    }

    @Test
    public void testNullClassname() {
        SourceFileVisitor visitor = new SourceFileVisitor(null);
        visitor.visitFile(new File("src/foo/bar/Baz.java").toPath(), null);

        Assert.assertEquals(null, visitor.getTargetFile());
    }
}
