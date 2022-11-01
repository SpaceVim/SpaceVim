package kg.ash.javavi.output;

import kg.ash.javavi.Javavi;
import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.JavaClassMap;

import java.util.Collections;
import java.util.HashMap;
import java.util.List;

public abstract class OutputSimilar {

    protected String wordPrefix = "";

    protected HashMap<String, JavaClassMap> classPackages;

    public OutputSimilar(HashMap<String, JavaClassMap> classPackages) {
        this.classPackages = classPackages;
    }

    public String get(String target) {
        if (target == null) {
            target = "";
        }

        if (classPackages == null || classPackages.isEmpty()) {
            return Cache.PACKAGES_EMPTY_ERROR;
        }

        List<String> keys = getKeys(target);
        Collections.sort(keys);

        StringBuilder builder = new StringBuilder();
        for (String key : keys) {
            classPackages.get(key)
                .getPaths()
                .forEach(scope -> builder.append("{")
                    .append("'word':'")
                    .append(wordPrefix)
                    .append(key)
                    .append("', 'menu':'")
                    .append(scope)
                    .append("', 'type': 'c'},")
                    .append(Javavi.NEWLINE));
        }
        return String.format("[%s]", builder);
    }

    protected abstract List<String> getKeys(String target);

}
