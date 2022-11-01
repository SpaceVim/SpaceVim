package kg.ash.javavi;

import org.junit.Assert;
import org.junit.Test;

public class TargetParserTest {

    @Test
    public void testParse() {
        TargetParser parser = new TargetParser("");
        Assert.assertEquals("", parser.parse(""));
        Assert.assertEquals("java.util.List", parser.parse("java.util.List"));
        Assert.assertEquals(0, parser.getTypeArguments().size());

        Assert.assertEquals("java.util.List",
            parser.parse("java.util.List<java.util.List<HashMap<String,BigDecimal>>>"));
        Assert.assertEquals(1, parser.getTypeArguments().size());
        Assert.assertEquals("java.util.List<HashMap<String,BigDecimal>>",
            parser.getTypeArguments().get(0));

        Assert.assertEquals("HashMap", parser.parse("HashMap<Long, HashMap<String,String>>"));

        Assert.assertEquals("java.util.HashMap", parser.parse(
            "java.util.HashMap<(kg.ash.demo.String|java.lang.String),java.math.BigDecimal>"));
        Assert.assertEquals(2, parser.getTypeArguments().size());
        Assert.assertEquals("java.lang.String", parser.getTypeArguments().get(0));
        Assert.assertEquals("java.math.BigDecimal", parser.getTypeArguments().get(1));

        Assert.assertEquals("java.util.List", parser.parse("java.util.List<? super Integer>"));
        Assert.assertEquals("Integer", parser.getTypeArguments().get(0));

        Assert.assertEquals("java.util.List", parser.parse("java.util.List<? super Integer[]>"));
        Assert.assertEquals("Integer[]", parser.getTypeArguments().get(0));

        Assert.assertEquals("java.util.List", parser.parse("java.util.List<? extends Integer>"));
        Assert.assertEquals("Integer", parser.getTypeArguments().get(0));

        Assert.assertEquals("java.lang.Class", parser.parse("java.lang.Class<?>"));

        Assert.assertEquals("java.util.HashMap$KeySet", parser.parse(
            "java.util.HashMap$KeySet<(kg.ash.demo.String|java.lang.String),java.math"
                + ".BigDecimal>"));
        Assert.assertEquals(2, parser.getTypeArguments().size());
        Assert.assertEquals("java.lang.String", parser.getTypeArguments().get(0));
        Assert.assertEquals("java.math.BigDecimal", parser.getTypeArguments().get(1));

        Assert.assertEquals("java.util.List",
            parser.parse("java.util.List<java.lang.Object, java.lang.Object, java.lang.Object>"));
        Assert.assertEquals("java.util.List", parser.parse(
            "java.util.List<(kg.test.Object|java.lang.Object),(kg.test.Object|java.lang.Object),"
                + "(kg.test.String|java.lang.String|java.lang.Object)>"));
    }

    @Test
    public void testTypeArgumentsToString() {
        TargetParser parser = new TargetParser("");
        parser.parse("java.util.List");
        Assert.assertEquals("", parser.getTypeArgumentsString());
        parser.parse("java.util.List<java.math.BigDecimal>");
        Assert.assertEquals("<java.math.BigDecimal>", parser.getTypeArgumentsString());
        parser.parse("java.util.List<SomeClass>");
        Assert.assertEquals("<java.lang.Object>", parser.getTypeArgumentsString());
        parser.parse(
            "java.util.HashMap<(kg.ash.demo.String|java.lang.String),java.math.BigDecimal>");
        Assert.assertEquals("<java.lang.String,java.math.BigDecimal>",
            parser.getTypeArgumentsString());
    }
}
