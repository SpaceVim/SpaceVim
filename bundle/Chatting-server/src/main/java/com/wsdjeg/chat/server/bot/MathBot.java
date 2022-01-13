package com.wsdjeg.chat.server.bot;

import java.util.ArrayList;
import java.util.List;

import com.wsdjeg.chat.server.Command;
import com.wsdjeg.chat.server.util.MathUtils;

public class MathBot implements Bot{
    private String version = "0.1.0";
    private String name = "MathBot";
    private String GET_LIST_BY_SUM = "/get_list_by_sum";
    private List<Integer> integerList = new ArrayList<>();
    private String type;

    public String reply(String msg){
        if (msg.equals(GET_LIST_BY_SUM)) {
            type = GET_LIST_BY_SUM;
            return "MathBot type is " + type;
        }
        if (type != null) {
            return reply(type, msg);
        }else{
            return "you need select a type.";
        }
    }
    private String reply(String type, String msg){
        if (type.equals(GET_LIST_BY_SUM)) {
            if (isInteger(msg)) {
                integerList.add(Integer.valueOf(msg));
                return msg + " is added into list!";
            }else if (msg.matches("^/sum [1-9][0-9]*$")) {
                return "sum list is : " + MathUtils.getResult(integerList, Integer.valueOf(msg.split(Command.SPLIT)[1]));
            }else{
                return "please insert a integer or use /sum command.";
            }
        }else{
            return null;
        }
    }

    private boolean isInteger(String i){
        return i.matches("^[1-9][0-9]*$");
    }

    public String[] help(){
        List<String> help = new ArrayList<String>();

        help.add(name + " : V" + this.version);
        help.add("types :");
        help.add("   /get_list_by_sum :");
        help.add("      /sum Integer: get the result.");


        return help.toArray(new String[help.size()]);
    }

    public String getName(){
        return name;
    }
}
