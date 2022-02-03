package com.wsdjeg.chat.server.bot;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.wsdjeg.chat.server.Account;
import com.wsdjeg.chat.server.Command;
import com.wsdjeg.chat.server.User;
import com.wsdjeg.chat.server.UserManager;
import com.wsdjeg.chat.server.bot.Bot;

public class SmartBot implements Bot {

    private String name = "lazycat";
    private String version = "0.1.0";
    private Map<String,String> msgDict = new HashMap<>();

    @Override
    public String getName() {
        return name;
    }

    public void setName(String name){
        this.name = name;
    }

    @Override
    public String[] help() {
        List<String> help = new ArrayList<String>();

        help.add(name + " : V" + this.version);
        help.add("types :");
        help.add("   /register USERNAME PASSWORD");
        help.add("   /learn pattern message");
        help.add("   /rename BOTNAME");
        return help.toArray(new String[help.size()]);
    }

    @Override
    public String reply(String string) {
        if (string.matches("^/register\\s\\S+\\s\\S+$")) {
            String[] cmds = string.split(Command.SPLIT);
            if (Account.loginAble(cmds[1], cmds[2])) {
                User u = UserManager.getUser(cmds[1]);
                if (u != null) {
                    u.setSmartBot(this);
                    return "you have set " + name + "(SmartBot) as " + u.getUserName() +" smartBot!";
                }
            }
        }else if (string.matches("^/learn\\s\\S+\\s(\\S+\\s*)+$")) {
            String[] cmds = string.split(Command.SPLIT);
            String lmsg = "";
            for (int i = 2; i < cmds.length; i++) {
                if (!lmsg.isEmpty()) {
                    lmsg += " ";
                }
                lmsg += cmds[i];
            }
            msgDict.put(cmds[1], lmsg);
            return "learn " + cmds[1];
        }else if (string.matches("^/rename\\s\\S+$")) {
            String[] cmds = string.split(Command.SPLIT);
            setName(cmds[1]);
            return "SmartBot's name change to " + name;
        }
        return msgDict.get(string) + " --- from SmartBot: " + name;
    }

    public Map<String,String> getMsgDict() {
        return msgDict;
    }
}
