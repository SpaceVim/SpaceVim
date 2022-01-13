package com.wsdjeg.chat.server;

import java.net.Socket;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.wsdjeg.chat.server.util.JsonBuilder;

public class Message {
    public static String format(String name, String msg){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "user_message");
        m.put("sendder", name);
        m.put("context", msg);
        return JsonBuilder.decode(m);
    }
    public static String format(String msg){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "info_message");
        m.put("context", msg);
        return JsonBuilder.decode(m);
    }
    public static String format(String gName, String uName, String msg){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "group_message");
        m.put("sendder", uName);
        m.put("context", msg);
        m.put("group_name", gName);
        return JsonBuilder.decode(m);
    }

    public static String onWindowChange(Group g){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "onWindowChange");
        m.put("name", g.getName());
        return JsonBuilder.decode(m);
    }

    public static String onWindowChange(User u){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "onWindowChange");
        m.put("name", u.getUserName());
        return JsonBuilder.decode(m);
    }
    public static String getTime(){
        Timestamp ts = new Timestamp(System.currentTimeMillis());
        DateFormat df = new SimpleDateFormat("HH:mm:ss");
        return df.format(ts);
    }

    public static String groupMessage(User sendder, Group group, String msg){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "group_message");
        m.put("sendder", sendder.getUserName());
        m.put("group_name", group.getName());
        m.put("context", msg);
        return JsonBuilder.decode(m);
    }
    public static String userMessage(User sendder, User receiver, String msg){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "user_message");
        m.put("sendder", sendder.getUserName());
        m.put("receiver", receiver.getUserName());
        m.put("context", msg);
        return JsonBuilder.decode(m);
    }

    public static String onLeft(User u, Group g){

        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "onLeft");
        m.put("user", u.getUserName());
        m.put("group_name", g.getName());
        return JsonBuilder.decode(m);
    }

    public static String onGetConnection(){
        Map<String,String> m = new HashMap<>();
        m.put("time", getTime());
        m.put("type", "onGetConnection");
        m.put("commands", String.join(",", Command.getCommands()));
        return JsonBuilder.decode(m);
    }
}
