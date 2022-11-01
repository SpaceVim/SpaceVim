package kg.ash.javavi.actions;

import static kg.ash.javavi.actions.ActionFactory.getArgWithName;

import kg.ash.javavi.apache.logging.log4j.LogManager;
import kg.ash.javavi.apache.logging.log4j.Logger;
import kg.ash.javavi.cache.Cache;
import kg.ash.javavi.searchers.ClassNameMap;
import kg.ash.javavi.searchers.JavaClassMap;

public class AddClassToCacheAction implements Action {

    public static final Logger logger = LogManager.getLogger();

    @Override
    public String perform(String[] args) {
        String sourceFileArg = getArgWithName(args, "-source");
        String classNameArg = getArgWithName(args, "-class");
        String packageNameArg = getArgWithName(args, "-package");

        ClassNameMap cnm = (ClassNameMap) Cache.getInstance().getClassPackages().get(classNameArg);
        if (cnm == null) {
            cnm = new ClassNameMap(classNameArg);
        }

        cnm.setJavaFile(sourceFileArg);
        cnm.add(packageNameArg, JavaClassMap.SOURCETYPE_SOURCES, JavaClassMap.TYPE_SUBPACKAGE,
            null);

        Cache.getInstance().getClassPackages().put(classNameArg, cnm);
        return "";
    }
}
