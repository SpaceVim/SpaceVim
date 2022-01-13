package com.wsdjeg.chat.server;

public class MessageSender {
    public void send(User u, String msg){
        u.send(msg);
    }

    public void send(Group g, String msg){

    }
}
