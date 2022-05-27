package com.wsdjeg.chat.server;

import java.util.ArrayList;
import java.util.List;

/**
 * GroupManager API:
 * 1. Create new group;
 * 2. delete a group
 * 3. search for a group
 * 4. edit a group
 */

public class GroupManager {
    private GroupManager(){

    }

    private static List<Group> groups = new ArrayList<>();


    public static Group newGroup(String name){
        if (getGroupId(name) == 0){
            Group group = new Group(name);
            groups.add(group);
            return group;
        }
        return null;
    }

    public static int getGroupId(String name){
        for (Group g : groups) {
            if (g.getName().equals(name)) {
                return g.getId();
            }
        }
        return 0;
    }

    public static int generateId(){
        return groups.size() + 1;
    }

    public static Group getGroup(String groupName){
        for (Group g : groups) {
            if (g.getName().equals(groupName)) {
                return g;
            }
        }
        return null;
    }
    public static Group getGroup(int id){
        for (Group g : groups) {
            if (g.getId() == id) {
                return g;
            }
        }
        return null;
    }

    public static List<Group> getGroups() {
        return groups;
    }
}
