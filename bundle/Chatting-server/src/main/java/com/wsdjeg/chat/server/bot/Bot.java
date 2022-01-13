package com.wsdjeg.chat.server.bot;

public interface Bot {
    public String reply(String str);
    public String[] help();
    public String getName();
}
