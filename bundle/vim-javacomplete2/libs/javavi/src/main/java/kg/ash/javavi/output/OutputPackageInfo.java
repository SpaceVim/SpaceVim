package kg.ash.javavi.output;

import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.JavaClassMap;

import java.util.HashMap;

public class OutputPackageInfo {

    private HashMap<String, JavaClassMap> classPackages;

    public OutputPackageInfo(HashMap<String, JavaClassMap> classPackages) {
        this.classPackages = classPackages;
    }

    public String get(String targetPackage) {
        if (classPackages == null || classPackages.isEmpty()) {
            return Cache.PACKAGES_EMPTY_ERROR;
        }

        StringBuilder sb = new StringBuilder();
        if (classPackages.containsKey(targetPackage)) {
            JavaClassMap classMap = classPackages.get(targetPackage);

            sb.append("'")
                .append(targetPackage)
                .append("':")
                .append("{'tag':'PACKAGE'")
                .append(",'subpackages':[")
                .append(classMap.getCachedSubpackages())
                .append("]")
                .append(",'classes':[")
                .append(classMap.getCachedClasses().toString())
                .append("]")
                .append("},");
        }

        return String.format("{%s}", sb);
    }

}
