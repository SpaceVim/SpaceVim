package kg.ash.javavi.actions;

import kg.ash.javavi.Javavi;
import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;
import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.ClassNameMap;
import kg.ash.javavi.searchers.JavaClassMap;

import java.io.File;

public class ClassRecompileAction extends ActionWithTarget {

    public static final Logger logger = LogManager.getLogger();

    @Override
    public String perform(String[] args) {
        String target = parseTarget(args);
        String[] splitted = target.split("\\.");

        ClassNameMap classMap = findClass(splitted[splitted.length - 1]);
        if (classMap != null && classMap.getClassFile() != null && classMap.getJavaFile() != null) {
            String classFile = classMap.getClassFile();
            String sourceFile = classMap.getJavaFile();
            String classDir = classFile.substring(0, classFile.lastIndexOf(File.separator));

            int offset = findOffset(sourceFile.substring(0, sourceFile.lastIndexOf(File.separator)),
                classDir);
            classDir = classFile.substring(0, offset);

            if (classDir.isEmpty()) {
                return "";
            }

            String compiler = Javavi.system.get("compiler");
            String classPath = System.getProperty("java.class.path");

            execute(String.format("%s -cp %s -d %s %s", compiler, classPath, classDir, sourceFile));
        }

        return "";
    }

    private void execute(String command) {
        try {
            Process p = Runtime.getRuntime().exec(command);
            p.waitFor();
        } catch (Exception e) {
            logger.error(e);
        }
    }

    private int findOffset(String sourceFile, String classDir) {
        int offset = 0;
        while (!sourceFile.endsWith(classDir)) {
            int index = classDir.indexOf(File.separator, 2);
            if (index == 0) {
                return 0;
            }

            classDir = classDir.substring(index);
            offset += index;
        }
        return offset;
    }

    private ClassNameMap findClass(String name) {
        JavaClassMap classMap = Cache.getInstance().getClassPackages().get(name);
        if (classMap != null && classMap instanceof ClassNameMap) {
            return (ClassNameMap) classMap;
        }
        return null;
    }

}
