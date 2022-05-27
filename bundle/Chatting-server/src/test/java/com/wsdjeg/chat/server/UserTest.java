package com.wsdjeg.chat.server;

import com.wsdjeg.chat.server.bot.SmartBot;

public class UserTest {
    /* test join */
    public void testJoin() {
        //TODO
    }
    /* test hashCode */
    public void testHashCode() {
        //TODO
    }
    /* test equals */
    public void testEquals() {
        User u1 = new User("root");
        User u2 = new User("root");
        System.out.println(u1.equals(u2));
    }
    /* test getClient */
    public void testGetClient() {
        String str = "/msg   nihao    122 aaa";
        System.out.println(str.replaceFirst("/msg\\s+", "").replaceFirst("\\S+\\s+", ""));
    }
    /* test setClient */
    public void testSetClient() {
        //TODO
    }
    /* test getUserName */
    public void testGetUserName() {
        //TODO
    }
    /* test setUserName */
    public void testSetUserName() {
        //TODO
    }
    /* test getFriends */
    public void testGetFriends() {
        //TODO
    }
    /* test removeFriend */
    public void testRemoveFriend() {
        //TODO
    }
    /* test send */
    public void testSend() {
        //TODO
    }
    /* test addFriend */
    public void testAddFriend() {
        //TODO
    }

    public void testSetSmartBot(){
        User u = new User("123");
        u.setSmartBot(new SmartBot());
        u.setSmartBot(new SmartBot());
    }

}
