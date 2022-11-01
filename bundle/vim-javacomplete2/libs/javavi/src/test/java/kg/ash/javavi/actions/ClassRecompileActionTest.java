package kg.ash.javavi.actions;

import kg.ash.javavi.Javavi;
import kg.ash.javavi.searchers.ClassNameMap;
import mockit.integration.junit4.JMockit;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(JMockit.class)
public class ClassRecompileActionTest {

    @Test
    public void testRecompilationCommandBuild() {
        ClassNameMap classMap = new ClassNameMap("foo.bar.Test");
        classMap.setJavaFile("/path/to/src/foo/bar/Test.java");
        classMap.setClassFile("/another/path/target/foo/bar/Test.class");

        Javavi.system.put("compiler", "javac");
        new ClassRecompileAction().perform(new String[] { classMap.getName() });
    }

    @Test
    public void testBadTargetClass() {
        ClassNameMap classMap = new ClassNameMap("foo.bar.Test");
        classMap.setJavaFile("/path/to/src/foo/bar/Test.java");
        classMap.setClassFile("/bar/Test.class");

        new ClassRecompileAction().perform(new String[] { classMap.getName() });

    }

    @Test
    public void testBadSrcFile() {
        ClassNameMap classMap = new ClassNameMap("baz.Test");
        classMap.setJavaFile("/bar/baz/Test.java");
        classMap.setClassFile("/another/path/target/foo/bar/Test.class");

        new ClassRecompileAction().perform(new String[] { classMap.getName() });
    }
}
