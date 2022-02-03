package com.wsdjeg.chat;

import java.net.Socket;

public class ClientTest {
    public static void main (String[] args) {
        try {
            Socket s = new Socket("perfi.wang",2013);
            System.out.println(s.getInetAddress());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
