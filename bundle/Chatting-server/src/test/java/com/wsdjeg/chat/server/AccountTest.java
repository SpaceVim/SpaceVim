package com.wsdjeg.chat.server;

import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.util.HashMap;
import java.util.Map;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import com.wsdjeg.chat.server.Account;

public class AccountTest {
    /* test register */
    public void testRegister() {
        //TODO
    }
    /* test password */
    public void testPassword() {
        System.out.println(Account.password("root", "12341"));
        System.out.println(Account.login("root", "12341"));
    }
    /* test signin */
    public void testSignin() {
        //TODO
    }
    /* test getServerThreads */
    public void testGetServerThreads() {
        //TODO
    }
    /* test loginOut */
    public void testLoginOut() {
        //TODO
    }
    /* test login */
    public void testLogin() {
        //TODO
    }
    public void testLoadDatabase()throws Exception{
        File f = new File("test.txt");
        Map<String,String> s = new HashMap<>();
        s.put("root", "1234");
        ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(f));
        os.writeObject(s);
        os.close();
        s = Account.loadDatabase(f);
        System.out.println(s.get("root"));


    }

}

