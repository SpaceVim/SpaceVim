package kg.ash.javavi.actions;

import kg.ash.javavi.Javavi;
import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;

public class GetClassInfoActionTest {

    @Ignore
    @Test
    public void testCorrect() {
        Javavi.system.put("sources", "");
        GetClassInfoAction cia = new GetClassInfoAction();

        JSONObject json = new JSONObject(
            "{'java.lang.Object':{'implements':[],'fqn':'java.lang.Object','classpath':'1',"
                + "'ctors':[{'d':'public java.lang.Object()','m':'1'}],'methods':[{'r':'void',"
                + "'c':'void','d':'protected void java.lang.Object.finalize() throws java.lang"
                + ".Throwable','m':'100','n':'finalize'},{'p':['long','int'],'r':'void',"
                + "'c':'void','d':'public final void java.lang.Object.wait(long,int) throws java"
                + ".lang.InterruptedException','m':'10001','n':'wait'},{'p':['long'],'r':'void',"
                + "'c':'void','d':'public final native void java.lang.Object.wait(long) throws "
                + "java.lang.InterruptedException','m':'100010001','n':'wait'},{'r':'void',"
                + "'c':'void','d':'public final void java.lang.Object.wait() throws java.lang"
                + ".InterruptedException','m':'10001','n':'wait'},{'p':['java.lang.Object'],"
                + "'r':'boolean','c':'boolean','d':'public boolean java.lang.Object.equals(java"
                + ".lang.Object)','m':'1','n':'equals'},{'r':'java.lang.String','c':'java.lang"
                + ".String','d':'public java.lang.String java.lang.Object.toString()','m':'1',"
                + "'n':'toString'},{'r':'int','c':'int','d':'public native int java.lang.Object"
                + ".hashCode()','m':'100000001','n':'hashCode'},{'r':'java.lang.Class<?>',"
                + "'c':'java.lang.Class<?>','d':'public final native java.lang.Class<?> java.lang"
                + ".Object.getClass()','m':'100010001','n':'getClass'},{'r':'java.lang.Object',"
                + "'d':'protected native java.lang.Object java.lang.Object.clone() throws java"
                + ".lang.CloneNotSupportedException','m':'100000100','n':'clone'},{'r':'void',"
                + "'c':'void','d':'private static native void java.lang.Object.registerNatives()"
                + "','m':'100001010','n':'registerNatives'},{'r':'void','c':'void','d':'public "
                + "final native void java.lang.Object.notify()','m':'100010001','n':'notify'},"
                + "{'r':'void','c':'void','d':'public final native void java.lang.Object"
                + ".notifyAll()','m':'100010001','n':'notifyAll'}],'flags':'1','name':'java.lang"
                + ".Object','tag':'CLASSDEF','fields':[],'nested':[]}}");
        Assert.assertTrue(
            json.similar(new JSONObject(cia.perform(new String[] { "-E", "java.lang.Object" }))));
    }
}
