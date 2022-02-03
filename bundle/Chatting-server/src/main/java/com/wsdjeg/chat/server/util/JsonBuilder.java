package com.wsdjeg.chat.server.util;

import java.util.Map;

public class JsonBuilder {
    public static String decode(Map<String,String> o){
        String begin = "{";
        for (String key : o.keySet()) {
            begin = begin
                +  "\"" + key
                .replace("\\", "\\" + "\\")
                .replace("\"", "\\" + "\"")
                + "\":\"" + o.get(key)
                .replace("\\", "\\" + "\\")
                .replace("\"", "\\" + "\"")
                + "\"," ;
        }

        begin = begin.substring(0, begin.length() - 1) + "}";
        return begin;
    }

    public static Map<String ,String > encode(String json){
        return null;
    }
}
