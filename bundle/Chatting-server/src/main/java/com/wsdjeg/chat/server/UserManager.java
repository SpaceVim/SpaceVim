package com.wsdjeg.chat.server;

import java.util.ArrayList;
import java.util.List;

/**
 * UserManager API:
 * 1. Create a new user.
 * 2. get a user.
 */
public class UserManager {
    private static List<User> users = new ArrayList<>();
    static {
        for (String acct : Account.getAllAccounts()) {
            add(create(acct));
        }
    }
    public static void add(User user){
        if (!users.contains(user)){
            users.add(user);
        }
    }
    public static User create(String name){
        if (getUser(name) == null) {
            User user = new User(name);
            add(user);
            return user;
        }
        return getUser(name);
    }
    public static User getUser(String name){
        for (User user : users) {
            if (user.getUserName().equals(name)) {
                return user;
            }
        }
        return null;
    }
}
