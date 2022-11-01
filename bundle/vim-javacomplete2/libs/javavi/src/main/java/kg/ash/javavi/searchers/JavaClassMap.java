package kg.ash.javavi.searchers;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

public abstract class JavaClassMap implements Serializable {

    public static final int SOURCETYPE_CLASSPATH = 0;
    public static final int SOURCETYPE_SOURCES = 1;

    public static final int TYPE_CLASS = 0;
    public static final int TYPE_SUBPACKAGE = 1;

    protected String name = null;
    protected HashMap<String, Integer> pathsMap = new HashMap<>();
    protected List<String> classes = new ArrayList<>();
    protected Map<String, String> subpackages = new HashMap<>();

    public JavaClassMap(String name) {
        setName(name);
    }

    public boolean contains(String path) {
        return pathsMap.containsKey(path);
    }

    public Set<String> getPaths() {
        return pathsMap.keySet();
    }

    public int getSourceType(String path) {
        return pathsMap.get(path);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void add(String path, int source, int type, String filename) {
        if (!contains(path)) {
            pathsMap.put(path, source);
            if (type == TYPE_CLASS) {
                classes.add(path);
            } else {
                subpackages.put(path, filename);
            }
        }
    }

    public StringBuilder getCachedClasses() {
        StringBuilder cachedClasses = new StringBuilder();
        classes.stream()
            .sorted()
            .forEach(path -> cachedClasses.append("'").append(path).append("',"));
        return cachedClasses;
    }

    public StringBuilder getCachedSubpackages() {
        StringBuilder cachedSubpackages = new StringBuilder();
        subpackages.keySet()
            .stream()
            .sorted()
            .forEach(path -> cachedSubpackages.append("'").append(path).append("',"));
        return cachedSubpackages;
    }


    public Map<String, String> getSubpackages() {
        return subpackages;
    }

    public abstract int getType();

    @Override
    public String toString() {
        return String.format("name: %s, type: %d", name, getType());
    }
}
