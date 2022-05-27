package com.wsdjeg.chat.server;

public class LoggerTest {
    /* test log */
    public void testLog() {
        Logger.setLevel(3);
        Logger.log(1, "1234");
        Logger.log(2, "hello");
        Logger.log(3, "helloworld");
    }
    /* test setLevel */
    public void testSetLevel() {
        //TODO
    }

}
