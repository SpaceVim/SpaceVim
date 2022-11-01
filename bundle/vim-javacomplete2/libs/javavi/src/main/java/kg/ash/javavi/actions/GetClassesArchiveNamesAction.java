package kg.ash.javavi.actions;

import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;
import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.JavaClassMap;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GetClassesArchiveNamesAction extends ActionWithTarget {

    public static final Logger logger = LogManager.getLogger();

    @Override
    public String perform(String[] args) {
        String classes = parseTarget(args);

        Map<String, List<String>> result = new HashMap<>();
        for (String _classFqn : classes.split(",")) {
            final String classFqn = removeStaticKeyword(_classFqn);

            String[] classFqnArray = classFqn.split("\\.");
            String className = classFqnArray[classFqnArray.length - 1];

            logger.debug("class name: {}", className);

            HashMap<String, JavaClassMap> classPackages = getClassPackages();
            if (classPackages.containsKey(className)) {
                String classPackage = removeLastElementAndJoin(classFqnArray);

                logger.debug("class name: {}", className);

                JavaClassMap cm = classPackages.get(className);
                Arrays.stream(new String[] { "", "$" }).forEach(s -> {
                    if (cm.getSubpackages().get(classPackage + s) != null) {
                        String fileName = cm.getSubpackages().get(classPackage + s);
                        if (result.containsKey(fileName)) {
                            result.get(fileName).add(classFqn);
                        } else {
                            result.put(fileName, new ArrayList<>(Arrays.asList(classFqn)));
                        }
                    }
                });
            }
        }
        return String.format("[%s]", buildResult(result));
    }

    private String removeStaticKeyword(String classFqn) {
        if (classFqn.contains(" ")) {
            return classFqn.split(" ")[1];
        }
        return classFqn;
    }

    private HashMap<String, JavaClassMap> getClassPackages() {
        return Cache.getInstance().getClassPackages();
    }

    private String removeLastElementAndJoin(String[] array) {
        String[] newArray = new String[array.length - 1];
        System.arraycopy(array, 0, newArray, 0, newArray.length);
        return String.join(".", newArray);
    }

    private StringBuilder buildResult(Map<String, List<String>> result) {
        StringBuilder builder = new StringBuilder();
        result.forEach((s, l) -> {
            builder.append("['").append(s).append("',[");
            l.forEach(classFqn -> builder.append("'").append(classFqn).append("',"));
            builder.append("]],");
        });
        return builder;
    }
}
