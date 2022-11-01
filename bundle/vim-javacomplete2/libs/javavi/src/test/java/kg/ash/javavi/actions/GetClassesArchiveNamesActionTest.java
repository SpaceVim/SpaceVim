package kg.ash.javavi.actions;

import kg.ash.javavi.searchers.ClassNameMap;
import kg.ash.javavi.searchers.JavaClassMap;
import mockit.Mock;
import mockit.MockUp;
import mockit.integration.junit4.JMockit;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.HashMap;

@RunWith(JMockit.class)
public class GetClassesArchiveNamesActionTest {

    @Test
    public void testArchiveNamesFetch() {
        new MockUp<GetClassesArchiveNamesAction>() {
            @Mock
            private HashMap<String, JavaClassMap> getClassPackages() {
                HashMap<String, JavaClassMap> map = new HashMap<>();

                JavaClassMap jc = new ClassNameMap("List");
                jc.add("java.util", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE,
                    "/dir/lib.jar");
                map.put("List", jc);

                jc = new ClassNameMap("HashMap");
                jc.add("java.util", JavaClassMap.SOURCETYPE_CLASSPATH, JavaClassMap.TYPE_SUBPACKAGE,
                    "/dir/lib.jar");
                map.put("HashMap", jc);

                return map;
            }
        };

        GetClassesArchiveNamesAction action = new GetClassesArchiveNamesAction();
        String result = action.perform(new String[] { "java.util.List,java.util.HashMap" });
        Assert.assertEquals("[['/dir/lib.jar',['java.util.List','java.util.HashMap',]],]", result);
    }

    @Test
    public void testNoResult() {
        GetClassesArchiveNamesAction action = new GetClassesArchiveNamesAction();
        Assert.assertEquals("[]",
            action.perform(new String[] { "java.util.List, java.util.HashMap" }));
    }

    @Test
    public void testEmptyRequest() {
        GetClassesArchiveNamesAction action = new GetClassesArchiveNamesAction();
        Assert.assertEquals("[]", action.perform(new String[] { "" }));
    }

    @Test
    public void testNoArgs() {
        GetClassesArchiveNamesAction action = new GetClassesArchiveNamesAction();
        Assert.assertEquals("[]", action.perform(new String[0]));
    }
}
