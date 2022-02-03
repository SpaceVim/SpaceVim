package com.wsdjeg.chat.server;

public class MessageTest {
    /* test format */
    /* test onWindowChange */
    public void testOnWindowChange() {
        //TODO
    }
    /* test userMessage */
    public void testUserMessage() {
        System.out.println(Message.userMessage(new User("root"), new User("wsd"), "helloworld!"));
    }
    /* test getTime */
    public void testGetTime() {
        //TODO
    }
    /* test format */
    public void testFormat() {
        System.out.println(Message.format("你好我,neo\\\""));
    }

    public void testOnGetConnection(){
        System.out.println(Message.onGetConnection());
    }
}
