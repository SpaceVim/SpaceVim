package kg.ash.javavi.output;

import kg.ash.javavi.searchers.JavaClassMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Collectors;

public class OutputSimilarClasses extends OutputSimilar {

    public OutputSimilarClasses(HashMap<String, JavaClassMap> classPackages) {
        super(classPackages);
    }

    @Override
    protected List<String> getKeys(String target) {
        if (target.isEmpty()) {
            return new ArrayList<>();
        }
        return classPackages.keySet()
            .stream()
            .filter(k -> k.startsWith(target))
            .collect(Collectors.toList());
    }

}
