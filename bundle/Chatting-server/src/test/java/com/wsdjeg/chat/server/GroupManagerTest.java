package com.wsdjeg.chat.server;

public class GroupManagerTest {
    /* test generateId */
    public void testGenerateId() {
        //TODO
    }
    /* test getGroup */
    public void testGetGroup() {
        //TODO
    }
    /* test newGroup */
    public void testNewGroup() {
        User u = new User("wsd");
        System.out.println(GroupManager.newGroup("vim"));
        GroupManager.getGroup("vim").addMember(u);
    }
    /* test getGroupId */
    public void testGetGroupId() {
        //TODO
    }

}
