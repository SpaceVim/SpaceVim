package com.wsdjeg.chat.server;

import java.util.HashSet;
import java.util.Set;

public class CommandTest {
    /* test help */
    public void testHelp() {
        //TODO
    }
    /* test names */
    public void testNames() {
        //TODO
    }
    /* test parser */
    public void testParser() {
        Set<String> s = new HashSet<>();
        s.add("/msg root 123");
        s.add("/query root");
        s.add("/join #vim");
        for (String cmd : s) {
            for (String arg :Command.parser(cmd)){
                System.out.print(arg);
                System.out.print(" ");
            }
            System.out.println();

        }
    }
    /* test isCommand */
    public void testIsCommand() {
        System.out.println(Command.isCommand("/login  wsdjeg 1234 "));
    }

}
