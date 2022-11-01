package kg.ash.javavi.actions;

import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.core.LoggerContext;
import kg.ash.javavi.apache.logging.log4j.core.lookup.StrLookup;

public class GetDebugLogPath implements Action {

    @Override
    public String perform(String[] args) {
        LoggerContext ctx = (LoggerContext) LogManager.getContext();
        StrLookup lookup = (ctx.getConfiguration()).getStrSubstitutor().getVariableResolver();
        String timeId = lookup.lookup("log.time_id");
        String logsDirectory = System.getProperty("log.directory", lookup.lookup("log.directory"));
        String daemonPort = System.getProperty("daemon.port", lookup.lookup("daemon.port"));
        return String.format("%s/%s-%s.log", logsDirectory, timeId, daemonPort);
    }
}
