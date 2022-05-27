package com.wsdjeg.chat.server.util;

import java.util.HashMap;
import java.util.Map;

public class JsonBuilderTest {
    /* test decode */
    public void testDecode() {
        Map<String,String> o = new HashMap<>();
        o.put("name", "wsdjeg");
        o.put("pa\"ssword", "12\\" + "\"34");
        System.out.println(JsonBuilder.decode(o));
        // output: {"name":"wsdjeg","pa\\\"ssword":"12\"34"}
    }

}
