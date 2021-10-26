package com.wsdjeg.chat.server;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.wsdjeg.chat.Server;

public class Command {
    public static final String SPLIT = "\\s+";
    private static Map<String,String> cmds = new HashMap<>();
    static {
        cmds.put("/help"         , "   /help : show help message.");
        cmds.put("/login"        , "   /login USERNAME PASSWORD : login with your chatting account.");
        cmds.put("/logout"       , "   /logout : logout current account.");
        cmds.put("/signup"       , "   /signup USERNAME PASSWORD PASSWORD: create a new account.");
        cmds.put("/password"     , "   /password : change the password of current user.");
        cmds.put("/names"        , "   /names : list all the user in current channel.");
        cmds.put("/join"         , "   /join : join a channel.");
        cmds.put("/msg"          , "   /msg : send a message to a user.");
        cmds.put("/query"        , "   /query : chatting with a user.");
        cmds.put("/addfriend"    , "   /addfriend : add a friend.");
        cmds.put("/removefriend" , "   /removefriend : remove a friend.");
        cmds.put("/list"         , "   /list : list all the channels in the server.");
        cmds.put("/connect"      , "   /connect : connect to a bot.");
        cmds.put("/disconnect"   , "   /disconnect : disconnect with a bot.");
        cmds.put("/debug"        , "   /dubug LEVEL: get the server log message by debug level, only for root.");
    }
    private Command(){

    }

    public static boolean isCommand(String str){
        return cmds.keySet().contains(str.split("\\s+")[0]);
    }

    public static String[] parser(String input){
        List<String> cli = new ArrayList<>();
        String inputs[] = input.split("\\s+");
        switch (inputs[0]) {
            case "/msg":
                if (inputs.length >= 3){
                    cli.add(inputs[0]);
                    cli.add(inputs[1]);
                    cli.add(input.replaceFirst("/msg\\s+", "").replaceFirst("\\S+\\s+", ""));
                    String[] result = new String[cli.size()];
                    return cli.toArray(result);
                }
                break;
            case "/query":
                if (inputs.length == 2 && inputs[1].matches("^[^#^\\s]+$")) {
                    cli.add(inputs[0]);
                    cli.add(inputs[1]);
                    String[] result = new String[cli.size()];
                    return cli.toArray(result);
                }
                break;
            case "/join":
                if (inputs.length == 2 && inputs[1].matches("^#[^\\s]+")) {
                    cli.add(inputs[0]);
                    cli.add(inputs[1]);
                    String[] result = new String[cli.size()];
                    return cli.toArray(result);
                }
        }
        return null;
    }

    public static String[] names(String ch){
        ArrayList<String> rst = new ArrayList<String>();
        String line = "";
        for (User s : GroupManager.getGroup(ch).getMembers()) {
            line += "[" + s.getUserName() + "] ";
            if (line.length() > 50) {
                rst.add(line);
                line = "";
            }
        }
        if (!line.equals("")) {
            rst.add(line);
        }
        String[] array = new String[rst.size()];
        return rst.toArray(array);
    }
    /**
     * Chatting Server: V0.1.0
     * command :
     *    /help : show help message.
     *    /login USERNAME PASSWORD : login with your chatting account.
     *    /signup USERNAME PASSWORD PASSWORD : create a new chatting account.
     *    /password NEWPASSWORD : change the password of current user.
     *    /join GROUP : join a chatting group
     *    ...
     *
     */
    public static String[] help(){
        List<String> help = new ArrayList<String>();

        help.add("Chatting Server: V" + Server.VERSION);
        help.add("commands :");
        help.addAll(cmds.values());


        return help.toArray(new String[help.size()]);
    }

    public static String[] list(){
        List<String> gs = new ArrayList<>();
        for (Group g: GroupManager.getGroups()) {
            gs.add(g.getName());
        }
        String[] result = new String[gs.size()];
        return gs.toArray(result);
    }

    public static Set<String> getCommands(){
        return cmds.keySet();
    }
}
