package kg.ash.javavi.searchers;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class PackagesLoader {

    private HashMap<String, JavaClassMap> classPackages;
    private List<PackageSeacherIFace> searchers = new ArrayList<>();

    public PackagesLoader(String sourceDirectories) {
        searchers.add(new ClasspathPackageSearcher());
        searchers.add(new SourcePackageSearcher(sourceDirectories));
    }

    public void collectPackages(HashMap<String, JavaClassMap> classPackages) {
        this.classPackages = classPackages;

        List<PackageEntry> entries = new ArrayList<>();
        searchers.parallelStream().forEach(s -> entries.addAll(s.loadEntries()));

        entries.forEach(entry -> appendEntry(entry));
    }

    public void setSearchers(List<PackageSeacherIFace> searchers) {
        this.searchers = searchers;
    }

    private void appendEntry(PackageEntry entry) {
        String name = entry.getEntry();
        if (isClassFile(name)) {
            int seppos = name.lastIndexOf('$');
            if (seppos < 0) {
                seppos = name.replace('\\', '/').lastIndexOf('/');
            }
            if (seppos != -1) {
                processClass(entry, seppos);
            }
        }
    }

    private JavaClassMap getClassMap(String name, int type) {
        if (classPackages.containsKey(name) && classPackages.get(name).getType() == type) {
            return classPackages.get(name);
        }

        JavaClassMap jcm;
        if (type == JavaClassMap.TYPE_CLASS) {
            jcm = new ClassNameMap(name);
        } else {
            jcm = new PackageNameMap(name);
        }

        classPackages.put(name, jcm);
        return jcm;
    }

    private void processClass(PackageEntry entry, int seppos) {
        String name = entry.getEntry();
        String parent = name.substring(0, seppos);
        String child = name.substring(seppos + 1, name.length() - 6);

        boolean nested = false;
        String parentDots = makeDots(parent);
        if (name.contains("$")) {
            nested = true;
            parentDots += "$";
        }

        int source = entry.getSource();

        if (!child.isEmpty() && !parentDots.isEmpty()) {
            ClassNameMap classMap = (ClassNameMap) getClassMap(child, JavaClassMap.TYPE_CLASS);
            classMap.add(parentDots, source, JavaClassMap.TYPE_SUBPACKAGE, entry.getArchiveName());
            if (entry.getJavaFile() != null) {
                classMap.setJavaFile(entry.getJavaFile());
            }
            if (entry.getClassFile() != null) {
                classMap.setClassFile(entry.getClassFile());
            }

            if (!nested) {
                getClassMap(parentDots, JavaClassMap.TYPE_SUBPACKAGE).add(child, source,
                    JavaClassMap.TYPE_CLASS, null);
            }

            addToParent(parent, source);
        }
    }

    private boolean isClassFile(String name) {
        return name.endsWith(".class");
    }

    private void addToParent(String name, int source) {
        int seppos = name.replace('\\', '/').lastIndexOf('/');
        if (seppos == -1) {
            return;
        }

        String parent = name.substring(0, seppos);
        String child = name.substring(seppos + 1);

        getClassMap(makeDots(parent), JavaClassMap.TYPE_SUBPACKAGE).add(child, source,
            JavaClassMap.TYPE_SUBPACKAGE, null);

        addToParent(parent, source);
    }

    private String makeDots(String name) {
        return name.replaceAll("/", ".").replaceAll("[.]{2,}", "");
    }
}
