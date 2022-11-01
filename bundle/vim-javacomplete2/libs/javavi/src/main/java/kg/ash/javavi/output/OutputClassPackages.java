package kg.ash.javavi.output;

import com.github.javaparser.ast.Modifier;
import kg.ash.javavi.Javavi;
import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.clazz.SourceClass;
import kg.ash.javavi.readers.ClassReader;
import kg.ash.javavi.searchers.ClassSearcher;
import kg.ash.javavi.searchers.JavaClassMap;

import java.util.HashMap;

public class OutputClassPackages {

    private HashMap<String, JavaClassMap> classPackages;
    private String sources = Javavi.system.get("sources").replace('\\', '/');

    public OutputClassPackages(HashMap<String, JavaClassMap> classPackages) {
        this.classPackages = classPackages;
    }

    public String get(String targetClass) {
        if (classPackages == null || classPackages.isEmpty()) {
            return Cache.PACKAGES_EMPTY_ERROR;
        }

        StringBuilder builder = new StringBuilder("");
        if (classPackages.containsKey(targetClass)) {
            JavaClassMap cm = classPackages.get(targetClass);
            if (cm.getType() == JavaClassMap.TYPE_CLASS) {
                cm.getSubpackages().keySet().forEach((String scope) -> {
                    if (scope.endsWith("$")) {
                        String target = scope + targetClass;
                        ClassSearcher seacher = new ClassSearcher();
                        if (seacher.find(target, sources)) {
                            ClassReader reader = seacher.getReader();
                            SourceClass clazz = reader.read(target);
                            if (clazz != null && clazz.getModifiers().contains(Modifier.STATIC)) {
                                scope = "static " + scope;
                            }
                        }
                    }
                    builder.append("'")
                        .append(scope)
                        .append(scope.endsWith("$") ? "" : ".")
                        .append(targetClass)
                        .append("',")
                        .append(Javavi.NEWLINE);
                });
            }
        }

        return String.format("[%s]", builder);
    }

}
