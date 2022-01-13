package com.wsdjeg.chat.server;

import java.util.ArrayList;
import java.util.List;

public  class Group {
    private String name;
    private int id;
    private List<User> members = new ArrayList<>();
    public Group(String name){
        this.name = name;
        this.id = GroupManager.generateId();
    }

    public String getName() {
        return name;
    }

    public int getId() {
        return id;
    }


    public boolean hasMember(User user){
        return members.contains(user);
    }

    public Group addMember(User user){
        if (!members.contains(user)) {
            members.add(user);
        }
        return this;
    }

    public Group removeMember(User user){
        if (members.contains(user)) {
            members.remove(user);
        }
        return this;
    }

    public void send(User sender, String msg){
        String line = Message.format(getName(), sender.getUserName(), msg);
        for (User m : members) {
            m.send(line);
        }
    }

    public void send(String msg){
        for (User m : members) {
            m.send(msg);
        }
    }

    public List<User> getMembers() {
        return members;
    }
}
