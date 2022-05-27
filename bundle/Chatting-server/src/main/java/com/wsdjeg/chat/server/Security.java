package com.wsdjeg.chat.server;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Security {
    public static Map<String,Integer> blockIps = new HashMap<String,Integer>();
    public static Map<String,Long> blockTime = new HashMap<String,Long>();
    public static boolean isBlock(String ip){
        return ((System.currentTimeMillis() - getTimeOfIp(ip)) < 60000) && getSignTimes(ip) > 3;
    }

    private static Long getTimeOfIp(String ip){
        if (blockTime.containsKey(ip)) {
            return blockTime.get(ip);
        }
        return System.currentTimeMillis();
    }

    private static int getSignTimes(String ip){
        if (blockIps.containsKey(ip)) {
            return blockIps.get(ip);
        }
        return 0;
    }

    public static void sign(String ip){
        if (blockIps.containsKey(ip)) {
            blockIps.put(ip, blockIps.get(ip) + 1);
            blockTime.put(ip, System.currentTimeMillis());
        }else{
            blockIps.put(ip, 1);
            blockTime.put(ip, System.currentTimeMillis());
        }
    }
    public static void remove(String ip){
        if (blockIps.containsKey(ip) && blockTime.containsKey(ip)) {
            blockIps.remove(ip);
            blockTime.remove(ip);
        }
    }
}
