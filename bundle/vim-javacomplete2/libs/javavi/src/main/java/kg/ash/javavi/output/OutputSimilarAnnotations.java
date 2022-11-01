package kg.ash.javavi.output;

import kg.ash.javavi.searchers.JavaClassMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.function.Predicate;

public class OutputSimilarAnnotations extends OutputSimilar {

    public OutputSimilarAnnotations(HashMap<String, JavaClassMap> classPackages) {
        super(classPackages);
        wordPrefix = "@";
    }

    @Override
    protected List<String> getKeys(String target) {
        List<String> keysResult = new ArrayList<>();

        classPackages.forEach((key, value) -> {
            if (target.isEmpty() || key.startsWith(target)) {
                value.getPaths()
                    .stream()
                    .filter(isFromClasspath(value))
                    .forEach(fqn -> addIfAnnotation(keysResult, fqn, key));
            }
        });

        return keysResult;
    }

    private void addIfAnnotation(List<String> keys, String fqn, String key) {
        try {
            String fullFqn = String.format("%s.%s", fqn, key);
            ClassLoader loader = getClass().getClassLoader();
            Class cls = Class.forName(fullFqn, false, loader);
            if (cls.isAnnotation()) {
                keys.add(key);
            }
        } catch (NoClassDefFoundError | ClassNotFoundException ex) {
        }
    }

    private Predicate<String> isFromClasspath(JavaClassMap map) {
        return s -> map.getSourceType(s) == JavaClassMap.SOURCETYPE_CLASSPATH;
    }
}
