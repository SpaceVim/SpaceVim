package com.wsdjeg.chat.server;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.wsdjeg.chat.Server;

public class Account {

    private static Map<String, String> accts = new HashMap<String ,String >();
    private static List<String> names = new ArrayList<String>();
    static {
        if (!Server.databaseFileName.isEmpty()) {
            File db = new File(Server.databaseFileName);
            if (db.exists() && db.isFile() && db.canRead() && db.canWrite()) {
                Logger.info("Loadding accounts from database file :" + Server.databaseFileName);
                accts = loadDatabase(db);
            }
        }
        if (!accts.keySet().contains("root")) {
            accts.put("root", "1234");
        }
    }
    private Account(){

    }
    public static Set<String> getAllAccounts(){
        return accts.keySet();
    }
    @SuppressWarnings("unchecked")
    public static Map<String,String> loadDatabase(File file){
        ObjectInputStream is;
        Map<String,String> loadAccts = new HashMap<>();
        try {
            is = new ObjectInputStream(new FileInputStream(file));
            loadAccts = (Map<String,String>)is.readObject();
        } catch (FileNotFoundException e) {
            Logger.error("File can not found:" + file.getPath());
        } catch (IOException e){
            Logger.error("Can not load accounts from database.");
        } catch (ClassNotFoundException e){
            Logger.error("Can not readObject from database.");
        }
        return loadAccts;
    }

    public static void updateDatabase(File f) {
        try{
            FileOutputStream out = new FileOutputStream(f);
            out.write(new String("").getBytes());
            out.close();
            ObjectOutputStream os = new ObjectOutputStream(new FileOutputStream(f));
            os.writeObject(accts);
            os.close();
        }catch (FileNotFoundException e){
            Logger.error("File can not found:" + f.getPath());
        }catch (IOException e){
            Logger.error("Can not update database.");
        }
    }

    public static boolean login(String username, String password){
        if (accts.keySet().contains(username)
                && accts.get(username).equals(password)
                && !names.contains(username)) {
            names.add(username);
            return true;
        }
        return false;
    }
    private static List<ServerThread> serverThreads = new ArrayList<>();
    public static void register(ServerThread s){
        if (!serverThreads.contains(s)) {
            serverThreads.add(s);
        }
    }
    public static void loginOut(ServerThread s){
        if (serverThreads.contains(s)){
            serverThreads.remove(s);
        }
        if (names.contains(s.getName())){
            names.remove(s.getName());
        }
        User u = UserManager.getUser(s.getName());
        if ( u != null) {
            u.left();
        }
    }
    public static List<ServerThread> getServerThreads(){
        return serverThreads;
    }

    public static boolean signin(String name, String pw, String pwcf){
        if (!pw.equals(pwcf)) {
            return false;
        }
        if (accts.containsKey(name)){
            return false;
        }

        accts.put(name, pw);
        if (!Server.databaseFileName.isEmpty()) {
            updateDatabase(new File(Server.databaseFileName));
        }
        names.add(name);
        return true;
    }

    public static boolean password(String user,String password){
        if ( accts.keySet().contains(user)){
            accts.put(user, password);
            if (!Server.databaseFileName.isEmpty()) {
                updateDatabase(new File(Server.databaseFileName));
            }
            return true;
        }
        return false;
    }

    public static boolean loginAble(String name,String pw){
        if (accts.keySet().contains(name) && accts.get(name).equals(pw)) {
            return true;
        }
        return false;
    }

}
