package kg.ash.javavi;

import kg.ash.javavi.actions.Action;
import kg.ash.javavi.actions.ActionFactory;
import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;
import kg.ash.javavi.searchers.ClasspathCollector;

import java.util.HashMap;

public class Javavi {

    public static final String VERSION = "2.4.3";

    public static String NEWLINE = "";

    public static final Logger logger = LogManager.getLogger();

    static void output(String s) {
        System.out.print(s);
    }

    private static void usage() {
        version();
        System.out.println(
            "  java [-classpath] kg.ash.javavi.Javavi [-sources sourceDirs] [-h] [-v] [-d] [-D "
                + "port] [action]");
        System.out.println("Options:");
        System.out.println("  -h	        help");
        System.out.println("  -v	        version");
        System.out.println("  -sources      sources directory");
        System.out.println("  -d            enable debug mode");
        System.out.println("  -D port       start daemon on specified port");
    }

    private static void version() {
        System.out.println("Reflection and parsing for javavi " + "vim plugin (" + VERSION + ")");
    }

    public static HashMap<String, String> system = new HashMap<>();
    public static Daemon daemon = null;

    public static void main(String[] args) {
        logger.info("starting javavi server on port: {}", System.getProperty("daemon.port", "0"));

        if (logger.isTraceEnabled()) {
            logger.trace("output included libraries");
            new ClasspathCollector().collectClassPath().forEach(logger::trace);
        }

        String response = makeResponse(args);

        output(response);
    }

    public static String makeResponse(String[] args) {

        long ms = System.currentTimeMillis();
        Action action = null;
        boolean asyncRun = false;
        for (int i = 0; i < args.length; i++) {
            String arg = args[i];
            logger.debug("argument: {}", arg);
            switch (arg) {
                case "-h":
                    usage();
                    return "";
                case "-v":
                    version();
                    return "";
                case "-sources":
                    system.put("sources", args[++i]);
                    break;
                case "-n":
                    NEWLINE = "\n";
                    break;
                case "-base":
                    system.put("base", args[++i]);
                    break;
                case "-project":
                    system.put("project", args[++i]);
                    break;
                case "-compiler":
                    system.put("compiler", args[++i]);
                    break;
                case "-async":
                    asyncRun = true;
                    break;
                default:
                    if (action == null) {
                        action = ActionFactory.get(arg);
                    }
            }

            if (action != null) {
                break;
            }
        }

        String result = "";
        if (action != null) {
            logger.debug("new {} action: \"{}\"", asyncRun ? "async" : "",
                action.getClass().getSimpleName());

            if (asyncRun) {
                final Action a = action;
                new Thread(() -> a.perform(args)).start();
            } else {
                result = action.perform(args);
            }
        }
        logger.debug("action time: {}ms", (System.currentTimeMillis() - ms));
        return result;
    }
}
