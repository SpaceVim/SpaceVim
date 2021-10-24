package com.wsdjeg.chat.server;

public class SecurityTest {
    /* test sign */
    public void testSign() {
        Security.sign("127.0.0.1");
        Security.sign("127.0.0.1");
        Security.sign("127.0.0.1");
        Security.sign("127.0.0.1");
        System.out.println(Security.isBlock("127.0.0.1"));
    }
    /* test isBlock */
    public void testIsBlock() {
        long i = System.currentTimeMillis();
        try {
            Thread.sleep(1000);
        } catch (Exception e) {
            e.printStackTrace();
        }
        long y = System.currentTimeMillis();
        System.out.println(i);
        System.out.println(y);
        System.out.println(y - i);
    }
    /* test block */
    public void testBlock() {
        //TODO
    }

}
