package kg.ash.javavi.output;

import com.github.javaparser.ast.Modifier;
import kg.ash.javavi.clazz.ClassConstructor;
import kg.ash.javavi.clazz.ClassField;
import kg.ash.javavi.clazz.ClassMethod;
import kg.ash.javavi.clazz.ClassTypeParameter;
import kg.ash.javavi.clazz.SourceClass;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import java.util.EnumSet;

public class OutputClassInfoTest {

    private SourceClass clazz;
    private OutputClassInfo oci;

    @Before
    public void Init() {
        oci = new OutputClassInfo();

        clazz = new SourceClass();
        clazz.setName("Bar");
        clazz.setPackage("foo.bar");
        clazz.setIsInterface(false);
        clazz.setModifiers(EnumSet.of(Modifier.PUBLIC));
    }

    @Test
    public void testEmptyClass() {
        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[],'fields':[],'methods':[],},}", oci.get(clazz));
    }

    @Test
    public void testConstructors() {
        ClassConstructor cc = new ClassConstructor();
        cc.setDeclaration("public Bar(Foo foo)");
        cc.setModifiers(EnumSet.of(Modifier.PUBLIC));
        ClassTypeParameter ctp = new ClassTypeParameter("Foo");
        cc.addTypeParameter(ctp);

        clazz.addConstructor(cc);

        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[{'m':'1','p':['Foo',],'d':'public Bar(Foo foo)'},],"
                + "'fields':[],'methods':[],},}", oci.get(clazz));
    }

    @Test
    public void testTwoConstructors() {
        ClassConstructor cc = new ClassConstructor();
        cc.setModifiers(EnumSet.of(Modifier.PUBLIC));
        cc.setDeclaration("public Bar()");

        clazz.addConstructor(cc);

        cc = new ClassConstructor();
        cc.setDeclaration("public Bar(Foo foo)");
        cc.setModifiers(EnumSet.of(Modifier.PUBLIC));
        ClassTypeParameter ctp = new ClassTypeParameter("Foo");
        cc.addTypeParameter(ctp);

        clazz.addConstructor(cc);

        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[{'m':'1','d':'public Bar()'},{'m':'1','p':['Foo',],"
                + "'d':'public Bar(Foo foo)'},],'fields':[],'methods':[],},}", oci.get(clazz));
    }

    @Test
    public void testFields() {
        ClassField field = new ClassField();
        field.setTypeName("Foo");
        field.setName("foo");
        field.setModifiers(EnumSet.of(Modifier.PUBLIC));

        clazz.addField(field);

        field = new ClassField();
        field.setTypeName("Bar");
        field.setName("bar");
        field.setModifiers(EnumSet.of(Modifier.PRIVATE));

        clazz.addField(field);

        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[],'fields':[{'n':'foo','c':'Foo','m':'1','t':'Foo'},"
                + "{'n':'bar','c':'Bar','m':'10','t':'Bar'},],'methods':[],},}", oci.get(clazz));
    }

    @Test
    public void testMethods() {
        ClassMethod method = new ClassMethod();
        method.setTypeName("Foo");
        method.setName("foo");
        method.setModifiers(EnumSet.of(Modifier.PUBLIC));
        method.setDeclaration("public Foo foo()");

        clazz.addMethod(method);

        method = new ClassMethod();
        method.setTypeName("Bar");
        method.setName("bar");
        method.setModifiers(EnumSet.of(Modifier.PRIVATE));
        method.setDeclaration("private Bar bar()");

        clazz.addMethod(method);

        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[],'fields':[],'methods':[{'n':'foo','c':'Foo','m':'1',"
                + "'r':'Foo','d':'public Foo foo()'},{'n':'bar','c':'Bar','m':'10','r':'Bar',"
                + "'d':'private Bar bar()'},],},}", oci.get(clazz));
    }

    @Test
    public void testExtends() {
        clazz.setSuperclass("foo.baz.Baz");
        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','extends':['foo.baz.Baz'],"
                + "'implements':[],'nested':[],'ctors':[],'fields':[],'methods':[],},}",
            oci.get(clazz));
    }

    @Test
    public void testImplements() {
        clazz.addInterface("foo.baz.Baz");
        clazz.addInterface("foo.bas.Bas");
        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':['foo.baz"
                + ".Baz','foo.bas.Bas',],'nested':[],'ctors':[],'fields':[],'methods':[],},}",
            oci.get(clazz));
    }

    @Test
    public void testTypeArguments() {
        clazz.addTypeArgument("A");
        clazz.addTypeArgument("B");
        Assert.assertEquals(
            "{'foo.bar.Bar<A,B>':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar<A,B>',"
                + "'classpath':'1','pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar<A,B>',"
                + "'implements':[],'nested':[],'ctors':[],'fields':[],'methods':[],},}",
            oci.get(clazz));
    }

    @Test
    public void testCompleteClass() {
        ClassConstructor cc = new ClassConstructor();
        cc.setDeclaration("public Bar(Foo foo)");
        cc.setModifiers(EnumSet.of(Modifier.PUBLIC));
        ClassTypeParameter ctp = new ClassTypeParameter("Foo");
        cc.addTypeParameter(ctp);
        clazz.addConstructor(cc);

        ClassField field = new ClassField();
        field.setTypeName("Foo");
        field.setName("foo");
        field.setModifiers(EnumSet.of(Modifier.PUBLIC));
        clazz.addField(field);

        ClassMethod method = new ClassMethod();
        method.setTypeName("Foo");
        method.setName("foo");
        method.setModifiers(EnumSet.of(Modifier.PUBLIC));
        method.setDeclaration("public Foo foo()");
        clazz.addMethod(method);

        clazz.addInterface("foo.baz.Baz");
        clazz.addInterface("foo.bas.Bas");
        clazz.setSuperclass("foo.baz.Baz");

        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','extends':['foo.baz.Baz'],"
                + "'implements':['foo.baz.Baz','foo.bas.Bas',],'nested':[],'ctors':[{'m':'1',"
                + "'p':['Foo',],'d':'public Bar(Foo foo)'},],'fields':[{'n':'foo','c':'Foo',"
                + "'m':'1','t':'Foo'},],'methods':[{'n':'foo','c':'Foo','m':'1','r':'Foo',"
                + "'d':'public Foo foo()'},],},}", oci.get(clazz));
    }

    @Test
    public void testNullRequest() {
        Assert.assertEquals("", oci.get(null));
    }

    @Test
    public void testNullConstructor() {
        clazz.addConstructor(null);
        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[],'fields':[],'methods':[],},}", oci.get(clazz));
    }

    @Test
    public void testNullField() {
        clazz.addField(null);
        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[],'fields':[],'methods':[],},}", oci.get(clazz));
    }

    @Test
    public void testNullMethod() {
        clazz.addMethod(null);
        Assert.assertEquals(
            "{'foo.bar.Bar':{'tag':'CLASSDEF','flags':'1','name':'foo.bar.Bar','classpath':'1',"
                + "'pos':[-1,-1],'endpos':[-1,-1],'fqn':'foo.bar.Bar','implements':[],"
                + "'nested':[],'ctors':[],'fields':[],'methods':[],},}",
            oci.get(clazz));
    }
}
