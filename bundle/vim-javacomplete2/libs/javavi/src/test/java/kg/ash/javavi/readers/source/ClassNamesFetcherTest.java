package kg.ash.javavi.readers.source;

import com.github.javaparser.ast.CompilationUnit;
import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class ClassNamesFetcherTest {


    @Test
    public void testClassnamesFetch() {
        String testClassDeclarationPath = 
            "src/test/resources/kg/ash/javavi/ClassWithClasses.java";

        CompilationUnitResult cur = CompilationUnitCreator.createFromFile(
                testClassDeclarationPath);
        Assert.assertNull(cur.getProblems());
        CompilationUnit cu = cur.getCompilationUnit();
        ClassNamesFetcher parser = new ClassNamesFetcher(cu);
        Set<String> result = parser.getNames();

        Assert.assertTrue(result.contains("BigDecimal"));
        Assert.assertTrue(result.contains("String"));
        Assert.assertTrue(result.contains("List"));
        Assert.assertTrue(result.contains("ArrayList"));
        Assert.assertTrue(result.contains("LinkedList"));
        Assert.assertEquals(5, result.size());
    }

    @Test
    public void testClassnamesFetchComplex() {
        String fetcherTestClassDeclarationPath
            = "src/test/resources/kg/ash/javavi/ResourceClassForClassFetcherTest.java";
        String waitFor = "UserTransaction, TestException, WebService, "
            + "HashMap, TestResponse, Resource, TestClass, String, "
            + "Logger, WebMethod, TestClassForbiddenException, Long, "
            + "EJB, BeanClass1, InterceptorRefs, InterceptorRef, BeanClass2, "
            + "WebParam, HashSet, Set, List, Map, Attr, ArrayList, HashLine, "
            + "SomeClass, unusualClassName, FakeAttr, StaticClassName, "
            + "AnotherStatic, ParentAnnotation, ChildAnnotation, format, "
            + "AnnotationForConstractor";
        Set<String> waitForList = new HashSet<>();
        waitForList.addAll(Arrays.asList(waitFor.split(", ")));

        CompilationUnitResult cur = CompilationUnitCreator.createFromFile(
                fetcherTestClassDeclarationPath);
        Assert.assertNull(cur.getProblems());
        CompilationUnit cu = cur.getCompilationUnit();
        ClassNamesFetcher parser = new ClassNamesFetcher(cu);
        Set<String> result = parser.getNames();

        Assert.assertEquals(waitForList, result);
    }
}
