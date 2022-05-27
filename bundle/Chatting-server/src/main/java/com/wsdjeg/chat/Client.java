package com.wsdjeg.chat;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

public class Client {
    private static String SERVER_IP = "127.0.0.1";
    private static int SERVER_PORT = 2013;
    private Socket client;
    private PrintWriter out;
    private BufferedReader in;
    private Client() throws Exception{
        client = new Socket(SERVER_IP, SERVER_PORT);
        out = new PrintWriter(client.getOutputStream(), true);
        in = new BufferedReader(new InputStreamReader(System.in));
        new ReadLineThread();
        while (true) {
            String msg = in.readLine();
            out.println(msg);
            if ("bye".equals(msg)) {
                break;
            }
        }
    }
    public static void main (String[] args) {
        try {
            if (args.length == 2){
                SERVER_IP = args[0];
                SERVER_PORT = Integer.valueOf(args[1]);
            }
            new Client();
        } catch (Exception e) {
        }
    }
    class ReadLineThread extends Thread {
        private BufferedReader buff;
        public ReadLineThread() throws Exception{
            buff = new BufferedReader(new InputStreamReader(client.getInputStream()));
            start();
        }
        public void run(){
            try {
                String result;
                while((result = buff.readLine()) != null){
                    if("bye, Client!".equals(result)){
                        break;
                    }else{
                        if (result != null) {
                            System.out.println(result);
                        }
                    }
                }
                in.close();
                out.close();
                client.close();
            } catch (Exception e) {
            }
        }
    }
}
