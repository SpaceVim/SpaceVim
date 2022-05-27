package com.wsdjeg.util;

import java.lang.reflect.Method;

public class GenerateMethod {
    public static void main(String[] args) {
        System.out.println(listMethos(args[0]));
    }
    private static String listMethos(String name){
        Class<?> clazz = null;
        try {
            clazz = Class.forName(name);
        } catch(Exception e){
            e.printStackTrace();
        }
        Method[] mds = clazz.getDeclaredMethods();
        String result = "";
        for (int i = 0; i < mds.length; i++) {
            if (result.length()>0) {
                result = result + "|" +mds[i].getName();
            }else{
                result = mds[0].getName();
            }
        }
        return result;
    }
}

